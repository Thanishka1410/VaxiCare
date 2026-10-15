# VaxiCare — Smart Vaccination Reminder & Tracking Application

[![Deploy VaxiCare to GitHub Pages](https://github.com/Thanishka1410/VaxiCare/actions/workflows/deploy.yml/badge.svg)](https://github.com/Thanishka1410/VaxiCare/actions/workflows/deploy.yml)

> **Tagline:** Never Miss a Dose. Protect Every Tomorrow.  
> **Project Title:** VaxiCare: A Smart Vaccination Reminder and Tracking Application Using Flutter  
> **Degree/Course:** B.Tech CSE — UI/UX Engineering & Mobile Applications Lab Project  

---

## 🌟 Project Overview

**VaxiCare** solves a critical healthcare problem faced by parents and families: tracking complex multi-year pediatric and adult immunization schedules. Remembering critical vaccination dates, preserving physical yellow-card vaccination certificates, and monitoring overdue milestones can be overwhelming. 

VaxiCare provides a clean, responsive, and reassuring digital companion built using **Flutter Web** and **Material 3**. It organizes personalized immunization calendars, calculates age-appropriate dose requirements, generates digital vaccination passes, and issues visual alerts for overdue doses.

---

## 🚀 Live Demonstration (No Local Flutter Installation Required)

Once pushed to GitHub, the application is automatically built and hosted via **GitHub Actions** and **GitHub Pages**:

🔗 **Live Website URL:**  
`https://Thanishka1410.github.io/VaxiCare/`  
*(Replace `YOUR_USERNAME` with your actual GitHub username)*

---

## ✨ Key Features & UI/UX Highlights

1. **Intuitive Dashboard:**
   - Visual immunization completion progress bar.
   - Quick counters for **Completed**, **Upcoming**, and **Overdue** milestones.
   - High-visibility alert banners for overdue vaccines requiring immediate pediatric attention.
   - Profile quick-switcher for households with multiple children.

2. **Personalized Vaccination Schedule:**
   - Automatic generation of standard WHO/IAP pediatric milestones upon adding a child profile (BCG, Hepatitis B, Polio OPV/IPV, Rotavirus, PCV, DTP, MMR).
   - Real-time search by vaccine name or target disease (e.g., *Polio*, *Tuberculosis*).
   - Instant filtering by status chips (*All*, *Upcoming*, *Overdue*, *Completed*).

3. **Digital Vaccination Passbook (Records):**
   - Centralized digital record book displaying administration dates, pediatric hospital/clinic names, and batch numbers.
   - Web print/export capability for school admissions or travel requirements.

4. **Multi-Child & Family Profile Management:**
   - Support for multiple children and dependents.
   - Custom avatars, date of birth tracking with dynamic age formatting (*"4 months old"*, *"2 yr 1 mo old"*), and blood group indicators.

5. **Local Web Persistence & Simulated Auth:**
   - **Persistent Browser Storage:** Built with `shared_preferences` web support so changes (marking doses, adding children) remain saved across page refreshes.
   - **Simulated Authentication:** Provides an educational, clear separation between demonstration authentication and production backend identity providers without requiring paid cloud databases or third-party API keys.
   - **Instant Demo Access Button:** One-click demo sign-in pre-configured with sample pediatric records for immediate presentation.

6. **Responsive Design System (8-Point Grid):**
   - **Primary Blue:** `#2563EB`
   - **Secondary Mint Green:** `#10B981`
   - **Background Soft Slate:** `#F8FAFC`
   - **Card Background:** `#FFFFFF`
   - **Text Palette:** Deep Charcoal `#0F172A` and Slate `#64748B`
   - Adaptive **Bottom Navigation Bar** for mobile phones and **Navigation Rail** for desktop browsers.

---

## ⚙️ Automated CI/CD Architecture (GitHub Actions)

The repository includes a production-grade automated deployment pipeline in [`.github/workflows/deploy.yml`](.github/workflows/deploy.yml):

```
Push to main branch / Manual Workflow Dispatch
         │
         ▼
GitHub Actions Ubuntu Runner
         │
         ├── Set up Flutter SDK (Stable Channel, Cached)
         ├── Run `dart format --output=none --set-exit-if-changed lib`
         ├── Run `flutter analyze`
         ├── Run Automated Unit Tests (`flutter test`)
         ├── Build Flutter Web in Release Mode (`flutter build web --release --base-href "/VaxiCare/"`)
         │
         ▼
Upload build/web Artifact
         │
         ▼
Deploy to GitHub Pages
         │
         ▼
Live Web Application at https://YOUR_USERNAME.github.io/VaxiCare/
```

> **Base Href Notice:**  
> The workflow compiles the Flutter Web app with `--base-href "/VaxiCare/"` to ensure all asset paths, icons, font files, and routing correctly resolve under the GitHub Pages repository subpath.

---

## 📋 Step-by-Step GitHub Setup Guide

Follow these steps to deploy and run the project online:

### Step 1: Create a New Repository on GitHub
1. Log into your GitHub account at [github.com](https://github.com).
2. Click **New** repository.
3. Repository name: **`VaxiCare`** *(Case-sensitive)*.
4. Set visibility to **Public** (required for free GitHub Pages).
5. **Do NOT** initialize with a README, .gitignore, or license (these are already created locally).
6. Click **Create repository**.

### Step 2: Push the Local Code to GitHub
Open PowerShell or your preferred terminal in this project directory (`c:\Users\91901\OneDrive\Desktop\VaxiCare`):

```powershell
cd "c:\Users\91901\OneDrive\Desktop\VaxiCare"
git init
git add .
git commit -m "feat: Initial release of VaxiCare with Flutter Web and GitHub Actions CI/CD"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/VaxiCare.git
git push -u origin main
```
*(Replace `YOUR_USERNAME` with your GitHub username)*

### Step 3: Enable GitHub Pages in Repository Settings
1. Go to your repository on GitHub: `https://github.com/YOUR_USERNAME/VaxiCare`.
2. Click **Settings** (gear icon in the top navigation).
3. In the left sidebar, click **Pages** (under "Code and automation").
4. Under **Build and deployment** > **Source**, select:
   👉 **GitHub Actions**
5. Save changes.

### Step 4: Monitor the Deployment & Open the Website
1. Click the **Actions** tab in your repository.
2. You will see the **Deploy VaxiCare to GitHub Pages** workflow running.
3. Once completed (indicated by a green checkmark ✅), click the run to view the generated URL:
   `https://YOUR_USERNAME.github.io/VaxiCare/`
4. Open the link in Google Chrome, Microsoft Edge, or Safari to demonstrate the full application!

---

## 🔒 Simulated vs. Real Authentication Explanation

For educational lab assessments and UI/UX reviews:
- **Simulated Authentication (Current Implementation):** Manages local session states using Flutter `Provider` and browser `SharedPreferences`. Validates email and password format on the client side without storing plain text on servers or incurring cloud database charges.
- **Production Backend Authentication (Enterprise Upgrade):** Uses OAuth 2.0 / OpenID Connect (e.g., Firebase Auth, Supabase, or AWS Cognito) where JWT tokens are securely signed, passwords hashed with bcrypt/Argon2, and user roles enforced via server-side security rules.

---

## 📁 Project Structure

```
VaxiCare/
├── .github/
│   └── workflows/
│       └── deploy.yml          # GitHub Actions workflow for Web build & deployment
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   │   └── app_colors.dart # Theme color constants (8-point system)
│   │   └── theme/
│   │       └── app_theme.dart  # Material 3 typography & centralized theme
│   ├── models/
│   │   ├── child_profile.dart  # Child dependent model with age calculation
│   │   ├── vaccine_record.dart # Vaccine status, dosage, and clinic details
│   │   └── mock_data.dart      # Standard pediatric vaccination schedule
│   ├── providers/
│   │   ├── auth_provider.dart  # Session state & demo login provider
│   │   └── vaccine_provider.dart # Filtering, CRUD, and progress metrics
│   ├── services/
│   │   └── storage_service.dart# SharedPreferences browser-local persistence
│   ├── widgets/
│   │   ├── primary_button.dart
│   │   ├── app_text_field.dart
│   │   ├── status_badge.dart
│   │   ├── vaccine_card.dart
│   │   ├── child_profile_card.dart
│   │   ├── progress_summary_card.dart
│   │   ├── empty_state_widget.dart
│   │   ├── confirmation_dialog.dart
│   │   ├── vaccine_detail_dialog.dart
│   │   ├── add_vaccine_dialog.dart
│   │   ├── add_child_dialog.dart
│   │   └── responsive_layout.dart
│   ├── screens/
│   │   ├── auth_screen.dart
│   │   ├── dashboard_screen.dart
│   │   ├── schedule_screen.dart
│   │   ├── records_screen.dart
│   │   ├── family_screen.dart
│   │   ├── settings_screen.dart
│   │   └── main_navigation_shell.dart
│   └── main.dart
├── test/
│   └── model_test.dart         # Unit tests for data models
├── web/
│   ├── favicon.svg             # Modern healthcare vector favicon
│   ├── index.html              # Web entrypoint with $FLUTTER_BASE_HREF
│   └── manifest.json           # Web app manifest
├── analysis_options.yaml       # Dart analysis & linter rules
├── pubspec.yaml                # Project metadata & dependencies
├── .gitignore                  # Git exclusions for Flutter & Web
└── README.md                   # Project documentation & presentation guide
```

---

## 👩‍💻 Authors & Academic Attribution
- **Project:** VaxiCare — Smart Vaccination Reminder
- **Course:** B.Tech Computer Science & Engineering
- **Domain:** UI/UX Engineering & Cross-Platform Mobile Applications
