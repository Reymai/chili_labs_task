import 'dart:convert';

import 'package:chili_labs_task/data/models/gif.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GifRepository {
  Future<List<Gif>> searchGifs(String query) async {
    final response = await http.get(
      Uri.parse(
          'https://api.giphy.com/v1/gifs/search?api_key${dotenv.env['GIPHY_API_KEY']}&q=$query&limit=25&offset=0&rating=g&lang=en'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to load gifs');
    }
    final bodyJson = jsonDecode(response.body) as Map<String, dynamic>;
    final data = bodyJson['data'] as List<Map<String, dynamic>>;
    return data.map((json) => Gif.fromJson(json)).toList();
  }
}
