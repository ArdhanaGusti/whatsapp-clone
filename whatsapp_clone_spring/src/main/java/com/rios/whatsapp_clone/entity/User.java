package com.rios.whatsapp_clone.entity;

import java.util.Date;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private Integer id;

    private String email;

    private String username;

    private String fullname;

    private String password;

    private String phone;

    @Column(nullable = true)
    private String status;

    @Column(name = "profile_picture_url", nullable = true)
    private String profilePicture;
    
    private Date createdAt;
}
