import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/screens/bookmark_page.dart';
import 'package:news_app/screens/detail_screen.dart';
import 'package:news_app/controller/news_controller.dart';

const _kPrimary = Color(0xff6366F1); // refined blue accent
const _kRadius = 16.0; // consistent rounded corners
const _kPill = 24.0;

class ScreenApi extends StatelessWidget {
  final NewsController controller = Get.put(NewsController());

  ScreenApi({super.key});

  Widget _buildHeader() {
    return GetBuilder<NewsController>(
      builder: (controller) => Container(
        padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
        decoration: BoxDecoration(
          color: controller.cardColor,
          boxShadow: [
            BoxShadow(
              color: controller.isDarkMode
                  ? Colors.black.withOpacity(0.25)
                  : Colors.black.withOpacity(0.04),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: controller.isDarkMode
                    ? Colors.white.withOpacity(0.06)
                    : Colors.black.withOpacity(0.04),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.person_outline,
                color: controller.isDarkMode ? Colors.white70 : Colors.black87,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi, Raja',
                    style: TextStyle(
                      color: controller.textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Discover the latest news',
                    style: TextStyle(
                      color: controller.subtitleColor,
                      fontSize: 13,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: controller.changeTheme,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: controller.isDarkMode
                      ? Colors.white.withOpacity(0.06)
                      : _kPrimary.withOpacity(0.08),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: controller.isDarkMode
                        ? Colors.white.withOpacity(0.08)
                        : Colors.black.withOpacity(0.06),
                  ),
                ),
                child: Obx(
                  () => Icon(
                    controller.isTheme.value
                        ? Icons.light_mode_outlined
                        : Icons.dark_mode_outlined,
                    color: controller.isDarkMode ? Colors.white70 : _kPrimary,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return GetBuilder<NewsController>(
      builder: (controller) => Container(
        margin: const EdgeInsets.fromLTRB(20, 16, 20, 8),
        decoration: BoxDecoration(
          color: controller.isDarkMode
              ? Colors.white.withOpacity(0.06)
              : Colors.black.withOpacity(0.04),
          borderRadius: BorderRadius.circular(_kPill),
          border: Border.all(
            color: controller.isDarkMode
                ? Colors.white.withOpacity(0.08)
                : Colors.black.withOpacity(0.06),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 8),
            Icon(
              Icons.search_rounded,
              color: controller.isDarkMode
                  ? Colors.grey.shade300
                  : Colors.grey.shade600,
              size: 22,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: TextField(
                onChanged: (value) => controller.search.value = value,
                decoration: const InputDecoration(
                  hintText: 'Search articles',
                  border: InputBorder.none,
                ),
                style: TextStyle(fontSize: 15, color: controller.textColor),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 6),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _kPrimary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.tune_rounded,
                color: Color(0xff6366F1),
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget categoryChip(String label, String type) {
    return Obx(() {
      final isSelected = controller.selectedCategory.value == type;
      final isDark = controller.isDarkMode;

      return AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(right: 10),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => controller.fetchNews(type),
            borderRadius: BorderRadius.circular(24),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? Color(0xff6366F1)
                    : (isDark
                          ? Colors.white.withOpacity(0.06)
                          : Colors.black.withOpacity(0.04)),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isSelected
                      ? Color(0xff6366F1)
                      : (isDark
                            ? Colors.white.withOpacity(0.08)
                            : Colors.black.withOpacity(0.06)),
                ),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : (isDark ? Colors.grey.shade200 : Colors.black87),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildSectionHeader(String title, {bool showViewMore = true}) {
    return GetBuilder<NewsController>(
      builder: (controller) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: controller.textColor,
                height: 1.1,
              ),
            ),
            if (showViewMore)
              Text(
                'View more',
                style: TextStyle(
                  color: _kPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendingGrid() {
    return Obx(() {
      if (controller.filteredNews.isEmpty) return const SizedBox.shrink();

      final trendingNews = controller.filteredNews.take(3).toList();

      return Container(
        height: 260,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildTrendingCard(trendingNews[0], isLarge: true),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  if (trendingNews.length > 1)
                    Expanded(
                      child: _buildTrendingCard(
                        trendingNews[1],
                        isLarge: false,
                      ),
                    ),
                  if (trendingNews.length > 2) ...[
                    const SizedBox(height: 12),
                    Expanded(
                      child: _buildTrendingCard(
                        trendingNews[2],
                        isLarge: false,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTrendingCard(
    Map<String, dynamic> item, {
    required bool isLarge,
  }) {
    return GestureDetector(
      onTap: () => Get.to(() => DetailScreen(newsDetail: item)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_kRadius),
          boxShadow: [
            BoxShadow(
              color: controller.isDarkMode
                  ? Colors.black.withOpacity(0.35)
                  : Colors.black.withOpacity(0.10),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_kRadius),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  item['image']?['large'] ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: controller.isDarkMode
                        ? Colors.white.withOpacity(0.06)
                        : Colors.black.withOpacity(0.04),
                    child: Icon(
                      Icons.article_outlined,
                      size: isLarge ? 44 : 30,
                      color: _kPrimary.withOpacity(0.7),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.55),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isLarge)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Trending',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    if (isLarge) const SizedBox(height: 8),
                    Text(
                      item['title'] ?? '',
                      maxLines: isLarge ? 3 : 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isLarge ? 16 : 12.5,
                        height: 1.25,
                        fontWeight: FontWeight.w700,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            offset: const Offset(0, 1),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLatestCard(Map<String, dynamic> item) {
    return GetBuilder<NewsController>(
      builder: (controller) => GestureDetector(
        onTap: () => Get.to(() => DetailScreen(newsDetail: item)),
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: controller.cardColor,
            borderRadius: BorderRadius.circular(_kRadius),
            border: Border.all(
              color: controller.isDarkMode
                  ? Colors.white.withOpacity(0.08)
                  : Colors.black.withOpacity(0.06),
            ),
            boxShadow: [
              BoxShadow(
                color: controller.isDarkMode
                    ? Colors.black.withOpacity(0.25)
                    : Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 84,
                  height: 84,
                  child: Image.network(
                    item['image']?['large'] ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: controller.isDarkMode
                          ? Colors.white.withOpacity(0.06)
                          : Colors.black.withOpacity(0.04),
                      child: Icon(
                        Icons.article_outlined,
                        size: 28,
                        color: _kPrimary.withOpacity(0.7),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'] ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        color: controller.textColor,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: _kPrimary.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Latest',
                            style: TextStyle(
                              color: _kPrimary,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Obx(
                          () => GestureDetector(
                            onTap: () {
                              if (controller.bookmark.contains(item)) {
                                controller.removeBookmark(item);
                              } else {
                                controller.addBookmark(item);
                              }
                            },
                            child: Icon(
                              controller.bookmark.contains(item)
                                  ? Icons.bookmark
                                  : Icons.bookmark_outline,
                              size: 20,
                              color: controller.bookmark.contains(item)
                                  ? _kPrimary
                                  : (controller.isDarkMode
                                        ? Colors.grey.shade400
                                        : Colors.grey.shade500),
                            ),
                          ),
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
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewsController>(
      builder: (controller) => Scaffold(
        backgroundColor: controller.backgroundColor,
        body: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSearchBar(),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            categoryChip('All', ''),
                            categoryChip('Business', 'ekonomi'),
                            categoryChip('Tech', 'teknologi'),
                            categoryChip('National', 'nasional'),
                            categoryChip('International', 'internasional'),
                            categoryChip('Sports', 'olahraga'),
                            categoryChip('Entertainment', 'hiburan'),
                          ],
                        ),
                      ),
                    ),
                    _buildSectionHeader('Trending'),
                    _buildTrendingGrid(),
                    _buildSectionHeader('Latest'),
                    Obx(() {
                      if (controller.isLoading.value) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: List.generate(
                              3,
                              (index) => Container(
                                margin: const EdgeInsets.only(bottom: 14),
                                height: 96,
                                decoration: BoxDecoration(
                                  color: controller.isDarkMode
                                      ? Colors.white.withOpacity(0.06)
                                      : Colors.black.withOpacity(0.04),
                                  borderRadius: BorderRadius.circular(_kRadius),
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      if (controller.filteredNews.isEmpty) {
                        return Container(
                          margin: const EdgeInsets.all(20),
                          padding: const EdgeInsets.all(36),
                          decoration: BoxDecoration(
                            color: controller.cardColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: controller.isDarkMode
                                  ? Colors.white.withOpacity(0.08)
                                  : Colors.black.withOpacity(0.06),
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 44,
                                color: controller.isDarkMode
                                    ? Colors.grey.shade500
                                    : Colors.grey.shade500,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No results found',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: controller.textColor,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Try different keywords or categories.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: controller.subtitleColor,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: controller.filteredNews
                              .skip(3)
                              .take(5)
                              .map((item) => _buildLatestCard(item))
                              .toList(),
                        ),
                      );
                    }),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          height: 76,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: controller.cardColor,
            boxShadow: [
              BoxShadow(
                color: controller.isDarkMode
                    ? Colors.black.withOpacity(0.28)
                    : Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBottomNavItem(Icons.home_rounded, true),
              _buildBottomNavItem(
                Icons.bookmark_outline,
                false,
                onTap: () => Get.to(() => BookmarkScreen()),
              ),
              _buildBottomNavItem(Icons.notifications_none_rounded, false),
              _buildBottomNavItem(Icons.person_outline_rounded, false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(
    IconData icon,
    bool isActive, {
    VoidCallback? onTap,
  }) {
    return GetBuilder<NewsController>(
      builder: (controller) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isActive
                ? _kPrimary.withOpacity(0.10)
                : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive
                  ? _kPrimary.withOpacity(0.25)
                  : Colors.transparent,
            ),
          ),
          child: Icon(
            icon,
            color: isActive
                ? _kPrimary
                : (controller.isDarkMode
                      ? Colors.grey.shade400
                      : Colors.grey.shade500),
            size: 22,
          ),
        ),
      ),
    );
  }
}
