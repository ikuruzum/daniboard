_**Daniboard —** Non-flutter solution to access clipboard_


[![Pub](https://img.shields.io/pub/v/clippy.svg?style=flat-square)](https://pub.dartlang.org/packages/clippy)
[![Build Status](https://travis-ci.org/andresaraujo/clippy.svg?branch=master)](https://travis-ci.org/andresaraujo/clippy)
[![Build status](https://ci.appveyor.com/api/projects/status/ufiu8o0wvugr149b?svg=true)](https://ci.appveyor.com/project/andresaraujo/clippy)


A library to access the clipboard (copy/paste) for server.

It's a fork of [clippy](https://pub.dartlang.org/packages/clippy)

The browser implementation was removed because it makes more sense to use flutter in the browser.


### Install

Add `daniboard` to dependencies/dev_dependencies in in your pubspec.yaml

### Usage

In the server Daniboard supports writing and reading from the clipboard. It uses system tools for this:
- On linux uses `xsel` (Install if needed)
- On Mac uses `pbcopy`/`pbpaste`
- On windows it embeds a copy/paste tool [win-clipboard](https://github.com/sindresorhus/win-clipboard)

```dart
import 'package:daniboard/daniboard.dart' as daniboard;

main() async {
  // Write to clipboard
  await daniboard.write('https://github.com/ikuruzum/daniboard');
  
  // Read from clipboard
  final clipboard = await daniboard.read();  
}
```

See [example](/example)

