# Claude Code Prompt — "Rondônia Cacau Clube" (Flutter Implementation)

> Use this SECOND, in Claude Code, AFTER you have the screens from Claude Design.
> Before running: do `gh auth login` in your terminal, and ATTACH the exported design screens/specs to the chat, telling Claude Code: "Implement the UI following these attached designs."

```text
# ROLE
You are a senior Flutter engineer. Build a clean, production-quality prototype from scratch following SOLID principles and Clean Architecture. Write idiomatic Dart, keep the code testable, and briefly explain key architectural decisions as you go. Implement the UI to match the attached design screens and design tokens.

# PRODUCT
App name: "Rondônia Cacau Clube" (main) / "Cacau Clube" (short — app icon, package id, social handles).
A SHOWCASE + TRACEABILITY app (NOT e-commerce: no checkout, no cart, no payments, no prices) for cocoa BYPRODUCTS from the state of Rondônia, Brazil. Focus on cocoa products BEYOND chocolate — especially COCOA HONEY ("mel de cacau") and COCOA NIBS ("nibs de cacau"), with the catalog also supporting cocoa butter, cocoa powder/liquor, pulp/juice, jelly, liqueur, biomass, cosmetics, and cocoa-husk "coffee".
Primary goal: let consumers discover Rondônia cocoa byproducts, see WHO produced them and WHERE they come from (full origin traceability), follow producers/cooperatives, and join a "Cocoa Club".
Language: Portuguese (pt-BR) UI. Code, comments, and identifiers in English.
IMPORTANT: This prototype has NO AI features and uses NO API keys.

# CORE FEATURES (MVP scope)
1. Product catalog (vitrine): browse / search / filter cocoa byproducts. Rich product page with photos, description, byproduct category, and quality seals. NO buy button, NO checkout (showcase only; an optional "Falar com o produtor" WhatsApp deep link is allowed).
2. Origin traceability: each product links to its producer and/or cooperative, its municipality in Rondônia, harvest/lot info, and a farm-to-product timeline. Show a map pin of the origin (municipality-level).
3. Producer & cooperative profiles: bio, location, story, certifications, product list, photo gallery, follower count, follow button.
4. Cocoa Club (subscription, prototype only): free tier + paid tier. Paid tier unlocks curated content, early product drops, and exclusive producer stories. Model subscription state per user; mock the paid state (no real payment provider).
5. Ratings & quality seals: users rate/review products; products and producers show quality seals/badges (e.g., "Cacau Fino", "Origem Rondônia", "Orgânico") and an aggregate rating.

# SCREENS (match the attached designs)
Onboarding/Splash, Login/Sign-up, Home/Catalog, Search & Filters, Product Detail (traceability timeline + map pin), Producer/Cooperative Profile, Cocoa Club (subscription), Reviews.

# TECH STACK (mandatory)
- Flutter (latest stable), Dart, null-safety.
- State management + DI + routing: GetX (get package). Use GetxController as view-models, Obx/GetBuilder for reactive UI, Bindings + Get.put/Get.lazyPut for dependency injection, and GetMaterialApp + GetPage named routes for navigation. Do NOT add Riverpod/Bloc/Provider or get_it/injectable.
- Firebase: Auth (email + Google sign-in), Cloud Firestore, Firebase Storage (images), Firebase Analytics, Firebase Crashlytics. (No Cloud Functions needed.)
- Maps: google_maps_flutter (or flutter_map) for origin pins.
- HTTP: dio (only if needed).
- Local cache: shared_preferences (or hive) for lightweight state.

# ARCHITECTURE — SOLID + CLEAN ARCHITECTURE (mandatory)
Layered structure with clear boundaries and dependency inversion:
- presentation/ (screens, widgets, GetxControllers as view-models, Bindings)
- domain/ (entities, repository INTERFACES, use cases) — pure Dart, no Flutter/Firebase/GetX imports
- data/ (repository IMPLEMENTATIONS, data sources, DTOs, mappers)
- core/ (bindings, error handling, result types, constants, theming, routes)
Apply SOLID explicitly:
- S: one responsibility per class (use cases, mappers, data sources, controllers).
- O: extend via new use cases/strategies, not by editing existing ones.
- L: repository implementations fully honor their interface contracts.
- I: small, focused repository interfaces (ProductRepository, ProducerRepository, etc.).
- D: presentation and domain depend on ABSTRACTIONS; controllers receive use cases via constructor, resolved through GetX Bindings; concrete Firebase code only in the data layer.
Use a Result/Either type for error handling (dartz or a custom sealed Result). Add unit tests for use cases and a few widget tests.

# THEMING (from the attached design tokens)
Implement a warm cocoa theme (deep browns, amber/caramel, cream backgrounds, forest-green accents, golden honey accent), Material 3, light AND dark mode. Centralize pt-BR strings for i18n. Reuse the components defined in the design (product card, producer card, quality-seal badge, rating stars, traceability timeline item, subscription tier card, review item, etc.).

# DATA MODEL (Firestore collections — propose & implement)
- users: { uid, name, email, photoUrl, subscriptionTier, followingProducerIds[], createdAt }
- producers: { id, name, type: "producer"|"cooperative", bio, story, municipality, geo, certifications[], qualitySeals[], photoUrls[], followerCount, rating }
- products: { id, producerId, name, byproductCategory (enum: cocoa_honey, nibs, butter, powder, pulp, jelly, liqueur, biomass, cosmetic, husk_coffee, chocolate, other), description, photoUrls[], qualitySeals[], originLotId, rating, reviewCount, createdAt }
- origin_lots: { id, producerId, municipality, geo, harvestDate, processingNotes, timeline[] }
- reviews: { id, productId, userId, rating, text, createdAt }
- subscriptions: { userId, tier, status, startedAt, renewsAt }
Seed Firestore with realistic mock data: at least 6 Rondônia producers/cooperatives (use plausible municipalities like Ariquemes, Ji-Paraná, Ouro Preto do Oeste, Cacoal, Jaru, Buritis) and 15+ products weighted toward cocoa honey and nibs.

# GIT / REPOSITORY
- Push the full project to https://github.com/LeoEliel/prototype1 (default branch: main).
- Assume the user is authenticated via the GitHub CLI (`gh auth login`).
- Steps: `git init` (if needed) -> add a Flutter-appropriate `.gitignore` -> `git remote add origin https://github.com/LeoEliel/prototype1.git` (use `git remote set-url` if it already exists) -> commit -> `git push -u origin main`.
- Use clear conventional commits per milestone (e.g., `feat: catalog + traceability`). Confirm the remote and that the push succeeded.

