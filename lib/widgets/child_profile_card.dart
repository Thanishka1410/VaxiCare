import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/child_profile.dart';
import 'hover_scale_card.dart';

class ChildProfileCard extends StatelessWidget {
  final ChildProfile child;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onEdit;

  const ChildProfileCard({
    super.key,
    required this.child,
    required this.isSelected,
    required this.onTap,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return HoverScaleCard(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      borderColor: isSelected ? AppColors.primaryBlue : AppColors.border,
      hoverBorderColor: AppColors.primaryBlue,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight.withValues(alpha: 0.6) : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            AnimatedScale(
              scale: isSelected ? 1.08 : 1.0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutBack,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.primaryBlue : AppColors.border,
                    width: isSelected ? 1.8 : 1.0,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  child.avatarEmoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    child.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${child.ageFormatted} • ${child.bloodGroup}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              AnimatedScale(
                scale: 1.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryBlue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              )
            else if (onEdit != null)
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 18),
                color: AppColors.secondaryText,
                onPressed: onEdit,
              ),
          ],
        ),
      ),
    );
  }
}
