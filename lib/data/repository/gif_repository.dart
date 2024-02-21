import 'dart:convert';

import 'package:chili_labs_task/data/models/gif.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GifRepository {
  final http.Client client;

  GifRepository({required this.client});

  Future<List<Gif>> searchGifs(String query, int offset) async {
    final baseUrl = 'https://api.giphy.com/v1/gifs/search';
    final params = {
      'api_key': dotenv.env['GIPHY_API_KEY'],
      'q': query,
      'limit': '25',
      'offset': offset.toString(),
      'rating': 'g',
      'lang': 'en',
    };
    final uri = Uri.parse(baseUrl).replace(queryParameters: params);

    final response = await client.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load gifs');
    }

    try {
      final bodyJson = jsonDecode(response.body) as Map<String, dynamic>;
      final data = bodyJson['data'] as List<dynamic>;

      if (data.isEmpty) {
        throw Exception('No gifs found');
      }

      return data.map((json) => Gif.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to parse gifs');
    }
  }
}
