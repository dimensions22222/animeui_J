// lib/presenters/anime_presenter.dart
import 'dart:async';
import '../models/anime.dart';
import '../services/jikan_api.dart';

abstract class AnimeViewContract {
  void showLoading();
  void showError(String message);
  void showResults(List<Anime> results, {bool append = false});
  void showEmpty();
}

class AnimePresenter {
  final AnimeViewContract view;
  final JikanApi api;
  String _currentQuery = '';
  int _currentPage = 1;
  bool _isLoading = false;

  AnimePresenter({required this.view, JikanApi? api}) : api = api ?? JikanApi();

  Future<void> search(String query, {bool nextPage = false}) async {
    if (_isLoading) return;
    if (!nextPage) {
      _currentQuery = query;
      _currentPage = 1;
    } else {
      _currentPage += 1;
    }

    if (_currentQuery.trim().isEmpty) {
      view.showEmpty();
      return;
    }

    _isLoading = true;
    if (!nextPage) view.showLoading();

    try {
      final results = await api.searchAnime(_currentQuery, page: _currentPage);
      if (results.isEmpty && _currentPage == 1) {
        view.showEmpty();
      } else {
        view.showResults(results, append: nextPage);
      }
    } catch (e) {
      view.showError(e.toString());
    } finally {
      _isLoading = false;
    }
  }

  Future<Anime> getAnimeDetail(int id) => api.getAnimeById(id);
}
