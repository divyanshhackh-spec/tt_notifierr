# TT Notifier – Teacher Timetable & Alerts

TT Notifier is a Flutter-based timetable and notification system for schools.  
Teachers get a cyberpunk-themed dashboard showing today’s periods, and the app schedules local notifications before each class. Admins manage timetables via Supabase.

---

## Features

- Teacher login with username + PIN (stored in Supabase `teachers` table).
- Daily timetable view filtered by:
  - `teacher_username`
  - `day_of_week` (1 = Monday … 7 = Sunday)
- Cyberpunk UI with neon styling for periods and session info.
- Local notifications a few minutes before each period.  
- Works on:
  - Android
  - Web (Flutter web)
  - iOS (requires macOS + Xcode to build).

---

## Tech Stack

- **Frontend**: Flutter, Provider for state management.  
- **Backend**: Supabase (PostgreSQL + Auth + REST).  
- **Notifications**: Custom `NotificationService` (local notifications per period).  
- **Language**: Dart.

---

## Project Structure (key parts)

- `lib/main.dart` – App entry point and routing.  
- `lib/services/auth_service.dart` – Teacher login and session management.  
- `lib/services/notification_service.dart` – Scheduling notifications for periods.  
- `lib/models/teacher.dart` – Teacher model (id, username, pin, fullName, isAdmin).  
- `lib/models/timetable_entry.dart` – Timetable entry model (day, period, subject, room, times).  
- `lib/screens/teacher_home_screen.dart` – Teacher dashboard with today’s timetable.

---

## Supabase Setup

1. Create a Supabase project and note the `url` and `anon key`.  
2. Add them to your Flutter app (usually in `main.dart` via `Supabase.initialize`).  
3. Create tables:

### `teachers`

- `id` – uuid (default `uuid_generate_v4()`).
- `username` – text, unique.
- `pin` – text.
- `full_name` – text.
- `is_admin` – boolean (default `false`).

### `timetables`

- `id` – uuid or serial (your choice).
- `teacher_username` – text (FK-style link to `teachers.username`).
- `day_of_week` – int (1–7).
- `period_number` – int.
- `class_name` – text.
- `section` – text.
- `room_number` – text.
- `subject` – text.
- `start_time` – text (e.g. `"09:00"`).
- `end_time` – text (e.g. `"09:45"`).

Populate some test data for a teacher (e.g. username `test`, pin `test`) and corresponding timetable rows.

---

## Running the App

### Prerequisites

- Flutter SDK installed.  
- Dart SDK (comes with Flutter).  
- Supabase project configured as above.

### Commands

