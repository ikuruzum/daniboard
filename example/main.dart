import 'package:daniboard/daniboard.dart' as daniboard;

main() async {
  await daniboard.write('https://github.com/ikuruzum/daniboard');
  final clipboard = await daniboard.read();
  print(clipboard);
}
