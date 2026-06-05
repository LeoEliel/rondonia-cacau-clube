# RevenueCat — Path A: Test Store setup

Get the Cocoa Club premium purchase flow running **end-to-end on a device/emulator**
without App Store Connect or Play Console, and **without renaming** the bundle id.

The Test Store replaces the system in-app-purchase sheet with a modal that has
*Simulate success / Simulate failure / Cancel* buttons, so it exercises the exact
code path you wrote (`Purchases.purchase`, the `premium` entitlement, the `default`
offering) — just with no real money and no store accounts.

> **Why Path A and not real stores:** the bundle id is `com.example.app` (iOS &
> Android), which the real App Store / Play Store will not accept. The Test Store
> doesn't validate the bundle id, so it works as-is. Real stores (Path B) require a
> real, owned bundle id — a separate decision tied to the Firebase coupling.

## What the app already expects (do not change these names)

The dashboard objects must match the identifiers hard-coded in the app, or the Club
tab won't unlock:

| Dashboard object | Must be named | Source |
| --- | --- | --- |
| Entitlement identifier | `premium` | `app/lib/data/repositories/revenuecat_purchases_repository.dart:28` |
| Offering identifier | `default` | `app/lib/data/repositories/revenuecat_purchases_repository.dart:29` |
| App user id | the signed-in Firebase uid (the SDK sets this for you via `Purchases.logIn`) | same file, `_identify` |

The API key is **not** committed — it's passed at build time with
`--dart-define=REVENUECAT_API_KEY=…` (`app/lib/main.dart:46`,
`app/lib/core/bindings/data_binding.dart:72`). The SDK is only configured/injected for
a **non-DEMO native build that was given a key**; web, DEMO, and keyless runs use the
tier fallback and never touch the SDK.

---

## Step-by-step

### 1. Create the RevenueCat project
1. Sign up / sign in at <https://app.revenuecat.com>.
2. Create a **Project** (e.g. "Rondônia Cacau Clube"). A Test Store is available to
   every new project.

### 2. Create the Test Store and grab its API key
1. Sidebar → **Apps and providers**.
2. Find the **Test configuration** section → **create a new Test Store**.
3. On creation you're shown a **Test Store API key**. Copy it — this is the value you
   pass as `REVENUECAT_API_KEY`.
   - It is a *separate* key from the real Apple/Android keys (Test Store keys keep the
     app talking to the Test Store, not a real store).
   - ⚠️ **Never** ship a Test Store key to an app store.

### 3. Create the entitlement
1. Sidebar → **Product catalog** → **Entitlements** → **New**.
2. Identifier: **`premium`** (exact — this is what the app checks for).
3. Display name: anything (e.g. "Cocoa Club Premium").

### 4. Create the products
1. **Product catalog** → **Products** → add one or more Test Store products, e.g.:
   - a **monthly** subscription
   - an **annual** subscription
2. Give them any identifiers you like — the app reads packages from the offering, not
   product ids directly. (Test subscriptions auto-renew up to 5× at accelerated
   intervals, then cancel, which is handy for testing renewals.)

### 5. Attach products to the `premium` entitlement
1. Open the **`premium`** entitlement.
2. Attach the product(s) from step 4. This is what makes `premium` go *active* in
   `CustomerInfo` after a successful purchase — which is exactly how the app decides
   the user is premium.

### 6. Create the `default` offering
1. **Product catalog** → **Offerings** → **New**.
2. Identifier: **`default`** (exact). *(The app falls back to "current" if `default`
   isn't found, but name it `default` to be unambiguous.)*
3. Add **Packages** (e.g. Monthly, Annual) and assign each the matching product from
   step 4.
4. The app surfaces each package's store price on the Club CTA, so make sure the
   offering has at least one package or the CTA will have no price to show.

### 7. Run the app with the key
On a **native device or emulator** (not web, not DEMO):

```bash
cd app
flutter run --dart-define=REVENUECAT_API_KEY=<your_test_store_key>
```

- No `--dart-define=DEMO=true` (DEMO uses the tier fallback, skips the SDK).
- Web is intentionally excluded — the SDK never runs in a browser build.
- Sign in first: the purchase ties to your Firebase uid, set automatically.

---

## Verify it works

1. Open the **Clube** tab. The CTA should show a **real price string** from the
   offering (e.g. "R$ 9,90/mês") instead of a generic label.
2. Tap subscribe → the **Test Store modal** appears with *Simulate success / failure /
   cancel*.
3. **Simulate success** → `premium` entitlement goes active → Club content unlocks,
   the **"Assinante"** badge shows, and premium mirrors to the Profile tab.
4. **Cancel** → app shows "Compra cancelada." and stays locked (no premium granted).
5. **Restaurar compras** → re-reads `CustomerInfo`; a previously-successful test
   purchase re-unlocks premium.

If the CTA shows no price or stays locked after a simulated success, the usual causes
are: the offering isn't named `default` (and none is marked current), the entitlement
isn't named exactly `premium`, no product is attached to the entitlement, or the build
was run with `DEMO=true` / on web / without the key.

---

## When you're ready for real stores (Path B, later)

Switch `REVENUECAT_API_KEY` to the platform-specific **public** key from
**Project settings → API keys**, after: choosing a real bundle id (touches Firebase),
creating subscriptions in App Store Connect / Play Console, connecting store
credentials in RevenueCat, importing those products, and attaching them to the same
`premium` entitlement / `default` offering. No app code changes are required — only
the key and the dashboard's store wiring.

## Sources
- [RevenueCat Test Store](https://www.revenuecat.com/docs/test-and-launch/sandbox/test-store)
- [Sandbox Testing](https://www.revenuecat.com/docs/test-and-launch/sandbox)
- [Flutter SDK installation](https://www.revenuecat.com/docs/getting-started/installation/flutter)
- [Configuring the SDK](https://www.revenuecat.com/docs/getting-started/configuring-sdk)
