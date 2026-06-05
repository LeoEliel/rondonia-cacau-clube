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

The single source of truth is [`design_tokens.md`](design_tokens.md) at the repo
root; the warm-cocoa Material 3 theme (light **and** dark) is generated from it
under `app/lib/core/theme/` (`app_colors`, `app_typography`, `app_spacing`,
`app_radii`, `app_elevation`, `app_seals`):

- **Surfaces**: cream `#FBF4E9`, white, soft creams.
- **Cacau**: choco `#241208 / #2E1C12 / #3A2317 / #5A3522 / #6B3F23`, caramel `#B5703A`.
- **Amber accent**: `#D98B1F` (+ deep `#C0741A`, soft `#F3C95E`, tint `#FBEFD2`).
- **Forest green accent**: `#3F7A43` (+ deep `#356637`, soft `#6BA45F`, tint `#E6F0DF`).
- **Type**: Lora (serif — display/titles/product names/italic story) + Hanken
  Grotesk (sans — body/meta/overline/seal).
- **Radii**: 8 / 12 / 18 / 26 / 32 / pill. **Spacing** (base 4): 4 / 8 / 12 / 16 /
  20 / 26, plus semantic `pad 20 · gap 14 · gapSm 9 · sect 26 · cardPad 15`.
- **Elevation**: cocoa-tinted `e1 / e2 / e3` shadows. **Quality seals** color map.

---

## Getting started

```bash
cd app
flutter pub get
flutter run         # choose a device (web/android/ios)
flutter test        # unit + widget tests
flutter analyze
```

### Run modes

The app runs in two modes, selected entirely by `--dart-define` — the same
binding code serves both (see `lib/core/bindings/data_binding.dart`):

- **DEMO** (offline, in-memory mock data; no Firebase backend or store keys
  needed). Cocoa Club purchases fall back to a tier-flip mock, so the
  "Assinar o Clube" flow works without RevenueCat. This Codespace forwards
  **port 8080** only:

  ```bash
  flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080 --dart-define=DEMO=true
  ```

- **Non-DEMO** (real Firebase). On **mobile**, Cocoa Club purchases use
  RevenueCat; pass the key at build time (never commit it). On **web**,
  purchases use the same tier fallback as DEMO (RevenueCat is mobile-only):

  ```bash
  flutter run --dart-define=REVENUECAT_API_KEY=goog_xxx        # Android/iOS
  flutter run -d web-server --web-port 8080                    # web (no key needed)
  ```

The RevenueCat SDK is only ever configured on non-DEMO **native** builds with a
non-empty key; web/DEMO never touch it.

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

### Security rules

`app/firestore.rules` makes the catalog (producers/products/origin_lots) public
read-only, lets signed-in users create their own reviews and adjust a producer's
follower count, and keeps each user's profile/subscription private to its owner.

---

## Data model & seeding

Firestore collections (wire shapes in `app/lib/data/dtos/`):

| Collection | Key fields |
|---|---|
| `users` | name, email, photoUrl, subscriptionTier, followingProducerIds[], createdAt |
| `producers` | name, type (producer\|cooperative), bio, story, municipality, geo, certifications[], qualitySeals[], photoUrls[], followerCount, rating |
| `products` | producerId, name, byproductCategory, description, photoUrls[], qualitySeals[], originLotId, rating, reviewCount, createdAt |
| `origin_lots` | producerId, municipality, geo, harvestDate, processingNotes, timeline[] |
| `reviews` | productId, userId, rating, text, createdAt, userName, userPhotoUrl |
| `subscriptions` | tier, status, startedAt, renewsAt (doc id = userId) |

The domain is pure: entities in `lib/domain/entities/`, repository interfaces in
`lib/domain/repositories/`, use cases in `lib/domain/usecases/` (all returning
`Result<T>`). Firestore lives only in `lib/data/` (DTO ↔ entity mappers, data
sources, repository implementations), wired through GetX in
`lib/core/bindings/data_binding.dart`.

### Seed mock data

A runnable seeder populates Firestore with 7 Rondônia producers/cooperatives
(Ariquemes, Ji-Paraná, Ouro Preto do Oeste, Cacoal, Jaru, Buritis), 19 products
weighted toward cocoa honey + nibs, one traceability lot per product, plus
sample users, reviews and a subscription. Ids are deterministic, so re-running
overwrites rather than duplicates.

```bash
cd app
flutter run -t lib/seed/seed_firestore.dart -d chrome   # or another device
```

Run it while the database allows unauthenticated writes (Firestore *test mode* /
your dev rules), then deploy the locked-down `firestore.rules`.

---

## Milestones

- [x] **M1 — Foundation**: Clean Architecture scaffold, GetX (controllers /
  bindings / routes), Firebase wiring, warm-cocoa Material 3 theme (light+dark),
  app shell + bottom navigation (Início · Buscar · Clube · Perfil).
- [x] **M2 — Domain + Data + Seed**: entities, repository interfaces and use
  cases (pure domain with `Result`); Firestore data layer (DTOs, mappers, data
  sources, repository impls) wired via GetX bindings; mock-data seed script +
  `firestore.rules`; use-case unit tests.
- [ ] **M3 — Catalog + Traceability UI**: Home/Catalog, Search & Filters,
  Product Detail (traceability timeline + origin map pin), reusable components.
- [ ] **M4 — Producers + Reviews UI**: producer/cooperative profiles, follow,
  ratings & reviews, quality-seal badges.
- [ ] **M5 — Cocoa Club + Auth**: onboarding, login/sign-up (email + Google),
  subscription tiers (mocked paid state).

Built incrementally; each milestone is committed and pushed separately.
