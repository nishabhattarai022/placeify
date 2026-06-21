import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../profile/presentation/widgets/profile_sub_hero.dart';
import '../domain/constants/order_strings.dart';

class OrderDetailScreen extends ConsumerWidget {
  const OrderDetailScreen({required this.orderId, super.key});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          const ProfileSubHero(title: OrderStrings.orderDetailTitle),
          Expanded(
            child: Center(
              child: Text(
                orderId,
                style: const TextStyle(color: AppColors.textMuted),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
