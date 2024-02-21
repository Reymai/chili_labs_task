import 'package:equatable/equatable.dart';

class Gif extends Equatable {
  final String id;
  final String title;
  final String url;

  const Gif({
    required this.id,
    required this.title,
    required this.url,
  });

  factory Gif.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('id') ||
        !json.containsKey('title') ||
        !json.containsKey('images')) {
      throw Exception('Invalid JSON');
    }

    var images = json['images'];
    if (!images.containsKey('preview_gif')) {
      throw Exception('Invalid JSON');
    }

    var previewGif = images['preview_gif'];
    if (!previewGif.containsKey('url')) {
      throw Exception('Invalid JSON');
    }

    return Gif(
      id: json['id'],
      title: json['title'],
      url: previewGif['url'],
    );
  }

  @override
  List<Object?> get props => [id, title, url];
}
