import 'dart:math';

final _random = Random();

/// Extend execution time for function until a random time in desired range.
Future<T> fakeLoadTime<T>(
  Future<T> Function() function, {
  int millisecondsMin = 100,
  int millisecondsMax = 300,
}) async {
  final totalTime =
      millisecondsMin + _random.nextInt(millisecondsMax - millisecondsMin);
  final stopwatch = Stopwatch()..start();
  final result = await function();
  final elapsed = stopwatch.elapsedMilliseconds;
  if (elapsed < totalTime) {
    await Future.delayed(Duration(milliseconds: totalTime - elapsed));
  }
  return result;
}
