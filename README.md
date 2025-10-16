# 📱 Suivi Absence Mobile - Student Attendance Tracking App

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-81.1%25-0175C2?logo=dart&logoColor=white)
![GetX](https://img.shields.io/badge/GetX-State_Management-purple)
![Mobile](https://img.shields.io/badge/Platform-iOS%20%7C%20Android-success)

**A cross-platform mobile application for student attendance management built with Flutter**

[Features](#-features) • [Tech Stack](#-tech-stack) • [Architecture](#-architecture) • [Getting Started](#-getting-started) • [Screenshots](#-screenshots)

</div>

---

## 📋 About The Project

**Suivi Absence Mobile** is a learning-focused Flutter project designed to master modern mobile application development. This cross-platform app provides a complete solution for managing student attendance at ISM (Institut Supérieur de Management), featuring QR code scanning, real-time tracking, and justification management.

### 🎯 Learning Objectives

- ✅ **Master Flutter**: Build production-ready cross-platform mobile apps
- ✅ **State Management**: Implement GetX for reactive state management
- ✅ **Clean Architecture**: Apply MVC+S pattern with proper separation of concerns
- ✅ **API Integration**: Connect mobile apps to REST APIs
- ✅ **QR Code Technology**: Implement scanning and generation features
- ✅ **Image Handling**: Work with camera, gallery, and cloud storage
- ✅ **Geolocation**: Integrate maps and location services
- ✅ **Authentication**: Secure user login with JWT tokens

---

## ✨ Features

### 👨‍🎓 Student Features

- **📊 Absence Dashboard**: View personal absence history and statistics
- **📸 QR Code Profile**: Generate personal QR code for quick check-in
- **📝 Absence Justification**: Submit justifications with photo attachments
- **📈 Real-time Stats**: Track cumulative absences and delays
- **🗺️ School Location**: View school location on interactive map
- **📷 Photo Upload**: Take pictures or select from gallery (Supabase storage)
- **🔔 Absence Status**: Monitor justification approval status

### 👨‍🏫 Teacher Features

- **📷 QR Code Scanner**: Scan student QR codes for instant attendance
- **✅ Quick Check-in**: Mark students present with one tap
- **🔍 Student Search**: Find students by registration number
- **📋 Attendance List**: View all students for current session
- **⏰ Real-time Updates**: Instant synchronization with backend

### 🔐 Authentication & Security

- **🔑 JWT Authentication**: Secure token-based login
- **🔒 Secure Storage**: Encrypted local data storage
- **👤 Role-based Access**: Different views for students and teachers
- **🚪 Auto Logout**: Session management and timeout

---

## 🛠️ Tech Stack

### Core Technologies

| Technology | Percentage | Purpose |
|------------|-----------|---------|
| ![Dart](https://img.shields.io/badge/Dart-81.1%25-0175C2?logo=dart) | 81.1% | Primary language |
| ![C++](https://img.shields.io/badge/C++-9.4%25-00599C?logo=cplusplus) | 9.4% | Native Android/iOS |
| ![CMake](https://img.shields.io/badge/CMake-7.2%25-064F8C) | 7.2% | Build configuration |
| ![Swift](https://img.shields.io/badge/Swift-1%25-FA7343?logo=swift) | 1.0% | iOS native code |

### Flutter Packages

#### State Management & Navigation
```yaml
dependencies:
  get: ^4.6.6                    # State management & routing
  flutter_secure_storage: ^9.0.0 # Secure JWT storage
```

#### QR Code Features
```yaml
  qr_flutter: ^4.1.0             # QR code generation
  mobile_scanner: ^5.1.1         # QR code scanning
```

#### Networking & API
```yaml
  http: ^1.4.0                   # HTTP requests
  http_parser: ^4.0.2            # Multipart data handling
```

#### Media & Storage
```yaml
  image_picker: ^1.0.7           # Camera & gallery access
  supabase_flutter: ^2.9.1       # Cloud storage & database
  uuid: ^4.5.1                   # Unique identifiers
  path: ^1.9.1                   # File path utilities
```

#### UI & Maps
```yaml
  flutter_map: ^6.1.0            # OpenStreetMap integration
  latlong2: ^0.9.0               # GPS coordinates
  intl: ^0.19.0                  # Date formatting
  logger: ^2.0.2+1               # Debug logging
```

### Platform Support

- ✅ **Android** (Native support)
- ✅ **iOS** (Native support)
- ✅ **Web** (PWA ready)
- ✅ **Windows** (Desktop)
- ✅ **macOS** (Desktop)
- ✅ **Linux** (Desktop)

---

## 🏗️ Architecture

### MVC+S Pattern (Model-View-Controller-Service)

```
lib/
├── app/
│   ├── data/                      # Data Layer
│   │   ├── controllers/           # Global Controllers
│   │   │   └── auth_controller.dart
│   │   ├── models/                # Data Models
│   │   │   ├── user_model.dart
│   │   │   ├── absence.dart
│   │   │   └── absence_stats.dart
│   │   ├── providers/             # API Communication
│   │   │   ├── auth_provider.dart
│   │   │   ├── pointage_provider.dart
│   │   │   └── etudiant_provider.dart
│   │   └── services/              # Business Logic
│   │       └── supabase_service.dart
│   ├── modules/                   # Feature Modules
│   │   ├── login/                 # Login Module
│   │   │   ├── bindings/
│   │   │   ├── controllers/
│   │   │   └── views/
│   │   ├── pointage/              # Teacher Check-in Module
│   │   │   ├── bindings/
│   │   │   ├── controllers/
│   │   │   └── views/
│   │   │       └── widgets/
│   │   │           └── scanner_page.dart  # QR Scanner
│   │   ├── etudiant/              # Student Module
│   │   │   ├── bindings/
│   │   │   ├── controllers/
│   │   │   └── views/
│   │   │       └── widgets/
│   │   │           ├── etudiant_absence_list.dart
│   │   │           ├── justification_dialog.dart
│   │   │           └── school_map_page.dart
│   │   └── marquage/              # Attendance Marking
│   └── routes/                    # App Navigation
│       ├── app_pages.dart
│       └── app_routes.dart
└── main.dart                      # Entry Point
```

### Data Flow

```
┌─────────────┐
│    View     │
│  (Widget)   │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ Controller  │ ◄─── GetX State Management
│   (GetX)    │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  Provider   │ ◄─── HTTP API Calls
│    (API)    │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   Backend   │
│  REST API   │
└─────────────┘
```

---

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: 3.7.2 or higher
- **Dart SDK**: Included with Flutter
- **Android Studio** / **Xcode** (for mobile development)
- **VS Code** (recommended editor)
- **Backend API**: Running instance of [suivi-absence-backend](https://github.com/mamadbah2/suivi-absence-backend)

### Installation

#### 1. Clone the repository

```bash
git clone https://github.com/mamadbah2/suivi-absence-mobile.git
cd suivi-absence-mobile
```

#### 2. Install dependencies

```bash
flutter pub get
```

#### 3. Configure backend URL

Edit `lib/app/data/providers/auth_provider.dart`:

```dart
final String apiBaseUrl = 'http://your-backend-url:8081/app';
```

#### 4. Configure Supabase (for image storage)

Edit `lib/app/data/config/app_config.dart`:

```dart
class AppConfig {
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
}
```

#### 5. Run the application

```bash
# Run on connected device
flutter run

# Run on specific platform
flutter run -d chrome        # Web
flutter run -d android       # Android
flutter run -d ios          # iOS
flutter run -d windows      # Windows
```

### Build for Production

```bash
# Android APK
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

---

## 📱 Screenshots

### Student View

| QR Code Profile | Absence List | Justification |
|----------------|--------------|---------------|
| ![Profile](image.png) | Student can view all absences | Upload photos for justification |

### Teacher View

| QR Scanner | Student Search | Attendance Marking |
|-----------|---------------|-------------------|
| Scan student QR codes | Search by registration number | One-tap check-in |

---

## 🎨 UI/UX Features

### ISM Color Palette

```dart
const Color ismBrownDark = Color(0xFF43291b);    // Primary Dark
const Color ismOrange = Color(0xFFf89620);       // Accent
const Color ismBrown = Color(0xFF77491c);        // Primary
const Color ismBrownLight = Color(0xFFb56e1e);   // Secondary
const Color ismOrangeLight = Color(0xFFda841f);  // Secondary Accent
const Color ismCream = Color(0xFFf8f1e5);        // Background
```

### Design Principles

- ✅ **Material Design**: Following Google's design guidelines
- ✅ **Responsive Layout**: Adapts to different screen sizes
- ✅ **Custom Widgets**: Reusable component library
- ✅ **Smooth Animations**: Native performance
- ✅ **Dark Mode Ready**: Theme support built-in

---

## 🔧 Key Functionalities

### 1. QR Code Generation

```dart
QrImageView(
  data: matricule,              // Student registration number
  version: QrVersions.auto,
  size: 180.0,
  backgroundColor: Colors.white,
  foregroundColor: ismBrownDark,
  errorCorrectionLevel: QrErrorCorrectLevel.H,
)
```

### 2. QR Code Scanning

```dart
MobileScanner(
  controller: controller,
  onDetect: (capture) {
    final String? scannedValue = capture.barcodes.first.rawValue;
    // Process scanned matricule
    _rechercherEtudiantAPI(scannedValue);
  },
)
```

### 3. Image Upload to Supabase

```dart
final url = await SupabaseService.uploadImage(image);
if (url != null) {
  uploadedImageUrls.add(url);
  // Use URL for justification
}
```

### 4. Geolocation Map

```dart
FlutterMap(
  options: MapOptions(
    initialCenter: schoolLocation,  // ISM coordinates
    initialZoom: 15.0,
  ),
  children: [
    TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    ),
    MarkerLayer(markers: [/* School marker */]),
  ],
)
```

---

## 🎓 Key Learning Concepts

### 1. GetX State Management

```dart
class EtudiantController extends GetxController {
  final RxList<Absence> mesAbsences = <Absence>[].obs;  // Observable list
  final RxBool isLoading = false.obs;                    // Observable boolean
  
  void chargerAbsences() async {
    isLoading.value = true;
    mesAbsences.value = await _etudiantProvider.getAbsences();
    isLoading.value = false;
  }
}
```

### 2. Reactive UI with Obx

```dart
Obx(() => controller.isLoading.value
  ? CircularProgressIndicator()
  : ListView.builder(
      itemCount: controller.mesAbsences.length,
      itemBuilder: (context, index) => AbsenceItem(
        absence: controller.mesAbsences[index],
      ),
    )
)
```

### 3. GetX Navigation

```dart
// Navigate to new screen
Get.to(() => EtudiantPage());

// Navigate and replace
Get.off(() => LoginView());

// Navigate and clear stack
Get.offAll(() => LoginView());

// Named routes
Get.toNamed(Routes.ETUDIANT);
```

### 4. Dependency Injection

```dart
// Binding
class EtudiantBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EtudiantController>(() => EtudiantController());
  }
}
```

### 5. HTTP API Calls

```dart
Future<UserModel> login(String email, String password) async {
  final response = await http.post(
    Uri.parse('$apiBaseUrl/auth/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );
  
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return UserModel.fromJson(data);
  }
  throw Exception('Login failed');
}
```

---

## 🌟 Best Practices Implemented

✅ **Clean Code**: Well-organized, readable, and maintainable  
✅ **Separation of Concerns**: MVC+S architecture  
✅ **Reusable Widgets**: Custom component library  
✅ **Error Handling**: Try-catch blocks and user feedback  
✅ **Loading States**: Proper UX during async operations  
✅ **Secure Storage**: Encrypted JWT token storage  
✅ **Null Safety**: Dart 3.x null safety features  
✅ **Responsive Design**: Adapts to all screen sizes  

---

## 🚧 Future Enhancements

### Planned Features

- [ ] 🔔 Push notifications for absence alerts
- [ ] 📊 Advanced analytics dashboard
- [ ] 📅 Calendar view for absences
- [ ] 🌐 Offline mode with local caching
- [ ] 🎨 Custom themes and personalization
- [ ] 📧 Email notifications
- [ ] 📱 Biometric authentication
- [ ] 🗣️ Multi-language support (French, English, Wolof)
- [ ] 📈 Absence trend charts
- [ ] 🔄 Real-time sync with WebSocket

---

## 🧪 Testing

Run tests:

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Integration tests
flutter drive --target=test_driver/app.test.dart
```

---

## 🤝 Contributors

This project was a collaborative learning effort:

- **Fatima KEITA**
- **Anna NDIAYE**
- **Mamadou Bobo BAH** [@mamadbah2](https://github.com/mamadbah2)
- **Adja Mariem KEITA**
- **Fatoumata Binetou aidel KABIR**
- **Ameth Touré**
- **Ousmane BA**

---

## 📚 Learning Resources

### Official Documentation
- [Flutter Documentation](https://flutter.dev/docs)
- [GetX Documentation](https://pub.dev/packages/get)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)

### Tutorials
- [Flutter Cookbook](https://flutter.dev/docs/cookbook)
- [GetX State Management](https://pub.dev/packages/get#state-management)
- [Mobile Scanner Package](https://pub.dev/packages/mobile_scanner)

---

## 📄 License

This project is available for educational purposes.

---

## 📧 Contact

**Mamadou Bah** - [@mamadbah2](https://github.com/mamadbah2)

Project Link: [https://github.com/mamadbah2/suivi-absence-mobile](https://github.com/mamadbah2/suivi-absence-mobile)

Backend API: [https://github.com/mamadbah2/suivi-absence-backend](https://github.com/mamadbah2/suivi-absence-backend)

---

## 🙏 Acknowledgments

- **ISM Senegal** - For the project context
- **Flutter Team** - For the amazing framework
- **GetX Team** - For the powerful state management
- **Supabase** - For cloud storage solution
- **OpenStreetMap** - For map integration

---

<div align="center">

**🎓 Built to Learn Flutter & Mobile App Development 🎓**

![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white&style=for-the-badge)
![Dart](https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white&style=for-the-badge)
![GetX](https://img.shields.io/badge/GetX-8A2BE2?style=for-the-badge)

**⭐ If this project helped you learn Flutter, please give it a star! ⭐**

</div>
