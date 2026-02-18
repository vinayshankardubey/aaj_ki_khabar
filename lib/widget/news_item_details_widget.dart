import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nb_utils/nb_utils.dart';
import '../main.dart';
import '../components/HtmlWidget.dart';
import '../utils/Common.dart';
import '../utils/Constants.dart';
import '../utils/app_colors.dart';
import '../utils/app_images.dart';
import '../utils/html_coversion.dart';

class NewsItemDetailsWidget extends StatefulWidget {
  final int index;
  final List<dynamic> postData;

  const NewsItemDetailsWidget({
    Key? key,
    required this.index,
    required this.postData,
  }) : super(key: key);

  @override
  State<NewsItemDetailsWidget> createState() => _NewsItemDetailsWidgetState();
}

class _NewsItemDetailsWidgetState extends State<NewsItemDetailsWidget> {
  late PageController pageController;
  late int currentIndex;
  double _currentPage = 0.0;
  FlutterTts flutterTts = FlutterTts();
  bool isSpeaking = false;
  ScrollController _scrollController = ScrollController();
  int _currentWordStart = 0;
  int _currentWordEnd = 0;
  String _currentSpeechText = "";
  final GlobalKey _readingContainerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
    pageController = PageController(initialPage: widget.index);
    _currentPage = widget.index.toDouble();

    pageController.addListener(() {
      setState(() {
        _currentPage = pageController.page!;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
        _currentWordStart = 0;
        _currentWordEnd = 0;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        isSpeaking = false;
        _currentWordStart = 0;
        _currentWordEnd = 0;
      });
    });

