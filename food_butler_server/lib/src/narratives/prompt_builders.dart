/// Prompt builders for generating Anthony Bourdain-inspired tour narratives.
///
/// These builders create structured prompts for the Groq LLM to generate
/// engaging, storytelling-focused descriptions for food tours.

/// System prompt defining the Anthony Bourdain-inspired voice.
const String narrativeSystemPrompt = '''
You are a seasoned culinary storyteller channeling the spirit of Anthony Bourdain.
Your voice is warm, honest, and passionate about food culture. You tell stories,
not just descriptions. You're curious about the people behind the food and the
neighborhoods that shaped each restaurant.

IMPORTANT RULES:
- NEVER use these cliched phrases: "hidden gem", "must-try", "foodie paradise",
  "mouthwatering", "culinary heaven", "food lover's dream", "best-kept secret",
  "to die for", "amazing flavors", "flavor explosion"
- Use vivid, specific details rather than generic praise
- Reference the craft, the tradition, the neighborhood character
- Be conversational, like you're sharing discoveries with a friend
- Acknowledge awards naturally without being overly promotional
- For Michelin stars or James Beard awards, mention them with respect but not worship
- Keep the focus on the food, the people, and the experience
''';

/// Input data for tour introduction narrative.
class TourIntroInput {
  final String neighborhood;
  final List<String> cuisineTypes;
  final int restaurantCount;
  final String timeOfDay;
  final String transportMode;
  final List<String>? userCuisinePreferences;

  TourIntroInput({
    required this.neighborhood,
    required this.cuisineTypes,
    required this.restaurantCount,
    required this.timeOfDay,
    required this.transportMode,
    this.userCuisinePreferences,
  });
}

/// Input data for restaurant description narrative.
class RestaurantDescriptionInput {
  final String restaurantName;
  final String cuisineType;
  final List<String> signatureDishes;
  final List<String> awards;
  final String neighborhood;
  final int stopNumber;
  final int totalStops;
  final List<String>? userDietaryRestrictions;
  final String? safeDishRecommendation;

  RestaurantDescriptionInput({
    required this.restaurantName,
    required this.cuisineType,
    required this.signatureDishes,
    required this.awards,
    required this.neighborhood,
    required this.stopNumber,
    required this.totalStops,
    this.userDietaryRestrictions,
    this.safeDishRecommendation,
  });
}

/// Input data for transition narrative.
class TransitionInput {
  final String fromRestaurant;
  final String fromCuisine;
  final String toRestaurant;
  final String toCuisine;
  final String travelMode;
  final int durationMinutes;
  final String? distanceDescription;

  TransitionInput({
    required this.fromRestaurant,
    required this.fromCuisine,
    required this.toRestaurant,
    required this.toCuisine,
    required this.travelMode,
    required this.durationMinutes,
    this.distanceDescription,
  });
}

/// Builds prompts for tour introduction narratives.
class TourIntroPromptBuilder {
  static const String _fewShotExample = '''
EXAMPLE OUTPUT:
"The West Loop unfolds before us like a story written in brick and butter.
What was once meatpacking territory now pulses with some of Chicago's most
daring kitchens. From an Italian spot where pasta is practically a religion
to a Korean steakhouse redefining the char, we're about to taste the
neighborhood's evolution. Five stops. Zero pretense. Let's eat."
''';

  /// Build the user prompt for tour introduction.
  static String buildPrompt(TourIntroInput input) {
    final cuisineList = input.cuisineTypes.join(', ');
    final preferenceNote = input.userCuisinePreferences != null &&
            input.userCuisinePreferences!.isNotEmpty
        ? '\nUser enjoys: ${input.userCuisinePreferences!.join(', ')}. '
            'Subtly acknowledge their tastes if relevant.'
        : '';

    return '''
Generate a tour introduction (50-75 words) for this food tour:

CONTEXT:
- Neighborhood: ${input.neighborhood}
- Cuisine diversity: $cuisineList
- Number of stops: ${input.restaurantCount}
- Time of day: ${input.timeOfDay}
- Transport mode: ${input.transportMode}$preferenceNote

REQUIREMENTS:
- Set the theme and mood for the culinary journey
- Reference the neighborhood character and food scene
- Build anticipation without revealing all the stops
- Conversational, storytelling tone
- Exactly 50-75 words

$_fewShotExample

YOUR INTRODUCTION:
''';
  }
}

