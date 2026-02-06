import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A badge widget showing total cart count.
///
/// Useful for displaying on cart icons or navigation items.
///
/// Example:
/// ```dart
/// CartBadge(
///   count: 5,
///   child: Icon(Icons.shopping_cart),
/// )
/// ```
class CartBadge extends StatelessWidget {
  /// The count to display in the badge.
  final num count;

  /// The widget to attach the badge to.
  final Widget child;

  /// Badge background color.
  ///
  /// Defaults to [ColorScheme.primary] from the current theme.
  final Color? badgeColor;

  /// Badge text color.
  ///
  /// Defaults to [ColorScheme.onPrimary] from the current theme.
  final Color? textColor;

  /// Badge size in logical pixels.
  ///
  /// Defaults to 18.
  final double? size;

  /// Whether to show the badge when count is 0.
  ///
  /// Defaults to `false`.
  final bool showZero;

  /// Maximum count before showing "+".
  ///
  /// For example, with maxCount 99, count 100 displays as "99+".
  final int? maxCount;

  /// Badge position relative to child.
  ///
  /// Defaults to [Alignment.topRight].
  final Alignment alignment;

  /// Offset from the alignment position.
  final EdgeInsets offset;

  /// Creates a cart badge.
  const CartBadge({
    super.key,
    required this.count,
    required this.child,
    this.badgeColor,
    this.textColor,
    this.size,
    this.showZero = false,
    this.maxCount = 99,
    this.alignment = Alignment.topRight,
    this.offset = const EdgeInsets.only(top: -4, right: -4),
  });

  @override
  Widget build(BuildContext context) {
    final showBadge = count > 0 || showZero;
    final displayCount =
        maxCount != null && count > maxCount! ? '$maxCount+' : '$count';

    // Resolve colors from theme if not explicitly provided
    final theme = Theme.of(context);
    final resolvedBadgeColor = badgeColor ?? theme.colorScheme.primary;
    final resolvedTextColor = textColor ?? theme.colorScheme.onPrimary;

    // Determine if this is a center alignment that needs special handling
    final isCenterVertically = alignment == Alignment.centerLeft ||
        alignment == Alignment.center ||
        alignment == Alignment.centerRight;
    final isCenterHorizontally = alignment == Alignment.topCenter ||
        alignment == Alignment.center ||
        alignment == Alignment.bottomCenter;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (showBadge)
          Positioned(
            // Top positioning
            top: alignment == Alignment.topRight ||
                    alignment == Alignment.topLeft ||
                    alignment == Alignment.topCenter
                ? offset.top
                // For vertical center alignments, use top: 0 and bottom: 0 for centering
                : isCenterVertically
                    ? 0
                    : null,
            // Bottom positioning
            bottom: alignment == Alignment.bottomRight ||
                    alignment == Alignment.bottomLeft ||
                    alignment == Alignment.bottomCenter
                ? offset.bottom
                // For vertical center alignments, use top: 0 and bottom: 0 for centering
                : isCenterVertically
                    ? 0
                    : null,
            // Right positioning
            right: alignment == Alignment.topRight ||
                    alignment == Alignment.bottomRight ||
                    alignment == Alignment.centerRight
                ? offset.right
                // For horizontal center alignments, use left: 0 and right: 0 for centering
                : isCenterHorizontally
                    ? 0
                    : null,
            // Left positioning
            left: alignment == Alignment.topLeft ||
                    alignment == Alignment.bottomLeft ||
                    alignment == Alignment.centerLeft
                ? offset.left
                // For horizontal center alignments, use left: 0 and right: 0 for centering
                : isCenterHorizontally
                    ? 0
                    : null,
            child: isCenterVertically || isCenterHorizontally
                // For center alignments, wrap in Center/Align widget
                ? Align(
                    alignment: alignment,
                    child: _AnimatedBadge(
                      count: count,
                      displayText: displayCount,
                      badgeColor: resolvedBadgeColor,
                      textColor: resolvedTextColor,
                      size: size ?? 18,
                    ),
                  )
                : _AnimatedBadge(
                    count: count,
                    displayText: displayCount,
                    badgeColor: resolvedBadgeColor,
                    textColor: resolvedTextColor,
                    size: size ?? 18,
                  ),
          ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<num>('count', count));
    properties
        .add(FlagProperty('showZero', value: showZero, ifTrue: 'showZero'));
    properties.add(IntProperty('maxCount', maxCount));
  }
}

class _AnimatedBadge extends StatelessWidget {
  final num count;
  final String displayText;
  final Color badgeColor;
  final Color textColor;
  final double size;

  const _AnimatedBadge({
    required this.count,
    required this.displayText,
    required this.badgeColor,
    required this.textColor,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final isWide = displayText.length > 2;
    final width = isWide ? size * 1.5 : size;
    final shadowColor = badgeColor.withValues(alpha: 0.4);

    return TweenAnimationBuilder<double>(
      // Use key to control when animation should restart (only when count changes)
      key: ValueKey(count),
      tween: Tween(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 200),
      // Use easeOutBack instead of elasticOut for better performance
      // while maintaining a similar "pop" effect
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: Container(
        constraints: BoxConstraints(minWidth: width, minHeight: size),
        padding: EdgeInsets.symmetric(
          horizontal: isWide ? 4 : 0,
        ),
        decoration: BoxDecoration(
          color: badgeColor,
          borderRadius: BorderRadius.circular(size / 2),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            displayText,
            style: TextStyle(
              color: textColor,
              fontSize: size * 0.6,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}
