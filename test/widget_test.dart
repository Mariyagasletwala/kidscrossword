import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kidscrossword/main.dart';

void main() {
  testWidgets('App launches and shows splash screen', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const CrosswordApp());

    // Verify the splash screen is shown
    expect(find.text('KidsCrossword'), findsOneWidget);
    expect(find.text('Fun Learning for Kids!'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for splash screen to complete
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Verify home screen is shown after splash
    expect(find.text('KidsCrossword'), findsOneWidget);
    expect(find.text('Fun Learning for Kids!'), findsOneWidget);
    expect(find.byIcon(Icons.play_circle_filled), findsOneWidget);
    expect(find.byIcon(Icons.leaderboard), findsOneWidget);
    expect(find.byIcon(Icons.help_outline), findsOneWidget);
  });

  testWidgets('Home screen navigation works', (WidgetTester tester) async {
    await tester.pumpWidget(const CrosswordApp());
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Tap on "How to Play" button
    await tester.tap(find.text('How to Play'));
    await tester.pumpAndSettle();

    // Verify how to play dialog appears
    expect(find.text('How to Play'), findsOneWidget);
    expect(find.text('Select a difficulty level to start the game.'), findsOneWidget);

    // Close the dialog
    await tester.tap(find.text('Got it!'));
    await tester.pumpAndSettle();
    expect(find.text('How to Play'), findsNothing);

    // Tap on "Play" button
    await tester.tap(find.text('Play'));
    await tester.pumpAndSettle();

    // Verify difficulty dialog appears
    expect(find.text('Choose Difficulty'), findsOneWidget);
    expect(find.text('Easy'), findsOneWidget);
    expect(find.text('Medium'), findsOneWidget);
    expect(find.text('Hard'), findsOneWidget);
  });

  testWidgets('Game screen loads with selected difficulty', (WidgetTester tester) async {
    // This would require more setup to mock navigation and test the game screen
    // For now, we'll just verify the basic navigation
    await tester.pumpWidget(const CrosswordApp());
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Tap on "Play" button
    await tester.tap(find.text('Play'));
    await tester.pumpAndSettle();

    // Select easy difficulty
    await tester.tap(find.text('Easy'));
    await tester.pumpAndSettle();

    // Verify game screen appears with correct difficulty
    expect(find.text('EASY CROSSWORD'), findsOneWidget);
    expect(find.byType(GameScreen), findsOneWidget);
  });
}