import 'dart:async';

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;

abstract class Clipboard {
  Future<bool> write(input);
  Future<String> read();
}

class MacClipboard implements Clipboard {
  @override
  Future<bool> write(covariant String input) async {
    final process = await Process.start('pbcopy', [], runInShell: true);
    process.stderr.transform(utf8.decoder).listen(print);
    process.stdin.write(input);

    try {
      await process.stdin.close();
    } catch (e) {
      return false;
    }

    return await process.exitCode == 0;
  }

  @override
  Future<String> read() async {
    final process = await Process.start('pbpaste', [], runInShell: true);
    process.stderr.transform(utf8.decoder).listen(print);

    final stdout = process.stdout.transform(utf8.decoder);

    try {
      return await stdout.first;
    } catch (_) {
      return '';
    }
  }
}

enum linuxDE {
  x11,
  wayland;

  static linuxDE fromString(String name) {
    return linuxDE.values.firstWhere((e) => e.name == name);
  }
}

linuxDE? _manager;

class LinuxClipboard implements Clipboard {
  Future<bool> isCommandAvailable(String command) async {
    final result = await Process.run('which', [command], runInShell: true);
    return result.exitCode == 0;
  }

  Future<void> findManager() async {
    if (_manager != null) return;
    if (await isCommandAvailable('xsel')) {
      _manager = linuxDE.x11;
    } else if (await isCommandAvailable('wl-paste')) {
      _manager = linuxDE.wayland;
    } else {
      throw Exception(
          'No clipboard manager found install either xsel or wl-clipboard');
    }
  }

  @override
  Future<bool> write(covariant String input) async {
    await findManager();
    Process process;
    switch (_manager) {
      case linuxDE.x11:
        process = await Process.start('xsel', ['--clipboard', '--input'],
            runInShell: true);
        break;
      case linuxDE.wayland:
        process = await Process.start('wl-copy', [], runInShell: true);
        break;
      default:
        throw Exception(
            'No clipboard manager found install either xsel or wl-clipboard');
    }
    process.stderr.transform(utf8.decoder).listen(print);
    process.stdin.write(input);

    try {
      await process.stdin.close();
    } catch (e) {
      print(
          'daniboard needs [xsel] or [wl-clipboard] in Linux, please install it. Nothing was written to clipboard');
      return false;
    }

    return await process.exitCode == 0;
  }

  @override
  Future<String> read() async {
    await findManager();
    Process process;

    switch (_manager) {
      case linuxDE.x11:
        process = await Process.start('xsel', ['--clipboard', '--output'],
            runInShell: true);
        break;
      case linuxDE.wayland:
        process = await Process.start('wl-paste', [], runInShell: true);
        break;
      default:
        throw Exception(
            'No clipboard manager found install either xsel or wl-clipboard');
    }
    process.stderr.transform(utf8.decoder).listen(print);

    final stdout = process.stdout.transform(utf8.decoder);

    try {
      return await stdout.first;
    } catch (_) {
      return '';
    }
  }
}

final winCopyPath =
    path.join(path.current, 'lib/src/backends/windows/copy.exe');
final winPastePath =
    path.join(path.current, 'lib/src/backends/windows/paste.exe');

class WindowsClipboard implements Clipboard {
  @override
  Future<bool> write(covariant String input) async {
    final process = await Process.start(winCopyPath, [], runInShell: true);
    process.stderr.transform(utf8.decoder).listen(print);
    process.stdin.write(input);

    try {
      await process.stdin.close();
    } catch (e) {
      return false;
    }

    return await process.exitCode == 0;
  }

  @override
  Future<String> read() async {
    final process = await Process.start(winPastePath, [], runInShell: true);
    process.stderr.transform(utf8.decoder).listen(print);

    final stdout = process.stdout.transform(utf8.decoder);

    try {
      return await stdout.first;
    } catch (_) {
      return '';
    }
  }
}
