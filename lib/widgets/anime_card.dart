// lib/widgets/anime_card.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/anime.dart';

class AnimeCard extends StatelessWidget {
  final Anime anime;
  final VoidCallback onTap;
  final bool showHover;

  const AnimeCard({
    super.key,
    required this.anime,
    required this.onTap,
    this.showHover = false,
  });

  @override
  Widget build(BuildContext context) {
    final card = Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Hero(
              tag: 'anime_${anime.malId}',
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: CachedNetworkImage(
                  imageUrl: anime.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (c, u) => Container(
                    color: Colors.grey.shade200,
                    child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  ),
                  errorWidget: (c, u, e) => Container(
                    color: Colors.grey.shade200,
                    child: Icon(Icons.broken_image, size: 48),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      anime.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star, size: 16),
                          SizedBox(width: 4),
                          Text(anime.score.toStringAsFixed(1)),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text('${anime.episodes} ep', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );

    if (!showHover) return card;

    // Add mouse hover effect for desktop
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 180),
        child: card,
      ),
    );
  }
}
