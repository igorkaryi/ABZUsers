# ABZUsersApp

## ⚙️ Configuration

Ensure you are using:

- **Xcode 15+**
- **Swift 5.9+**
- Active run scheme uses `AppEnvironment.prod`

## 📦 Dependencies

This project uses the following frameworks/libraries:

- **Combine** – for asynchronous reactive operations.
- **SwiftUI** – for modern declarative UI.
- **Foundation** – for networking and JSON decoding.

No third-party packages are used.

## 🧯 Troubleshooting

- 🔌 **No Internet** – handled by `NetworkMonitor`, triggers `StatusScreen` when offline.
- ⛔ **API Errors (400–599)** – parsed using `APIError`. Token refresh is triggered for 401.
- 🧪 **Token expired** – ensure `TokenStorage.getToken(using:)` is implemented properly.

## 📘 Documentation

### 🌐 External APIs

OpenAPI Docs: [ABZ API](https://openapi_apidocs.abz.dev/frontend-test-assignment-v1#/users/post_users)

Used endpoints:

- `GET /users` – Fetch users
- `POST /users` – Register new user
- `GET /token` – Token generation

### 📁 Project Structure

```
ABZUsersApp/
├── Screens/
│   ├── Users/
│   ├── Signup/
│   └── Status/
├── Networking/
│   ├── APIService.swift
│   ├── IdentityEndPoint.swift
│   ├── APIError.swift
│   └── TokenStorage.swift
├── Views/
│   └── FormFields/
├── Resources/
│   └── Assets.xcassets
│   └── Localizable.strings
└── Helpers/
    ├── Extensions/
    └── Constants/
```

### 🧠 Main Modules

- `APIService` – generic networking logic with token handling and retry support
- `TokenStorage` – handles saving and refreshing tokens
- `NetworkMonitor` – monitors connectivity status
- `Form Fields` – reusable validated input fields
- `StatusScreen` – displays error/success/offline messages

---
