# 🦷 Dentist Booking Admin System — Full Project Documentation
## **Version 1.1 — Complete Admin Panel**
Author: **Haithem Nini**

---

## 📱 Application Overview

**Dentist Booking Admin** is a comprehensive Flutter-based management system for dental clinic bookings. It provides an advanced admin panel for administrators and staff to efficiently manage all aspects of the clinic.

### ✨ Key Features
- 🔐 **Advanced Authentication System**
- 📊 **Interactive Dashboard with Statistics**
- 👥 **Patient Management (Registered & Guest)**
- 👨‍⚕️ **Staff Management**
- 📅 **Smart Booking System with Validation**
- ⏰ **Queue Management**
- 📢 **Announcements System**
- ⚙️ **Comprehensive Settings**
- 🌍 **Multi-language Support (Arabic/English)**
- 🌓 **Dark/Light Theme Support**

### 🛠️ Technologies Used
- **Frontend**: Flutter (Dart)
- **Backend**: Supabase (PostgreSQL)
- **State Management**: Flutter BLoC
- **Database**: PostgreSQL with RPC Functions
- **Authentication**: Supabase Auth
- **UI Components**: Material Design 3
- **Localization**: Easy Localization
- **Icons**: HugeIcons

---

## 🎯 Login Screen

### Light Mode
![Light Mode Login](assets/screenshots/signin-default-light.jpg)

### Dark Mode
![Dark Mode Login](assets/screenshots/signin-default.jpg)

---

## 📊 Dashboard

### Light Mode Dashboard
![Light Mode Dashboard](assets/screenshots/light_mode_dashboard.jpg)

### Dark Mode Dashboard
![Dark Mode Dashboard](assets/screenshots/dark_mode_dashboard.jpg)

---

## 📋 System Details

This document explains the complete logic for the **booking system**,
including: - Booking creation - Booking update - Booking deletion -
Booking validation rules - Supabase RPC functions - Database schema -
Working hours logic - Admin/staff bypass rules - Error messages
mapping - Flutter client integration

------------------------------------------------------------------------

## 🖥️ UI Interfaces

### 👥 Patient Management

#### Patient List - Light Mode
![Light Mode Patients](assets/screenshots/light_mode_patient.jpg)

#### Patient List - Dark Mode
![Dark Mode Patients](assets/screenshots/dark_mode_patient.jpg)

#### Edit Patient
![Edit Patient](assets/screenshots/dark_mode_edit_patient.jpg)

### 👨‍⚕️ Staff Management

#### Staff List - Light Mode
![Light Mode Staff](assets/screenshots/light_mode_staff.jpg)

#### Staff List - Dark Mode
![Dark Mode Staff](assets/screenshots/dark_mode_staff.jpg)

#### Add Staff
![Add Staff](assets/screenshots/dark_mode_add_staff.jpg)

#### Edit Staff
![Edit Staff](assets/screenshots/dark_mode_edit_staff.jpg)

#### Delete Staff
![Delete Staff](assets/screenshots/dark_mode_delete_staff.jpg)

### 📅 Booking System

#### Booking Screen - Light Mode
![Light Mode Booking](assets/screenshots/light_mode_booking.jpg)

#### Empty Booking List
![Empty Booking List](assets/screenshots/empty_booking_list.jpg)

#### Add Booking
![Add Booking](assets/screenshots/add_booking.jpg)

#### Update Booking
![Update Booking](assets/screenshots/update_booking.jpg)

#### Choose Patient for Booking
![Choose Patient Booking](assets/screenshots/choose_patient_booking.jpg)

### 📢 Announcements System

#### Announcements - Light Mode
![Light Mode Announcements](assets/screenshots/light_mode_announcements.jpg)

#### Announcements - Dark Mode
![Dark Mode Announcements](assets/screenshots/dark_mode_announcements.jpg)

#### Add Announcement
![Add Announcement](assets/screenshots/dark_mode_add_announcement.jpg)

#### Edit Announcement
![Edit Announcement](assets/screenshots/dark_mode_edit_announcement.jpg)

#### Delete Announcement
![Delete Announcement](assets/screenshots/dark_mode_delete_announcement.jpg)

### ⚙️ Settings

#### Settings - Light Mode
![Light Mode Settings](assets/screenshots/light_mode_settings.jpg)

