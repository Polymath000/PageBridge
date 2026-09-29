import 'package:flutter/material.dart';
import 'package:pagebridge/config/routes/on_generate_routes.dart';
import 'package:pagebridge/core/constants/constants.dart';
import 'package:pagebridge/core/services/shared_preferences_singleton.dart';
import 'package:pagebridge/feature/auth/presentation/widgets/custom_animation_background.dart';
import 'package:pagebridge/feature/on_started_views/presentation/widgets/onboarding_footer.dart';
import 'package:pagebridge/feature/on_started_views/presentation/widgets/onboarding_header.dart';
import 'package:pagebridge/feature/on_started_views/presentation/widgets/onboarding_page.dart';
import 'package:pagebridge/feature/on_started_views/presentation/widgets/privacy_visual.dart';
import 'package:pagebridge/feature/on_started_views/presentation/widgets/welcome_visual.dart';
import 'package:pagebridge/feature/on_started_views/presentation/widgets/workflow_visual.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  final ValueNotifier<int> _pageIndex = ValueNotifier<int>(0);

  final List<OnboardingPageData> _pages = const [
    OnboardingPageData(
      title: 'Bridge the Gap to Notion',
      description:
          'Capture ideas instantly to your Notion databases without opening the full app.',
      primaryActionLabel: 'Next',
      visualBuilder: WelcomeVisual.new,
    ),
    OnboardingPageData(
      title: 'Your Data, Your Notion',
      description:
          'Your data stays yours. Sign in securely via OAuth directly to your Notion workspace.',
      primaryActionLabel: 'Next',
      visualBuilder: PrivacyVisual.new,
    ),
    OnboardingPageData(
      title: 'Frictionless Capture',
      description:
          'Choose a database, fill properties, and save. We handle text, dates, and relations seamlessly.',
      primaryActionLabel: 'Connect to Notion',
      visualBuilder: WorkflowVisual.new,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _pageIndex.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding(BuildContext context) async {
    await SharedPreferencesSingleton.setBool(
      AppConstants.onboardingSeenKey,
      value: true,
    );
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.auth, (_) => false);
  }

  void _handlePrimaryAction(BuildContext context) {
    final currentIndex = _pageIndex.value;
    if (currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
      return;
    }
    _completeOnboarding(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const CustomAnimationBackground(),
          SafeArea(
            child: Column(
              children: [
                OnboardingHeader(
                  pageIndex: _pageIndex,
                  onSkip: () => _completeOnboarding(context),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pages.length,
                    onPageChanged: (index) => _pageIndex.value = index,
                    itemBuilder: (context, index) {
                      final page = _pages[index];
                      return AnimatedBuilder(
                        animation: _pageController,
                        builder: (context, child) {
                          double pageOffset = 0.0;
                          if (_pageController.position.haveDimensions) {
                            pageOffset = _pageController.page! - index;
                          } else {
                            pageOffset = _pageIndex.value.toDouble() - index;
                          }

                          // Calculate opacity and scale based on how far the page is from the center
                          final opacity = (1 - pageOffset.abs()).clamp(
                            0.0,
                            1.0,
                          );
                          final scale = 0.85 + (0.15 * opacity);
                          // Slight vertical parallax effect
                          final translateY = pageOffset.abs() * 50.0;

                          return Opacity(
                            opacity: opacity,
                            child: Transform(
                              transform: Matrix4.identity()
                                ..translate(0.0, translateY)
                                ..scale(scale, scale),
                              alignment: Alignment.center,
                              child: child,
                            ),
                          );
                        },
                        child: OnboardingPage(
                          title: page.title,
                          description: page.description,
                          visualBuilder: page.visualBuilder,
                        ),
                      );
                    },
                  ),
                ),
                OnboardingFooter(
                  pageIndex: _pageIndex,
                  pagesCount: _pages.length,
                  onPrimaryAction: () => _handlePrimaryAction(context),
                  primaryLabelBuilder: () =>
                      _pages[_pageIndex.value].primaryActionLabel,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPageData {
  final String title;
  final String description;
  final String primaryActionLabel;
  final Widget Function() visualBuilder;

  const OnboardingPageData({
    required this.title,
    required this.description,
    required this.primaryActionLabel,
    required this.visualBuilder,
  });
}
