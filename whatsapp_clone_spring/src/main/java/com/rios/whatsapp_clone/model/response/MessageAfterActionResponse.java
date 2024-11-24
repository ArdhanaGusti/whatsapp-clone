package com.rios.whatsapp_clone.model.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class MessageAfterActionResponse {
    private String message;

    private int statusCode;
}
