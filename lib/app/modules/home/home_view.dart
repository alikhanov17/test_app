import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/widgets/article_card.dart';
import '../../common/widgets/subscription_badge.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F9),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 110,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 14),
              title: const Text(
                'Для вас',
                style: TextStyle(
                  color: Color(0xFF1A1A2E),
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              background: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20, top: 40),
                  child: SubscriptionBadge(
                    label: controller.subscriptionType == 'yearly'
                        ? 'Годовой Pro'
                        : 'Месячный Pro',
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, index) =>
                    ArticleCard(article: controller.articles[index]),
                childCount: controller.articles.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
