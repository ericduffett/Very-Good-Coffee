import 'package:coffee_api/coffee_api.dart';
import 'package:test/test.dart';

void main() {
  test('returns the correct Coffee object', () {
    expect(Coffee.fromJson(<String, dynamic>{
      'file': 'https://coffee.alexflipnote.dev/wafuwerasdfn18438_coffee.jpg',
    },),
      isA<Coffee>()
          .having((c) => c.file, 'file',
          'https://coffee.alexflipnote.dev/wafuwerasdfn18438_coffee.jpg',)
          .having((c) => c.url, 'url', Uri.https('coffee.alexflipnote.dev',
          'wafuwerasdfn18438_coffee.jpg',),),
    );
  });
}
