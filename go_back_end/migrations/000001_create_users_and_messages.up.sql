CREATE TABLE users (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,

    created_at DATETIME(3),
    updated_at DATETIME(3),
    deleted_at DATETIME(3)
);

CREATE TABLE messages (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,

    message TEXT NOT NULL,
    sender_id BIGINT UNSIGNED NOT NULL,
    receiver_id BIGINT UNSIGNED NOT NULL,

    created_at DATETIME(3),
    updated_at DATETIME(3),
    deleted_at DATETIME(3)
);

CREATE INDEX idx_sender_receiver ON messages(sender_id, receiver_id);