# PawPals 🐾

<p align="center">
  <img src="https://img.shields.io/badge/Platform-iOS%2016%2B-purple?style=for-the-badge&logo=apple" />
  <img src="https://img.shields.io/badge/Swift-5.9-orange?style=for-the-badge&logo=swift" />
  <img src="https://img.shields.io/badge/Firebase-Auth%20%2B%20Firestore-yellow?style=for-the-badge&logo=firebase" />
  <img src="https://img.shields.io/badge/Status-In%20Progress-green?style=for-the-badge" />
</p>

**IOS Mobile Development II** · LaSalle College Montreal · 2026  
Byron Baron (2311617) & Hope Ukundimana (202333733)

---

## What is PawPals?

PawPals is an iOS app we built for our Mobile Development II course. The idea came from a simple problem — pet owners in the city have a hard time finding reliable, local pet care. You either ask around or scroll through sketchy websites. We wanted to fix that.

The app lets pet owners find sitters, walkers, vets, and groomers nearby, book them directly, and manage everything in one place — their pet's profile, medical records, upcoming appointments, and messages with providers.

We also built it with service providers in mind, so they have their own dashboard to manage jobs and clients.

---

## The Problem We're Solving

If you own a pet in Montreal (or any city) and need someone to look after them while you travel or work late, finding someone trustworthy is actually hard. Most people rely on word of mouth. We wanted to build something that makes the whole process easier — discovering providers, checking reviews, booking, paying, and staying in touch — all in one app.

---

## Who It's For

Pet Owners — busy professionals, travelers, new pet owners, families, anyone who needs help taking care of their animals.

Service Providers — pet sitters, dog walkers, groomers, vets, trainers. Anyone offering pet-related services locally.

Businesses — vet clinics, pet shops, grooming studios, shelters. Businesses that want to reach more clients through the app.

---

## What We Built

We have 24 screens built in SwiftUI. Here's a breakdown of what's in the app:

Auth
- Sign up, login, logout (Firebase Auth)
- Role selection at onboarding — you pick if you're a pet owner, provider, or business
- Forgot password / change password

**Pet Owner Side**
- Home dashboard with upcoming bookings and pet carousel
- Pet profiles (add, edit, view)
- Medical records — vaccinations, vet visits, treatments
- Browse service providers with filters
- Book a service with date/time selection
- Schedule view for upcoming appointments
- Messaging (conversations + chat)
- Payment flow
- User profile with settings

**Service Provider Side**
- Separate home dashboard with earnings and job overview
- Client management

**Business Client Side**
- Business-focused dashboard

---

## Tech Stack

| | |
|---|---|
| Language | Swift 5.9 |
| UI | SwiftUI |
| Auth | Firebase Authentication |
| Database | Firebase Firestore |
| Local Storage | CoreData |
| Navigation | NavigationStack (iOS 16+) |
| Architecture | MVVM |
| Design | Figma |
| Version Control | Git + GitHub |

---

## Project Structure

```
PawPals/
├── Auth/
│   ├── AuthenticationManager.swift
│   ├── LoginView.swift
│   ├── SignUpView.swift
│   ├── ForgotPasswordView.swift
│   └── ChangePasswordView.swift
│
├── Home/
│   ├── PetOwnerHomeView.swift
│   ├── ServiceProviderHomeView.swift
│   └── BusinessClientHomeView.swift
│
├── Pets/
│   ├── PetProfileView.swift
│   ├── AddPetView.swift
│   ├── EditPetView.swift
│   └── MedicalRecordsView.swift
│
├── Services/
│   ├── ServiceProvidersListView.swift
│   ├── ServiceProviderDetailView.swift
│   └── BookServiceView.swift
│
├── Bookings/
│   ├── BookingDetailsView.swift
│   └── ScheduleView.swift
│
├── Messages/
│   └── MessagesView.swift
│
├── Payment/
│   └── PaymentView.swift
│
├── Profile/
│   ├── UserProfileView.swift
│   └── EditProfileView.swift
│
└── Core/
    ├── ContentView.swift
    ├── AppState.swift
    ├── RoleSelectionView.swift
    └── Persistence.swift
```

---

## Firestore Data Structure

```
users/{userId}
  ├── uid
  ├── email
  ├── fullName
  ├── phoneNumber
  ├── userType        → "petOwner" | "serviceProvider" | "businessClient"
  ├── profileImageUrl
  ├── bio
  └── createdAt
```

Bookings, pets, messages, and reviews will be added as we continue building.

---

## Running the Project

You'll need Xcode 15+ and a Firebase project set up.

```bash
git clone https://github.com/hope400/PawPals.git
cd PawPals
```

Add Firebase through Swift Package Manager:
- `https://github.com/firebase/firebase-ios-sdk`
- Add `FirebaseAuth` and `FirebaseFirestore`

Download your `GoogleService-Info.plist` from Firebase Console and drop it in the root of the project. **Don't commit this file.**

Enable Email/Password auth and create a Firestore database in your Firebase Console, then build and run.

---

## What's Done vs What's Next

Done
- All 24 screens built in SwiftUI
- Firebase auth working (sign up, login, logout)
- User data saved to Firestore
- Role-based navigation
- All UI flows connected

In progress
- Saving bookings and pets to Firestore
- Real-time chat with Firestore
- Profile image upload with Firebase Storage

Coming later
- MapKit for finding providers on a map
- Walk tracking with CoreLocation
- Push notifications
- Stripe payments
- Google and Apple Sign-In
- Offline support with CoreData
- Tests

---

## Notes

Make sure your `.gitignore` has:
```
GoogleService-Info.plist
*.xcuserstate
DerivedData/
```

---

## Team

Byron Baron & Hope Ukundimana  
IOS Mobile Development II · 420-DM6-ASC2  
LaSalle College, Montreal · 2026
