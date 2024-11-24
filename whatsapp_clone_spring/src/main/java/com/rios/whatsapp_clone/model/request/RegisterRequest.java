package com.rios.whatsapp_clone.model.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class RegisterRequest {
    @NotBlank
    @Size(max = 100)
    private String fullname;

    @NotBlank
    @Size(max = 50)
    private String username;
    
    @NotBlank
    @Size(max = 100)
    private String email;

    @NotBlank
    @Size(max = 15)
    private String phone;

    @NotBlank
    @Size(max = 100)
    private String password;
}
