<div align="center">

# ⛳ TeeTrack

**A modern iOS golf scoring & performance tracking app built with SwiftUI**

![Swift](https://img.shields.io/badge/Swift-5.9-FA7343?style=flat&logo=swift&logoColor=white)
![SwiftUI](https://img.shields.io/badge/SwiftUI-iOS%2015+-0077FF?style=flat&logo=apple&logoColor=white)
![Storage](https://img.shields.io/badge/Storage-UserDefaults-lightgrey?style=flat)


*Replace paper scorecards. Track your game. Improve your handicap.*

</div>

---

## 📱 Overview

TeeTrack is a clean, intuitive golf companion that lets you log rounds, track performance over time, and manage your profile — all in one place. Built entirely with SwiftUI and designed around a green golf-inspired aesthetic.

---

## ✨ Features

### 🏌️ Round Tracking
- Create scorecards for 9 or 18 holes
- Track **strokes**, **putts**, **greens in regulation** per hole
- Full scorecard detail view — hole number, distance, par, stroke index

### 📊 Statistics Dashboard
- Score progression line chart over time
- Filter by **Last 5**, **Last 10**, or **All** rounds
- Round history with course name, date, and net score
- **Best Round** highlight system
- Swipe-to-delete with confirmation

### 🧮 Belgian Handicap System
- Custom stroke allocation based on gender and handicap index
- Dynamic stroke distribution using Stroke Index (SI)
- Net scoring: `Par + allocated strokes = baseline`
- Score computed per hole and aggregated per round

### 👤 Profile & Auth
- Sign up / Login system
- Editable profile: name, email, password, gender, handicap, club, year started
- Persistent storage via `UserDefaults` + `Codable`

### 🌤️ Weather Forecast & Play Planner
- Search any location to get a **live weather forecast**
- **8-day forecast** powered by the [OpenWeatherMap API](https://openweathermap.org/api)
- Smart **best time to play** recommendation based on:
  - Temperature, wind speed, precipitation chance, and UV index
- Helps you plan your round before heading to the course

### 🎨 UI / UX
- Built 100% in SwiftUI
- Custom components: top bars, feature cards, round cards, shimmer text
- Green golf-inspired design system
- Smooth transitions, overlays, and keyboard handling

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| UI Framework | SwiftUI |
| State Management | `@StateObject`, `@ObservedObject`, Combine |
| Persistence | `UserDefaults` + `Codable` |
| Minimum Target | iOS 15+ |

---

## 🧩 Architecture

```
TeeTrack/
├── Models/
│   ├── User
│   ├── GolfCourse
│   ├── StoredGolfRound
│   └── HoleScore
├── ViewModels/
│   └── AuthViewModel        # Authentication + persistence logic
└── Views/
    ├── Home                 # Dashboard
    ├── Scorecard            # Round input
    ├── Statistics           # Analytics & charts
    ├── RoundDetail          # Per-hole breakdown
    ├── Profile              # User profile management
    └── Settings             # Preferences & account
```

---

## 💾 Data Persistence

All data is stored locally using `UserDefaults`:
- User accounts keyed per email
- Golf rounds stored per user
- Courses stored locally
- `Codable` encoding/decoding for all structured data

---

## 📈 Roadmap

- [ ] iCloud / Firebase sync
- [ ] Advanced analytics (putts, fairways hit)
- [ ] GPS course mapping
- [ ] Live round tracking
- [ ] Leaderboard system
- [ ] Apple Watch companion app

---

## 👨‍💻 Author

Built with passion for golf & iOS development.  

---

<div align="center">
Made with ☀️ and SwiftUI
</div>
