import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/screens/detail_screen.dart';
import 'package:news_app/controller/news_controller.dart';

class BookmarkScreen extends StatelessWidget {
  final NewsController controller = Get.find<NewsController>();

  BookmarkScreen({super.key});

  // Palette (kept minimal + relies on controller colors)
  static const Color _primary = Color(0xff6366F1); // modern blue accent
  static const Color _danger = Color(0xFFE11D48); // remove/clear
  static const double _radiusL = 20;
  static const double _radiusM = 14;
  static const double _radiusS = 10;

  // Header: clean, modern-classic, no heavy gradient
  Widget _buildHeader() {
    return GetBuilder<NewsController>(
      builder: (c) {
        final bg = c.backgroundColor;
        final titleColor = c.textColor;
        final subtitle = '${c.bookmark.length} saved articles';
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          decoration: BoxDecoration(
            color: bg,
            boxShadow: [
              BoxShadow(
                color: (c.isDarkMode ? Colors.black : Colors.black12)
                    .withOpacity(0.06),
                offset: const Offset(0, 1),
                blurRadius: 6,
                spreadRadius: 0,
              ),
            ],
          ),
          child: SafeArea(
            bottom: false,
            child: Row(
              children: [
                _softButton(
                  c,
                  onTap: () => Get.back(),
                  icon: Icons.arrow_back_ios_new_rounded,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bookmarks',
                        style: TextStyle(
                          color: titleColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: c.subtitleColor,
                          fontSize: 13,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                _softButton(
                  c,
                  onTap: controller.changeTheme,
                  icon: c.isTheme.value ? Icons.light_mode : Icons.dark_mode,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Search bar: minimalist pill with optional "clear all"
  Widget _buildSearchBar() {
    return GetBuilder<NewsController>(
      builder: (c) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: c.cardColor,
                    borderRadius: BorderRadius.circular(_radiusL),
                    border: Border.all(
                      color: c.isDarkMode
                          ? Colors.white.withOpacity(0.06)
                          : Colors.black.withOpacity(0.06),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            (c.isDarkMode
                                    ? Colors.black.withOpacity(0.25)
                                    : Colors.black.withOpacity(0.06))
                                .withOpacity(0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search_rounded,
                        color: c.isDarkMode
                            ? Colors.grey.shade300
                            : Colors.grey.shade500,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          onChanged: (v) => c.search.value = v,
                          style: TextStyle(fontSize: 16, color: c.textColor),
                          decoration: InputDecoration(
                            hintText: 'Search bookmarks',
                            hintStyle: TextStyle(
                              color: c.isDarkMode
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade500,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                      // Clear input action when searching
                      Obx(
                        () => AnimatedSwitcher(
                          duration: const Duration(milliseconds: 180),
                          child: c.search.value.isNotEmpty
                              ? _iconTap(
                                  c,
                                  icon: Icons.close_rounded,
                                  tooltip: 'Clear search',
                                  onTap: () => c.search.value = '',
                                )
                              : const SizedBox.shrink(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Clear all bookmarks if any
              Obx(
                () => AnimatedOpacity(
                  duration: const Duration(milliseconds: 180),
                  opacity: c.bookmark.isNotEmpty ? 1 : 0.4,
                  child: _iconTap(
                    c,
                    icon: Icons.layers_clear_rounded,
                    tooltip: 'Clear all',
                    onTap: c.bookmark.isNotEmpty ? _showClearAllDialog : null,
                    bgColor: _danger.withOpacity(0.10),
                    iconColor: _danger,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Bookmark card: refined, modern, image on top + content + actions
  Widget _buildBookmarkCard(Map<String, dynamic> item) {
    return GetBuilder<NewsController>(
      builder: (c) {
        final title = (item['title'] ?? '').toString();
        final desc = (item['description'] ?? '').toString();
        final img = (item['image']?['large'] ?? '').toString();

        return Material(
          color: c.cardColor,
          borderRadius: BorderRadius.circular(_radiusL),
          elevation: 0,
          child: InkWell(
            onTap: () => Get.to(() => DetailScreen(newsDetail: item)),
            borderRadius: BorderRadius.circular(_radiusL),
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_radiusL),
                border: Border.all(
                  color: c.isDarkMode
                      ? Colors.white.withOpacity(0.06)
                      : Colors.black.withOpacity(0.06),
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        (c.isDarkMode
                                ? Colors.black.withOpacity(0.25)
                                : Colors.black.withOpacity(0.06))
                            .withOpacity(0.06),
                    blurRadius: 14,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Media
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(_radiusL),
                    ),
                    child: SizedBox(
                      height: 180,
                      width: double.infinity,
                      child: Image.network(
                        img,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          decoration: BoxDecoration(
                            color: c.isDarkMode
                                ? Colors.grey.shade900
                                : Colors.grey.shade200,
                          ),
                          child: Icon(
                            Icons.article_outlined,
                            size: 40,
                            color: c.isDarkMode
                                ? Colors.grey.shade600
                                : Colors.grey.shade500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: c.textColor,
                            fontSize: 16.5,
                            fontWeight: FontWeight.w700,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Description
                        if (desc.isNotEmpty)
                          Text(
                            desc,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: c.subtitleColor,
                              fontSize: 14,
                              height: 1.45,
                            ),
                          ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _chip(
                              c,
                              label: 'Bookmarked',
                              bg: _primary,
                              fg: Colors.white,
                            ),
                            const Spacer(),
                            _softIconButton(
                              c,
                              icon: Icons.bookmark_remove_rounded,
                              onTap: () => _showRemoveDialog(item),
                              iconColor: _danger,
                              bgColor: _danger.withOpacity(0.10),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Empty state: minimalist and inviting
  Widget _buildEmptyState() {
    return GetBuilder<NewsController>(
      builder: (c) => Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
          decoration: BoxDecoration(
            color: c.cardColor,
            borderRadius: BorderRadius.circular(_radiusL),
            border: Border.all(
              color: c.isDarkMode
                  ? Colors.white.withOpacity(0.06)
                  : Colors.black.withOpacity(0.06),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _iconCircle(
                bg: _primary.withOpacity(0.10),
                icon: Icons.bookmark_border_rounded,
                iconColor: _primary,
              ),
              const SizedBox(height: 18),
              Text(
                'No Bookmarks Yet',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: c.textColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Save articles to read later. They will appear here.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: c.subtitleColor,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 18),
              _primaryButton(
                label: 'Explore News',
                onPressed: () => Get.back(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Filtering (essence preserved)
  List<Map<String, dynamic>> get filteredBookmarks {
    if (controller.search.value.isEmpty) return controller.bookmark;
    return controller.bookmark.where((news) {
      final title = (news['title'] ?? '').toString().toLowerCase();
      final desc = (news['description'] ?? '').toString().toLowerCase();
      final q = controller.search.value.toLowerCase();
      return title.contains(q) || desc.contains(q);
    }).toList();
  }

  // Dialogs (essence preserved, refined styles)
  void _showRemoveDialog(Map<String, dynamic> item) {
    Get.dialog(
      GetBuilder<NewsController>(
        builder: (c) => AlertDialog(
          backgroundColor: c.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radiusM),
          ),
          title: Text('Remove Bookmark', style: TextStyle(color: c.textColor)),
          content: Text(
            'Are you sure you want to remove this article from bookmarks?',
            style: TextStyle(color: c.subtitleColor),
          ),
          actions: [
            TextButton(onPressed: Get.back, child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                controller.removeBookmark(item);
                Get.back();
              },
              style: TextButton.styleFrom(foregroundColor: _danger),
              child: const Text('Remove'),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearAllDialog() {
    Get.dialog(
      GetBuilder<NewsController>(
        builder: (c) => AlertDialog(
          backgroundColor: c.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radiusM),
          ),
          title: Text(
            'Clear All Bookmarks',
            style: TextStyle(color: c.textColor),
          ),
          content: Text(
            'This action cannot be undone.',
            style: TextStyle(color: c.subtitleColor),
          ),
          actions: [
            TextButton(onPressed: Get.back, child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                controller.bookmark.clear();
                Get.back();
                Get.snackbar(
                  'Success',
                  'All bookmarks cleared',
                  backgroundColor: controller.isDarkMode
                      ? Colors.grey[800]
                      : _primary,
                  colorText: Colors.white,
                );
              },
              style: TextButton.styleFrom(foregroundColor: _danger),
              child: const Text('Clear All'),
            ),
          ],
        ),
      ),
    );
  }

  // Helpers — minimalist components
  Widget _softButton(
    NewsController c, {
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: c.cardColor,
          borderRadius: BorderRadius.circular(_radiusS),
          border: Border.all(
            color: c.isDarkMode
                ? Colors.white.withOpacity(0.06)
                : Colors.black.withOpacity(0.06),
          ),
        ),
        padding: const EdgeInsets.all(10),
        child: Icon(icon, size: 18, color: c.textColor),
      ),
    );
  }

  Widget _iconTap(
    NewsController c, {
    required IconData icon,
    required String tooltip,
    VoidCallback? onTap,
    Color? bgColor,
    Color? iconColor,
  }) {
    final disabled = onTap == null;
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: disabled ? null : onTap,
        child: Container(
          decoration: BoxDecoration(
            color:
                (bgColor ??
                        (c.isDarkMode
                            ? Colors.white.withOpacity(0.06)
                            : Colors.black.withOpacity(0.04)))
                    .withOpacity(disabled ? 0.5 : 1),
            borderRadius: BorderRadius.circular(_radiusS),
          ),
          padding: const EdgeInsets.all(10),
          child: Icon(
            icon,
            size: 20,
            color: (iconColor ?? c.subtitleColor).withOpacity(
              disabled ? 0.6 : 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _chip(
    NewsController c, {
    required String label,
    required Color bg,
    required Color fg,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _softIconButton(
    NewsController c, {
    required IconData icon,
    required VoidCallback onTap,
    Color? iconColor,
    Color? bgColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color:
              bgColor ??
              (c.isDarkMode
                  ? Colors.white.withOpacity(0.06)
                  : Colors.black.withOpacity(0.04)),
          borderRadius: BorderRadius.circular(_radiusS),
        ),
        padding: const EdgeInsets.all(8),
        child: Icon(icon, size: 20, color: iconColor ?? c.subtitleColor),
      ),
    );
  }

  Widget _iconCircle({
    required Color bg,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Icon(icon, color: iconColor, size: 40),
    );
  }

  Widget _primaryButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radiusL),
        ),
        elevation: 0,
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewsController>(
      builder: (c) => Scaffold(
        backgroundColor: c.backgroundColor,
        body: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            Expanded(
              child: Obx(() {
                final bookmarks = filteredBookmarks;

                if (c.bookmark.isEmpty) {
                  return _buildEmptyState();
                }

                if (bookmarks.isEmpty && c.search.value.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
                      decoration: BoxDecoration(
                        color: c.cardColor,
                        borderRadius: BorderRadius.circular(_radiusL),
                        border: Border.all(
                          color: c.isDarkMode
                              ? Colors.white.withOpacity(0.06)
                              : Colors.black.withOpacity(0.06),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 42,
                            color: c.isDarkMode
                                ? Colors.grey.shade500
                                : Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No Results Found',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: c.textColor,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Try a different keyword.',
                            style: TextStyle(
                              fontSize: 14,
                              color: c.subtitleColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  itemCount: bookmarks.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    return _buildBookmarkCard(bookmarks[index]);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
