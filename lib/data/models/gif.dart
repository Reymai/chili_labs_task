class Gif {
  final String id;
  final String title;
  final String url;

  const Gif({
    required this.id,
    required this.title,
    required this.url,
  });

  factory Gif.fromJson(Map<String, dynamic> json) {
    return Gif(
      id: json['id'],
      title: json['title'],
      url: json['images']['preview_gif']['url'],
    );
  }
}
