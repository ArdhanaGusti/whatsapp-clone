# 📱 WhatsApp Clone

A modern real-time chat application built with **Flutter**, **Golang**,
and **MySQL**.\
This project recreates key WhatsApp features including instant
messaging, media sharing, and a clean mobile UI.

------------------------------------------------------------------------

## 🚀 Features

-   Real-time messaging\

------------------------------------------------------------------------

## 🛠️ Tech Stack

**Frontend:** Flutter\
**Backend:** Golang\
**Database:** MySQL\
**Auth:** JWT\
**API Communication:** REST API + optional WebSockets

------------------------------------------------------------------------

## 📂 Project Structure

### Backend (Go)

    /backend
      /config
      /controllers
      /models
      /routes
      /services
      main.go

### Mobile App (Flutter)

    /lib
      /screens
      /widgets
      /models
      /providers
      /services
      main.dart

------------------------------------------------------------------------

## ⚙️ Installation & Setup

### 1. Clone the Repo

``` bash
git clone https://github.com/yourusername/whatsapp-clone.git
cd whatsapp-clone
```

------------------------------------------------------------------------

## 🗄️ Backend Setup (Golang + MySQL)

### Install Go dependencies

``` bash
cd backend
go mod tidy
```

### Create `.env`

    DB_HOST=localhost
    DB_PORT=3306
    DB_USER=root
    DB_PASS=yourpassword
    DB_NAME=whatsapp
    JWT_SECRET=your_jwt_secret

### Run the backend

``` bash
go run main.go
```

------------------------------------------------------------------------

## 📦 Database Structure

### users

-   id\
-   username\
-   phone\
-   password\
-   created_at\
-   updated_at\
-   deleted_at

### messages

-   id\
-   sender_id\
-   receiver_id\
-   content\
-   created_at\
-   updated_at\
-   deleted_at

------------------------------------------------------------------------

## 📱 Flutter Setup

### Install dependencies

``` bash
flutter pub get
```

### Run the app

``` bash
flutter run
```

### Configure API base URL

Update your API service file:

``` dart
static const String baseUrl = "http://your-ip:8080";
```

------------------------------------------------------------------------

## 📸 Screenshots

<p float="left">
  <img src="https://github.com/user-attachments/assets/a0779d79-b6f0-4620-b054-4a098c583d07" width="200" />
  <img src="https://github.com/user-attachments/assets/0fb20b05-bbdb-4bf3-a467-31189f164dcf" width="200" />
  <img src="https://github.com/user-attachments/assets/f784ee45-eace-4baa-94d9-0fd6fded9af3" width="200" />
  <img src="https://github.com/user-attachments/assets/696cfb7b-01ea-46c7-a2a4-b2fba01a5b2d" width="600" />

</p>

------------------------------------------------------------------------

## 🧪 Future Enhancements

-   Voice messages\
-   Group chats\
-   Video & audio calls\
-   Message reactions\
-   Cloud backups

------------------------------------------------------------------------

## 🤝 Contributing

Contributions, issues, and feature requests are welcome.

------------------------------------------------------------------------

## ⭐ Support

If you like this project, please give it a ⭐ on GitHub!

------------------------------------------------------------------------

## 📜 License

MIT License © 2025 ardhanagusti
