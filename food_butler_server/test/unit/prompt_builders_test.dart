import 'package:test/test.dart';

import 'package:food_butler_server/src/narratives/prompt_builders.dart';

void main() {
  group('narrativeSystemPrompt', () {
    test('defines Anthony Bourdain persona characteristics', () {
      expect(narrativeSystemPrompt.toLowerCase(), contains('warm'));
      expect(narrativeSystemPrompt.toLowerCase(), contains('honest'));
      expect(narrativeSystemPrompt.toLowerCase(), contains('passionate'));
      expect(narrativeSystemPrompt.toLowerCase(), contains('storyteller'));
    });

    test('includes anti-cliche instructions', () {
      expect(narrativeSystemPrompt, contains('hidden gem'));
      expect(narrativeSystemPrompt, contains('must-try'));
      expect(narrativeSystemPrompt, contains('foodie paradise'));
      expect(narrativeSystemPrompt, contains('NEVER'));
    });
  });

  group('TourIntroPromptBuilder', () {
    test('includes neighborhood and cuisine diversity in prompt', () {
      final input = TourIntroInput(
        neighborhood: 'West Loop',
        cuisineTypes: ['Italian', 'Korean', 'Mexican'],
        restaurantCount: 4,
        timeOfDay: 'evening',
        transportMode: 'walking',
      );

      final prompt = TourIntroPromptBuilder.buildPrompt(input);

      expect(prompt, contains('West Loop'));
      expect(prompt, contains('Italian'));
      expect(prompt, contains('Korean'));
      expect(prompt, contains('Mexican'));
      expect(prompt, contains('4'));
      expect(prompt, contains('evening'));
      expect(prompt, contains('walking'));
    });

    test('includes user cuisine preferences when provided', () {
      final input = TourIntroInput(
        neighborhood: 'Lincoln Park',
        cuisineTypes: ['Japanese', 'French'],
        restaurantCount: 3,
        timeOfDay: 'lunch',
        transportMode: 'driving',
        userCuisinePreferences: ['sushi', 'seafood'],
      );

      final prompt = TourIntroPromptBuilder.buildPrompt(input);

      expect(prompt, contains('sushi'));
      expect(prompt, contains('seafood'));
      expect(prompt, contains('User enjoys'));
    });

    test('omits user preferences when not provided', () {
      final input = TourIntroInput(
        neighborhood: 'River North',
        cuisineTypes: ['American'],
        restaurantCount: 2,
        timeOfDay: 'brunch',
        transportMode: 'walking',
      );

      final prompt = TourIntroPromptBuilder.buildPrompt(input);

      expect(prompt.contains('User enjoys'), isFalse);
    });

    test('includes word count requirements', () {
      final input = TourIntroInput(
        neighborhood: 'Test',
        cuisineTypes: ['Test'],
        restaurantCount: 1,
        timeOfDay: 'lunch',
        transportMode: 'walking',
      );

      final prompt = TourIntroPromptBuilder.buildPrompt(input);

      expect(prompt, contains('50-75 words'));
    });
  });

  group('RestaurantDescriptionPromptBuilder', () {
    test('includes awards prominently when present', () {
      final input = RestaurantDescriptionInput(
        restaurantName: 'Alinea',
        cuisineType: 'Contemporary American',
        signatureDishes: ['Edible Balloon', 'The Dessert'],
        awards: ['Michelin 3-Star', 'James Beard Outstanding Restaurant'],
        neighborhood: 'Lincoln Park',
        stopNumber: 2,
        totalStops: 4,
      );

      final prompt = RestaurantDescriptionPromptBuilder.buildPrompt(input);

      expect(prompt, contains('Michelin 3-Star'));
      expect(prompt, contains('James Beard'));
      expect(prompt, contains('Awards'));
    });

    test('includes signature dishes in context', () {
      final input = RestaurantDescriptionInput(
        restaurantName: 'Portillo\'s',
        cuisineType: 'Chicago-style',
        signatureDishes: ['Italian Beef', 'Chicago Dog', 'Chocolate Cake Shake'],
        awards: [],
        neighborhood: 'River North',
        stopNumber: 1,
        totalStops: 3,
      );

      final prompt = RestaurantDescriptionPromptBuilder.buildPrompt(input);

      expect(prompt, contains('Italian Beef'));
      expect(prompt, contains('Chicago Dog'));
      expect(prompt, contains('Chocolate Cake Shake'));
    });

    test('highlights safe dishes for users with dietary restrictions', () {
      final input = RestaurantDescriptionInput(
        restaurantName: 'Veggie Grill',
        cuisineType: 'Vegetarian',
        signatureDishes: ['Buddha Bowl', 'Crispy Cauliflower'],
        awards: [],
        neighborhood: 'Wicker Park',
        stopNumber: 3,
        totalStops: 5,
        userDietaryRestrictions: ['gluten-free', 'vegetarian'],
        safeDishRecommendation: 'Buddha Bowl (GF, V)',
      );

      final prompt = RestaurantDescriptionPromptBuilder.buildPrompt(input);

      expect(prompt, contains('gluten-free'));
      expect(prompt, contains('vegetarian'));
      expect(prompt, contains('Buddha Bowl (GF, V)'));
    });

    test('includes position context in narrative arc', () {
      // Test opening stop
      var input = RestaurantDescriptionInput(
        restaurantName: 'First Stop',
        cuisineType: 'American',
        signatureDishes: [],
        awards: [],
        neighborhood: 'Downtown',
        stopNumber: 1,
        totalStops: 4,
      );
      var prompt = RestaurantDescriptionPromptBuilder.buildPrompt(input);
      expect(prompt, contains('Opening stop'));

      // Test finale
      input = RestaurantDescriptionInput(
        restaurantName: 'Last Stop',
        cuisineType: 'Dessert',
        signatureDishes: [],
        awards: [],
        neighborhood: 'Downtown',
        stopNumber: 4,
        totalStops: 4,
      );
      prompt = RestaurantDescriptionPromptBuilder.buildPrompt(input);
      expect(prompt, contains('finale'));
    });

    test('includes word count requirements', () {
      final input = RestaurantDescriptionInput(
        restaurantName: 'Test',
        cuisineType: 'Test',
        signatureDishes: [],
        awards: [],
        neighborhood: 'Test',
        stopNumber: 1,
        totalStops: 1,
      );

      final prompt = RestaurantDescriptionPromptBuilder.buildPrompt(input);

      expect(prompt, contains('75-100 words'));
    });
  });

  group('TransitionPromptBuilder', () {
    test('includes travel mode and duration', () {
      final input = TransitionInput(
        fromRestaurant: 'Seafood Shack',
        fromCuisine: 'Seafood',
        toRestaurant: 'BBQ Joint',
        toCuisine: 'Barbecue',
        travelMode: 'walking',
        durationMinutes: 8,
      );

      final prompt = TransitionPromptBuilder.buildPrompt(input);

      expect(prompt, contains('walking'));
      expect(prompt, contains('8 minutes'));
    });

    test('includes both restaurant names and cuisines', () {
      final input = TransitionInput(
        fromRestaurant: 'Sushi Paradise',
        fromCuisine: 'Japanese',
        toRestaurant: 'Taqueria Central',
        toCuisine: 'Mexican',
        travelMode: 'driving',
        durationMinutes: 12,
      );

      final prompt = TransitionPromptBuilder.buildPrompt(input);

      expect(prompt, contains('Sushi Paradise'));
      expect(prompt, contains('Japanese'));
      expect(prompt, contains('Taqueria Central'));
      expect(prompt, contains('Mexican'));
    });

    test('includes distance description when provided', () {
      final input = TransitionInput(
        fromRestaurant: 'Place A',
        fromCuisine: 'Italian',
        toRestaurant: 'Place B',
        toCuisine: 'French',
        travelMode: 'walking',
        durationMinutes: 5,
        distanceDescription: '0.3 miles',
      );

      final prompt = TransitionPromptBuilder.buildPrompt(input);

      expect(prompt, contains('0.3 miles'));
    });

    test('includes word count requirements', () {
      final input = TransitionInput(
        fromRestaurant: 'A',
        fromCuisine: 'X',
        toRestaurant: 'B',
        toCuisine: 'Y',
        travelMode: 'walking',
        durationMinutes: 1,
      );

      final prompt = TransitionPromptBuilder.buildPrompt(input);

      expect(prompt, contains('25-40 words'));
    });
  });
}
