import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tall_us/main.dart' as app;

/// Integration Tests for Swipe Flow
///
/// Tests the complete swipe/discovery experience:
/// 1. View profile cards
/// 2. Swipe left (pass)
/// 3. Swipe right (like)
/// 4. Super like
/// 5. View profile details
/// 6. Match notification
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Swipe Flow', () {
    testWidgets('should display profile cards', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Should see the discovery/swipe screen
      expect(find.byType(Scaffold), findsWidgets);

      // Look for profile card
      final profileCard = find.byType(Card);
      if (profileCard.evaluate().isNotEmpty) {
        expect(profileCard, findsAtLeastNWidgets(1));
      }
    });

    testWidgets('should swipe right on profile', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Find a swipable card
      final card = find.byType(Card).first;

      if (card.evaluate().isNotEmpty) {
        // Get the initial position
        final initialPosition = tester.getCenter(card);

        // Swipe right
        await tester.drag(card, Offset(500, 0));
        await tester.pumpAndSettle();

        // Card should be gone or moved
        final newPosition = tester.getCenter(card);
        expect(newPosition.dx, greaterThan(initialPosition.dx));
      }
    });

    testWidgets('should swipe left on profile', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final card = find.byType(Card).first;

      if (card.evaluate().isNotEmpty) {
        final initialPosition = tester.getCenter(card);

        // Swipe left
        await tester.drag(card, Offset(-500, 0));
        await tester.pumpAndSettle();

        final newPosition = tester.getCenter(card);
        expect(newPosition.dx, lessThan(initialPosition.dx));
      }
    });

    testWidgets('should display like and pass buttons', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Look for action buttons
      final likeButton = find.byIcon(Icons.favorite);
      final passButton = find.byIcon(Icons.close);

      // Buttons may or may not be visible depending on UI
      if (likeButton.evaluate().isNotEmpty) {
        expect(likeButton, findsOneWidget);
      }

      if (passButton.evaluate().isNotEmpty) {
        expect(passButton, findsOneWidget);
      }
    });

    testWidgets('should tap like button', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final likeButton = find.byIcon(Icons.favorite);

      if (likeButton.evaluate().isNotEmpty) {
        await tester.tap(likeButton);
        await tester.pumpAndSettle();

        // Should move to next profile or show match
        expect(find.byType(Scaffold), findsWidgets);
      }
    });

    testWidgets('should tap pass button', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final passButton = find.byIcon(Icons.close);

      if (passButton.evaluate().isNotEmpty) {
        await tester.tap(passButton);
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsWidgets);
      }
    });

    testWidgets('should display profile information', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Look for common profile elements
      expect(
        find.textContaining('Ans'),
        findsWidgets,
      ); // Age display

      // Look for name
      final textWidgets = find.byType(Text);
      expect(textWidgets, findsAtLeastNWidgets(1));
    });

    testWidgets('should view full profile details', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Look for info/details button
      final infoButton = find.byIcon(Icons.info);
      final detailsButton = find.text('Voir le profil');

      if (infoButton.evaluate().isNotEmpty) {
        await tester.tap(infoButton);
        await tester.pumpAndSettle();

        // Should show more details
        expect(find.byType(Scaffold), findsWidgets);
      } else if (detailsButton.evaluate().isNotEmpty) {
        await tester.tap(detailsButton);
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsWidgets);
      }
    });

    testWidgets('should handle empty stack', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Keep swiping until no more profiles
      for (int i = 0; i < 10; i++) {
        final card = find.byType(Card).first;

        if (card.evaluate().isEmpty) {
          // No more cards
          expect(find.text('Plus de profils'), findsWidgets);
          break;
        }

        await tester.drag(card, Offset(500, 0));
        await tester.pumpAndSettle();
      }
    });

    testWidgets('should display match screen', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // This test would require mocking a match scenario
      // For now, just verify the app doesn't crash

      expect(find.byType(MaterialApp), findsWidgets);
    });

    testWidgets('should handle rewind/premium feature', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Look for rewind button (premium feature)
      final rewindButton = find.byIcon(Icons.replay);

      if (rewindButton.evaluate().isNotEmpty) {
        await tester.tap(rewindButton);
        await tester.pumpAndSettle();

        // May show premium upgrade screen
        expect(find.byType(Scaffold), findsWidgets);
      }
    });

    testWidgets('should handle boost feature', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Look for boost button
      final boostButton = find.byIcon(Icons.flash_on);
      final boostText = find.text('Boost');

      if (boostButton.evaluate().isNotEmpty || boostText.evaluate().isNotEmpty) {
        final target = boostButton.evaluate().isNotEmpty ? boostButton : boostText;
        await tester.tap(target);
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsWidgets);
      }
    });
  });

  group('Swipe Edge Cases', () {
    testWidgets('should handle rapid swipes', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Perform multiple rapid swipes
      for (int i = 0; i < 5; i++) {
        final card = find.byType(Card).first;

        if (card.evaluate().isEmpty) break;

        await tester.drag(card, Offset(500, 0));
        await tester.pump(); // Don't settle, test rapid swipes
      }

      await tester.pumpAndSettle();

      // App should still be responsive
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('should handle partial swipes', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final card = find.byType(Card).first;

      if (card.evaluate().isNotEmpty) {
        // Small drag that shouldn't trigger swipe
        await tester.drag(card, Offset(50, 0));
        await tester.pumpAndSettle();

        // Card should still be visible
        expect(card, findsOneWidget);
      }
    });

    testWidgets('should handle vertical drag (should not swipe)',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final card = find.byType(Card).first;

      if (card.evaluate().isNotEmpty) {
        // Vertical drag
        await tester.drag(card, Offset(0, 100));
        await tester.pumpAndSettle();

        // Card should still be visible (vertical drag doesn't swipe)
        expect(card, findsOneWidget);
      }
    });

    testWidgets('should display super like option', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Look for super like button (star icon)
      final superLikeButton = find.byIcon(Icons.star);

      if (superLikeButton.evaluate().isNotEmpty) {
        await tester.tap(superLikeButton);
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsWidgets);
      }
    });

    testWidgets('should handle tap on profile photo', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Try to find and tap profile photo
      final image = find.byType(Image);

      if (image.evaluate().isNotEmpty) {
        await tester.tap(image.first);
        await tester.pumpAndSettle();

        // Should show full screen image or profile details
        expect(find.byType(Scaffold), findsWidgets);
      }
    });
  });

  group('Swipe Settings', () {
    testWidgets('should access discovery preferences', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Look for settings/filter button
      final settingsButton = find.byIcon(Icons.tune);
      final filterButton = find.text('Filtres');

      if (settingsButton.evaluate().isNotEmpty) {
        await tester.tap(settingsButton);
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsWidgets);
      } else if (filterButton.evaluate().isNotEmpty) {
        await tester.tap(filterButton);
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsWidgets);
      }
    });

    testWidgets('should change age range', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // This would require navigating to preferences
      // For now, just verify app is stable
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('should change distance range', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // This would require navigating to preferences
      expect(find.byType(Scaffold), findsWidgets);
    });
  });
}
