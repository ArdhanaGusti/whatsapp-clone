package com.rios.whatsapp_clone.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.rios.whatsapp_clone.entity.User;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Integer> {
    Optional<User> findFirstByEmail(String email);

    Optional<User> findFirstByToken(String token);
}
