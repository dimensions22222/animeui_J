// lib/models/anime.dart
class Anime {
  final int malId;
  final String title;
  final String imageUrl;
  final String synopsis;
  final double score;
  final int episodes;
  final String type;
  final String aired;

  Anime({
    required this.malId,
    required this.title,
    required this.imageUrl,
    required this.synopsis,
    required this.score,
    required this.episodes,
    required this.type,
    required this.aired,
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    final data = json['images'] != null
        ? (json['images']['jpg'] ?? json['images']['webp'])
        : null;

    String img = '';
    if (data != null && data['image_url'] != null) {
      img = data['image_url'];
    } else if (json['image_url'] != null) {
      img = json['image_url'];
    }

    // fallback if Jikan v4 structure is different
    if (img.isEmpty && json['images'] != null) {
      try {
        img = json['images']['jpg']['large_image_url'] ?? '';
      } catch (_) {}
    }

    return Anime(
      malId: json['mal_id'] ?? 0,
      title: json['title'] ?? 'Unknown',
      imageUrl: img,
      synopsis: json['synopsis'] ?? '',
      score: (json['score'] is num) ? (json['score'] as num).toDouble() : 0.0,
      episodes: json['episodes'] ?? 0,
      type: json['type'] ?? '',
      aired: json['aired'] != null && json['aired']['string'] != null
          ? json['aired']['string']
          : (json['year'] != null ? json['year'].toString() : ''),
    );
  }
}

