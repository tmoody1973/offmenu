import 'package:flutter/material.dart';
import 'package:food_butler_client/food_butler_client.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';
import '../widgets/eater_style_widgets.dart';
import '../widgets/save_button.dart';

/// Full story detail screen - Editorial narrative view.
///
/// Displays the complete Daily Story with:
/// - Hero image
/// - Headline and subheadline
/// - Full body text (narrative)
/// - Restaurant info and CTA
class StoryDetailScreen extends StatelessWidget {
  final DailyStory story;

  const StoryDetailScreen({
    super.key,
    required this.story,
  });

  String get _storyTypeLabel {
    switch (story.storyType) {
      case DailyStoryType.hiddenGem:
        return 'HIDDEN GEM';
      case DailyStoryType.legacyStory:
        return 'LEGACY';
      case DailyStoryType.cuisineDeepDive:
        return 'DEEP DIVE';
      case DailyStoryType.chefSpotlight:
        return 'CHEF SPOTLIGHT';
      case DailyStoryType.neighborhoodGuide:
        return 'NEIGHBORHOOD';
      case DailyStoryType.seasonalFeature:
        return 'SEASONAL';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.charcoal,
      body: CustomScrollView(
        slivers: [
          // Collapsing hero image app bar
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            backgroundColor: AppTheme.charcoal,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.charcoal.withAlpha(180),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: AppTheme.cream),
              ),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Hero image
                  Image.network(
                    story.heroImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppTheme.charcoalLight,
                      child: const Center(
                        child: Icon(Icons.restaurant, size: 64, color: AppTheme.creamMuted),
                      ),
                    ),
                  ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppTheme.charcoal.withAlpha(100),
                          AppTheme.charcoal,
                        ],
                        stops: const [0.4, 0.7, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Story content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tags row
                  Row(
                    children: [
                      EaterTag(label: _storyTypeLabel, filled: true),
                      const SizedBox(width: 12),
                      if (story.cuisineType != null)
                        EaterTag(label: story.cuisineType!),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Location
                  Text(
                    '${story.city}${story.state != null ? ', ${story.state}' : ''}'.toUpperCase(),
                    style: AppTheme.labelCaps.copyWith(
                      fontSize: 12,
                      color: AppTheme.creamMuted,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Headline
                  Text(
                    story.headline,
                    style: AppTheme.headlineSans.copyWith(
                      fontSize: 32,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Subheadline
                  Text(
                    story.subheadline,
                    style: AppTheme.bodySerif.copyWith(
                      fontSize: 20,
                      color: AppTheme.creamMuted,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 24),
                  const EaterDivider(indent: 0, endIndent: 0),
                  const SizedBox(height: 24),

                  // Restaurant name card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: AppTheme.boxDecoration(accentBorder: true),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'THE RESTAURANT',
                                style: AppTheme.labelCaps.copyWith(
                                  fontSize: 10,
                                  color: AppTheme.burntOrange,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                story.restaurantName,
                                style: AppTheme.headlineSans.copyWith(
                                  fontSize: 20,
                                ),
                              ),
                              if (story.restaurantAddress != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  story.restaurantAddress!,
                                  style: AppTheme.bodySans.copyWith(
                                    fontSize: 14,
                                    color: AppTheme.creamMuted,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        // Save button
                        SaveButton(
                          name: story.restaurantName,
                          placeId: story.restaurantPlaceId,
                          address: story.restaurantAddress,
                          cuisineType: story.cuisineType,
                          imageUrl: story.heroImageUrl,
                          source: SavedRestaurantSource.story,
                          size: 28,
                        ),
                        if (story.restaurantPlaceId != null)
                          IconButton(
                            icon: const Icon(Icons.directions, color: AppTheme.burntOrange),
                            onPressed: () {
                              // Could open maps/directions
                            },
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Body text (the actual story narrative)
                  if (story.bodyText != null && story.bodyText!.isNotEmpty) ...[
                    // Split body text into paragraphs
                    ..._buildBodyParagraphs(story.bodyText!),
                  ] else ...[
                    // If no body text, show a placeholder or generate content
                    _buildGeneratedStoryContent(),
                  ],

                  const SizedBox(height: 32),

                  // Source attribution if available
                  if (story.sourceUrl != null) ...[
                    const EaterDivider(indent: 0, endIndent: 0),
                    const SizedBox(height: 16),
                    Text(
                      'SOURCE',
                      style: AppTheme.labelCaps.copyWith(
                        fontSize: 10,
                        color: AppTheme.creamMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      story.sourceUrl!,
                      style: AppTheme.bodySans.copyWith(
                        fontSize: 12,
                        color: AppTheme.burntOrange,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],

                  const SizedBox(height: 32),

                  // CTA Button
                  SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: () {
                        context.go('/ask', extra: {
                          'prompt': 'Tell me more about ${story.restaurantName} - what should I order?',
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: AppTheme.burntOrange,
                        ),
                        child: Center(
                          child: Text(
                            'ASK THE BUTLER ABOUT THIS PLACE',
                            style: AppTheme.labelCaps.copyWith(
                              fontSize: 14,
                              color: AppTheme.cream,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build body paragraphs from the story text
  List<Widget> _buildBodyParagraphs(String bodyText) {
    final paragraphs = bodyText.split('\n\n');
    return paragraphs.map((paragraph) {
      if (paragraph.trim().isEmpty) return const SizedBox.shrink();

      // Check if it's a quote (starts with ")
      if (paragraph.trim().startsWith('"') && paragraph.contains('"')) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: EaterQuote(quote: paragraph.replaceAll('"', '').trim()),
        );
      }

      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Text(
          paragraph.trim(),
          style: AppTheme.bodySerif.copyWith(
            fontSize: 18,
            height: 1.7,
            color: AppTheme.cream,
          ),
        ),
      );
    }).toList();
  }

  /// Build placeholder content when no body text is available
  Widget _buildGeneratedStoryContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'This story is still being written. In the meantime, ask the Butler to tell you more about ${story.restaurantName}.',
          style: AppTheme.bodySerif.copyWith(
            fontSize: 18,
            height: 1.7,
            color: AppTheme.creamMuted,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
