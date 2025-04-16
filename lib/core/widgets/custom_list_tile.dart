import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.onTap,
    this.leading,
    this.trailing,
    this.isExpanded,
    this.iconColor,
  });

  final Widget title;
  final Widget? subtitle;
  final Function()? onTap;
  final Widget? leading;
  final Widget? trailing;
  final bool? isExpanded;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 2),
                  title,
                  if (subtitle != null) ...[
                    subtitle!,
                  ],
                  const SizedBox(height: 5),
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 5),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}
