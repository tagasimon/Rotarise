import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class PerformanceUtils {
  static void timeOperation(String operationName, Function operation) {
    if (kDebugMode) {
      final stopwatch = Stopwatch()..start();
      operation();
      stopwatch.stop();

      final duration = stopwatch.elapsedMilliseconds;
      if (duration > 16) {
        // Flag operations taking longer than one frame (16ms)
        developer.log(
          'Performance Warning: $operationName took ${duration}ms',
          name: 'Performance',
        );
      }
    } else {
      operation();
    }
  }

  static Future<T> timeAsyncOperation<T>(
    String operationName,
    Future<T> Function() operation,
  ) async {
    if (kDebugMode) {
      final stopwatch = Stopwatch()..start();
      final result = await operation();
      stopwatch.stop();

      final duration = stopwatch.elapsedMilliseconds;
      if (duration > 100) {
        // Flag async operations taking longer than 100ms
        developer.log(
          'Performance Warning: $operationName took ${duration}ms',
          name: 'Performance',
        );
      }

      return result;
    } else {
      return await operation();
    }
  }

  /// Defers execution to the next frame to avoid blocking the current frame
  static Future<void> deferExecution() async {
    await Future.delayed(Duration.zero);
  }

  /// Batches multiple operations to run in a single frame
  static Future<void> batchOperations(List<Function> operations) async {
    for (int i = 0; i < operations.length; i++) {
      operations[i]();

      // Yield control every few operations to avoid blocking
      if (i % 5 == 0 && i > 0) {
        await deferExecution();
      }
    }
  }
}