/// Builds prompts for restaurant description narratives.
class RestaurantDescriptionPromptBuilder {
  static const String _fewShotExample = '''
EXAMPLE OUTPUT:
"Avec has been setting the standard since 2003, back when the West Loop was
still finding its voice. The wood-burning oven dominates the open kitchen,
turning out chorizo-stuffed dates that have achieved near-legendary status.
James Beard took notice—this is one of the few spots in Chicago where the
Mediterranean doesn't feel like a costume. Grab a seat at the communal table
and taste what happens when restraint meets fire."
''';

  /// Build the user prompt for restaurant description.
  static String buildPrompt(RestaurantDescriptionInput input) {
    final awardsNote = input.awards.isNotEmpty
        ? '\n- Awards: ${input.awards.join(', ')}'
        : '';

    final dishesNote = input.signatureDishes.isNotEmpty
        ? '\n- Signature dishes: ${input.signatureDishes.join(', ')}'
        : '';

    final dietaryNote = input.userDietaryRestrictions != null &&
            input.userDietaryRestrictions!.isNotEmpty
        ? '\n- User dietary restrictions: ${input.userDietaryRestrictions!.join(', ')}.'
            '${input.safeDishRecommendation != null ? ' Safe dish recommendation: ${input.safeDishRecommendation}' : ''}'
        : '';

    final positionNote = input.stopNumber == 1
        ? 'Opening stop of the tour'
        : input.stopNumber == input.totalStops
            ? 'Grand finale of the tour'
            : 'Stop ${input.stopNumber} of ${input.totalStops}';

    return '''
Generate a restaurant description (75-100 words) for this stop:

CONTEXT:
- Restaurant: ${input.restaurantName}
- Cuisine: ${input.cuisineType}
- Neighborhood: ${input.neighborhood}$dishesNote$awardsNote
- Position: $positionNote$dietaryNote

REQUIREMENTS:
- Include culinary context and what makes this spot notable
- If awards are mentioned, reference them naturally (not as marketing)
- Connect to the overall tour narrative arc
- Vivid, specific details over generic praise
- Conversational, storytelling tone
- Exactly 75-100 words

$_fewShotExample

YOUR DESCRIPTION:
''';
  }
}

/// Builds prompts for transition narratives.
class TransitionPromptBuilder {
  static const String _fewShotExample = '''
EXAMPLE OUTPUT:
"A five-minute stroll takes us from seafood's clean precision to the
smoke-kissed world of Texas barbecue. Cross Randolph Street, let the
anticipation build with each step toward those wood piles out front."
''';

  /// Build the user prompt for transition.
  static String buildPrompt(TransitionInput input) {
    final distanceNote = input.distanceDescription != null
        ? ' (${input.distanceDescription})'
        : '';

    return '''
Generate a transition (25-40 words) between these stops:

CONTEXT:
- From: ${input.fromRestaurant} (${input.fromCuisine})
- To: ${input.toRestaurant} (${input.toCuisine})
- Travel: ${input.travelMode}, ${input.durationMinutes} minutes$distanceNote

REQUIREMENTS:
- Reference the travel mode and time naturally
- Build anticipation for the next stop
- Connect the two stops thematically (cuisine contrast, neighborhood shift, etc.)
- Brief closure on what we're leaving behind
- Exactly 25-40 words

$_fewShotExample

YOUR TRANSITION:
''';
  }
}
