import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/placeify_bottom_nav.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../data/mock_vendor_repository.dart';
import 'widgets/metric_card.dart';
import 'widgets/order_row.dart';
import 'widgets/revenue_card.dart';
import 'widgets/top_products_chart.dart';
import 'widgets/upload_product_button.dart';

class VendorDashboardScreen extends StatefulWidget {
  const VendorDashboardScreen({super.key});

  @override
  State<VendorDashboardScreen> createState() => _VendorDashboardScreenState();
}

class _VendorDashboardScreenState extends State<VendorDashboardScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final metrics = MockVendorRepository.metrics;
    final orders = MockVendorRepository.orders;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good morning, Alex',
                    style: AppTypography.vendorGreeting,
                  ),
                  const SizedBox(height: 4),
                  const Text('Vendor Dashboard', style: AppTypography.sectionTitle),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Expanded(flex: 3, child: RevenueCard()),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Expanded(child: MetricCard(metric: metrics[0])),
                                const SizedBox(height: 12),
                                Expanded(child: MetricCard(metric: metrics[1])),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const UploadProductButton(),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Recent Orders', style: AppTypography.sectionTitle),
                        GestureDetector(
                          onTap: () {},
                          child: const Text('See all', style: AppTypography.seeAll),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...orders.map((o) => OrderRow(order: o)),
                    const SizedBox(height: 20),
                    const TopProductsChart(),
                    const SizedBox(height: BottomNavTokens.scrollBottomPadding),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
