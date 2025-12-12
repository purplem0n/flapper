import 'package:flutter/foundation.dart';

void printDebug<T>(T data) {
  if (kDebugMode) {
    print(data);
  }
}
