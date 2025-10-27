# Storekeeper App 📦

A modern product inventory management application built with Flutter, featuring local database storage, camera integration, and clean architecture.

## 📥 Download & Demo

- **[Watch Demo Video](https://drive.google.com/drive/folders/1Fyopm33w4ipPXYjyD02APq2oIjHmZL9T)**
- **[GitHub Repository](https://github.com/Redoxm/Storekeeper)**

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

[<img width="402" height="790" alt="image" src="https://github.com/user-attachments/assets/6d289536-3158-499f-8803-fe6026f49ce7" />
<img width="415" height="775" alt="image" src="https://github.com/user-attachments/assets/a3544846-efde-4c47-ac05-9a8b5e67f5d5" />
<img width="393" height="766" alt="image" src="https://github.com/user-attachments/assets/66482618-9847-4240-9d08-b79cde3ae247" />
<img width="397" height="760" alt="image" src="https://github.com/user-attachments/assets/655372ca-ebbb-4fe8-b588-ba84bebd7c3b" />

]

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
