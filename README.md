#⛳ TeeTrack
#TeeTrack is a modern iOS golf scoring and performance tracking app built with SwiftUI.
It allows golfers to track rounds, analyze performance, view statistics, and manage their golf profile — all in a clean and intuitive interface.
#📱 Features
#🏌️‍♂️ Golf Round Tracking
#Create and save full golf scorecards (9 or 18 holes)
#Track:
#Strokes
#Putts
#Greens in regulation
#Automatic score saving per round
#📊 Statistics Dashboard
Score progression over time (line chart)
Filter rounds (Last 5 / Last 10 / All)
Round history with:
Course name
Date
Total score (net score system)
Delete rounds with confirmation
“Best Round” highlight system
🧠 Handicap & Net Scoring System
Custom Belgian-style handicap distribution system
Dynamic stroke allocation based on:
Handicap (Male: 11 strokes / Female: 12 strokes)
Stroke Index (SI)
Net scoring logic:
Par + allocated strokes = baseline
Performance adjusts score above/below baseline
Fully computed per hole and per round
👤 User Profile System
Authentication system (Sign up / Login)
Editable user profile:
Name
Email
Password
Gender (Male / Female)
Handicap
Golf club
Year started golfing
Persistent user data using UserDefaults
⚙️ Settings & Customization
Update profile information
Success confirmation popup (consistent UI feedback system)
Auto-save updates with persistence
Smooth UX with keyboard dismissal handling
🧾 Round Detail View
Full scorecard breakdown per hole:
Hole number
Distance
Par
Stroke Index
Score
Putts
Greens in regulation
Clean tabular layout (real scorecard style)
🎨 UI / UX
Built entirely with SwiftUI
Custom components:
Top bars
Feature cards
Round cards
Shimmer text animations
Green golf-inspired design system
Smooth transitions & overlays
Consistent navigation flow
🛠️ Tech Stack
SwiftUI (UI framework)
Combine / State Management
UserDefaults (local persistence)
Codable (data encoding/decoding)
MVVM architecture
Custom UI components
iOS 15+ compatible design
🧩 Architecture Overview
The app follows a lightweight MVVM structure:
Models
User
GolfCourse
StoredGolfRound
HoleScore
ViewModels
AuthViewModel (authentication + persistence)
Views
Home dashboard
Scorecard input system
Stats analytics
Profile management
Settings editor
Round detail view
💾 Data Persistence
All data is stored locally using UserDefaults:
User accounts stored per email key
Golf rounds stored per user
Courses stored locally
Codable encoding/decoding for structured data
📈 Future Improvements
Cloud sync (iCloud / Firebase)
Advanced analytics (putting stats, fairways hit)
GPS course mapping
Live round tracking
Leaderboard system
Apple Watch companion app
🚀 Purpose
TeeTrack was built to:
Replace paper scorecards
Provide meaningful golf performance insights
Create a smooth, modern mobile golf experience
👨‍💻 Developer
Built with passion for golf & iOS development using SwiftUI.
