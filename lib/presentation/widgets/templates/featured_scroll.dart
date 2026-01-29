import 'package:flutter/material.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../domain/entities/template_entity.dart';
import 'featured_card.dart';

/// Horizontal scrolling list of featured templates
class FeaturedScroll extends StatelessWidget {
  final List<TemplateEntity> templates;
  final Function(TemplateEntity)? onTemplateTap;

  const FeaturedScroll({
    super.key,
    required this.templates,
    this.onTemplateTap,
  });

  @override
  Widget build(BuildContext context) {
    if (templates.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: AppDimensions.featuredCardHeaderHeight + 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPaddingH,
        ),
        itemCount: templates.length,
        separatorBuilder: (_, __) => const SizedBox(
          width: AppDimensions.spacingMd,
        ),
        itemBuilder: (context, index) {
          final template = templates[index];
          return FeaturedCard(
            template: template,
            onTap: () => onTemplateTap?.call(template),
          );
        },
      ),
    );
  }
}
