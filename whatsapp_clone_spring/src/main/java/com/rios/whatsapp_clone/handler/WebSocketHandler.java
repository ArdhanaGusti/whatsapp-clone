package com.rios.whatsapp_clone.handler;

import java.util.concurrent.CopyOnWriteArraySet;

import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.rios.whatsapp_clone.entity.temporary.ShortMessage;

public class WebSocketHandler extends TextWebSocketHandler {
    private final CopyOnWriteArraySet<WebSocketSession> sessions = new CopyOnWriteArraySet<>();
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        sessions.add(session);
        System.out.println("Connected: " + session.getId());
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        System.out.println("Received: " + message.getPayload());

        ShortMessage receivedMessage = objectMapper.readValue(message.getPayload(), ShortMessage.class);

        TextMessage responseMessage = new TextMessage("Succesfully send " + receivedMessage.getMessage() + " from "
                + receivedMessage.getSender() + " to " + receivedMessage.getReceiver());

        session.sendMessage(responseMessage);

        for (WebSocketSession s : sessions) {
            if (s.isOpen()) {
                s.sendMessage(responseMessage);
            }
        }
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, org.springframework.web.socket.CloseStatus status)
            throws Exception {
        sessions.remove(session);
        System.out.println("Disconnected: " + session.getId());
    }
}
