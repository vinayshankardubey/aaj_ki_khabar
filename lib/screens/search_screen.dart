import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../network/api/api_servies.dart';
import '../utils/app_colors.dart';
import '../utils/html_coversion.dart';
import '../widget/news_item_details_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  List<dynamic> _results = [];
  bool _isLoading = false;
  bool _hasSearched = false;
  String _lastQuery = '';
  Timer? _debounce;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);

    // Auto-focus the search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    _animController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      setState(() {
        _results = [];
        _hasSearched = false;
        _isLoading = false;
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 600), () {
      _performSearch(query.trim());
    });
  }

  Future<void> _performSearch(String query) async {
    if (query == _lastQuery && _hasSearched) return;
    _lastQuery = query;

    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    final results = await ApiServices.searchPosts(query: query);

    if (mounted) {
      setState(() {
        _results = results;
        _isLoading = false;
      });
      _animController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: TextField(
        controller: _searchController,
        focusNode: _focusNode,
        onChanged: _onSearchChanged,
        onSubmitted: (q) {
          if (q.trim().isNotEmpty) _performSearch(q.trim());
        },
        style: TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontFamily: GoogleFonts.mukta().fontFamily,
        ),
        cursorColor: Colors.white70,
        decoration: InputDecoration(
          hintText: 'खबर खोजें... Search news...',
          hintStyle: TextStyle(
            color: Colors.white54,
            fontSize: 15,
            fontFamily: GoogleFonts.mukta().fontFamily,
          ),
          border: InputBorder.none,
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70, size: 20),
                  onPressed: () {
                    _searchController.clear();
                    _onSearchChanged('');
                    _focusNode.requestFocus();
                  },
                )
              : const Icon(Icons.search, color: Colors.white54, size: 22),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return _buildShimmer();
    if (!_hasSearched) return _buildIdleState();
    if (_results.isEmpty) return _buildEmptyState();
    return _buildResults();
  }

  Widget _buildIdleState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_rounded,
              size: 48,
              color: AppColors.primaryColor.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'खबर खोजें',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.mukta().fontFamily,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Type to search latest news',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontFamily: GoogleFonts.mukta().fontFamily,
            ),
          ),
          const SizedBox(height: 30),
          // Trending tags hint
          Wrap(
            spacing: 10,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: ['राजनीति', 'खेल', 'मनोरंजन', 'Business', 'Crime', 'UP']
                .map((tag) => GestureDetector(
                      onTap: () {
                        _searchController.text = tag;
                        _performSearch(tag);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppColors.primaryColor.withOpacity(0.2)),
                        ),
                        child: Text(
                          '# $tag',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            fontFamily: GoogleFonts.mukta().fontFamily,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.newspaper_outlined,
              size: 72, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
              fontFamily: GoogleFonts.mukta().fontFamily,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try different keywords',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontFamily: GoogleFonts.mukta().fontFamily,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.grey.shade100,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          height: 110,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  Widget _buildResults() {
    return FadeTransition(
      opacity: _fadeAnim,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              '${_results.length} results for "${_searchController.text}"',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
                fontFamily: GoogleFonts.mukta().fontFamily,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              itemCount: _results.length,
              itemBuilder: (context, index) {
                return _SearchResultCard(
                  post: _results[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NewsItemDetailsWidget(
                          postData: _results,
                          index: index,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final dynamic post;
  final VoidCallback onTap;

  const _SearchResultCard({required this.post, required this.onTap});

  @override
  Widget build(BuildContext context) {
    String imageUrl = '';
    try {
      imageUrl =
          post['_embedded']['wp:featuredmedia'][0]['source_url'] ?? '';
    } catch (_) {}

    final title =
        HtmlConversion.parseHtmlString(post['title']['rendered'] ?? '');
    final category =
        post['_embedded']?['wp:term']?[0]?[0]?['name'] ?? 'News';
    String dateStr = '';
    try {
      dateStr = DateFormat('dd MMM yyyy')
          .format(DateTime.parse(post['date']));
    } catch (_) {}

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                bottomLeft: Radius.circular(14),
              ),
              child: imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      width: 110,
                      height: 110,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Shimmer.fromColors(
                        baseColor: Colors.grey.shade200,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                            width: 110, height: 110, color: Colors.white),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        width: 110,
                        height: 110,
                        color: AppColors.primaryColor.withOpacity(0.1),
                        child: Icon(Icons.newspaper,
                            color: AppColors.primaryColor.withOpacity(0.4),
                            size: 32),
                      ),
                    )
                  : Container(
                      width: 110,
                      height: 110,
                      color: AppColors.primaryColor.withOpacity(0.1),
                      child: Icon(Icons.newspaper,
                          color: AppColors.primaryColor.withOpacity(0.4),
                          size: 32),
                    ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        category.toUpperCase(),
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                          fontFamily: GoogleFonts.mukta().fontFamily,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Title
                    Text(
                      title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                        fontFamily: GoogleFonts.mukta().fontFamily,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Date
                    if (dateStr.isNotEmpty)
                      Row(
                        children: [
                          Icon(Icons.access_time_rounded,
                              size: 11, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            dateStr,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                              fontFamily: GoogleFonts.mukta().fontFamily,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
