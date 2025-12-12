import 'dart:math';

String generateUUID() {
  final random = Random.secure();

  // Generate random hex characters (0-9, a-f)
  String generateHex(int length) {
    const chars = '0123456789abcdef';
    return String.fromCharCodes(Iterable.generate(length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  // Format: 8-4-4-4-12
  final part1 = generateHex(8);
  final part2 = generateHex(4);
  final part3 = generateHex(4);
  final part4 = generateHex(4);
  final part5 = generateHex(12);

  return '$part1-$part2-$part3-$part4-$part5';
}
