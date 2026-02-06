/// Cart stepper library providing expandable quantity stepper widgets.
///
/// This library is split into multiple part files for maintainability:
/// - [_cart_stepper_facades.dart] - Public API: `CartStepper` and `AsyncCartStepper`
/// - [_cart_stepper_core.dart] - Internal widget, state fields, and lifecycle
/// - [_cart_stepper_operations.dart] - Business logic mixin (validation, async, increment/decrement)
/// - [_cart_stepper_builders.dart] - UI building mixin (all `_build*` methods)
library;

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'animated_counter.dart';
import 'cart_badge.dart';
import 'cart_stepper_config.dart';
import 'cart_stepper_controller.dart';
import 'cart_stepper_enums.dart';
import 'cart_stepper_errors.dart';
import 'cart_stepper_types.dart';
import 'stepper_button.dart';

part '_cart_stepper_builders.dart';
part '_cart_stepper_core.dart';
// Note: Public API exports are managed in lib/advance_cart_stepper.dart
// Internal imports only - no re-exports to avoid duplication

part '_cart_stepper_facades.dart';
part '_cart_stepper_operations.dart';
