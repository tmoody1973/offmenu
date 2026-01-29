import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';

/// Landing page for unauthenticated users.
///
/// Shows a beautiful, responsive marketing page that introduces
/// the app and encourages users to sign in.
class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  // High-quality food/restaurant images from Unsplash
  static const _heroImage = 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=1200&q=80';
  static const _featureImages = [
    'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=600&q=80', // Fine dining
    'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=600&q=80', // Beautiful dish
    'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=600&q=80', // Restaurant interior
    'https://images.unsplash.com/photo-1476224203421-9ac39bcb3327?w=600&q=80', // Food spread
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isWide = size.width >= 800;
    final isMobile = size.width < 600;

    return Scaffold(
      backgroundColor: AppTheme.charcoal,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            _HeroSection(isWide: isWide, isMobile: isMobile),

            // Features Section
            _FeaturesSection(isWide: isWide, isMobile: isMobile),

            // Photo Gallery
            _PhotoGallery(isWide: isWide),

            // Call to Action
            _CTASection(isMobile: isMobile),

            // Footer
            _Footer(),
          ],
        ),
      ),
    );
  }
}

/// Hero section with background image and main CTA.
class _HeroSection extends StatelessWidget {
  final bool isWide;
  final bool isMobile;

  const _HeroSection({required this.isWide, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isMobile ? 500 : 600,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const NetworkImage(
            'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=1400&q=80',
          ),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withAlpha(150),
            BlendMode.darken,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Top bar with logo
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : 40,
                vertical: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo
                  Row(
                    children: [
                      Icon(
                        Icons.restaurant_menu,
                        color: AppTheme.burntOrange,
                        size: isMobile ? 28 : 32,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Off Menu',
                        style: AppTheme.headlineSerif.copyWith(
                          fontSize: isMobile ? 24 : 28,
                          color: AppTheme.cream,
                        ),
                      ),
                    ],
                  ),
                  // Sign in button (top)
                  TextButton(
                    onPressed: () => context.go('/sign-in'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.cream,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      'Sign In',
                      style: AppTheme.labelSans.copyWith(
                        color: AppTheme.cream,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Hero content
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Tagline
                    Text(
                      'Every Meal Has a Story.',
                      style: AppTheme.headlineSerif.copyWith(
                        fontSize: isMobile ? 36 : 56,
                        color: AppTheme.cream,
                        height: 1.1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Find Yours.',
                      style: AppTheme.headlineSerif.copyWith(
                        fontSize: isMobile ? 36 : 56,
                        color: AppTheme.burntOrange,
                        height: 1.1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    // Subtitle
                    Container(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Text(
                        'An AI-powered culinary concierge that transforms restaurant discovery into immersive, narrative-driven journeys.',
                        style: AppTheme.bodySerif.copyWith(
                          fontSize: isMobile ? 16 : 20,
                          color: AppTheme.cream.withAlpha(220),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // CTA Button
                    _SignInButton(isMobile: isMobile),
                  ],
                ),
              ),
            ),

            // Scroll indicator
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Icon(
                Icons.keyboard_arrow_down,
                color: AppTheme.cream.withAlpha(150),
                size: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Sign in button with Google branding.
class _SignInButton extends StatelessWidget {
  final bool isMobile;

  const _SignInButton({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => context.go('/sign-in'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.cream,
        foregroundColor: AppTheme.charcoal,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 32 : 48,
          vertical: isMobile ? 16 : 20,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 4,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.network(
            'https://www.google.com/favicon.ico',
            width: 20,
            height: 20,
            errorBuilder: (_, __, ___) => const Icon(Icons.login, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            'Continue with Google',
            style: AppTheme.labelSans.copyWith(
              fontSize: isMobile ? 16 : 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.charcoal,
            ),
          ),
        ],
      ),
    );
  }
}

/// Features section showing app capabilities.
class _FeaturesSection extends StatelessWidget {
  final bool isWide;
  final bool isMobile;

  const _FeaturesSection({required this.isWide, required this.isMobile});

  static const _features = [
    _Feature(
      icon: Icons.auto_awesome,
      title: 'Ask the Butler',
      description: 'Your AI concierge for natural language food discovery. Ask anything from "hidden gems near me" to "best late-night tacos."',
      image: 'https://images.unsplash.com/photo-1559339352-11d035aa65de?w=500&q=80',
    ),
    _Feature(
      icon: Icons.map_outlined,
      title: 'Curated Maps',
      description: 'Eater-style restaurant guides generated by AI. Best Tacos, Hidden Gems, Date Night spots - personalized for your city.',
      image: 'https://images.unsplash.com/photo-1466978913421-dad2ebd01d17?w=500&q=80',
    ),
    _Feature(
      icon: Icons.nights_stay_outlined,
      title: 'Three for Tonight',
      description: 'Weather-aware, time-of-day contextual dinner recommendations. Perfect picks for right now.',
      image: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=500&q=80',
    ),
    _Feature(
      icon: Icons.auto_stories_outlined,
      title: 'Daily Story',
      description: 'AI-generated restaurant narratives in editorial style. Discover the stories behind the food.',
      image: 'https://images.unsplash.com/photo-1515003197210-e0cd71810b5f?w=500&q=80',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.charcoalLight,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 60,
        vertical: isMobile ? 60 : 100,
      ),
      child: Column(
        children: [
          // Section header
          Text(
            'DISCOVER',
            style: AppTheme.labelCaps.copyWith(
              color: AppTheme.burntOrange,
              fontSize: 12,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'More Than Just Restaurants',
            style: AppTheme.headlineSerif.copyWith(
              fontSize: isMobile ? 28 : 40,
              color: AppTheme.cream,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Text(
              'We surface not just what to eat, but why it matters.',
              style: AppTheme.bodySerif.copyWith(
                fontSize: isMobile ? 16 : 18,
                color: AppTheme.creamMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: isMobile ? 40 : 60),

          // Features grid
          isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _features
                      .map((f) => Expanded(child: _FeatureCard(feature: f, isMobile: isMobile)))
                      .toList(),
                )
              : Column(
                  children: _features
                      .map((f) => Padding(
                            padding: const EdgeInsets.only(bottom: 32),
                            child: _FeatureCard(feature: f, isMobile: isMobile),
                          ))
                      .toList(),
                ),
        ],
      ),
    );
  }
}

class _Feature {
  final IconData icon;
  final String title;
  final String description;
  final String image;

  const _Feature({
    required this.icon,
    required this.title,
    required this.description,
    required this.image,
  });
}

class _FeatureCard extends StatelessWidget {
  final _Feature feature;
  final bool isMobile;

  const _FeatureCard({required this.feature, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 0 : 16),
      child: Column(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              feature.image,
              height: isMobile ? 200 : 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: isMobile ? 200 : 180,
                color: AppTheme.charcoal,
                child: Icon(feature.icon, color: AppTheme.creamMuted, size: 48),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.burntOrange.withAlpha(30),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              feature.icon,
              color: AppTheme.burntOrange,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          // Title
          Text(
            feature.title,
            style: AppTheme.headlineSans.copyWith(
              fontSize: isMobile ? 20 : 18,
              color: AppTheme.cream,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          // Description
          Text(
            feature.description,
            style: AppTheme.bodySans.copyWith(
              fontSize: 14,
              color: AppTheme.creamMuted,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Photo gallery showcasing food imagery.
class _PhotoGallery extends StatelessWidget {
  final bool isWide;

  const _PhotoGallery({required this.isWide});

  static const _photos = [
    'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=600&q=80',
    'https://images.unsplash.com/photo-1476224203421-9ac39bcb3327?w=600&q=80',
    'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=600&q=80',
    'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=600&q=80',
    'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=600&q=80',
    'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=600&q=80',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.charcoal,
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          // Scrolling photo strip
          SizedBox(
            height: isWide ? 250 : 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _photos.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      _photos[index],
                      width: isWide ? 350 : 260,
                      height: isWide ? 250 : 180,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: isWide ? 350 : 260,
                        color: AppTheme.charcoalLight,
                        child: const Icon(Icons.restaurant, color: AppTheme.creamMuted),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Final call to action section.
class _CTASection extends StatelessWidget {
  final bool isMobile;

  const _CTASection({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 60,
        vertical: isMobile ? 60 : 80,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.charcoal,
            AppTheme.charcoal.withAlpha(240),
          ],
        ),
      ),
      child: Column(
        children: [
          Text(
            'Ready to Discover?',
            style: AppTheme.headlineSerif.copyWith(
              fontSize: isMobile ? 32 : 44,
              color: AppTheme.cream,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Text(
              'Join food lovers who\'ve found their next favorite spot with Off Menu.',
              style: AppTheme.bodySerif.copyWith(
                fontSize: isMobile ? 16 : 18,
                color: AppTheme.creamMuted,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          _SignInButton(isMobile: isMobile),
        ],
      ),
    );
  }
}

/// Footer with credits.
class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      color: AppTheme.charcoalLight,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.restaurant_menu,
                color: AppTheme.burntOrange,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Off Menu',
                style: AppTheme.headlineSerif.copyWith(
                  fontSize: 18,
                  color: AppTheme.cream,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'The love child of Anthony Bourdain\'s storytelling and Alton Brown\'s food science.',
            style: AppTheme.bodySans.copyWith(
              fontSize: 13,
              color: AppTheme.creamMuted,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            'Built for the Serverpod Hackathon 2025',
            style: AppTheme.labelSans.copyWith(
              fontSize: 12,
              color: AppTheme.creamMuted.withAlpha(150),
            ),
          ),
        ],
      ),
    );
  }
}
