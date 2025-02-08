import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final Widget child;
  final String? label;
  final VoidCallback? onTap;

  const InputField({
    super.key,
    required this.child,
    this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            if (label != null) ...[
              Text(label!, style: const TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(width: 10),
            ],
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}