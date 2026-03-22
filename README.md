# Neuro Habit

A habit tracking app built with full clean architecture in Flutter. The focus is on simplicity — build habits, track them daily, and stay consistent.

## Features

- Add custom habits with a title and mood tag
- Toggle habit completion per day
- Animated dashboard screen with a pulsing FAB button
- Bottom sheet for adding new habits without leaving the screen
- Offline-first: all data stored locally with Hive

## Tech Stack

- **State Management:** Cubit (flutter_bloc) with Equatable
- **Local Storage:** Hive + hive_flutter
- **Other:** UUID for unique habit IDs, cupertino_icons

## Architecture

Clean Architecture with three layers:

```
lib/
├── data/
│   ├── models/         — HabitModel (serialization)
│   ├── repositories/   — HabitRepositoryImpl
│   └── data_sources/   — HabitLocalDataSourceImpl (Hive)
├── domain/
│   ├── entities/       — Habit
│   ├── repositories/   — HabitRepository (abstract)
└── presentation/
    ├── cubit/          — HabitCubit, HabitState
    └── screens/        — HabitDashboardScreen, AddHabitSheet
```
