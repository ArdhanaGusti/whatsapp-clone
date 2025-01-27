CREATE TABLE Users (
    id SERIAL PRIMARY KEY,
    fullname VARCHAR(100) NOT NULL,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    profile_picture_url VARCHAR(255),
    status VARCHAR(255),
    token VARCHAR(255),
    token_end_time TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE InnoDB;

CREATE TABLE Messages (
    id SERIAL PRIMARY KEY,
    sender_id INT NOT NULL REFERENCES Users (id),
    receiver_id INT NOT NULL REFERENCES Users (id),
    message TEXT NOT NULL,
    media_url VARCHAR(255),
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Contacts (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES Users(user_id),
    contact_id INT NOT NULL REFERENCES Users(user_id),
    nickname VARCHAR(100) NOT NULL
);