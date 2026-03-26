# TestApp

Flutter-приложение с онбордингом, экраном подписки и главным экраном с контентом — построено на GetX и SharedPreferences.

---

## Стек технологий

| Инструмент | Версия | Назначение |
|---|---|---|
| Flutter | 3.41.4 | UI-фреймворк |
| Dart | 3.11.1+ | Язык программирования |
| [get](https://pub.dev/packages/get) | ^4.6.6 | Стейт-менеджмент, роутинг, DI |
| [shared_preferences](https://pub.dev/packages/shared_preferences) | ^2.3.2 | Локальное хранение состояния подписки |

---

## Архитектура

Проект построен на **GetX MVC** с модульной структурой папок по фичам.

### Почему GetX MVC

- Clean Architecture избыточна для 3 экранов — репозитории и use-case не нужны
- GetX берёт на себя стейт, роутинг и DI в одном пакете с минимальным кодом
- Каждая фича полностью изолирована: свой контроллер, вью и байндинг
- Общий слой `common/widgets` исключает дублирование между модулями

### Ответственность слоёв

```
Controller   Бизнес-логика + реактивное состояние (GetxController)
View         Stateless UI, читает контроллер через Obx / GetView
Binding      Ленивое внедрение зависимостей, привязанное к роуту
Service      Слой данных — обёртка над SharedPreferences (GetxService)
```

---

## Структура проекта

```
lib/
├── main.dart                           # Точка входа — инициализация StorageService, выбор начального роута
│
└── app/
    ├── data/
    │   └── services/
    │       └── storage_service.dart    # Обёртка SharedPreferences (состояние подписки)
    │
    ├── common/
    │   └── widgets/
    │       ├── app_button.dart         # Основная кнопка CTA (поддержка состояния загрузки)
    │       ├── page_indicator.dart     # Анимированные точки для PageView
    │       ├── plan_card.dart          # Карточка выбора тарифа
    │       ├── article_card.dart       # Карточка статьи на главном экране
    │       └── subscription_badge.dart # Бейдж Pro в шапке приложения
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
        ├── app_routes.dart             # Константы имён роутов
        └── app_pages.dart              # Определения GetPage с байндингами
```

---

## Навигационный поток

```
Запуск приложения
    │
    ├─ is_subscribed == true ──────────────────────► Главный экран
    │
    └─ is_subscribed == false
             │
             ▼
        Онбординг (2 экрана)
             │  нажатие "Начать" на последнем экране
             ▼
        Пейвол
             │  нажатие "Продолжить" → сохранение тарифа в SharedPreferences
             ▼
        Главный экран  (offAll — стек навигации очищается)
```

Начальный роут определяется **до** вызова `runApp`, поэтому мигания неправильного экрана при запуске не происходит.

---

## Стейт-менеджмент

Для всего изменяемого UI-состояния используются реактивные примитивы GetX:

```dart
// Реактивное значение — любой Obx(), подписанный на него, перестраивается автоматически
final currentPage = 0.obs;
final selectedPlan = 'yearly'.obs;
final isLoading = false.obs;
```

Контроллеры внедряются лениво через `Bindings` и привязаны к жизненному циклу роута — создаются при переходе на экран и удаляются при выходе с него.

```dart
class PaywallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaywallController>(() => PaywallController());
  }
}
```

---

## Хранение данных

`StorageService` (наследник `GetxService`) оборачивает SharedPreferences и инициализируется один раз при старте через `Get.putAsync`. Хранит два ключа:

| Ключ | Тип | Описание |
|---|---|---|
| `is_subscribed` | bool | Наличие активной подписки |
| `subscription_type` | String | `"yearly"` или `"monthly"` |

```dart
// Сохранение после имитации покупки
await Get.find<StorageService>().saveSubscription('yearly');
```

---

## Общие виджеты

Переиспользуемые виджеты находятся в `app/common/widgets/` и используются в нескольких модулях:

| Виджет | Параметры | Примечание |
|---|---|---|
| `AppButton` | `label`, `onPressed`, `isLoading` | При `isLoading: true` показывает спиннер |
| `PageIndicator` | `count`, `current` | Анимированные точки-пилюли |
| `PlanCard` | `title`, `price`, `period`, `subtitle?`, `badge?`, `isSelected`, `onTap` | Анимированная рамка при выборе |
| `ArticleCard` | `article` | Цветной чип категории |
| `SubscriptionBadge` | `label` | Фиолетовая пилюля в шапке |

---

## Экраны

### Онбординг
`PageView` из двух страниц с иконкой, заголовком и описанием. Текст кнопки меняется с **«Продолжить»** на **«Начать»** на последней странице.

### Пейвол
Тёмный экран (`#0F0F1A`) с двумя карточками выбора тарифа. Тариф **«Годовой»** выбран по умолчанию и имеет бейдж **«ВЫГОДНЕЕ»**. Нажатие **«Продолжить»** имитирует задержку покупки 800 мс, сохраняет подписку и переходит на главный экран через `Get.offAllNamed` (стек очищается).

### Главный экран
`CustomScrollView` с закреплённым `SliverAppBar`, отображающим бейдж активного тарифа. Ниже — список из шести карточек статей с цветной категорией, заголовком, описанием и временем чтения.

---

## Запуск проекта

```bash
# Установка зависимостей
flutter pub get

# Запуск на подключённом устройстве или симуляторе
flutter run
```

Чтобы сбросить состояние подписки и вернуться к онбордингу — очистите данные приложения на устройстве или вызовите `StorageService.clearSubscription()`.