#### Settings - Dark Mode
![Dark Mode Settings](assets/screenshots/dark_mode_settings.jpg)

#### Update Settings
![Update Settings](assets/screenshots/update_settings.jpg)

#### Change Password
![Change Password](assets/screenshots/dark_mode_change_password.jpg)

### 📊 System Status

#### Active Status
![Active Status](assets/screenshots/status-active.jpg)

#### Banned Status
![Banned Status](assets/screenshots/status-banned.jpg)

#### Inactive Status
![Inactive Status](assets/screenshots/status-inactive.jpg)

#### Maintenance Status
![Maintenance Status](assets/screenshots/status-maintenance.jpg)

#### Paused Status
![Paused Status](assets/screenshots/status-paused.jpg)

#### Suspended Status
![Suspended Status](assets/screenshots/status-suspended.jpg)
  
------------------------------------------------------------------------

## 📈 Project Statistics

### ✅ Completed Features

| Feature | Status | Description |
|---------|--------|-------------|
| 🔐 Authentication System | ✅ Complete | Advanced Authentication System |
| 📊 Dashboard | ✅ Complete | Interactive Dashboard with Statistics |
| 👥 Patient Management | ✅ Complete | Patient Management (Registered & Guest) |
| 👨‍⚕️ Staff Management | ✅ Complete | Staff Management System |
| 📅 Booking Validation | ✅ Complete | Booking Validation Logic |
| ➕ Booking Creation | ✅ Complete | Booking Creation |
| ✏️ Booking Update | ✅ Complete | Booking Update |
| 🗑️ Booking Delete | ✅ Complete | Booking Delete |
| ⏰ Working Hours Logic | ✅ Complete | Working Hours Logic |
| 👑 Admin/Staff Bypass | ✅ Complete | Admin/Staff Bypass Rules |
| 🔧 Full RPC Integration | ✅ Complete | Full RPC Integration |
| 🎯 Flutter BLoC Integration | ✅ Complete | Flutter BLoC Integration |
| 🌍 Error Localization | ✅ Complete | Error Localization |
| 🎨 UI/UX Design | ✅ Complete | Modern UI/UX Design |
| 🌙 Dark/Light Theme | ✅ Complete | Dark/Light Theme Support |
| 🔄 Queue Management | ✅ Complete | Queue Management |
| 📢 Announcements System | ✅ Complete | Announcements System |
| ⚙️ Comprehensive Settings | ✅ Complete | Comprehensive Settings |

### 📊 Project Metrics

- **Total Files**: 150+ Dart files
- **Main Modules**: 8 features (Auth, Dashboard, Patients, Staff, Booking, Queue, Announcements, Settings)
- **Supported Languages**: Arabic, English
- **Platforms**: Web, Windows
- **Database**: PostgreSQL with Supabase
- **Flutter Version**: 3.9.2+

---

## 🚀 How to Run

### System Requirements
```bash
Flutter SDK: ^3.9.2
Dart SDK: ^3.9.2
Supabase Account
```

### Installation Steps
```bash
# 1. Clone the repository
git clone [https://github.com/haithemnini/dentist_booking]

# 2. Install dependencies
flutter pub get

# 3. Configure environment variables (.env file)
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key

# 4. Generate localization files
flutter pub run easy_localization:generate -S assets/lang -f keys -o locale_keys.g.dart

# 5. Run the app
flutter run
```

---

## 🏗️ Project Structure

```
lib/
├── app/                    # App configuration
├── core/                   # Core utilities and blocs
│   ├── blocs/             # Global blocs
│   ├── config/            # Configuration files
│   ├── model/             # Data models
│   ├── routes/            # App routing
│   ├── util/              # Utility functions
│   └── widgets/           # Shared widgets
├── features/              # Feature modules
│   ├── auth/              # Authentication
│   ├── dashboard/         # Dashboard
│   ├── patient/           # Patient management
│   ├── staff/             # Staff management
│   ├── booking/           # Booking system
│   ├── queue/             # Queue management
│   ├── announcement/      # Announcements
│   └── settings/          # Settings
└── generated/             # Generated files
```

---

## 📞 Developer Information

**Haithem Nini**\
GitHub: https://github.com/haithemnini\
Email: haithemnini@outlook.com

---

## 📄 License

This project was developed by Haithem Nini for company use and commercial purposes.

---

# ---------- End of Documentation ----------
