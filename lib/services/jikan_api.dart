// lib/services/jikan_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/anime.dart';

class JikanApi {
  // base for Jikan v4
  static const _base = 'https://api.jikan.moe/v4';

  final http.Client client;
  JikanApi({http.Client? client}) : client = client ?? http.Client();

  Future<List<Anime>> searchAnime(String query, {int page = 1}) async {
    final q = Uri.encodeQueryComponent(query);
    final url = Uri.parse('$_base/anime?q=$q&page=$page');
    final res = await client.get(url, headers: {'Accept': 'application/json'});

    if (res.statusCode != 200) {
      throw Exception('Failed to fetch anime: ${res.statusCode}');
    }

    final jsonBody = json.decode(res.body);
    final List data = jsonBody['data'] ?? [];
    return data.map((e) => Anime.fromJson(e)).toList();
  }

  Future<Anime> getAnimeById(int malId) async {
    final url = Uri.parse('$_base/anime/$malId/full');
    final res = await client.get(url, headers: {'Accept': 'application/json'});
    if (res.statusCode != 200) {
      throw Exception('Failed to fetch anime detail');
    }
    final jsonBody = json.decode(res.body);
    final data = jsonBody['data'];
    return Anime.fromJson(data);
  }
}
