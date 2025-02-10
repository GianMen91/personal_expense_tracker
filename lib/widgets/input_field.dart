import 'package:flutter/material.dart';

// A reusable input field container with optional label and tap functionality.
class InputField extends StatelessWidget {
  final Widget
      child; // The main content of the input field (e.g., TextField, Text, etc.)
  final String? label; // Optional label displayed before the input field
  final VoidCallback? onTap; // Optional callback function when tapped

  const InputField({
    super.key,
    required this.child,
    this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: const Key('input_field_inkwell'),
      onTap: onTap, // Triggers the onTap function if provided
      child: Container(
        key: const Key('input_field_container'),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        // Padding inside the container
        decoration: BoxDecoration(
          color: Colors.white, // Background color
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        child: Row(
          key: const Key('input_field_row'),
          children: [
            // If a label is provided, display it before the input field
            if (label != null) ...[
              Text(
                label!,
                key: const Key('input_field_label'),
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey), // Style for the label text
              ),
              const SizedBox(width: 10),
              // Spacing between label and input field
            ],
            // The main input field content (e.g., TextField, Dropdown, etc.)
            Expanded(
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
