import 'package:flutter/material.dart';

import '../../../../core/theme/app_fonts.dart';
import '../../data/product_detail_content.dart';
import '../product_detail_tokens.dart';

class ProductDetailInfoSection extends StatelessWidget {
  const ProductDetailInfoSection({
    required this.title,
    required this.shortDescription,
    required this.fullDescription,
    required this.expanded,
    required this.onViewMore,
    required this.materials,
    required this.specs,
    required this.careInstructions,
    required this.warranty,
    super.key,
  });

  final String title;
  final String shortDescription;
  final String fullDescription;
  final bool expanded;
  final VoidCallback onViewMore;
  final List<String> materials;
  final List<ProductSpec> specs;
  final List<String> careInstructions;
  final String? warranty;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: ProductDetailTokens.infoCardHorizontalPadding,
      ),
      child: Container(
        padding: const EdgeInsets.all(ProductDetailTokens.infoCardPadding),
        decoration: BoxDecoration(
          color: ProductDetailTokens.infoCardBg,
          borderRadius: BorderRadius.circular(
            ProductDetailTokens.infoCardRadius,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppFonts.dmSans(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: ProductDetailTokens.textPrimary,
                letterSpacing: -0.4,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 14),
            AnimatedSize(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: expanded
                  ? _ExpandedDetails(
                      description: fullDescription,
                      materials: materials,
                      specs: specs,
                      careInstructions: careInstructions,
                      warranty: warranty,
                    )
                  : Text(
                      shortDescription,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: _bodyStyle(),
                    ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: onViewMore,
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    expanded ? 'View Less' : 'View More',
                    style: AppFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: ProductDetailTokens.textPrimary,
                      letterSpacing: -0.1,
                    ),
                  ),
                  const SizedBox(width: 4),
                  AnimatedRotation(
                    turns: expanded ? 0.125 : 0,
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    child: const Icon(
                      Icons.add,
                      size: 14,
                      color: ProductDetailTokens.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

TextStyle _bodyStyle() => AppFonts.dmSans(
  fontSize: 13.5,
  fontWeight: FontWeight.w400,
  color: ProductDetailTokens.textSecondary,
  height: 1.55,
  letterSpacing: -0.05,
);

TextStyle _sectionHeading() => AppFonts.dmSans(
  fontSize: 13,
  fontWeight: FontWeight.w700,
  color: ProductDetailTokens.textPrimary,
  letterSpacing: 0.4,
);

class _ExpandedDetails extends StatelessWidget {
  const _ExpandedDetails({
    required this.description,
    required this.materials,
    required this.specs,
    required this.careInstructions,
    required this.warranty,
  });

  final String description;
  final List<String> materials;
  final List<ProductSpec> specs;
  final List<String> careInstructions;
  final String? warranty;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(description, style: _bodyStyle()),
        if (materials.isNotEmpty) ...[
          const SizedBox(height: 22),
          _SectionLabel(text: 'MATERIALS'),
          const SizedBox(height: 10),
          for (final m in materials) _BulletRow(text: m),
        ],
        if (specs.isNotEmpty) ...[
          const SizedBox(height: 22),
          _SectionLabel(text: 'SPECIFICATIONS'),
          const SizedBox(height: 6),
          ...List.generate(specs.length, (i) {
            final spec = specs[i];
            return _SpecRow(
              label: spec.label,
              value: spec.value,
              showDivider: i < specs.length - 1,
            );
          }),
        ],
        if (careInstructions.isNotEmpty) ...[
          const SizedBox(height: 22),
          _SectionLabel(text: 'CARE'),
          const SizedBox(height: 10),
          for (final c in careInstructions) _BulletRow(text: c),
        ],
        if (warranty != null) ...[
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.verified_outlined,
                  size: 16,
                  color: ProductDetailTokens.textPrimary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    warranty!,
                    style: AppFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: ProductDetailTokens.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: _sectionHeading());
  }
}

class _BulletRow extends StatelessWidget {
  const _BulletRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 7, right: 10),
            child: Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: ProductDetailTokens.textPrimary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(
            child: Text(text, style: _bodyStyle()),
          ),
        ],
      ),
    );
  }
}

class _SpecRow extends StatelessWidget {
  const _SpecRow({
    required this.label,
    required this.value,
    required this.showDivider,
  });

  final String label;
  final String value;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppFonts.dmSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: ProductDetailTokens.textSecondary,
                ),
              ),
              const Spacer(),
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: AppFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: ProductDetailTokens.textPrimary,
                    letterSpacing: -0.1,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Container(
            height: 1,
            color: Colors.black.withValues(alpha: 0.05),
          ),
      ],
    );
  }
}
