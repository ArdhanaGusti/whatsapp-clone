package com.rios.whatsapp_clone.entity.temporary;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ShortMessage {
    private String message;
    private String sender;
    private String receiver;
}
