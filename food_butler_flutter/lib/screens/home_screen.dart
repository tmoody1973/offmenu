import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../main.dart';
import '../theme/app_theme.dart';

/// Culinary storytelling home screen.
///
/// Inspired by documentary film and food culture - this is NOT a utility app,
/// it's a gateway to culinary adventures and stories.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Inspiring food quotes for rotation
  static const List<String> _quotes = [
    '"Food is everything we are. It\'s an extension of nationalist feeling, ethnic feeling, your personal history." — Anthony Bourdain',
    '"The discovery of a new dish does more for the happiness of the human race than the discovery of a star." — Jean Anthelme Brillat-Savarin',
    '"One cannot think well, love well, sleep well, if one has not dined well." — Virginia Woolf',
    '"Food is our common ground, a universal experience." — James Beard',
  ];

  // Featured culinary quests
  static const List<Map<String, String>> _featuredQuests = [
    {
      'title': 'The Ramen Pilgrimage',
      'subtitle': 'Find the soul of tonkotsu',
      'dish': 'tonkotsu ramen',
      'emoji': '🍜',
    },
    {
      'title': 'Taco Trail',
      'subtitle': 'Street food stories',
      'dish': 'tacos al pastor',
      'emoji': '🌮',
    },
    {
      'title': 'Pizza Quest',
      'subtitle': 'From Napoli with love',
      'dish': 'Neapolitan pizza',
      'emoji': '🍕',
    },
    {
      'title': 'Pho Journey',
      'subtitle': 'Broth as meditation',
      'dish': 'pho',
      'emoji': '🍲',
    },
  ];

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String _getQuote() {
    final index = DateTime.now().day % _quotes.length;
    return _quotes[index];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final isTabletOrDesktop = size.width >= AppTheme.mobileBreakpoint;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Cinematic header
          SliverToBoxAdapter(
            child: _CinematicHeader(
              greeting: _getGreeting(),
              onSearchTap: () => context.push('/tour/create'),
            ),
          ),

          // Ask the Butler - Conversational AI input (HERO)
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: isTabletOrDesktop ? 32 : 16,
              vertical: 8,
            ),
            sliver: SliverToBoxAdapter(
              child: Transform.translate(
                offset: const Offset(0, -20),
                child: _AskButlerCard(
                  onTap: () => context.push('/ask'),
                ),
              ),
            ),
          ),

          // Two modes: Quick Find vs Food Tour
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: isTabletOrDesktop ? 32 : 16,
            ),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  // Quick Find - Single Restaurant
                  Expanded(
                    child: _ModeCard(
                      icon: Icons.place,
                      title: 'Quick Find',
                      subtitle: 'Best spot for one dish',
                      color: AppTheme.primaryColor,
                      onTap: () => context.push('/tour/create', extra: {
                        'mode': 'single',
                      }),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Food Tour - Multi-stop Journey
                  Expanded(
                    child: _ModeCard(
                      icon: Icons.route,
                      title: 'Food Tour',
                      subtitle: 'Multi-stop adventure',
                      color: Colors.deepPurple,
                      onTap: () => context.push('/tour/create', extra: {
                        'mode': 'tour',
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Featured Culinary Quests
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: isTabletOrDesktop ? 32 : 16,
            ),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Text(
                        'Culinary Quests',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => context.push('/tour/create'),
                        child: const Text('See All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'One dish. Multiple stops. Countless stories.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Quest cards - horizontal scroll
          SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(
                  horizontal: isTabletOrDesktop ? 32 : 16,
                  vertical: 16,
                ),
                itemCount: _featuredQuests.length,
                itemBuilder: (context, index) {
                  final quest = _featuredQuests[index];
                  return _QuestCard(
                    emoji: quest['emoji']!,
                    title: quest['title']!,
                    subtitle: quest['subtitle']!,
                    onTap: () => context.push('/tour/create', extra: {
                      'prefilledDish': quest['dish'],
                    }),
                  );
                },
              ),
            ),
          ),

          // Create Your Own Journey
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: isTabletOrDesktop ? 32 : 16,
            ),
            sliver: SliverToBoxAdapter(
              child: _CreateJourneyCard(
                onTap: () => context.push('/tour/create'),
              ),
            ),
          ),

          // Inspiring quote
          SliverPadding(
            padding: EdgeInsets.all(isTabletOrDesktop ? 32 : 16),
            sliver: SliverToBoxAdapter(
              child: _QuoteCard(quote: _getQuote()),
            ),
          ),

          // Quick actions row
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: isTabletOrDesktop ? 32 : 16,
            ),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Expanded(
                    child: _CompactActionCard(
                      icon: Icons.auto_stories,
                      label: 'Food Journal',
                      onTap: () => context.push('/journal'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _CompactActionCard(
                      icon: Icons.bookmark_outline,
                      label: 'Saved Tours',
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _CompactActionCard(
                      icon: Icons.emoji_events_outlined,
                      label: 'Awards',
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom padding
          const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
        ],
      ),
    );
  }
}

/// Cinematic header with gradient and tagline.
class _CinematicHeader extends StatelessWidget {
  final String greeting;
  final VoidCallback onSearchTap;

  const _CinematicHeader({
    required this.greeting,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 20,
        right: 20,
        bottom: 24,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryColor.withAlpha(220),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row with logo and profile
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.restaurant,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Food Butler',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              PopupMenuButton<String>(
                icon: const Icon(Icons.person_outline, color: Colors.white),
                onSelected: (value) {
                  if (value == 'profile') {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const _ProfileSettingsPage(),
                      ),
                    );
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
          const SizedBox(height: 24),

          // Greeting
          Text(
            greeting,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withAlpha(200),
            ),
          ),
          const SizedBox(height: 4),

          // Tagline
          Text(
            'Every meal has a story.',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Find yours.',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: Colors.white.withAlpha(200),
              fontWeight: FontWeight.w300,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

/// Ask the Butler - Conversational AI card.
class _AskButlerCard extends StatelessWidget {
  final VoidCallback onTap;

  const _AskButlerCard({required this.onTap});

  // Example prompts to inspire users
  static const List<String> _examplePrompts = [
    'Hidden gems in Capitol Hill for locals only',
    'Late night eats after a Mariners game',
    'Best brunch with a view in Seattle',
    'Hole-in-the-wall taquerias tourists don\'t know',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 8,
      shadowColor: Colors.black.withAlpha(40),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.grey.shade900,
                Colors.grey.shade800,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.amber.withAlpha(30),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.auto_awesome,
                      color: Colors.amber.shade400,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ask the Butler',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Your personal food concierge',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey.shade500,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Fake input field
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(10),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withAlpha(20)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey.shade500, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      'Ask me anything about food...',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade500,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Example prompts
              Text(
                'Try asking:',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: _examplePrompts.take(2).map((prompt) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(10),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '"$prompt"',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade400,
                        fontSize: 11,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Mode selection card (Quick Find vs Food Tour).
class _ModeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ModeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 6,
      shadowColor: color.withAlpha(60),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withAlpha(20),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Quest card for featured culinary journeys.
class _QuestCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuestCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 2,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  emoji,
                  style: const TextStyle(fontSize: 32),
                ),
                const Spacer(),
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
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

/// Create your own journey card.
class _CreateJourneyCard extends StatelessWidget {
  final VoidCallback onTap;

  const _CreateJourneyCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: Colors.grey.shade900,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.auto_awesome,
                            color: Colors.amber.shade400, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'AI-POWERED',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.amber.shade400,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Create Your Own\nCulinary Journey',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Choose your cuisine, budget, and vibe. We\'ll craft a story-driven food tour just for you.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade400,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: onTap,
                      icon: const Icon(Icons.explore, size: 18),
                      label: const Text('Start Planning'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(10),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.map_outlined,
                  color: Colors.white54,
                  size: 48,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Inspirational quote card.
class _QuoteCard extends StatelessWidget {
  final String quote;

  const _QuoteCard({required this.quote});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.format_quote, color: Colors.grey.shade400, size: 32),
          const SizedBox(height: 12),
          Text(
            quote,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact action card for secondary actions.
class _CompactActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _CompactActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            children: [
              Icon(icon, color: AppTheme.primaryColor, size: 24),
              const SizedBox(height: 8),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
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

/// Profile settings page.
class _ProfileSettingsPage extends StatefulWidget {
  const _ProfileSettingsPage();

  @override
  State<_ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<_ProfileSettingsPage> {
  String? _homeCity;
  String? _homeState;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await client.userProfile.getProfile();
      if (mounted) {
        setState(() {
          _homeCity = profile?.homeCity;
          _homeState = profile?.homeState;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String get _locationDisplay {
    if (_homeCity != null && _homeState != null) {
      return '$_homeCity, $_homeState';
    } else if (_homeCity != null) {
      return _homeCity!;
    }
    return 'Location not set';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Settings'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Profile header
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: AppTheme.primaryColor.withAlpha(50),
                          child: Icon(Icons.person, size: 40, color: AppTheme.primaryColor),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Food Explorer',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
                            const SizedBox(width: 4),
                            Text(
                              _locationDisplay,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Settings options
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person_outline),
                        title: const Text('Edit Profile'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // TODO: Navigate to edit profile
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.restaurant_menu),
                        title: const Text('Food Preferences'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          context.push('/onboarding');
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.notifications_outlined),
                        title: const Text('Notifications'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // TODO: Navigate to notifications settings
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.privacy_tip_outlined),
                        title: const Text('Privacy'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // TODO: Navigate to privacy settings
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Logout button
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text('Logout', style: TextStyle(color: Colors.red)),
                    onTap: () {
                      Navigator.of(context).pop();
                      _showLogoutDialog(context);
                    },
                  ),
                ),
                const SizedBox(height: 32),

                // App version
                Center(
                  child: Text(
                    'Off Menu v1.0.0',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
