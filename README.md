# FitSync - Fitness Tracker App

FitSync is a fitness tracker built with Flutter (frontend) and Node.js + Express + MongoDB (backend).  
Core features: authentication (login/register), timer, workout CRUD, calendar, and progress tracking.

---

## Features

### Authentication
- Register (email, password)
- Login (JWT)
- Protected routes for user data

### Timer
- Start / pause / stop timer for workouts
- Save timer sessions to a workout or as a standalone session

### Workouts (CRUD)
- Create, read, update, delete workout entries
- Each workout: id, userId, title, type, duration_min, calories, date, notes

### Calendar
- View workouts and sessions by date
- Add or move workouts on calendar
- Fetch events for a date range

### Progress
- Daily metrics: steps, distance_km, calories_burned, active_minutes, weight_kg, sleep_hours
- Goals (daily/weekly)
- Trends and aggregates (7/30/90 days)
- Export (CSV / JSON)

---

## Tech Stack
- Frontend: Flutter, Cubit/Bloc, fl_chart
- Backend: Node.js, Express, MongoDB, Mongoose
- Auth: JWT
- Storage: MongoDB (progress, workouts, users, goals)

---

---

## Setup

### Backend
```bash
cd backend
npm install
# create .env with MONGO_URI, JWT_SECRET, PORT
npm start
```

### Frontend
```bash
cd frontend
flutter pub get
flutter run
```

---
