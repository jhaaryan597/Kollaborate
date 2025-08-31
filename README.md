# 🤝 Kollaborate  

![Status](https://img.shields.io/badge/Status-Active-brightgreen)  ![Made With](https://img.shields.io/badge/Made%20With-SwiftUI-blue?logo=swift)  
![iOS](https://img.shields.io/badge/iOS-16%2B-lightgrey?logo=apple)  
![Supabase](https://img.shields.io/badge/Backend-Supabase-3ECF8E?logo=supabase)  
![Database](https://img.shields.io/badge/Database-Postgres-336791?logo=postgresql) 

**A modern iOS app for collaboration, discussions, and project management.**  
Built with **SwiftUI** and powered by **Supabase**, Kollaborate provides a space where users can share updates, explore projects, manage tasks, and connect with peers.  

---

## 📖 Project Overview  

Kollaborate is designed for **professionals, students, and teams** who want a single platform for:  
- Posting **discussions & announcements**  
- Exploring **new people & projects**  
- Managing and tracking **tasks**  
- Building and maintaining **profiles**  

✨ Think of it as a **hybrid between a social feed and a project management tool**.  

---

## 🛠 Core Technologies  

- **Framework:** [SwiftUI](https://developer.apple.com/xcode/swiftui/) (declarative UI)  
- **Backend:** [Supabase](https://supabase.com/)  
  - 🔑 Authentication → Secure login & registration  
  - 📂 Database → Threads, tasks, and user data  
  - 📦 Storage → User profile images & media  
- **Database:** PostgreSQL (via Supabase)  
- **Image Loading & Caching:** [Kingfisher](https://github.com/onevcat/Kingfisher)  
- **Concurrency:** Swift Concurrency + [Point-Free libraries](https://github.com/pointfreeco)  
- **Security:** [swift-crypto](https://github.com/apple/swift-crypto)  

---

## 📸 Screenshots  

**Actual app looks even better in action!** 😍  

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

## ✨ Features  

- 📰 **Feed** → Discussions, updates & announcements  
- 🔍 **Explore** → Discover projects & collaborators  
- 📋 **Task Management** → Create, assign, and track tasks  
- ✍️ **Content Creation** → Start threads & add tasks  
- 👤 **Profiles** → View & edit user profiles  
- 🎨 **Modern UI** with clean SwiftUI design & animations  

---

## 🔄 Application Flow  

- **Splash Screen** → Auth state check  
- **Login / Signup** → Supabase Auth (email/password)  
- **Feed Screen** → Central hub for activity  
- **Explore Screen** → Projects & collaborators  
- **Task Screen** → Task lists & assignments  
- **Create Screens** → New discussions & tasks  
- **Profile Screen** → User info & settings  

---

## 📂 Project Structure  

- Kollaborate/  
  ┣ Models/         # Data models (User, Thread, Task)  
  ┣ Services/       # Supabase API integration  
  ┣ Views/          # SwiftUI screens  
  ┣ Components/     # Reusable UI components  
  ┣ Assets/         # App assets (icons, images)  

---

## 💬 Feedback & Contact  

- We’d love your thoughts and feedback!  
- 📧 aryanjha230705@gmail.com  
