library console_util;

import 'dart:io';

int readNumber({String errorMsg, bool test(int arg)}) {
  var num;
  do {
    var str = stdin.readLineSync();
    num = int.parse(str, onError: (_) => null);
    if (test != null) {
      if (! test(num)) num = null;
    }
    if (num == null) print(errorMsg);
  } while (num == null);
  return num;
}