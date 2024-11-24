package com.rios.whatsapp_clone.service;

import java.util.Date;

import org.springframework.stereotype.Service;

import io.jsonwebtoken.*;

@Service
public class JwtService {
    private static final String SECRET = "your-secret-key";
    public static String generateToken(String username, Date expireDate) {
        return Jwts.builder()
            .setSubject(username)
            .setExpiration(expireDate)
            .signWith(SignatureAlgorithm.HS512, SECRET)
            .compact();
    }
    public static String extractUsername(String token) {
        return Jwts.parser()
            .setSigningKey(SECRET)
            .parseClaimsJws(token)
            .getBody()
            .getSubject();
    }
}
