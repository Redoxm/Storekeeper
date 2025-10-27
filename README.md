# Storekeeper App 📦

A modern product inventory management application built with Flutter, featuring local database storage, camera integration, and clean architecture.

## 📥 Download & Demo

- **[Download APK](YOUR_GOOGLE_DRIVE_APK_LINK_HERE)**
- **[Watch Demo Video](YOUR_GOOGLE_DRIVE_VIDEO_LINK_HERE)**
- **[GitHub Repository](YOUR_GITHUB_REPO_LINK_HERE)**

## ✨ Features

- ✅ **CRUD Operations**: Create, Read, Update, and Delete products
- ✅ **Local Database**: SQLite database with `sqflite` package
- ✅ **Camera Integration**: Native camera and gallery support
- ✅ **Search Functionality**: Real-time product search
- ✅ **Clean Architecture**: MVVM pattern with Riverpod
- ✅ **Beautiful UI**: Modern design with animations
- ✅ **Pie Chart**: Visual inventory distribution
- ✅ **Data Persistence**: Products saved locally

## 🏗️ Architecture

- **Clean Architecture** with 3 layers (Domain, Data, Presentation)
- **MVVM Pattern** for presentation layer
- **Riverpod** for state management
- **SQLite** for local database

## 📱 Screenshots

[Add 4-5 screenshots here after taking them]

## 🛠️ Technologies Used

| Technology         | Purpose                  |
| ------------------ | ------------------------ |
| Flutter            | Cross-platform framework |
| Riverpod           | State management         |
| SQLite (sqflite)   | Local database           |
| image_picker       | Camera/Gallery           |
| fl_chart           | Pie chart visualization  |
| animate_do         | UI animations            |
| Clean Architecture | Code organization        |

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0.0+)
- Dart SDK (3.0.0+)
- Android SDK (API 21+)

### Installation

```bash
# Clone repository
git clone [your-repo-url]
cd storekeeper-app

# Install dependencies
flutter pub get

# Run app
flutter run
```

### Build APK

```bash
flutter build apk --release
```

## 📖 Project Structure

```
lib/
├── core/                    # Core utilities
│   ├── constants/          # App constants
│   ├── errors/             # Error handling
│   ├── services/           # Shared services
│   ├── usecase/            # Base UseCase
│   └── utils/              # Utilities
├── features/
│   └── product/
│       ├── data/           # Data layer
│       ├── domain/         # Business logic
│       └── presentation/   # UI layer
└── main.dart               # Entry point
```

## 🎯 Key Features Implementation

### Local Database (SQLite)

- Schema-based product table
- CRUD operations with error handling
- Singleton pattern for database instance
- Automatic timestamp management

### Camera Integration

- Native camera capture
- Gallery image selection
- Runtime permission handling
- Image compression and storage

### State Management (Riverpod)

- Provider-based dependency injection
- StateNotifier for reactive updates
- Separation of concerns
- Automatic UI rebuilds

### Clean Architecture

- Testable code
- Clear separation of concerns
- Easy to maintain and scale
- Framework independent business logic

## 👨‍💻 Author

**Luqman Adebayo**

- GitHub: [@Redoxm](https://github.com/Redoxm)
- Email: Luqmanadebayoaremu@gmail.com

## 🙏 Acknowledgments

- HNG12 Internship
- Flutter Community
- Clean Architecture by Robert C. Martin

## 📄 License

This project is licensed under the MIT License.

---

**Built with ❤️ for HNG12 Mobile Track - Stage 2**
