import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  final int count;
  final int current;

  const PageIndicator({
    super.key,
    required this.count,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color:
                active ? const Color(0xFF6C63FF) : const Color(0xFFDDDDDD),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
