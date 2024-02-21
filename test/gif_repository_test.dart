import 'package:chili_labs_task/data/models/gif.dart';
import 'package:chili_labs_task/data/repository/gif_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class MockHttpClient extends Mock implements http.Client {
  @override
  Future<http.Response> get(Uri? url, {Map<String, String>? headers}) {
    return super.noSuchMethod(
      Invocation.method(#get, [url], {#headers: headers}),
      returnValue: Future.value(http.Response('{"data": []}', 200)),
      returnValueForMissingStub:
          Future.value(http.Response('{"data": []}', 200)),
    );
  }
}

void main() {
  late GifRepository gifRepository;
  late MockHttpClient mockHttpClient;

  setUp(() async {
    mockHttpClient = MockHttpClient();
    gifRepository = GifRepository(client: mockHttpClient);
    await dotenv.load();
  });

  group('searchGifs', () {
    final testQuery = 'test';
    final testOffset = 0;
    final testGifList = [
      const Gif(
        id: 'testId',
        title: 'testTitle',
        url: 'testImageUrl',
      ),
    ];

    test('should return a list of Gif when the response code is 200', () async {
      when(mockHttpClient.get(any)).thenAnswer((_) async => http.Response(
          '{"data": [{"id": "testId", "title": "testTitle", "images": {"preview_gif": {"url": "testImageUrl"}}}]}',
          200));
      final result = await gifRepository.searchGifs(testQuery, testOffset);
      expect(result, testGifList);
    });

    test('should throw an exception when the response code is not 200',
        () async {
      when(mockHttpClient.get(any))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      expect(() => gifRepository.searchGifs(testQuery, testOffset),
          throwsException);
    });

    test('should throw an exception when the response body is empty', () async {
      when(mockHttpClient.get(any))
          .thenAnswer((_) async => http.Response('{"data": []}', 200));
      expect(() => gifRepository.searchGifs(testQuery, testOffset),
          throwsException);
    });
  });
}
