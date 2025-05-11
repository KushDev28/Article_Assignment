# Kushal Assignment App

A Flutter app that fetches and displays a list of articles from a public API using clean architecture and Riverpod for state management.A Flutter app that fetches and displays a list of articles from a public API using clean architecture and Riverpod for state management.

## Features

- ✅ List of articles
- 🔍 Client-side search functionality
- 📄 Detail view (optional or expandable)
- 📱 Responsive UI with reusable ListView
- ⚙️ Clean architecture with separation of concerns (data, domain, presentation)

## Setup Instructions
1. Clone the repo:
   git clone <your-repo-link>
   cd kushal_assignment
2. Install dependencies:
   flutter pub get
3. Run the app:
   flutter run


## Tech Stack

- Flutter SDK: 3.27.1

- Dart SDK: 3.6.0

- State Management: Riverpod (with code generation using riverpod_annotation)

- HTTP Client: Dio

- Dependency Injection: GetIt

- Architecture: Clean Architecture (data, domain, presentation layers)


## State Management Explanation
This app uses flutter_riverpod with @Riverpod annotations for managing application state in a modular and testable way. The PostNotifier handles API calls and exposes a list of posts via an AsyncValue. A StateProvider tracks the search query and filters posts client-side based on the title or body.

## Screenshots

### Main Screen
![Main Screen](assets/screenshots/main_screen.png)

### Article Detail Screen
![Article Detail](assets/screenshots/detail_screen.png)

### Favorites Screen
![Favorites](assets/screenshots/favorites_screen.png)