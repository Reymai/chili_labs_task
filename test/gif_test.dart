import 'package:chili_labs_task/data/models/gif.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Gif', () {
    test(
        'fromJson should return correct Gif object when valid json is provided',
        () {
      final json = {
        'id': 'testId',
        'title': 'testTitle',
        'images': {
          'preview_gif': {
            'url': 'testUrl',
          },
        },
      };

      final expectedGif = Gif(
        id: 'testId',
        title: 'testTitle',
        url: 'testUrl',
      );

      expect(Gif.fromJson(json), expectedGif);
    });

    test('fromJson should throw exception when invalid json is provided', () {
      final json = {
        'id': 'testId',
        'title': 'testTitle',
      };

      expect(() => Gif.fromJson(json), throwsA(isA<Exception>()));
    });

    test('props should return correct list of properties', () {
      final gif = Gif(
        id: 'testId',
        title: 'testTitle',
        url: 'testUrl',
      );

      expect(gif.props, ['testId', 'testTitle', 'testUrl']);
    });
  });
}
