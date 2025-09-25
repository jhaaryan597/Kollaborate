# 🤝 Kollaborate

![Status](https://img.shields.io/badge/Status-Active-brightgreen)
![Made With](https://img.shields.io/badge/Made%20With-SwiftUI-blue?logo=swift)
![iOS](https://img.shields.io/badge/iOS-16%2B-lightgrey?logo=apple)
![Supabase](https://img.shields.io/badge/Backend-Supabase-3ECF8E?logo=supabase)
![Database](https://img.shields.io/badge/Database-Postgres-336791?logo=postgresql)

**A modern iOS app for team collaboration, project management, and real-time communication.**  
Built with **SwiftUI** and powered by **Supabase**, Kollaborate enables users to manage projects, track tasks, and communicate seamlessly with their teams.

---

## 📖 Project Overview

Kollaborate is designed for **professionals, students, and teams** seeking a unified collaboration platform.  
Users can post discussions, explore projects, manage tasks, share files, and maintain profiles—all in one place.

✨ Think of it as a **hybrid between a social feed and a project management tool**, providing:

- **Real-time collaboration** via channels, direct messages, and threaded comments  
- **Task & project management** with assignments, due dates, and status tracking  
- **File sharing** for documents and images  
- **User profiles** displaying activity, projects, and contributions  

---

## ✨ Core Features

### 👤 Authentication
- Secure login/signup with **email/password**  
- Backend handled by **Supabase Auth**

### 📰 Feed
- Centralized feed showing **activities, updates, and discussions** across projects

### 📋 Task Management
- Create, assign, and track tasks  
- Each task supports **title, description, due date, and assignee**

### 🏗️ Project Collaboration
- Create projects and **invite team members**  
- Manage project-specific **tasks and files**

### 📂 File Sharing
- Upload and share **documents & images** within projects

### 👤 User Profiles
- View detailed user activity, contributions, and project involvement

### 💬 Real-time Communication
- **Channels:** Public & private discussions  
- **Direct Messages:** One-on-one or group messaging  
- **Comments:** Threaded on tasks and discussions  

### 🔍 Explore
- Discover **public projects and discussions** within the community  

---

## 🏗️ Architecture

Kollaborate is built using **MVVM** (Model-View-ViewModel) and a **service-oriented architecture**:

- **Model:** Core data structures (User, Project, Task, File, Channel, DirectMessage, Comment, Repost)  
- **View:** SwiftUI components forming the UI  
- **ViewModel:** Handles business logic and prepares data for views  
- **Services Layer:** Handles all interactions with Supabase (AuthService, UserService, ProjectService, TaskService, FileService, ChannelService, DirectMessageService, CommentService)  

---

## 🛠 Key Technologies

| Component       | Technology |
|-----------------|------------|
| **Frontend**    | SwiftUI |
| **Backend**     | Supabase |
| **Database**    | PostgreSQL |
| **Real-time**   | Supabase Realtime |
| **Image Caching** | Kingfisher |

---

## 📸 Screenshots

**Experience the app in action!** 😍  

<p align="center">
  <img src="AssetIMG/ss1.png" width="250"/>
  <img src="AssetIMG/ss2.png" width="250"/>
  <img src="AssetIMG/ss3.png" width="250"/>
  <img src="AssetIMG/ss4.png" width="250"/>
  <img src="AssetIMG/ss5.png" width="250"/>
  <img src="AssetIMG/ss6.png" width="250"/>
  <img src="AssetIMG/ss7.png" width="250"/>
  <img src="AssetIMG/ss8.png" width="250"/>
  <img src="AssetIMG/ss9.png" width="250"/>
  <img src="AssetIMG/ss10.png" width="250"/>
  <img src="AssetIMG/ss11.png" width="250"/>
  <img src="AssetIMG/ss12.png" width="250"/>
</p>

---

## 🔄 Application Flow

1. **Splash Screen** → Check authentication state  
2. **Login / Signup** → Supabase Auth  
3. **Feed Screen** → Central hub for updates and discussions  
4. **Explore Screen** → Discover projects & collaborators  
5. **Task Screen** → Manage task lists and assignments  
6. **Create Screens** → New tasks, discussions, or projects  
7. **Profile Screen** → View and edit user information  

---

## 🚀 Getting Started

### Requirements
- Xcode 14+  
- Apple Developer Account (for physical device)  
- Supabase account and configured project

### Setup Instructions
```bash
# Clone the repository
git clone https://github.com/jhaaryan597/Kollaborate.git

# Open the project in Xcode
cd Kollaborate
open Kollaborate.xcodeproj
