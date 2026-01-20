# 🧱 GetX Architecture — Flutter Template

A **clean and scalable Flutter architecture template** built using **GetX** for **state management**, **routing**, and **dependency injection**. This repository demonstrates how to structure a Flutter application in a maintainable, modular, and production-ready way using GetX best practices.

---

## 🚀 What This Repository Does

This project provides:

* 🧠 **GetX State Management** (Reactive & simple)
* 🧭 **Centralized Routing** using GetX
* 🔗 **Dependency Injection** with Bindings
* 🗂️ **Well-organized folder structure**
* 🧩 Clear separation of **UI, logic, and services**

This repository is ideal as a **starter template** for small to large-scale Flutter applications.

---

## 🛠️ Tech Stack

* **Flutter** (UI framework)
* **GetX** (State management, routing & DI)

---

## 📂 Architecture Overview

The project follows a **feature-based clean architecture** using GetX.

```
lib/
 ├── bindings/          # Dependency injection bindings
 ├── controllers/      # GetX Controllers (business logic & state)
 ├── models/           # Data models
 ├── services/         # API calls, repositories, utilities
 ├── views/            # UI screens & widgets
 ├── routes/           # App routes configuration
 ├── utils/            # Constants, helpers
 └── main.dart         # App entry point
```

---

## 🧩 Folder Responsibilities

### 📌 bindings/

* Connects controllers to views
* Handles dependency injection using `Bindings`

### 📌 controllers/

* Contains all `GetxController` classes
* Manages state and business logic
* No UI code

### 📌 models/

* Data models for API and local data
* Pure Dart classes

### 📌 services/

* API calls
* Local storage
* Business services

### 📌 views/

* UI screens and widgets
* Observes controller state using `Obx` / `GetBuilder`

### 📌 routes/

* Centralized route definitions
* Named navigation using GetX

---

## ✨ Key GetX Concepts Used

### 1️⃣ State Management

```dart
final count = 0.obs;
```

Reactive UI updates without `setState()`.

---

### 2️⃣ Dependency Injection

```dart
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
```

---

### 3️⃣ Navigation

```dart
Get.toNamed(Routes.home);
```

No `BuildContext` required.

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  dio: ^5.9.0
  get: ^4.7.2
  get_storage: ^2.1.1
  lottie: ^2.3.0
  cached_network_image: ^3.2.3
  connectivity_plus: ^7.0.0
  intl: ^0.20.2
  permission_handler: ^12.0.1
  socket_io_client: ^3.1.3
  photo_manager: ^3.8.3
```

---

## ▶️ How to Run

```bash
flutter pub get
flutter run
```

---

## 🧪 Use Cases

* Production Flutter apps
* Large-scale applications
* Apps requiring clean state management
* Team-based Flutter projects
* Scalable and maintainable codebases

---

## 🧑‍💻 Author

**Jatin Sharma**
Flutter Developer

GitHub: [https://github.com/sharmajatin1997](https://github.com/sharmajatin1997)

---

## ⭐ Support

If this architecture helps you:

* ⭐ Star the repository
* 🍴 Fork it
* 🧑‍💻 Use it in your projects

---

## 📄 License

This project is open-source and available under the **MIT License**.

---

> ⚠️ Note: This repository is meant as a **reference architecture**. You can extend it with networking libraries (Dio), local storage (GetStorage), and authentication layers as needed.
