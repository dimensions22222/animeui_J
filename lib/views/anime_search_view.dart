// lib/views/anime_search_view.dart
import 'package:flutter/material.dart';
import '../models/anime.dart';
import '../presenters/anime_presenter.dart';
import '../widgets/anime_card.dart';
import 'anime_detail_view.dart';

class AnimeSearchView extends StatefulWidget {
  const AnimeSearchView({super.key});

  @override
  _AnimeSearchViewState createState() => _AnimeSearchViewState();
}

class _AnimeSearchViewState extends State<AnimeSearchView> implements AnimeViewContract {
  late AnimePresenter presenter;
  List<Anime> _results = [];
  bool _loading = false;
  String _error = '';
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    presenter = AnimePresenter(view: this);
    _scrollController.addListener(_onScroll);
    // Optional: warm-up search
    // presenter.search('naruto');
  }

  void _onScroll() {
    if (_scrollController.position.pixels > _scrollController.position.maxScrollExtent - 300 && !_loading && _hasMore) {
      presenter.search(_controller.text.trim(), nextPage: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchSubmitted(String q) {
    FocusScope.of(context).unfocus();
    _results.clear();
    _hasMore = true;
    presenter.search(q);
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;
    return Scaffold(
      appBar: AppBar(
        title: Text('Anime Explorer'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () => showAboutDialog(
              context: context,
              applicationName: 'Anime Explorer',
              applicationVersion: '1.0',
              children: [Text('Search anime using the Jikan (MyAnimeList) API. Clean MVP structure.')],
            ),
          )
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: _buildBody(isWide),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(36),
              child: TextField(
                controller: _controller,
                onSubmitted: _onSearchSubmitted,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Search anime (e.g. Demon Slayer, One Piece)',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            onPressed: () => _onSearchSubmitted(_controller.text),
            style: ElevatedButton.styleFrom(shape: StadiumBorder(), padding: EdgeInsets.symmetric(horizontal: 18, vertical: 14)),
            child: Text('Find'),
          )
        ],
      ),
    );
  }

  Widget _buildBody(bool isWide) {
    if (_loading && _results.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    if (_error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Error', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(_error),
            SizedBox(height: 12),
            ElevatedButton(onPressed: () => presenter.search(_controller.text), child: Text('Retry')),
          ],
        ),
      );
    }
    if (_results.isEmpty) {
      return Center(child: Text('Search for an anime to get started ✨', style: TextStyle(fontSize: 16)));
    }

    // Layout: grid on wide screens, list on narrow
    if (isWide) {
      final cross = (MediaQuery.of(context).size.width / 300).floor().clamp(2, 6);
      return RefreshIndicator(
        onRefresh: () async {
          _results.clear();
          _hasMore = true;
          await presenter.search(_controller.text);
        },
        child: GridView.builder(
          controller: _scrollController,
          padding: EdgeInsets.all(12),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cross,
            childAspectRatio: 0.78,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: _results.length + (_loading && _hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= _results.length) return Center(child: CircularProgressIndicator());
            final a = _results[index];
            return AnimeCard(
              anime: a,
              showHover: true,
              onTap: () => _openDetail(a),
            );
          },
        ),
      );
    } else {
      return RefreshIndicator(
        onRefresh: () async {
          _results.clear();
          _hasMore = true;
          await presenter.search(_controller.text);
        },
        child: ListView.separated(
          controller: _scrollController,
          padding: EdgeInsets.all(12),
          itemCount: _results.length + (_loading && _hasMore ? 1 : 0),
          separatorBuilder: (_, __) => SizedBox(height: 10),
          itemBuilder: (context, index) {
            if (index >= _results.length) {
              return Center(child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: CircularProgressIndicator(),
            ));
            }
            final a = _results[index];
            return AnimeCard(anime: a, onTap: () => _openDetail(a));
          },
        ),
      );
    }
  }

  void _openDetail(Anime a) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => AnimeDetailView(animeId: a.malId)));
  }

  // AnimeViewContract implementations
  @override
  void showEmpty() {
    setState(() {
      _loading = false;
      _results = [];
      _error = '';
    });
  }

  @override
  void showError(String message) {
    setState(() {
      _loading = false;
      _error = message;
    });
  }

  @override
  void showLoading() {
    setState(() {
      _loading = true;
      _error = '';
    });
  }

  @override
  void showResults(List<Anime> results, {bool append = false}) {
    setState(() {
      _loading = false;
      _error = '';
      if (append) {
        if (results.isEmpty) _hasMore = false;
        _results.addAll(results);
      } else {
        _results = results;
      }
    });
  }
}
