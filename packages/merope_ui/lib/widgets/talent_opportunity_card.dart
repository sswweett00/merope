import 'package:flutter/material.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'merope_card.dart';

class TalentOpportunityCard extends StatelessWidget {
  final String title;
  final String company;
  final String location;
  final String type;
  final String compensation;
  final List<String> tags;
  final MeropeColorTokens tokens;
  final VoidCallback? onTap;

  const TalentOpportunityCard({
    super.key,
    required this.title,
    required this.company,
    required this.location,
    required this.type,
    required this.compensation,
    required this.tags,
    required this.tokens,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MeropeCard(
      color: tokens.surface,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(MeropeTokens.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: tokens.primary.withValues(alpha: 0.1),
                      borderRadius:
                          BorderRadius.circular(MeropeTokens.radiusSm),
                    ),
                    child: Icon(Icons.business, color: tokens.primary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: tokens.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          company,
                          style: TextStyle(
                            color: tokens.primary,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.bookmark_border,
                      color: tokens.textSecondary, size: 20),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _InfoItem(
                      icon: Icons.location_on_outlined,
                      label: location,
                      tokens: tokens),
                  const SizedBox(width: 16),
                  _InfoItem(
                      icon: Icons.work_outline, label: type, tokens: tokens),
                  const SizedBox(width: 16),
                  _InfoItem(
                      icon: Icons.payments_outlined,
                      label: compensation,
                      tokens: tokens),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: tags
                    .map((tag) => _Tag(label: tag, tokens: tokens))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final MeropeColorTokens tokens;

  const _InfoItem(
      {required this.icon, required this.label, required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: tokens.textSecondary),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(color: tokens.textSecondary, fontSize: 12),
        ),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final MeropeColorTokens tokens;

  const _Tag({required this.label, required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: tokens.background,
        borderRadius: BorderRadius.circular(MeropeTokens.radiusSm),
        border: Border.all(color: tokens.border, width: 0.5),
      ),
      child: Text(
        label,
        style: TextStyle(color: tokens.textSecondary, fontSize: 11),
      ),
    );
  }
}
