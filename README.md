# CC 302 API Activity

A Flutter application that fetches data from a REST API and displays the
results using `ListView.builder`.

## Technologies

- Flutter
- Dart
- `http` package
- JSONPlaceholder API

## API

https://jsonplaceholder.typicode.com/posts

## Features

- Fetch data from an API
- Parse JSON data into a custom Dart class
- Display API data with `ListView.builder`
- Loading indicator while the request is in progress
- Error handling with a retry action

## Project Structure

```
lib/
├── main.dart                 # UI, FutureBuilder, ListView.builder
├── models/
│   └── post.dart             # Post model + Post.fromJson()
├── services/
│   └── api_service.dart      # http.get() + jsonDecode()
└── fruit_list.dart           # Separate ListView.builder practice app
```

## How It Works

```
JSONPlaceholder API
        │ GET
        ▼
   ApiService.http.get()
        │ JSON
        ▼
     jsonDecode()
        │ List<dynamic>
        ▼
    Post.fromJson()
        │ List<Post>
        ▼
    FutureBuilder
        │
        ▼
  ListView.builder()
        │
        ▼
    Flutter UI
```

## How to Run

```bash
flutter pub get
flutter run
```

## Testing

```bash
flutter analyze
flutter test
```

The test suite covers the `Post` model, `ApiService` (including a live request
to JSONPlaceholder), and all UI states: loading, success, empty, and error with
retry.