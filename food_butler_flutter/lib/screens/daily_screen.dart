import 'package:flutter/material.dart';
import 'package:food_butler_client/food_butler_client.dart';
import 'package:go_router/go_router.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart'
    hide UserProfile;

import '../main.dart';
import '../theme/app_theme.dart';
import '../widgets/eater_style_widgets.dart';
import '../widgets/save_button.dart';

/// "The Daily" - Editorial home screen.
///
/// Not a search bar. It's a curated editorial spread — like opening
/// a food magazine, not a database.
///
/// Layout:
/// 1. The Lead Story — Full-bleed hero with a single restaurant story
/// 2. "Three for Tonight" — Context-aware quick picks
/// 3. "The Adventure" — Challenge prompt based on user behavior
/// 4. "From the Regulars" — Community intel
class DailyScreen extends StatefulWidget {
  const DailyScreen({super.key});

  @override
  State<DailyScreen> createState() => _DailyScreenState();
}

class _DailyScreenState extends State<DailyScreen> {
  DailyStory? _dailyStory;
  bool _isLoadingStory = true;
  String? _storyError;
  UserProfile? _userProfile;
  CuisineExplorationSuggestion? _explorationSuggestion;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Load profile first (needed for exploration), then others in parallel
    await _loadUserProfile();
    await Future.wait([
      _loadDailyStory(),
      _loadExplorationSuggestion(),
    ]);
  }

  Future<void> _loadUserProfile() async {
    try {
      final profile = await client.userProfile.getProfile();
      if (mounted) {
        setState(() => _userProfile = profile);
      }
    } catch (e) {
      debugPrint('Error loading user profile: $e');
      // If we get an auth error, sign out and redirect to landing
      if (e.toString().contains('authenticated') ||
          e.toString().contains('401') ||
          e.toString().contains('500')) {
        _handleAuthError();
      }
    }
  }

  /// Handle authentication errors by signing out and redirecting to landing
  Future<void> _handleAuthError() async {
    try {
      await client.auth.signOutAllDevices();
    } catch (_) {}
    if (mounted) {
      context.go('/landing');
    }
  }

  Future<void> _loadDailyStory() async {
    setState(() {
      _isLoadingStory = true;
      _storyError = null;
    });

    try {
      final story = await client.dailyStory.getDailyStory();
      if (mounted) {
        setState(() {
          _dailyStory = story;
          _isLoadingStory = false;
          if (story == null) {
            _storyError = 'No story generated. Check your profile has a home city set.';
          }
        });
      }
    } catch (e) {
      debugPrint('Error loading daily story: $e');
      if (mounted) {
        setState(() {
          _isLoadingStory = false;
          _storyError = 'Failed to load story: ${e.toString().split('\n').first}';
        });
      }
    }
  }

  Future<void> _loadExplorationSuggestion() async {
    if (_userProfile == null) return;

    try {
      final suggestion = await client.cuisineExploration.getExplorationSuggestion(
        cityName: _userProfile!.homeCity ?? 'Seattle',
        stateOrRegion: _userProfile!.homeState,
        latitude: _userProfile!.homeLatitude,
        longitude: _userProfile!.homeLongitude,
      );
      if (mounted) {
        setState(() => _explorationSuggestion = suggestion);
      }
    } catch (e) {
      debugPrint('Error loading exploration suggestion: $e');
    }
  }

  /// Get time-appropriate greeting
  static String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning.';
    if (hour < 17) return 'Good afternoon.';
    return 'Good evening.';
  }

  /// Show debug info dialog (long press on greeting)
  Future<void> _showDebugInfo() async {
    try {
      final status = await client.userProfile.debugProfileStatus();
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Profile Debug Info'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _debugRow('Daily Story Ready', status['dailyStoryReady']?.toString() ?? 'false'),
                _debugRow('Has Profile', status['hasProfile']?.toString() ?? 'false'),
                _debugRow('Onboarding Done', status['onboardingCompleted']?.toString() ?? 'false'),
                _debugRow('Home City', status['homeCity']?.toString() ?? 'NOT SET'),
                _debugRow('Home State', status['homeState']?.toString() ?? '-'),
                _debugRow('Philosophy', status['foodPhilosophy']?.toString() ?? '-'),
                _debugRow('Adventure', status['adventureLevel']?.toString() ?? '-'),
                const Divider(),
                Text(
                  status['message']?.toString() ?? '',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: status['dailyStoryReady'] == true ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close'),
            ),
            if (status['dailyStoryReady'] != true)
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  context.push('/onboarding');
                },
                child: const Text('Go to Onboarding'),
              ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Debug error: $e')),
      );
    }
  }

  Widget _debugRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.charcoal,
      body: CustomScrollView(
        slivers: [
          // App bar with "Off Menu" branding
          SliverAppBar(
            floating: true,
            backgroundColor: AppTheme.charcoal,
            title: Text(
              'Off Menu',
              style: AppTheme.headlineSerif.copyWith(
                fontSize: 24,
                color: AppTheme.cream,
              ),
            ),
            actions: [
              // The Hunt (search)
              IconButton(
                icon: const Icon(Icons.search, color: AppTheme.cream),
                onPressed: () => context.go('/ask'),
                tooltip: 'The Hunt',
              ),
              // Profile
              PopupMenuButton<String>(
                icon: const Icon(Icons.person_outline, color: AppTheme.cream),
                tooltip: 'Your Travels',
                onSelected: (value) {
                  if (value == 'profile') {
                    context.go('/profile');
                  } else if (value == 'logout') {
                    _showLogoutDialog(context);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'profile',
                    child: Row(
                      children: [
                        Icon(Icons.settings, size: 20),
                        SizedBox(width: 12),
                        Text('Profile Settings'),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, size: 20, color: Colors.red),
                        SizedBox(width: 12),
                        Text('Logout', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Greeting (long press for debug info)
          SliverToBoxAdapter(
            child: GestureDetector(
              onLongPress: _showDebugInfo,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  _getGreeting(),
                  style: AppTheme.bodySans.copyWith(
                    fontSize: 16,
                    color: AppTheme.creamMuted,
                  ),
                ),
              ),
            ),
          ),

          // 1. THE LEAD STORY - Full-bleed hero
          SliverToBoxAdapter(
            child: _LeadStory(
              story: _dailyStory,
              isLoading: _isLoadingStory,
              error: _storyError,
              onRefresh: _loadDailyStory,
              onTap: () {
                if (_dailyStory != null) {
                  // Navigate to full story detail view (outside shell)
                  context.push('/story', extra: {'story': _dailyStory});
                } else {
                  // Switch to Ask tab (within shell - use go, not push)
                  context.go('/ask');
                }
              },
            ),
          ),

          // QUICK ACTIONS - Create Map, Where Tonight, Ask Butler
          SliverToBoxAdapter(
            child: _QuickActions(
              onCreateMap: () => context.push('/maps/create'),
              onWhereTonight: () => context.go('/ask', extra: {
                'prompt': 'Find me something great for dinner tonight',
              }),
              onAskButler: () => context.go('/ask'),
            ),
          ),

          // Section header: Three for Tonight
          SliverToBoxAdapter(
            child: _SectionHeader(
              title: 'Three for Tonight',
              subtitle: 'Based on the weather, the hour, and your history',
            ),
          ),

          // 2. THREE FOR TONIGHT - Horizontal scroll (with weather)
          // Uses user's home city from profile, or falls back to daily story city
          SliverToBoxAdapter(
            child: _ThreeForTonight(
              cityName: _userProfile?.homeCity ?? _dailyStory?.city ?? 'Milwaukee',
              stateOrRegion: _userProfile?.homeState ?? _dailyStory?.state ?? 'WI',
              latitude: _userProfile?.homeLatitude ?? 43.0389,
              longitude: _userProfile?.homeLongitude ?? -87.9065,
              onTap: (pick) {
                if (pick.placeId != null) {
                  context.go('/ask', extra: {
                    'prompt': 'Tell me about ${pick.name}',
                  });
                } else {
                  context.go('/ask', extra: {'prompt': pick.name});
                }
              },
            ),
          ),

          // 3. THE ADVENTURE - Cuisine exploration
          if (_explorationSuggestion != null)
            SliverToBoxAdapter(
              child: _AdventureCard(
                suggestion: _explorationSuggestion!,
                onTap: () {
                  final cuisine = _explorationSuggestion!.cuisine;
                  final restaurant = _explorationSuggestion!.restaurantName;
                  final prompt = restaurant != null
                      ? 'Tell me about $restaurant and $cuisine cuisine'
                      : 'Find me a great $cuisine restaurant nearby';
                  context.go('/ask', extra: {'prompt': prompt});
                },
              ),
            ),

          // Section header: The Hunt
          SliverToBoxAdapter(
            child: _SectionHeader(
              title: 'The Hunt',
              subtitle: 'Find something real',
            ),
          ),

          // Quick hunt prompts
          SliverToBoxAdapter(
            child: _HuntPrompts(
              onTap: (prompt) => context.go('/ask', extra: {'prompt': prompt}),
            ),
          ),

          // 4. FROM THE REGULARS - Community intel (coming soon)
          SliverToBoxAdapter(
            child: _RegularsSection(),
          ),

          // Bottom padding
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
    );
  }
}

/// The Lead Story - Full-bleed editorial hero.
class _LeadStory extends StatelessWidget {
  final DailyStory? story;
  final bool isLoading;
  final String? error;
  final VoidCallback onTap;
  final VoidCallback? onRefresh;

  const _LeadStory({
    this.story,
    required this.isLoading,
    this.error,
    required this.onTap,
    this.onRefresh,
  });

  // Fallback content when no story is available
  static const _fallbackHeadline =
      'The Laotian Grandmother Who\'s Been Making Larb in a Strip Mall for 22 Years';
  static const _fallbackSubheadline =
      'At Sabaidee, the recipes haven\'t changed since 2002. Neither has the line out the door.';
  static const _fallbackImageUrl =
      'https://images.unsplash.com/photo-1555126634-323283e090fa?w=800&q=80';

  String get _storyTypeLabel {
    if (story == null) return 'TODAY\'S STORY';
    switch (story!.storyType) {
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
    // Show error state if there's an error
    if (error != null && story == null) {
      return Container(
        height: 420,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppTheme.charcoalLight,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.auto_stories, size: 48, color: AppTheme.creamMuted),
                const SizedBox(height: 16),
                Text(
                  'Today\'s Story',
                  style: AppTheme.headlineSerif.copyWith(
                    fontSize: 24,
                    color: AppTheme.cream,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  error!,
                  style: AppTheme.bodySans.copyWith(
                    fontSize: 14,
                    color: AppTheme.creamMuted,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                if (onRefresh != null)
                  TextButton.icon(
                    onPressed: onRefresh,
                    icon: const Icon(Icons.refresh, color: AppTheme.burntOrange),
                    label: Text(
                      'Try Again',
                      style: AppTheme.labelSans.copyWith(color: AppTheme.burntOrange),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    final headline = story?.headline ?? _fallbackHeadline;
    final subheadline = story?.subheadline ?? _fallbackSubheadline;
    final imageUrl = story?.heroImageUrl ?? _fallbackImageUrl;
    final hasRealStory = story != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 420,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppTheme.charcoalLight,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: isLoading
                  ? Container(color: AppTheme.charcoalLight)
                  : Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppTheme.charcoalLight,
                        child: const Center(
                          child: Icon(
                            Icons.restaurant,
                            size: 64,
                            color: AppTheme.creamMuted,
                          ),
                        ),
                      ),
                    ),
            ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppTheme.charcoal.withAlpha(200),
                    AppTheme.charcoal.withAlpha(240),
                  ],
                  stops: const [0.3, 0.7, 1.0],
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.burntOrange,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Label with story type
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: hasRealStory ? AppTheme.burntOrange : AppTheme.creamMuted.withAlpha(100),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                hasRealStory ? _storyTypeLabel : 'SAMPLE STORY',
                                style: AppTheme.labelSans.copyWith(
                                  fontSize: 10,
                                  color: AppTheme.cream,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                            if (story?.city != null) ...[
                              const SizedBox(width: 8),
                              Text(
                                story!.city.toUpperCase(),
                                style: AppTheme.labelSans.copyWith(
                                  fontSize: 10,
                                  color: AppTheme.creamMuted,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Headline
                        Text(
                          headline,
                          style: AppTheme.headlineSerif.copyWith(
                            fontSize: 28,
                            height: 1.2,
                            color: AppTheme.cream,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Subhead
                        Text(
                          subheadline,
                          style: AppTheme.bodySans.copyWith(
                            fontSize: 14,
                            color: AppTheme.creamMuted,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Read more
                        Row(
                          children: [
                            Text(
                              hasRealStory ? 'Read the story' : 'Ask the Butler',
                              style: AppTheme.labelSans.copyWith(
                                color: AppTheme.burntOrange,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward,
                              size: 16,
                              color: AppTheme.burntOrange,
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Quick Actions - Create Map, Where Tonight, Ask Butler.
class _QuickActions extends StatelessWidget {
  final VoidCallback onCreateMap;
  final VoidCallback onWhereTonight;
  final VoidCallback onAskButler;

  const _QuickActions({
    required this.onCreateMap,
    required this.onWhereTonight,
    required this.onAskButler,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _QuickActionButton(
              icon: Icons.map_outlined,
              label: 'Create a\nMap',
              onTap: onCreateMap,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _QuickActionButton(
              icon: Icons.place,
              label: 'Where\nTonight',
              onTap: onWhereTonight,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _QuickActionButton(
              icon: Icons.auto_awesome,
              label: 'Ask the\nButler',
              onTap: onAskButler,
              isHighlighted: true,
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual quick action button.
class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isHighlighted;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isHighlighted
          ? AppTheme.burntOrange.withAlpha(30)
          : AppTheme.charcoalLight,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isHighlighted
                  ? AppTheme.burntOrange.withAlpha(80)
                  : AppTheme.cream.withAlpha(10),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 28,
                color: isHighlighted ? AppTheme.burntOrange : AppTheme.cream,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: AppTheme.labelSans.copyWith(
                  fontSize: 12,
                  color: isHighlighted ? AppTheme.burntOrange : AppTheme.creamMuted,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Section header with title and subtitle - Eater style.
class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // All-caps label with accent color (Eater style)
          Text(
            title.toUpperCase(),
            style: AppTheme.labelCaps.copyWith(
              fontSize: 12,
              color: AppTheme.burntOrange,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 8),
          // Subtitle in serif (Literata)
          Text(
            subtitle,
            style: AppTheme.bodySerif.copyWith(
              fontSize: 16,
              color: AppTheme.creamMuted,
            ),
          ),
        ],
      ),
    );
  }
}

/// Three for Tonight - Quick picks based on context.
class _ThreeForTonight extends StatefulWidget {
  final String cityName;
  final String? stateOrRegion;
  final double? latitude;
  final double? longitude;
  final ValueChanged<TonightPick> onTap;

  const _ThreeForTonight({
    required this.cityName,
    this.stateOrRegion,
    this.latitude,
    this.longitude,
    required this.onTap,
  });

  @override
  State<_ThreeForTonight> createState() => _ThreeForTonightState();
}

class _ThreeForTonightState extends State<_ThreeForTonight> {
  List<TonightPick>? _picks;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPicks();
  }

  @override
  void didUpdateWidget(_ThreeForTonight oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cityName != widget.cityName ||
        oldWidget.latitude != widget.latitude ||
        oldWidget.longitude != widget.longitude) {
      _loadPicks();
    }
  }

  Future<void> _loadPicks() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final picks = await client.threeForTonight.getThreeForTonight(
        cityName: widget.cityName,
        stateOrRegion: widget.stateOrRegion,
        latitude: widget.latitude,
        longitude: widget.longitude,
      );
      if (mounted) {
        setState(() {
          _picks = picks;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading tonight picks: $e');
      if (mounted) {
        setState(() {
          _error = 'Could not load picks';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SizedBox(
        height: 250,
        child: Center(
          child: CircularProgressIndicator(
            color: AppTheme.burntOrange,
          ),
        ),
      );
    }

    if (_error != null || _picks == null || _picks!.isEmpty) {
      return SizedBox(
        height: 250,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.restaurant, color: AppTheme.creamMuted, size: 32),
              const SizedBox(height: 8),
              Text(
                _error ?? 'No picks available',
                style: AppTheme.bodySans.copyWith(color: AppTheme.creamMuted),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _loadPicks,
                child: Text(
                  'Try again',
                  style: AppTheme.labelSans.copyWith(color: AppTheme.burntOrange),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final screenWidth = MediaQuery.sizeOf(context).width;
    final isWide = screenWidth >= 800;

    // On wide screens, show cards in a responsive row
    if (isWide) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _picks!.asMap().entries.map((entry) {
              final index = entry.key;
              final pick = entry.value;
              final isLast = index == _picks!.length - 1;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: isLast ? 0 : 12),
                  child: _TonightCard(
                    pick: pick,
                    onTap: () => widget.onTap(pick),
                    isExpanded: true,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
    }

    // On mobile, keep horizontal scroll
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _picks!.length,
        itemBuilder: (context, index) {
          final pick = _picks![index];
          return _TonightCard(
            pick: pick,
            onTap: () => widget.onTap(pick),
            isExpanded: false,
          );
        },
      ),
    );
  }
}

/// Individual card for Three for Tonight - Eater style with borders.
class _TonightCard extends StatelessWidget {
  final TonightPick pick;
  final VoidCallback onTap;
  final bool isExpanded;

  const _TonightCard({
    required this.pick,
    required this.onTap,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    // Dynamic image height based on expanded state
    final imageHeight = isExpanded ? 180.0 : 140.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isExpanded ? null : 220,
        margin: isExpanded ? EdgeInsets.zero : const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppTheme.charcoalLight,
          border: AppTheme.boxBorder, // Eater-style border
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image with save button overlay
            Stack(
              children: [
                pick.imageUrl != null
                    ? Image.network(
                        pick.imageUrl!,
                        height: imageHeight,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: imageHeight,
                          color: AppTheme.charcoal,
                          child: const Icon(Icons.restaurant, color: AppTheme.creamMuted),
                        ),
                      )
                    : Container(
                        height: 110,
                        color: AppTheme.charcoal,
                        child: const Center(
                          child: Icon(Icons.restaurant, color: AppTheme.creamMuted, size: 32),
                        ),
                      ),
                // Save button in top-right corner
                Positioned(
                  top: 6,
                  right: 6,
                  child: SaveButton(
                    name: pick.name,
                    placeId: pick.placeId,
                    address: pick.address,
                    cuisineType: pick.cuisineType,
                    imageUrl: pick.imageUrl,
                    rating: pick.rating,
                    priceLevel: pick.priceLevel,
                    source: SavedRestaurantSource.tonight,
                    size: 20,
                    showBackground: true,
                  ),
                ),
              ],
            ),
            // Divider between image and content
            Container(height: 1, color: AppTheme.borderColor),
            // Info content
            _buildContentSection(),
          ],
        ),
      ),
    );
  }

  /// Build content section - uses Expanded when in fixed-height mode (mobile scroll),
  /// otherwise flows naturally for desktop row layout.
  Widget _buildContentSection() {
    final content = Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Cuisine type as tag
          if (pick.cuisineType != null)
            Text(
              pick.cuisineType!.toUpperCase(),
              style: AppTheme.labelCaps.copyWith(
                fontSize: 10,
                color: AppTheme.burntOrange,
              ),
            ),
          const SizedBox(height: 4),
          // Name in bold sans (DM Sans)
          Text(
            pick.name,
            style: AppTheme.headlineSans.copyWith(
              fontSize: 14,
              height: 1.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          // Hook in serif italic (Literata)
          Text(
            pick.hook,
            style: AppTheme.butlerVoice.copyWith(
              fontSize: 12,
              color: AppTheme.creamMuted,
              height: 1.3,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          // Rating if available
          if (pick.rating != null)
            Row(
              children: [
                Icon(Icons.star, size: 12, color: AppTheme.agedBrass),
                const SizedBox(width: 3),
                Text(
                  pick.rating!.toStringAsFixed(1),
                  style: AppTheme.labelSans.copyWith(
                    fontSize: 11,
                    color: AppTheme.creamMuted,
                  ),
                ),
              ],
            ),
        ],
      ),
    );

    // When not expanded (mobile horizontal scroll), use Expanded to fill height
    // When expanded (desktop row), let it flow naturally
    if (isExpanded) {
      return content;
    }
    return Expanded(child: content);
  }
}

/// The Adventure - Cuisine exploration card with Eater-style borders.
class _AdventureCard extends StatelessWidget {
  final CuisineExplorationSuggestion suggestion;
  final VoidCallback onTap;

  const _AdventureCard({
    required this.suggestion,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.charcoalLight,
        border: Border.all(color: AppTheme.burntOrange, width: 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label
                Text(
                  'CUISINE TO EXPLORE',
                  style: AppTheme.labelCaps.copyWith(
                    fontSize: 12,
                    color: AppTheme.burntOrange,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 16),
                // Context line in serif
                Text(
                  'You said you want to try...',
                  style: AppTheme.bodySerif.copyWith(
                    fontSize: 16,
                    color: AppTheme.creamMuted,
                  ),
                ),
                const SizedBox(height: 8),
                // Main headline - the cuisine
                Text(
                  suggestion.cuisine,
                  style: AppTheme.headlineSans.copyWith(
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 4),
                // Supporting line - restaurant info
                Text(
                  suggestion.hookLine,
                  style: AppTheme.bodySerif.copyWith(
                    fontSize: 16,
                    color: AppTheme.creamMuted,
                  ),
                ),
                const SizedBox(height: 20),
                // CTA Button
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: const BoxDecoration(
                    color: AppTheme.burntOrange,
                  ),
                  child: Text(
                    suggestion.ctaText,
                    style: AppTheme.labelCaps.copyWith(
                      fontSize: 13,
                      color: AppTheme.cream,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Hunt prompts - Quick search suggestions.
class _HuntPrompts extends StatelessWidget {
  final ValueChanged<String> onTap;

  const _HuntPrompts({required this.onTap});

  static const _prompts = [
    'Where do the kitchen workers eat after their shift?',
    'Show me a dive bar with incredible food',
    'I want to understand mole',
    'Impress someone special tonight',
    'Cure this hangover',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _prompts.map((prompt) {
          return GestureDetector(
            onTap: () => onTap(prompt),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.charcoalLight,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.cream.withAlpha(20)),
              ),
              child: Text(
                prompt,
                style: AppTheme.bodySans.copyWith(
                  fontSize: 13,
                  color: AppTheme.creamMuted,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// From the Regulars - Community intel section.
class _RegularsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.charcoalLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.cream.withAlpha(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.people_outline, size: 20, color: AppTheme.creamMuted),
              const SizedBox(width: 8),
              Text(
                'FROM THE REGULARS',
                style: AppTheme.labelSans.copyWith(
                  fontSize: 12,
                  color: AppTheme.creamMuted,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Sample intel
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.charcoal,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '"At Dong Phuong right now. Skip the menu. Ask for banh mi dac biet with extra pate. \$6. Life-changing."',
                  style: AppTheme.bodySans.copyWith(
                    fontSize: 14,
                    color: AppTheme.cream,
                    fontStyle: FontStyle.italic,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: AppTheme.burntOrange.withAlpha(50),
                      child: const Icon(Icons.person, size: 14, color: AppTheme.burntOrange),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '@localfoodwriter',
                      style: AppTheme.labelSans.copyWith(
                        fontSize: 12,
                        color: AppTheme.creamMuted,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '2 hours ago',
                      style: AppTheme.labelSans.copyWith(
                        fontSize: 11,
                        color: AppTheme.creamMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Shows logout confirmation dialog.
void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Logout'),
      content: const Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(ctx).pop();
            await client.auth.signOutDevice();
            if (context.mounted) {
              context.go('/sign-in');
            }
          },
          child: const Text('Logout', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}
