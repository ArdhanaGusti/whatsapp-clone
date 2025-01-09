package com.rios.whatsapp_clone.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.rios.whatsapp_clone.model.request.LoginRequest;
import com.rios.whatsapp_clone.model.request.RegisterRequest;
import com.rios.whatsapp_clone.model.response.MessageAfterActionResponse;
import com.rios.whatsapp_clone.model.response.TokenResponse;
import com.rios.whatsapp_clone.model.response.WebResponse;
import com.rios.whatsapp_clone.service.AuthService;

@RestController
public class AuthController {
    @Autowired
    private AuthService authService;

    @PostMapping(path = "/api/auth/login", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public WebResponse<TokenResponse> login(@RequestBody LoginRequest request) {
        try {
            TokenResponse tokenResponse = authService.login(request);
            return WebResponse.<TokenResponse>builder().data(tokenResponse).build();
        } catch (Exception e) {
            return WebResponse.<TokenResponse>builder().errors(e.getMessage()).build();
        }
    }

    @GetMapping(path = "/api/auth/token", produces = MediaType.APPLICATION_JSON_VALUE)
    public WebResponse<TokenResponse> token(String token) {
        try {
            TokenResponse tokenResponse = authService.getToken(token);
            return WebResponse.<TokenResponse>builder().data(tokenResponse).build();
        } catch (Exception e) {
            return WebResponse.<TokenResponse>builder().errors(e.getMessage()).build();
        }
    }

    @PostMapping(path = "/api/auth/register", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Object> register(@RequestBody RegisterRequest request) {
        try {
            MessageAfterActionResponse registerResponse = authService.register(request);
            return new ResponseEntity<>(registerResponse.getMessage(),
                    HttpStatus.valueOf(registerResponse.getStatusCode()));
        } catch (Exception e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // @GetMapping(value = "/generateOTP")
    // public ResponseEntity<String> generateOTP() {

    // Twilio.init("", "");

    // // Verification verification = Verification.creator(
    // // "",
    // // "",
    // // "sms")
    // // .create();

    // // System.out.println(verification.getStatus());

    // // Create Message to be sent
    // Message.creator(new PhoneNumber(""), "", "Hello from Twilio 📞").create();

    // return new ResponseEntity<>("Your OTP has been sent to your verified phone
    // number", HttpStatus.OK);
    // }
}