# DELIVERABLES
1. Full Flutter project scaffold with the layered folder structure above, implementing the attached designs.
2. Firebase setup instructions (firebase_options.dart placeholder, firestore.rules with sensible security). Run `flutterfire configure` to wire the project.
3. Seed script for the mock Firestore data.
4. All screens implemented and navigable.
5. README with setup, run, and Firebase-config steps; basic unit + widget tests.

# WORKING STYLE
Build incrementally: start with architecture + GetX bindings + domain entities + Firebase wiring + theme from design tokens, then catalog + traceability, then producer profiles + reviews, then the Cocoa Club. After each milestone, summarize what changed and what's next, then commit and push. Ask me before introducing any dependency not listed above.
```

---

## Notas (em português)

- Use isto **depois** do Claude Design.
- **Antes de rodar:** `gh auth login` no terminal, e **anexe as telas/tokens** exportados do Design, dizendo "implemente a UI seguindo estes designs".
- Tenha o projeto criado no **Firebase Console** (Auth + Firestore + Storage) e rode `flutterfire configure` quando pedir.
- Sem IA e sem chaves neste protótipo. Se quiser IA dentro do app no futuro, me chame que eu adapto o prompt.

---

## Linha final para colar junto do prompt (Codespaces)

> No Codespaces, coloque as telas exportadas em `design/screens/` e os tokens em `design/design-tokens.md`. Depois de colar o prompt acima, adicione esta linha no final:

```text
Implement the UI to match the design screens in ./design/screens/ and use the color, typography, and spacing tokens in ./design/design-tokens.md. The brand logo is in ./design/logo/cacau-clube-logo-rondonia.png. Start with ./design/screens/03_home_catalog.png and ./design/screens/05_product_detail.png, then build the remaining screens to match.
```
