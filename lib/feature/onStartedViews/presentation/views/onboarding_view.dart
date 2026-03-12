import 'package:flutter/material.dart';
import 'package:quicknotion/config/routes/on_generate_routes.dart';
import 'package:quicknotion/core/constants/constants.dart';
import 'package:quicknotion/core/services/shared_preferences_singleton.dart';
import 'package:quicknotion/core/helpers/custom_animation_background.dart';
import 'package:quicknotion/feature/onStartedViews/presentation/widgets/onboarding_footer.dart';
import 'package:quicknotion/feature/onStartedViews/presentation/widgets/onboarding_header.dart';
import 'package:quicknotion/feature/onStartedViews/presentation/widgets/onboarding_page.dart';
import 'package:quicknotion/feature/onStartedViews/presentation/widgets/privacy_visual.dart';
import 'package:quicknotion/feature/onStartedViews/presentation/widgets/welcome_visual.dart';
import 'package:quicknotion/feature/onStartedViews/presentation/widgets/workflow_visual.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});
  static const String routeName = 'onboarding_view';

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  final ValueNotifier<int> _pageIndex = ValueNotifier<int>(0);

  final List<OnboardingPageData> _pages = const [
    OnboardingPageData(
      title: 'Welcome to QuickNotion',
      description:
          'Capture ideas fast and sync them to your Notion workspace in '
          'seconds.',
      primaryActionLabel: 'Get started',
      visualBuilder: WelcomeVisual.new,
    ),
    OnboardingPageData(
      title: 'Private by design',
      description: 'Your activity is for your eyes only.',
      primaryActionLabel: 'Continue',
      visualBuilder: PrivacyVisual.new,
    ),
    OnboardingPageData(
      title: 'Pick a database. Create a page.',
      description:
          'Tap a database to open a quick form. Supports text, select, dates, '
          'and relations.',
      primaryActionLabel: 'Start creating',
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
    await SharedPreferencesSingleton.setBool(onboardingSeenKey, value: true);
    if (!context.mounted) return;
    AppRoutes.authView(context);
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
          const Positioned.fill(child: CustomAnimationBackground()),
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
                      return OnboardingPage(
                        title: page.title,
                        description: page.description,
                        visualBuilder: page.visualBuilder,
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
