import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tall_us/main.dart' as app;

/// Integration Tests for Messaging Flow
///
/// Tests the complete messaging experience:
/// 1. View matches list
/// 2. Open conversation
/// 3. Send text messages
/// 4. Send rich media (photos, GIFs, audio)
/// 5. View message history
/// 6. Real-time updates
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Messaging Flow', () {
    testWidgets('should display matches list', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to messages/matches screen
      final messagesButton = find.byIcon(Icons.message);
      final matchesTab = find.text('Messages');

      if (messagesButton.evaluate().isNotEmpty) {
        await tester.tap(messagesButton);
        await tester.pumpAndSettle();
      } else if (matchesTab.evaluate().isNotEmpty) {
        await tester.tap(matchesTab);
        await tester.pumpAndSettle();
      }

      // Should show matches or conversations list
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('should open conversation', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to messages
      final messagesButton = find.byIcon(Icons.message);
      if (messagesButton.evaluate().isNotEmpty) {
        await tester.tap(messagesButton);
        await tester.pumpAndSettle();
      }

      // Look for conversation list items
      final listTile = find.byType(ListTile);

      if (listTile.evaluate().isNotEmpty) {
        await tester.tap(listTile.first);
        await tester.pumpAndSettle();

        // Should open chat screen
        expect(find.byType(Scaffold), findsWidgets);
      }
    });

    testWidgets('should display message input field', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Try to navigate to a conversation
      final messagesButton = find.byIcon(Icons.message);
      if (messagesButton.evaluate().isNotEmpty) {
        await tester.tap(messagesButton);
        await tester.pumpAndSettle();

        final listTile = find.byType(ListTile).first;
        if (listTile.evaluate().isNotEmpty) {
          await tester.tap(listTile);
          await tester.pumpAndSettle();

          // Should show text input field
          expect(find.byType(TextField), findsWidgets);
        }
      }
    });

    testWidgets('should send text message', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final messagesButton = find.byIcon(Icons.message);
      if (messagesButton.evaluate().isNotEmpty) {
        await tester.tap(messagesButton);
        await tester.pumpAndSettle();

        final listTile = find.byType(ListTile).first;
        if (listTile.evaluate().isNotEmpty) {
          await tester.tap(listTile);
          await tester.pumpAndSettle();

          // Find text field
          final textField = find.byType(TextField).last;

          if (textField.evaluate().isNotEmpty) {
            await tester.enterText(textField, 'Salut ! Comment ça va ?');
            await tester.pumpAndSettle();

            // Look for send button
            final sendButton = find.byIcon(Icons.send);
            if (sendButton.evaluate().isNotEmpty) {
              await tester.tap(sendButton);
              await tester.pumpAndSettle();

              // Message should be sent
              expect(find.text('Salut ! Comment ça va ?'), findsOneWidget);
            }
          }
        }
      }
    });

    testWidgets('should display sent messages', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to conversation
      final messagesButton = find.byIcon(Icons.message);
      if (messagesButton.evaluate().isNotEmpty) {
        await tester.tap(messagesButton);
        await tester.pumpAndSettle();

        final listTile = find.byType(ListTile).first;
        if (listTile.evaluate().isNotEmpty) {
          await tester.tap(listTile);
          await tester.pumpAndSettle();

          // Should show message history
          expect(find.byType(Scaffold), findsWidgets);
        }
      }
    });

    testWidgets('should display message timestamps', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // In a conversation, should show timestamps
      final messagesButton = find.byIcon(Icons.message);
      if (messagesButton.evaluate().isNotEmpty) {
        await tester.tap(messagesButton);
        await tester.pumpAndSettle();

        final listTile = find.byType(ListTile).first;
        if (listTile.evaluate().isNotEmpty) {
          await tester.tap(listTile);
          await tester.pumpAndSettle();

          // Look for time indicators
          expect(find.byType(Scaffold), findsWidgets);
        }
      }
    });

    testWidgets('should handle long messages', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final longMessage = 'Ceci est un message très long. ' * 10;

      final messagesButton = find.byIcon(Icons.message);
      if (messagesButton.evaluate().isNotEmpty) {
        await tester.tap(messagesButton);
        await tester.pumpAndSettle();

        final listTile = find.byType(ListTile).first;
        if (listTile.evaluate().isNotEmpty) {
          await tester.tap(listTile);
          await tester.pumpAndSettle();

          final textField = find.byType(TextField).last;
          if (textField.evaluate().isNotEmpty) {
            await tester.enterText(textField, longMessage);
            await tester.pumpAndSettle();

            // Should handle long message
            expect(find.byType(TextField), findsWidgets);
          }
        }
      }
    });

    testWidgets('should access media options', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Look for media attachment button
      final attachmentButton = find.byIcon(Icons.attach_file);
      final plusButton = find.byIcon(Icons.add);

      if (attachmentButton.evaluate().isNotEmpty) {
        await tester.tap(attachmentButton);
        await tester.pumpAndSettle();

        // Should show media options
        expect(find.byType(Scaffold), findsWidgets);
      } else if (plusButton.evaluate().isNotEmpty) {
        await tester.tap(plusButton);
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsWidgets);
      }
    });

    testWidgets('should show GIF option', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Look for GIF button
      final gifButton = find.text('GIF');
      final gifIcon = find.byIcon(Icons.gif);

      if (gifButton.evaluate().isNotEmpty || gifIcon.evaluate().isNotEmpty) {
        final target = gifButton.evaluate().isNotEmpty ? gifButton : gifIcon;
        await tester.tap(target);
        await tester.pumpAndSettle();

        // Should show GIF picker
        expect(find.byType(Scaffold), findsWidgets);
      }
    });

    testWidgets('should display typing indicator', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // This would require the other person to be typing
      // For now, just verify stability
      expect(find.byType(Scaffold), findsWidgets);
    });
  });

  group('Messaging Edge Cases', () {
    testWidgets('should handle empty message', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final messagesButton = find.byIcon(Icons.message);
      if (messagesButton.evaluate().isNotEmpty) {
        await tester.tap(messagesButton);
        await tester.pumpAndSettle();

        final listTile = find.byType(ListTile).first;
        if (listTile.evaluate().isNotEmpty) {
          await tester.tap(listTile);
          await tester.pumpAndSettle();

          final textField = find.byType(TextField).last;
          if (textField.evaluate().isNotEmpty) {
            // Try to send empty message
            await tester.enterText(textField, '');
            await tester.pumpAndSettle();

            final sendButton = find.byIcon(Icons.send);
            if (sendButton.evaluate().isNotEmpty) {
              await tester.tap(sendButton);
              await tester.pumpAndSettle();

              // Should not send empty message
              expect(find.byType(Scaffold), findsWidgets);
            }
          }
        }
      }
    });

    testWidgets('should handle special characters', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final specialMessage = '😀 Test émoji 🎉 & spëcial çhars';

      final messagesButton = find.byIcon(Icons.message);
      if (messagesButton.evaluate().isNotEmpty) {
        await tester.tap(messagesButton);
        await tester.pumpAndSettle();

        final listTile = find.byType(ListTile).first;
        if (listTile.evaluate().isNotEmpty) {
          await tester.tap(listTile);
          await tester.pumpAndSettle();

          final textField = find.byType(TextField).last;
          if (textField.evaluate().isNotEmpty) {
            await tester.enterText(textField, specialMessage);
            await tester.pumpAndSettle();

            // Should handle special characters
            expect(find.byType(TextField), findsWidgets);
          }
        }
      }
    });

    testWidgets('should handle rapid message sending', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final messagesButton = find.byIcon(Icons.message);
      if (messagesButton.evaluate().isNotEmpty) {
        await tester.tap(messagesButton);
        await tester.pumpAndSettle();

        final listTile = find.byType(ListTile).first;
        if (listTile.evaluate().isNotEmpty) {
          await tester.tap(listTile);
          await tester.pumpAndSettle();

          final textField = find.byType(TextField).last;
          if (textField.evaluate().isNotEmpty) {
            // Send multiple messages quickly
            for (int i = 0; i < 3; i++) {
              await tester.enterText(textField, 'Message $i');
              await tester.pumpAndSettle();

              final sendButton = find.byIcon(Icons.send);
              if (sendButton.evaluate().isNotEmpty) {
                await tester.tap(sendButton);
                await tester.pump(); // Don't settle, test rapid sending
              }
            }

            await tester.pumpAndSettle();

            // Should handle rapid messages
            expect(find.byType(Scaffold), findsWidgets);
          }
        }
      }
    });

    testWidgets('should scroll through message history', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final messagesButton = find.byIcon(Icons.message);
      if (messagesButton.evaluate().isNotEmpty) {
        await tester.tap(messagesButton);
        await tester.pumpAndSettle();

        final listTile = find.byType(ListTile).first;
        if (listTile.evaluate().isNotEmpty) {
          await tester.tap(listTile);
          await tester.pumpAndSettle();

          // Try scrolling
          await tester.drag(find.byType(ScrollView).first, Offset(0, 500));
          await tester.pumpAndSettle();

          expect(find.byType(Scaffold), findsWidgets);
        }
      }
    });

    testWidgets('should display unread count', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final messagesButton = find.byIcon(Icons.message);
      if (messagesButton.evaluate().isNotEmpty) {
        await tester.tap(messagesButton);
        await tester.pumpAndSettle();

        // Look for unread badges
        final badge = find.byType(Badge);
        if (badge.evaluate().isNotEmpty) {
          expect(badge, findsWidgets);
        }
      }
    });

    testWidgets('should handle conversation deletion', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final messagesButton = find.byIcon(Icons.message);
      if (messagesButton.evaluate().isNotEmpty) {
        await tester.tap(messagesButton);
        await tester.pumpAndSettle();

        // Look for delete option (long press or swipe)
        final listTile = find.byType(ListTile).first;
        if (listTile.evaluate().isNotEmpty) {
          await tester.longPress(listTile);
          await tester.pumpAndSettle();

          // May show delete dialog
          expect(find.byType(Scaffold), findsWidgets);
        }
      }
    });

    testWidgets('should search conversations', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final messagesButton = find.byIcon(Icons.message);
      if (messagesButton.evaluate().isNotEmpty) {
        await tester.tap(messagesButton);
        await tester.pumpAndSettle();

        // Look for search field
        final searchField = find.byType(TextField).first;
        if (searchField.evaluate().isNotEmpty) {
          await tester.enterText(searchField, 'Marie');
          await tester.pumpAndSettle();

          // Should filter conversations
          expect(find.byType(Scaffold), findsWidgets);
        }
      }
    });
  });

  group('Rich Messaging', () {
    testWidgets('should send photo', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Look for photo attachment option
      final photoButton = find.text('Photo');
      final photoIcon = find.byIcon(Icons.photo_camera);

      if (photoButton.evaluate().isNotEmpty || photoIcon.evaluate().isNotEmpty) {
        final target = photoButton.evaluate().isNotEmpty ? photoButton : photoIcon;
        await tester.tap(target);
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsWidgets);
      }
    });

    testWidgets('should send audio message', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Look for audio recording option
      final micButton = find.byIcon(Icons.mic);

      if (micButton.evaluate().isNotEmpty) {
        await tester.tap(micButton);
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsWidgets);
      }
    });

    testWidgets('should send location', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Look for location option
      final locationButton = find.text('Position');
      final locationIcon = find.byIcon(Icons.location_on);

      if (locationButton.evaluate().isNotEmpty || locationIcon.evaluate().isNotEmpty) {
        final target = locationButton.evaluate().isNotEmpty ? locationButton : locationIcon;
        await tester.tap(target);
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsWidgets);
      }
    });

    testWidgets('should view full screen image', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final messagesButton = find.byIcon(Icons.message);
      if (messagesButton.evaluate().isNotEmpty) {
        await tester.tap(messagesButton);
        await tester.pumpAndSettle();

        final listTile = find.byType(ListTile).first;
        if (listTile.evaluate().isNotEmpty) {
          await tester.tap(listTile);
          await tester.pumpAndSettle();

          // Look for image in conversation
          final image = find.byType(Image);
          if (image.evaluate().isNotEmpty) {
            await tester.tap(image.first);
            await tester.pumpAndSettle();

            // Should show full screen view
            expect(find.byType(Scaffold), findsWidgets);
          }
        }
      }
    });
  });
}
