<div align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" />
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" />
  <img src="https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white" />
  <img src="https://img.shields.io/badge/Hackathon_Project-FF6B6B?style=for-the-badge&logo=hackaday&logoColor=white" />

  <h1>🚀 NextUtsav</h1>
  <p><strong>The Ultimate College Extracurricular Activity Platform</strong></p>
  <p><i>A production-ready Flutter Android application for discovering and managing campus clubs, events, and your vibrant student life!</i></p>
</div>

---

## 📸 Snapshots

<div align="center" style="display: flex; gap: 15px; justify-content: center;">
  <img src="assets/app_home.png" alt="Home Screen" width="350" />
  <img src="assets/app_events.png" alt="Events Screen" width="350" />
</div>

<br>

## ✨ Why NextUtsav?

College life is more than just academics! NextUtsav digitizes campus engagement, offering students a central hub for clubs, registrations, and stories. Built exclusively as a high-performance Android experience!

## 🌟 Key Features

### 🔐 Interactive Onboarding
- **Dynamic Splash** — Animated logo with sleek gradient backdrop
- **Smart College Picker** — Instantly search and select your institution
- **Personalized Setup** — Select 3+ interests and get automated club recommendations!

### 🏠 Vibrant Home Feed
- **Campus Stories** — Instagram-style ephemeral stories from clubs
- **Interactive Posts** — Vertical feed with bouncy like animations and rich media
- **Always Fresh** — Pull-to-refresh & infinite scroll

### 📅 Events & Discovery
- **Dual View** — Seamless toggle between List View and Calendar (`table_calendar`)
- **Ticket Generation** — Generates an actual QR code ticket upon event registration!
- **Celebration!** — Confetti animations on successful enrollments 🎉

### 🏛️ Club & Profile Hub
- **Club Dashboards** — Follow clubs, view sticky cover photos, members, and achievements
- **Gamification (XP)** — Earn badges, track XP points, and download certificates!
- **Recruitment** — Live multi-step application forms with visual progress dots!

## 🎨 Premium Design System
Crafted with **Material 3** guidelines to deliver a visually stunning UI!
- 💜 **Primary Palette:** Deep Purple (`#6C63FF`) & Teal (`#1D9E75`)
- 🌙 **Dark Mode Support:** Gorgeous pure dark themes for night owls
- ✨ **Micro-interactions:** Powered by `flutter_animate` & custom transitions
- 📝 **Typography:** Sleek *Plus Jakarta Sans* 

## 📦 Tech Stack
| Technology | Role in Project |
|------------|-----------------|
| **Flutter 3.x** | Core UI & framework |
| **Riverpod** | Reactive State Management |
| **GoRouter** | Robust nested routing & navigation |
| **Shimmer** | Beautiful skeleton loading screens |

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (Android Support)
- Dart SDK
- Android Emulator or physical Android device

### Running Locally
```bash
# Clone the repository
git clone https://github.com/methodmystic/NextUtsav-Hackathon.git
cd nextUtsav

# Install dependencies
flutter pub get

# Spin it up on Android emulator  
flutter run -d android
```

### Build for Production
```bash
# Generate high-performance Android APK
flutter build apk --release
```

## 📁 Architecture (Feature-First)
```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── theme/          # Custom Material 3 styling
│   ├── router/         # GoRouter setup
│   └── widgets/        # Universal components
└── features/
    ├── auth/           # Login & Onboarding flow
    ├── feed/           # Stories & Social Posts
    ├── clubs/          # Club directories
    ├── events/         # Registration & Calendars
    └── profile/        # Resumes & XP tracking
```

## 🔄 API Integration 
Currently runs on `MockDataService` for seamless testing. 
To launch onto a real backend: 
1. Find `TODO: Replace with real API call` markers.
2. Replace with standard `Dio`/`HTTP` network requests.

<br>
<div align="center">
  <sub>Built with ❤️ for the Hackathon</sub>
</div>
