import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flixora/app/app_routes.dart';
import 'package:flixora/data/model/genre_model.dart';
import 'package:flixora/data/model/media_type.dart';
import 'package:flixora/data/providers/genre/genre_provider.dart';
import 'package:flixora/resources/assets_app.dart';
import 'package:flixora/resources/colors_app.dart';
import 'package:flixora/resources/strings_app.dart';

class BrowseHeader extends StatelessWidget {
  const BrowseHeader({
    super.key,
    this.title,
    this.type,
    this.selectedGenre,
    this.onGenreSelected,
  });

  final String? title;
  final MediaType? type;
  final Genre? selectedGenre;
  final ValueChanged<Genre?>? onGenreSelected;

  void _openGenreSheet(BuildContext context) {
    if (type == null || onGenreSelected == null) return;
    final genreProvider = context.read<GenreProvider>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.72),
      builder: (_) => _GenreBottomSheet(
        type: type!,
        genres: genreProvider.genresFor(type!),
        isLoading: genreProvider.statusFor(type!) == GenreLoadStatus.loading,
        selectedGenre: selectedGenre,
        onSelected: (g) {
          onGenreSelected!(g);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasGenre = type != null && onGenreSelected != null;
    final isFiltered = selectedGenre != null;

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 9.h, 4.w, 5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(AppIcons.textLogo, height: 25.h),
                if (title != null) ...[
                  SizedBox(width: 10.w),
                  Container(
                    width: 1.w,
                    height: 18.h,
                    color: AppColors.white30,
                  ),
                  SizedBox(width: 10.w),
                  Flexible(
                    child: Text(
                      title!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (hasGenre) ...[
            GestureDetector(
              onTap: () => _openGenreSheet(context),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  color: isFiltered
                      ? AppColors.accent.withValues(alpha: 0.15)
                      : Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: isFiltered
                        ? AppColors.accent.withValues(alpha: 0.60)
                        : Colors.white.withValues(alpha: 0.18),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.tune_rounded,
                      size: 14.r,
                      color: isFiltered ? AppColors.accent : Colors.white70,
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      isFiltered ? selectedGenre!.name : 'Genres',
                      style: TextStyle(
                        fontSize: 12.5.sp,
                        fontWeight: isFiltered
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isFiltered ? AppColors.accent : Colors.white70,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 14.r,
                      color: isFiltered ? AppColors.accent : Colors.white70,
                    ),
                  ],
                ),
              ),
            ),
          ],
          IconButton(
            tooltip: AppStrings.search,
            onPressed: () => context.push(AppRoutes.search),
            icon: Icon(Icons.search_rounded, size: 27.r),
          ),
        ],
      ),
    );
  }
}

class _GenreBottomSheet extends StatefulWidget {
  const _GenreBottomSheet({
    required this.type,
    required this.genres,
    required this.isLoading,
    required this.selectedGenre,
    required this.onSelected,
  });

  final MediaType type;
  final List<Genre> genres;
  final bool isLoading;
  final Genre? selectedGenre;
  final ValueChanged<Genre?> onSelected;

  @override
  State<_GenreBottomSheet> createState() => _GenreBottomSheetState();
}

class _GenreBottomSheetState extends State<_GenreBottomSheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
  )..forward();

  late final Animation<double> _fade =
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.paddingOf(context).bottom;
    final screenH = MediaQuery.sizeOf(context).height;

    return FadeTransition(
      opacity: _fade,
      child: Container(
        constraints: BoxConstraints(maxHeight: screenH * 0.88),
        decoration: BoxDecoration(
          color: const Color(0xD9141414),
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(top: 10.h, bottom: 6.h),
              width: 36.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 6.h, bottom: 4.h),
              child: Text(
                'Categories',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            const _SheetDivider(),
            Flexible(
              child: widget.isLoading
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.h),
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      separatorBuilder: (_, _) => const _SheetDivider(),
                      itemCount: widget.genres.length + 1,
                      itemBuilder: (context, index) {
                        final Genre? genre =
                            index == 0 ? null : widget.genres[index - 1];
                        final isSelected = index == 0
                            ? widget.selectedGenre == null
                            : widget.selectedGenre?.id == genre?.id;
                        return _GenreListTile(
                          label: index == 0 ? 'All' : genre!.name,
                          isSelected: isSelected,
                          onTap: () => widget.onSelected(genre),
                        );
                      },
                    ),
            ),
            const _SheetDivider(),
            Padding(
              padding: EdgeInsets.only(top: 20.h, bottom: bottomPad + 24.h),
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 44.r,
                  height: 44.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.28),
                    ),
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 22.r,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetDivider extends StatelessWidget {
  const _SheetDivider();
  @override
  Widget build(BuildContext context) => Divider(
    height: 1,
    thickness: 1,
    color: Colors.white.withValues(alpha: 0.08),
  );
}

class _GenreListTile extends StatefulWidget {
  const _GenreListTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_GenreListTile> createState() => _GenreListTileState();
}

class _GenreListTileState extends State<_GenreListTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _press = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 100),
    lowerBound: 0.97,
    upperBound: 1.0,
    value: 1.0,
  );

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _press.reverse(),
      onTapUp: (_) {
        _press.forward();
        widget.onTap();
      },
      onTapCancel: () => _press.forward(),
      child: ScaleTransition(
        scale: _press,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: widget.isSelected
                      ? FontWeight.w700
                      : FontWeight.w400,
                  color: widget.isSelected ? Colors.white : Colors.white70,
                ),
              ),
              if (widget.isSelected) ...[
                SizedBox(width: 8.w),
                Icon(
                  Icons.check_rounded,
                  color: AppColors.accent,
                  size: 18.r,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
