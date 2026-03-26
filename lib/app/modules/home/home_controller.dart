import 'package:get/get.dart';
import '../../data/services/storage_service.dart';

class Article {
  final String title;
  final String description;
  final String category;
  final String readTime;

  const Article({
    required this.title,
    required this.description,
    required this.category,
    required this.readTime,
  });
}

class HomeController extends GetxController {
  late final String subscriptionType;

  final articles = const [
    Article(
      title: 'Будущее мобильной разработки',
      description:
          'Исследуем кроссплатформенные фреймворки и что ждёт разработчиков приложений.',
      category: 'Технологии',
      readTime: '5 мин',
    ),
    Article(
      title: 'Начало работы с Flutter',
      description:
          'Подробное руководство по созданию красивых приложений с помощью UI-инструментария Google.',
      category: 'Руководство',
      readTime: '8 мин',
    ),
    Article(
      title: 'Сравнение стейт-менеджеров',
      description:
          'Сравниваем GetX, Riverpod, BLoC и Provider для разных сценариев проекта.',
      category: 'Flutter',
      readTime: '12 мин',
    ),
    Article(
      title: 'Дизайн тёмной темы',
      description:
          'Лучшие практики создания красивых тёмных тем, которые понравятся пользователям.',
      category: 'Дизайн',
      readTime: '6 мин',
    ),
    Article(
      title: 'Оптимизация Flutter-приложений',
      description:
          'Как найти и устранить распространённые узкие места производительности.',
      category: 'Оптимизация',
      readTime: '10 мин',
    ),
    Article(
      title: 'Монетизация приложения',
      description:
          'Стратегии подписок и покупок внутри приложения, которые действительно работают.',
      category: 'Бизнес',
      readTime: '7 мин',
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    subscriptionType = Get.find<StorageService>().subscriptionType;
  }
}
