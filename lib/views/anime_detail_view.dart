// lib/views/anime_detail_view.dart
// ignore_for_file: unused_import, library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../models/anime.dart';
import '../presenters/anime_presenter.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AnimeDetailView extends StatefulWidget {
  final int animeId;
  const AnimeDetailView({super.key, required this.animeId});

  @override
  _AnimeDetailViewState createState() => _AnimeDetailViewState();
}

class _AnimeDetailViewState extends State<AnimeDetailView> {
  AnimePresenter? _presenter;
  Anime? _anime;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _presenter = AnimePresenter(view: _NullView());
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final a = await _presenter!.getAnimeDetail(widget.animeId);
      setState(() {
        _anime = a;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(elevation: 0, title: Text('Details')),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : _buildContent(context, _anime!, theme),
    );
  }

  Widget _buildContent(BuildContext context, Anime anime, ThemeData theme) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: 'anime_${anime.malId}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: anime.imageUrl,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
                placeholder: (c, u) => Container(height: 220, color: Colors.grey.shade200),
              ),
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(anime.title, style: theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(children: [Icon(Icons.star), SizedBox(width: 4), Text(anime.score.toStringAsFixed(1))]),
                  SizedBox(height: 6),
                  Text('${anime.episodes} episodes'),
                ],
              )
            ],
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              Chip(label: Text(anime.type.isNotEmpty ? anime.type : 'Unknown')),
              if (anime.aired.isNotEmpty) Chip(label: Text(anime.aired)),
            ],
          ),
          SizedBox(height: 12),
          Text('Synopsis', style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600)),
          SizedBox(height: 6),
          Text(anime.synopsis.isNotEmpty ? anime.synopsis : 'No synopsis available.'),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => _share(anime),
            icon: Icon(Icons.share),
            label: Text('Share'),
          )
        ],
      ),
    );
  }

  void _share(Anime anime) {
    // Light placeholder for interview: explain you'd use share_plus here.
    final shareText = '${anime.title} — ${anime.synopsis.substring(0, anime.synopsis.length.clamp(0, 200))}...';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Share'),
        content: Text('Would share:\n\n$shareText'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Close')),
        ],
      ),
    );
  }
}

// a tiny view stub used by presenter when we only call getAnimeById
class _NullView implements AnimeViewContract {
  @override
  void showEmpty() {}

  @override
  void showError(String message) {}

  @override
  void showLoading() {}

  @override
  void showResults(List results, {bool append = false}) {}
}
