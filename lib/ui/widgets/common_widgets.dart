import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/app_theme.dart';
import '../../core/copy.dart';
import '../../core/models.dart';
import '../../data/api.dart';
import '../../features/watchlist/watchlist_provider.dart';

class DetailArgs {
  const DetailArgs(this.item, this.heroTag);
  final MediaItem item;
  final String heroTag;
}

void openDetail(BuildContext context, MediaItem item, String heroTag) {
  context.push(
    '/detail/${item.type.name}/${item.id}',
    extra: DetailArgs(item, heroTag),
  );
}

class Brand extends StatelessWidget {
  const Brand({super.key, this.size = 25});
  final double size;
  @override
  Widget build(BuildContext context) => Text(
    Copy.appName,
    style: TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w900,
      color: AppTheme.accent,
      letterSpacing: -1.5,
    ),
  );
}

class Artwork extends StatelessWidget {
  const Artwork({
    super.key,
    required this.path,
    required this.height,
    required this.width,
    this.backdrop = false,
    this.heroTag,
  });
  final String? path;
  final double height;
  final double width;
  final bool backdrop;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final repository = context.read<MediaRepository>();
    final url = repository.imageUrl(path, backdrop: backdrop);
    Widget child;
    if (url == null) {
      child = _placeholder();
    } else {
      child = CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        fit: BoxFit.cover,
        placeholder: (_, _) => const ColoredBox(color: AppTheme.surface),
        errorWidget: (_, _, _) => _placeholder(),
      );
    }
    child = SizedBox(width: width, height: height, child: child);
    if (heroTag != null) child = Hero(tag: heroTag!, child: child);
    return child;
  }

  Widget _placeholder() => Container(
    color: AppTheme.surface,
    alignment: Alignment.center,
    child: const Icon(Icons.movie_outlined, size: 42, color: Colors.white38),
  );
}

class PosterCard extends StatelessWidget {
  const PosterCard({
    super.key,
    required this.item,
    required this.scope,
    this.width = 120,
  });
  final MediaItem item;
  final String scope;
  final double width;

  @override
  Widget build(BuildContext context) {
    final tag = '$scope-${item.key}';
    return Semantics(
      button: true,
      label: 'Open ${item.title}',
      child: InkWell(
        onTap: () => openDetail(context, item, tag),
        borderRadius: BorderRadius.circular(5),
        child: SizedBox(
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Artwork(
                  path: item.posterPath,
                  width: width,
                  height: width * 1.5,
                  heroTag: tag,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: Color(0xFFFFC857),
                    size: 13,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    item.rating.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 11, color: AppTheme.muted),
                  ),
                  const SizedBox(width: 7),
                  Flexible(
                    child: Text(
                      item.year,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.muted,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoadingBlock extends StatelessWidget {
  const LoadingBlock({
    super.key,
    required this.width,
    required this.height,
    this.radius = 5,
  });
  final double width;
  final double height;
  final double radius;
  @override
  Widget build(BuildContext context) {
    final block = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
    if (MediaQuery.disableAnimationsOf(context)) return block;
    return Shimmer.fromColors(
      baseColor: AppTheme.surface,
      highlightColor: const Color(0xFF393939),
      child: block,
    );
  }
}

class PosterSkeletonRow extends StatelessWidget {
  const PosterSkeletonRow({super.key});
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 219,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: 5,
      separatorBuilder: (_, _) => const SizedBox(width: 10),
      itemBuilder: (_, _) => const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LoadingBlock(width: 120, height: 180),
          SizedBox(height: 8),
          LoadingBlock(width: 92, height: 10),
        ],
      ),
    ),
  );
}

class StateMessage extends StatelessWidget {
  const StateMessage({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
    this.actionLabel = Copy.tryAgain,
    this.compact = false,
  });
  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? action;
  final String actionLabel;
  final bool compact;
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(horizontal: 28, vertical: compact ? 18 : 54),
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: compact ? 32 : 48, color: AppTheme.muted),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: compact ? 16 : 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppTheme.muted, height: 1.4),
          ),
          if (action != null) ...[
            const SizedBox(height: 20),
            OutlinedButton(onPressed: action, child: Text(actionLabel)),
          ],
        ],
      ),
    ),
  );
}

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({
    super.key,
    required this.error,
    required this.retry,
    this.compact = false,
  });
  final AppException error;
  final VoidCallback retry;
  final bool compact;
  @override
  Widget build(BuildContext context) => StateMessage(
    icon: error.type == AppErrorType.noConnection
        ? Icons.wifi_off_rounded
        : Icons.error_outline_rounded,
    title: error.type == AppErrorType.noConnection
        ? Copy.offlineTitle
        : 'Unable to Load',
    message: error.type == AppErrorType.noConnection
        ? Copy.offlineBody
        : error.message,
    action: retry,
    compact: compact,
  );
}

class ListAction extends StatelessWidget {
  const ListAction({super.key, required this.item, this.fullWidth = false});
  final MediaItem item;
  final bool fullWidth;
  @override
  Widget build(BuildContext context) {
    final saved = context.select<WatchlistProvider, bool>(
      (provider) => provider.contains(item),
    );
    return OutlinedButton.icon(
      onPressed: () => context.read<WatchlistProvider>().toggle(item),
      icon: Icon(saved ? Icons.check_rounded : Icons.add_rounded),
      label: Text(saved ? 'In My List' : 'My List'),
      style: OutlinedButton.styleFrom(
        minimumSize: Size(fullWidth ? double.infinity : 0, 46),
        side: const BorderSide(color: Colors.white54),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );
  }
}
