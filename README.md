# Rondônia Cacau Clube

A showcase + traceability app (NOT e-commerce — no cart, checkout, prices or
payments) for cocoa **byproducts** from the state of Rondônia, Brazil, with a
focus on products beyond chocolate: **mel de cacau** (cocoa honey) and
**nibs de cacau** (cocoa nibs). Consumers discover Rondônia cocoa byproducts,
see who produced them and where they come from (full origin traceability),
follow producers/cooperatives, and join a "Clube do Cacau".

UI language: **pt-BR**. Code, comments and identifiers: **English**.
This prototype has **no AI features and uses no third-party API keys**.

The Flutter project lives in [`app/`](app/).

---

## Tech stack

- **Flutter** (stable) + Dart, null-safe.
- **GetX** (`get`) for state management, dependency injection and routing.
- **Firebase**: Core, Auth, Cloud Firestore, Storage, Analytics, Crashlytics.
- **google_fonts** for the Lora + Hanken Grotesk type families.
- **shared_preferences** for lightweight local state (e.g. theme).
- **dartz** for the functional `Result` (Either) error type.

## Architecture — SOLID + Clean Architecture

```
app/lib/
├── app/            # GetMaterialApp root widget
├── core/           # cross-cutting: theme, routes, bindings, constants, widgets
│   ├── theme/      # design tokens → colors, spacing, radii, typography, themes
│   ├── routes/     # AppRoutes (names) + AppPages (GetPage table)
│   ├── bindings/   # InitialBinding (app-wide DI)
│   ├── controllers/# ThemeController
│   ├── constants/  # pt-BR strings, asset paths
│   └── widgets/    # shared widgets
├── domain/         # pure Dart: entities, repository INTERFACES, use cases
│   └── core/       # Failure, Result (Either), UseCase contract
├── data/           # repository IMPLEMENTATIONS, data sources, DTOs, mappers
└── presentation/   # screens, GetxControllers (view-models), Bindings
    ├── shell/      # app shell + bottom navigation
    ├── home/  search/  club/  profile/
```

Layer rules:
- **domain** depends on nothing Flutter/Firebase/GetX — pure Dart abstractions.
- **data** implements the domain repository interfaces (Firebase lives here only).
- **presentation** depends on domain abstractions; controllers receive use cases
  through GetX **Bindings** (dependency inversion).
- Errors cross boundaries as a `Result<T>` (`Either<Failure, T>`), never as
  thrown exceptions.

## Design system

The warm-cocoa Material 3 theme (light **and** dark) is generated from the
design tokens in `design/screens/Tokens _ Componentes.png`:

- **Surfaces**: cream `#FBF4E9`, white, soft creams.
- **Cacau**: choco `#2E1C12 / #5A3522 / #6B3F23`, caramel `#B5703A`.
- **Accent**: honey/amber `#D98B1F`, amber-soft `#F3C95E`, forest green `#3F7A43`.
- **Type**: Lora (serif, display/titles) + Hanken Grotesk (sans, body).
- **Radii**: 12 / 18 / 26 / 32 / pill. **Spacing** (base 4): 4 / 8 / 12 / 16 / 20 / 26.

---

## Getting started

```bash
cd app
flutter pub get
flutter run         # choose a device (web/android/ios)
flutter test        # unit + widget tests
flutter analyze
```

### Firebase configuration

The Firebase config files contain the project's client API keys and are **not
committed** (this repo is public). They are git-ignored; the repo ships
placeholder templates instead:

- `app/lib/firebase_options.dart.example`
- `app/android/app/google-services.json.example`

To wire your own Firebase project, run:

```bash
cd app
flutterfire configure
```

This regenerates the ignored real files (`lib/firebase_options.dart`,
`android/app/google-services.json`, and the iOS/macOS `GoogleService-Info.plist`).
Alternatively, copy each `*.example` to its real filename and fill in your
values.

Required Firebase products: Authentication (Email + Google), Cloud Firestore,
Storage. Crashlytics collection is disabled in debug builds.

> **Note on API keys:** Firebase *client* API keys are not classic secrets —
> access is enforced by Firebase Security Rules, API-key restrictions and App
> Check, not by hiding the key. We still keep them out of this public repo as
> good hygiene. Because the keys were briefly public, restrict/rotate them in
> the Google Cloud Console and lock down Security Rules before any real use.

---

## Milestones

- [x] **M1 — Foundation**: Clean Architecture scaffold, GetX (controllers /
  bindings / routes), Firebase wiring, warm-cocoa Material 3 theme (light+dark),
  app shell + bottom navigation (Início · Buscar · Clube · Perfil).
- [ ] **M2 — Catalog + Traceability**: product domain/data layers + Firestore,
  Home/Catalog, Product Detail (traceability timeline + origin map pin), seed data.
- [ ] **M3 — Producers + Reviews**: producer/cooperative profiles, follow,
  ratings & reviews, quality seals.
- [ ] **M4 — Cocoa Club + Auth**: onboarding, login/sign-up (email + Google),
  subscription tiers (mocked paid state), search & filters.

Built incrementally; each milestone is committed and pushed separately.
