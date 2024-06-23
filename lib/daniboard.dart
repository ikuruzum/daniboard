import 'dart:async';
import 'dart:io' show Platform;
import 'src/clipboard.dart';


Clipboard _platform() {
  if (Platform.isMacOS) {
    return new MacClipboard();
  } else if (Platform.isWindows) {
    return new WindowsClipboard();
  } else {
    return new LinuxClipboard();
  }
}

Future<bool> write(String input) => _platform().write(input);
Future<String> read() => _platform().read();
