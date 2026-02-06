/// Built-in quantity formatters for display customization.
///
/// These formatters transform the quantity value into display strings.
/// All formatters accept [num] to support both integer and decimal quantities.
class QuantityFormatters {
  QuantityFormatters._();

  /// Abbreviates large numbers (e.g., 1000 -> "1k", 1500 -> "1.5k").
  static String abbreviated(num quantity) {
    if (quantity >= 1000000) {
      final value = quantity / 1000000;
      return value == value.truncate()
          ? '${value.truncate()}M'
          : '${value.toStringAsFixed(1)}M';
    } else if (quantity >= 1000) {
      final value = quantity / 1000;
      return value == value.truncate()
          ? '${value.truncate()}k'
          : '${value.toStringAsFixed(1)}k';
    }
    // Display integers without decimal point
    if (quantity is int || quantity == quantity.toInt()) {
      return quantity.toInt().toString();
    }
    return quantity.toString();
  }

  /// Creates a formatter that abbreviates with "+" suffix at max.
  ///
  /// Example: With maxQuantity 99, quantity 99+ displays as "99+".
  static String Function(num) abbreviatedWithMax(num maxQuantity) {
    return (num quantity) {
      if (quantity >= maxQuantity) {
        return '$maxQuantity+';
      }
      return abbreviated(quantity);
    };
  }

  /// Simple formatter that just returns the number as-is.
  ///
  /// Integers are displayed without a decimal point.
  static String simple(num quantity) {
    if (quantity is int || quantity == quantity.toInt()) {
      return quantity.toInt().toString();
    }
    return quantity.toString();
  }
}
