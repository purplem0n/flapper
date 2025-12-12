import 'dart:math';

class TemplateRepository {
  Future<int> increment(int current) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final randomError = Random().nextBool();
    if (randomError) {
      throw Exception('Random error');
    }
    return current + 1;
  }

  Future<int> decrement(int current) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final randomError = Random().nextBool();
    if (randomError) {
      throw Exception('Random error');
    }
    return current - 1;
  }
}