    flutterTts.setProgressHandler((String text, int start, int end, String word) {
      setState(() {
        _currentWordStart = start;
        _currentWordEnd = end;
        _currentSpeechText = text;
      });
      
      // Enhanced Auto-scroll logic
      if (_scrollController.hasClients && _readingContainerKey.currentContext != null) {
        try {
          // 1. Get the vertical offset of the reading container relative to the scroll content
          final RenderBox renderBox = _readingContainerKey.currentContext!.findRenderObject() as RenderBox;
          final ScrollableState? scrollable = Scrollable.of(_readingContainerKey.currentContext!);
          final double containerOffset = renderBox.localToGlobal(Offset.zero, ancestor: scrollable?.context.findRenderObject()).dy + _scrollController.offset;

          // 2. Calculate the vertical offset of the word within the text
          final double screenWidth = MediaQuery.of(context).size.width;
          final double textPadding = 40; // container padding (20*2)
          final double availableWidth = screenWidth - 40 - textPadding; // 40 is the outer padding (20*2)
          
          final textStyle = TextStyle(
            fontSize: getIntAsync(FONT_SIZE_PREF, defaultValue: 18).toDouble(),
            height: 1.6,
            fontFamily: GoogleFonts.mukta().fontFamily,
          );

          final textPainter = TextPainter(
            text: TextSpan(text: text.substring(0, start), style: textStyle),
            textDirection: ui.TextDirection.ltr,
          );
          
          textPainter.layout(maxWidth: availableWidth);
          final double wordYOffset = textPainter.size.height;

          // 3. Final target: Container Top + Word Y - 50 Padding
          double scrollTarget = (containerOffset + wordYOffset - 50).clamp(0, _scrollController.position.maxScrollExtent);
          
          if ((scrollTarget - _scrollController.offset).abs() > 5) {
            _scrollController.animateTo(
              scrollTarget,
              duration: const Duration(milliseconds: 800),
              curve: Curves.fastOutSlowIn,
            );
          }
        } catch (e) {
          // Fallback to simple ratio if geometry calculation fails
          double multiplier = start / text.length;
          double scrollTarget = _scrollController.position.maxScrollExtent * multiplier;
          _scrollController.animateTo(scrollTarget, duration: const Duration(milliseconds: 700), curve: Curves.easeOut);
        }
      }
    });
  }

  bool _isHindi(String text) {
    // Regular expression for Devanagari script (Hindi)
    return RegExp(r'[\u0900-\u097F]').hasMatch(text);
  }

  Future<void> _startSpeak(int index) async {
    final post = widget.postData[index];
    String title = HtmlConversion.parseHtmlString(post["title"]["rendered"]);
    String content = HtmlConversion.extractReadableText(post["content"]["rendered"]);
    String textToRead = "$title. $content";

    // Auto-detect language
    String languageCode = _isHindi(textToRead) ? "hi-IN" : "en-US";

    setState(() {
      _currentSpeechText = textToRead;
      _currentWordStart = 0;
      _currentWordEnd = 0;
    });

    await flutterTts.setLanguage(languageCode);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(textToRead);
    setState(() => isSpeaking = true);
  }

  Future<void> _stopSpeak() async {
    await flutterTts.stop();
    setState(() {
      isSpeaking = false;
      _currentWordStart = 0;
      _currentWordEnd = 0;
    });
  }

  Future<void> _toggleSpeak(int index) async {
    if (isSpeaking) {
      await _stopSpeak();
    } else {
      await _startSpeak(index);
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          AppImages.appLogo,
          fit: BoxFit.fitHeight,
          width: 80,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: () {
              final post = widget.postData[currentIndex];
              Share.share(post['link'] ?? post['title']['rendered']);
            },
            icon: const Icon(Icons.share, color: Colors.white),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.35),
              blurRadius: 18,
              spreadRadius: 2,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => _toggleSpeak(currentIndex),
          backgroundColor: Colors.transparent,
          elevation: 0,
          focusElevation: 0,
          hoverElevation: 0,
          highlightElevation: 0,
          shape: const CircleBorder(),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: CustomPaint(
              key: ValueKey(isSpeaking),
              size: const Size(60, 60),
              painter: _BotFacePainter(
                color: AppColors.primaryColor,
                isSpeaking: isSpeaking,
              ),
            ),
          ),
        ),
      ),
      body: PageView.builder(
        itemCount: widget.postData.length,
        controller: pageController,
        physics: const BouncingScrollPhysics(),
        onPageChanged: (index) async {
          if (isSpeaking) {
            await flutterTts.stop();
            setState(() {
              currentIndex = index;
            });
            _startSpeak(index);
          } else {
            setState(() {
              currentIndex = index;
            });
          }
        },
        itemBuilder: (context, index) {
          final post = widget.postData[index];
          
          // Animation calculations
          double value = (index - _currentPage).abs();
          double opacity = (1 - value).clamp(0.0, 1.0);
          double scale = (1 - (value * 0.1)).clamp(0.8, 1.0);

          return Opacity(
            opacity: opacity,
            child: Transform.scale(
              scale: scale,
              child: _buildNewsContent(post),
            ),
          );
        },
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildNewsContent(dynamic post) {
    String imageUrl = "";
    try {
      imageUrl = post["_embedded"]["wp:featuredmedia"][0]["source_url"] ?? "";
    } catch (e) {}

    return SingleChildScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Tag
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              "${post["_embedded"]["wp:term"]?[0]?[0]?["name"] ?? "News"}".toUpperCase(),
              style: TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 15),
          // Title
          Text(
            HtmlConversion.parseHtmlString(post["title"]["rendered"]),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              height: 1.25,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 15),
          // Author & Date
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: Colors.grey.shade200,
                child: const Icon(Icons.person, size: 14, color: Colors.grey),
              ),
              const SizedBox(width: 8),
              Text(
                "By ${post["_embedded"]?['author']?[0]?["name"] ?? "Admin"}",
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(width: 15),
              const Icon(Icons.calendar_today_outlined, size: 12, color: Colors.grey),
              const SizedBox(width: 5),
              Text(
                DateFormat('dd MMM yyyy').format(DateTime.parse(post['date'])),
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 25),
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Hero(
              tag: "news_image_${post['id']}",
              child: imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(color: Colors.white, height: 250),
                      ),
                      errorWidget: (context, url, error) => Image.asset(AppImages.appLogo),
                    )
                  : Image.asset(AppImages.appLogo, height: 250, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 25),
          // Content Label

            isSpeaking
              ? Container(
                  key: _readingContainerKey,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primaryColor.withOpacity(0.1)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset(AppImages.aiNewsBot, width: 24, height: 24),
                          const SizedBox(width: 8),
                          Text(
                            "Reading Mode Active",
                            style: boldTextStyle(color: AppColors.primaryColor, size: 12),
                          ),
                        ],
                      ).paddingBottom(16),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: getIntAsync(FONT_SIZE_PREF, defaultValue: 18).toDouble(),
                            color: context.iconColor,
                            height: 1.6,
                            fontFamily: GoogleFonts.mukta().fontFamily,
                          ),
                          children: [
                            TextSpan(text: _currentSpeechText.substring(0, _currentWordStart)),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(4),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primaryColor.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    )
                                  ],
                                ),
                                child: Text(
                                  _currentSpeechText.substring(_currentWordStart, _currentWordEnd),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            TextSpan(text: _currentSpeechText.substring(_currentWordEnd)),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : HtmlWidget(postContent: post["content"]["rendered"]),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _navButton(
              label: "Previous",
              icon: Icons.arrow_back_ios_new,
              isEnabled: currentIndex > 0,
              onTap: () {
                pageController.previousPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOutCubic,
                );
              },
            ),
            // Page Indicator
            Text(
              "${currentIndex + 1} / ${widget.postData.length}",
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            _navButton(
              label: "Next",
              icon: Icons.arrow_forward_ios,
              isEnabled: currentIndex < widget.postData.length - 1,
              isRight: true,
              onTap: () {
                pageController.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOutCubic,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _navButton({
    required String label,
    required IconData icon,
    required bool isEnabled,
    required VoidCallback onTap,
    bool isRight = false,
  }) {
    return InkWell(
      onTap: isEnabled ? onTap : null,
      child: Opacity(
        opacity: isEnabled ? 1.0 : 0.3,
        child: Row(
          children: [
            if (!isRight) Icon(icon, size: 16),
            if (!isRight) const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            if (isRight) const SizedBox(width: 8),
            if (isRight) Icon(icon, size: 16),
          ],
        ),
      ),
    );
  }
}

class _BotFacePainter extends CustomPainter {
  final Color color;
  final bool isSpeaking;

  _BotFacePainter({required this.color, required this.isSpeaking});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.46;

    // ── Outer glow ring ──
    if (isSpeaking) {
      final glowPaint = Paint()
        ..color = color.withOpacity(0.18)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(cx, cy), r + 5, glowPaint);
    }

    // ── Main circle background ──
    final bgPaint = Paint()
      ..shader = RadialGradient(
        colors: [color.withOpacity(0.95), color],
        center: Alignment(-0.3, -0.4),
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r));
    canvas.drawCircle(Offset(cx, cy), r, bgPaint);

    // ── Inner face plate (lighter circle) ──
    final platePaint = Paint()..color = Colors.white.withOpacity(0.12)..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, cy + r * 0.08), r * 0.72, platePaint);

    final white = Paint()..color = Colors.white..style = PaintingStyle.fill;
    final whiteStroke = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    // ── Visor eyes (horizontal pill shapes) ──
    final eyeRect1 = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx - r * 0.28, cy - r * 0.12), width: r * 0.36, height: r * 0.18),
      Radius.circular(r * 0.09),
    );
    final eyeRect2 = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx + r * 0.28, cy - r * 0.12), width: r * 0.36, height: r * 0.18),
      Radius.circular(r * 0.09),
    );
    canvas.drawRRect(eyeRect1, white);
    canvas.drawRRect(eyeRect2, white);

    // Eye glow dots
    final eyeGlow = Paint()..color = color.withOpacity(0.5)..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx - r * 0.28, cy - r * 0.12), r * 0.06, eyeGlow);
    canvas.drawCircle(Offset(cx + r * 0.28, cy - r * 0.12), r * 0.06, eyeGlow);

    if (isSpeaking) {
      // ── SPEAKING: Sound wave bars ──
      final barPaint = Paint()..color = Colors.white..style = PaintingStyle.fill;
      final barRR = Radius.circular(3);
      final barHeights = [r * 0.18, r * 0.32, r * 0.44, r * 0.32, r * 0.18];
      final barWidth = r * 0.1;
      final totalWidth = barWidth * 5 + r * 0.06 * 4;
      double startX = cx - totalWidth / 2;

      for (int i = 0; i < 5; i++) {
        final bh = barHeights[i];
        final bx = startX + i * (barWidth + r * 0.06);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset(bx + barWidth / 2, cy + r * 0.38), width: barWidth, height: bh),
            barRR,
          ),
          barPaint,
        );
      }
    } else {
      // ── IDLE: Gentle smile ──
      final smilePath = Path()
        ..moveTo(cx - r * 0.25, cy + r * 0.35)
        ..quadraticBezierTo(cx, cy + r * 0.52, cx + r * 0.25, cy + r * 0.35);
      canvas.drawPath(smilePath, whiteStroke..strokeWidth = 2.5);

      // Small dot nose
      canvas.drawCircle(Offset(cx, cy + r * 0.18), r * 0.045, white..color = Colors.white.withOpacity(0.7));
    }

    // ── Top antenna ──
    canvas.drawLine(
      Offset(cx, cy - r),
      Offset(cx, cy - r * 1.28),
      whiteStroke..strokeWidth = 2.0..color = Colors.white.withOpacity(0.8),
    );
    canvas.drawCircle(Offset(cx, cy - r * 1.33), r * 0.07, white..color = Colors.white);
  }

  @override
  bool shouldRepaint(_BotFacePainter oldDelegate) =>
      oldDelegate.isSpeaking != isSpeaking || oldDelegate.color != color;
}
