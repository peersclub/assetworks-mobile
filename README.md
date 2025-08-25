# AssetWorks Mobile - iOS App

AI-Powered Financial Analysis Mobile Application built with Flutter for iOS.

## Features

✅ **Dashboard with Tabs**
- My Reports - View your created reports
- Saved Reports - Access bookmarked reports

✅ **Profile Screen**
- User profile with stats (followers, following, reports)
- Edit profile functionality
- Follow/unfollow users
- Settings and sign out

✅ **Widget Creation**
- Asset class selection (Stocks, Crypto, Forex, etc.)
- AI-powered report generation
- Advanced analysis options
- Quick suggestions

✅ **Explore Page**
- All reports with pagination
- Trending reports
- Following feed
- Search functionality

✅ **Notifications**
- Real-time notifications
- Mark as read/unread
- Swipe to delete
- Notification badges

✅ **Authentication**
- Sign in / Sign up
- Secure authentication with API
- Session management

## Tech Stack

- **Framework**: Flutter (iOS-focused with Cupertino widgets)
- **State Management**: GetX
- **Navigation**: GetX routing
- **HTTP Client**: Dio with interceptors
- **Local Storage**: GetStorage
- **UI Theme**: iOS 18 Design System

## Project Structure

```
lib/
├── main.dart                      # App entry point
├── core/
│   ├── theme/
│   │   └── ios18_theme.dart      # iOS 18 theme configuration
│   └── utils/
│       └── helpers.dart          # Utility functions
├── data/
│   └── models/
│       ├── user_model.dart       # User data model
│       └── widget_model.dart     # Widget/Report data model
├── services/
│   ├── api_service.dart          # API integration
│   └── auth_service.dart         # Authentication service
└── presentation/
    ├── controllers/
    │   ├── dashboard_controller.dart
    │   ├── profile_controller.dart
    │   ├── explore_controller.dart
    │   ├── create_widget_controller.dart
    │   └── notifications_controller.dart
    ├── pages/
    │   └── ios/
    │       ├── main_tab_screen.dart
    │       ├── auth/
    │       ├── dashboard/
    │       ├── profile/
    │       ├── explore/
    │       ├── create/
    │       └── notifications/
    └── widgets/
        └── ios/
            ├── ios_widget_card.dart
            └── ios_loader.dart
```

## Getting Started

1. **Install Dependencies**
   ```bash
   flutter pub get
   ```

2. **Run the App**
   ```bash
   flutter run
   ```

3. **Build for iOS**
   ```bash
   flutter build ios
   ```

## API Configuration

The app connects to the AssetWorks API at `https://app.assetworks.ai`. 
API endpoints are configured in `lib/services/api_service.dart`.

## Key Components

### Dashboard
- Displays user's created reports and saved reports
- Tab switching with smooth animations
- Pull-to-refresh functionality
- Grid layout with compact widget cards

### Profile
- Comprehensive user profile display
- Follow/unfollow functionality
- Profile editing
- User statistics
- Settings menu

### Create Widget
- Interactive asset class selection
- Rich text input for analysis prompts
- Real-time generation progress
- Advanced analysis options

### Explore
- Three tabs: All, Trending, Following
- Infinite scroll pagination
- Search functionality
- Widget interaction (save, share)

### Notifications
- Real-time notification updates
- Swipe-to-delete
- Mark all as read
- Notification type indicators

## Design System

The app follows iOS 18 design guidelines with:
- Cupertino widgets throughout
- System colors and typography
- Haptic feedback
- Smooth animations
- Adaptive layouts

## State Management

Using GetX for:
- Reactive state management (Obx)
- Dependency injection
- Navigation
- Snackbar notifications

## API Integration

- RESTful API communication
- JWT token authentication
- Automatic retry on 502 errors
- Request/response interceptors
- Error handling

## Future Enhancements

- [ ] Widget detail view
- [ ] Comments system
- [ ] Real-time updates via WebSocket
- [ ] Offline mode with local caching
- [ ] Push notifications
- [ ] Dark mode support
- [ ] iPad optimization

## License

Proprietary - AssetWorks AI