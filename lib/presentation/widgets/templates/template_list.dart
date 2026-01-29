import 'package:flutter/material.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../domain/entities/template_entity.dart';
import 'template_card.dart';

/// Vertical list of template cards
class TemplateList extends StatelessWidget {
  final List<TemplateEntity> templates;
  final Function(TemplateEntity)? onTemplateTap;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const TemplateList({
    super.key,
    required this.templates,
    this.onTemplateTap,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPaddingH,
      ),
      itemCount: templates.length,
      separatorBuilder: (_, __) => const SizedBox(
        height: AppDimensions.spacingMd,
      ),
      itemBuilder: (context, index) {
        final template = templates[index];
        return TemplateCard(
          template: template,
          onTap: () => onTemplateTap?.call(template),
        );
      },
    );
  }
}
