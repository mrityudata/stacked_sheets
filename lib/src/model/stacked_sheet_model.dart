import 'package:flutter/material.dart';

/// Defines the configuration and content for an individual sheet in the stack.
class StackedSheet {
  /// The widget to be displayed inside the bottom sheet.
  final Widget child;

  /// The fraction of the screen height the sheet should initially occupy.
  /// Should be between 0.0 and 1.0. Defaults to 0.7.
  final double initialExtent;

  /// Whether the sheet can be dismissed by a downward swipe or by tapping the scrim.
  /// (Currently under development)
  final bool dismissible;

  /// The background color of the sheet.
  final Color backgroundColor;

  /// The border radius applied to the sheet's container.
  final BorderRadius borderRadius;

  /// Creates a [StackedSheet] configuration.
  StackedSheet({
    required this.child,
    this.initialExtent = 0.7,
    this.dismissible = true,
    this.backgroundColor = Colors.white,
    this.borderRadius = const BorderRadius.vertical(top: Radius.circular(24)),
  });
}
