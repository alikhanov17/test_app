# TestApp

A Flutter demo app showcasing onboarding, a subscription paywall, and a main content screen — built with GetX and SharedPreferences.

---

## Tech Stack

| Tool | Version | Purpose |
|---|---|---|
| Flutter | 3.41.4 | UI framework |
| Dart | 3.11.1+ | Language |
| [get](https://pub.dev/packages/get) | ^4.6.6 | State management, routing, DI |
| [shared_preferences](https://pub.dev/packages/shared_preferences) | ^2.3.2 | Local subscription persistence |

---

## Architecture

The project follows **GetX MVC** with a feature-based (modular) folder structure.

### Why GetX MVC for this app

- Clean Architecture would be overkill for 3 screens — no repositories or use-cases needed
- GetX handles state, routing, and dependency injection in one package with minimal boilerplate
- Each feature is fully self-contained: its own controller, view, and binding
- A shared `common/widgets` layer prevents duplication across modules

### Layer responsibilities

```
Controller   Business logic + reactive state (GetxController)
View         Stateless UI, reads from controller via Obx / GetView
Binding      Lazy dependency injection wired to a route
Service      Data layer — SharedPreferences wrapper (GetxService)
```

---

## Folder Structure

```
lib/
├── main.dart                           # Entry point — initializes StorageService, resolves initial route
│
└── app/
    ├── data/
    │   └── services/
    │       └── storage_service.dart    # SharedPreferences wrapper (subscription state)
    │
    ├── common/
    │   └── widgets/
    │       ├── app_button.dart         # Primary CTA button (loading state support)
    │       ├── page_indicator.dart     # Animated dot indicator for PageView
    │       ├── plan_card.dart          # Subscription plan selection card
    │       ├── article_card.dart       # Home feed article card
    │       └── subscription_badge.dart # Pro badge shown in the app bar
    │
    ├── modules/
    │   ├── onboarding/
    │   │   ├── onboarding_binding.dart
    │   │   ├── onboarding_controller.dart
    │   │   └── onboarding_view.dart
    │   │
    │   ├── paywall/
    │   │   ├── paywall_binding.dart
    │   │   ├── paywall_controller.dart
    │   │   └── paywall_view.dart
    │   │
    │   └── home/
    │       ├── home_binding.dart
    │       ├── home_controller.dart
    │       └── home_view.dart
    │
    └── routes/
        ├── app_routes.dart             # Route name constants
        └── app_pages.dart              # GetPage definitions with bindings
```

---

## App Flow

```
App launch
    │
    ├─ is_subscribed == true ──────────────────────► Home
    │
    └─ is_subscribed == false
             │
             ▼
        Onboarding (2 screens)
             │  tap "Начать" on last page
             ▼
        Paywall
             │  tap "Продолжить" → saves plan to SharedPreferences
             ▼
        Home  (offAll — clears navigation stack)
```

On every subsequent launch the app resolves the initial route **before** `runApp`, so there is no flash of the wrong screen.

---

## State Management

GetX reactive primitives are used for all mutable UI state:

```dart
// Observable value — any Obx() listening to it rebuilds automatically
final currentPage = 0.obs;
final selectedPlan = 'yearly'.obs;
final isLoading = false.obs;
```

Controllers are injected lazily via `Bindings` and tied to their route's lifecycle — they are created when the route is pushed and disposed when it is popped.

```dart
class PaywallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaywallController>(() => PaywallController());
  }
}
```

---

## Data Persistence

`StorageService` (a `GetxService`) wraps SharedPreferences and is initialized once at startup with `Get.putAsync`. It stores two keys:

| Key | Type | Description |
|---|---|---|
| `is_subscribed` | bool | Whether the user has an active subscription |
| `subscription_type` | String | `"yearly"` or `"monthly"` |

```dart
// Save after simulated purchase
await Get.find<StorageService>().saveSubscription('yearly');
```

---

## Common Widgets

Reusable widgets live in `app/common/widgets/` and are shared across modules:

| Widget | Props | Notes |
|---|---|---|
| `AppButton` | `label`, `onPressed`, `isLoading` | Shows a spinner when `isLoading: true` |
| `PageIndicator` | `count`, `current` | Animated pill-shaped dots |
| `PlanCard` | `title`, `price`, `period`, `subtitle?`, `badge?`, `isSelected`, `onTap` | Animated selection border |
| `ArticleCard` | `article` | Color-coded category chip |
| `SubscriptionBadge` | `label` | Purple pill shown in the app bar |

---

## Screens

### Onboarding
Two-page `PageView` with an icon, title, and description. The button label switches from **"Продолжить"** to **"Начать"** on the last page.

### Paywall
Dark-themed screen (`#0F0F1A`) with two selectable plan cards. The **Yearly** plan is pre-selected and carries a **"ВЫГОДНЕЕ"** badge. Tapping **"Продолжить"** simulates an 800 ms purchase delay, persists the subscription, then navigates to Home via `Get.offAllNamed` (clearing the back stack).

### Home
A `CustomScrollView` with a pinned `SliverAppBar` that displays the active plan badge. Below it is a list of six article cards, each with a color-coded category, title, description, and read-time indicator.

---

## Getting Started

```bash
# Install dependencies
flutter pub get

# Run on a connected device or simulator
flutter run
```

To reset subscription state (go back to onboarding), clear app data on the device or call `StorageService.clearSubscription()` from the app.
