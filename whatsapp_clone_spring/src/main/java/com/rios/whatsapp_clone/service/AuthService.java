package com.rios.whatsapp_clone.service;

import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import com.rios.whatsapp_clone.entity.User;
import com.rios.whatsapp_clone.model.request.LoginRequest;
import com.rios.whatsapp_clone.model.request.RegisterRequest;
import com.rios.whatsapp_clone.model.response.MessageAfterActionResponse;
import com.rios.whatsapp_clone.model.response.TokenResponse;
import com.rios.whatsapp_clone.repository.UserRepository;
import com.rios.whatsapp_clone.utility.BCrypt;

import jakarta.transaction.Transactional;

@Service
public class AuthService {
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ValidationService validationService;

    @Transactional
    public TokenResponse login(LoginRequest request) {
        validationService.validate(request);

        User user = userRepository.findFirstByEmail(request.getEmail())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Email or password wrong"));

        if (BCrypt.checkpw(request.getPassword(), user.getPassword())) {
            userRepository.save(user);

            Date expireDate = new Date(System.currentTimeMillis() + 864000);
            String token = JwtService.generateToken(request.getEmail(), expireDate);

            return TokenResponse.builder()
                    .token(token)
                    .expiredAt(expireDate)
                    .build();
        } else {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Email or password wrong");
        }
    }

    @Transactional
    public MessageAfterActionResponse register(RegisterRequest registerRequest) {
        validationService.validate(registerRequest);

        var existingUser = userRepository.findFirstByEmail(registerRequest.getEmail())
                .isPresent();

        if (existingUser) {
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Duplicate data");
        }

        User user = new User();
        user.setEmail(registerRequest.getEmail());
        user.setUsername(registerRequest.getUsername());
        user.setFullname(registerRequest.getFullname());
        user.setPhone(registerRequest.getPhone());
        user.setPassword(BCrypt.hashpw(registerRequest.getPassword(), BCrypt.gensalt()));
        userRepository.save(user);

        return MessageAfterActionResponse.builder()
                .message("User registered successfully")
                .statusCode(200)
                .build();

    }

    public TokenResponse getToken(String token) {
        // var expireDate = (Date) redisTemplate.opsForValue().get(token);
        return TokenResponse.builder()
                .token(token)
                // .expiredAt(expireDate)
                .build();
    }
}
