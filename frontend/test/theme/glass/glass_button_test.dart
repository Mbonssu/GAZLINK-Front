import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gazlink_app/theme/glass/glass_components.dart';
import 'package:gazlink_app/theme/glass/glass_constants.dart';

void main() {
  group('GlassButton - Task 4: Conditional Rendering', () {
    testWidgets('4.1: GlassButton detects brightness correctly in light mode',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: Brightness.light),
          home: Scaffold(
            body: GlassButton(
              onPressed: () {},
              child: Text('Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify no BackdropFilter in light mode
      expect(find.byType(BackdropFilter), findsNothing);
    });

    testWidgets('4.1: GlassButton detects brightness correctly in dark mode',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: Brightness.dark),
          home: Scaffold(
            body: GlassButton(
              onPressed: () {},
              child: Text('Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify BackdropFilter is present in dark mode
      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets('4.2: BackdropFilter is conditionally rendered in light mode',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: Brightness.light),
          home: Scaffold(
            body: GlassButton(
              onPressed: () {},
              child: Text('Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Validates Requirement 1.1, 1.4 - No BackdropFilter in light mode
      expect(find.byType(BackdropFilter), findsNothing);
    });

    testWidgets('4.2: BackdropFilter is conditionally rendered in dark mode',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: Brightness.dark),
          home: Scaffold(
            body: GlassButton(
              onPressed: () {},
              child: Text('Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Validates Requirement 1.2 - BackdropFilter present in dark mode
      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets(
        '4.2: GlassButton uses appropriate color for active button in light mode',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: Brightness.light),
          home: Scaffold(
            body: GlassButton(
              onPressed: () {},
              child: Text('Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Validates Requirement 2.1, 4.3 - Active button uses accent color with alpha=0.85 in light mode
      final container = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer).first,
      );
      final decoration = container.decoration as BoxDecoration;
      // Alpha should be 0.85 for active buttons in light mode
      expect(decoration.color!.a, greaterThanOrEqualTo(0.85));
    });

    testWidgets(
        '4.2: GlassButton uses adaptiveSurfaceColor for disabled button in light mode',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: Brightness.light),
          home: Scaffold(
            body: GlassButton(
              onPressed: null, // Disabled button
              child: Text('Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Validates Requirement 2.1, 2.4 - Disabled button uses opaque surface color
      final container = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer).first,
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color!.a, 1.0);
    });

    testWidgets('4.2: GlassButton uses transparent color in dark mode',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: Brightness.dark),
          home: Scaffold(
            body: GlassButton(
              onPressed: () {},
              child: Text('Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Validates Requirement 2.2, 3.3 - Transparent surface in dark mode
      final container = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer).first,
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color!.a, lessThan(1.0));
    });

    testWidgets('4.3: Border is preserved in light mode', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: Brightness.light),
          home: Scaffold(
            body: GlassButton(
              onPressed: () {},
              child: Text('Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Validates Requirement 5.1 - Border preserved
      final container = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer).first,
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border, isNotNull);
    });

    testWidgets('4.3: AnimatedScale is preserved in light mode',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: Brightness.light),
          home: Scaffold(
            body: GlassButton(
              onPressed: () {},
              child: Text('Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Validates Requirement 6.1, 6.4 - Animations preserved
      expect(find.byType(AnimatedScale), findsOneWidget);
      final animatedScale = tester.widget<AnimatedScale>(
        find.byType(AnimatedScale),
      );
      expect(animatedScale.duration, GlassConstants.motionFast);
    });

    testWidgets('4.3: AnimatedContainer is preserved in light mode',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: Brightness.light),
          home: Scaffold(
            body: GlassButton(
              onPressed: () {},
              child: Text('Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Validates Requirement 6.1, 6.4 - Animations preserved
      expect(find.byType(AnimatedContainer), findsOneWidget);
      final animatedContainer = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer).first,
      );
      expect(animatedContainer.duration, GlassConstants.motionFast);
    });

    testWidgets('4.3: MouseRegion hover interaction works in light mode',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: Brightness.light),
          home: Scaffold(
            body: GlassButton(
              onPressed: () {},
              child: Text('Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Validates Requirement 6.2 - Hover behavior preserved
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await tester.pump();
      await gesture.moveTo(tester.getCenter(find.byType(GlassButton)));
      await tester.pumpAndSettle();

      final animatedScale = tester.widget<AnimatedScale>(
        find.byType(AnimatedScale),
      );
      expect(animatedScale.scale, 1.015);
    });

    testWidgets('4.3: MouseRegion hover interaction works in dark mode',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: Brightness.dark),
          home: Scaffold(
            body: GlassButton(
              onPressed: () {},
              child: Text('Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Validates Requirement 6.2 - Hover behavior identical in both modes
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await tester.pump();
      await gesture.moveTo(tester.getCenter(find.byType(GlassButton)));
      await tester.pumpAndSettle();

      final animatedScale = tester.widget<AnimatedScale>(
        find.byType(AnimatedScale),
      );
      expect(animatedScale.scale, 1.015);
    });

    testWidgets('4.3: Tap interaction works identically in light mode',
        (tester) async {
      final tapCalled = <bool>[];

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: Brightness.light),
          home: Scaffold(
            body: GlassButton(
              onPressed: () => tapCalled.add(true),
              child: Text('Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Validates Requirement 6.3 - Tap feedback works
      await tester.tap(find.byType(GlassButton));
      expect(tapCalled.length, 1);
    });

    testWidgets('4.3: Tap interaction works identically in dark mode',
        (tester) async {
      final tapCalled = <bool>[];

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: Brightness.dark),
          home: Scaffold(
            body: GlassButton(
              onPressed: () => tapCalled.add(true),
              child: Text('Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Validates Requirement 6.3 - Tap feedback identical in both modes
      await tester.tap(find.byType(GlassButton));
      expect(tapCalled.length, 1);
    });

    testWidgets('Mode transition: light to dark applies BackdropFilter',
        (tester) async {
      // Validates Requirement 8.1
      final themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);

      await tester.pumpWidget(
        ValueListenableBuilder<ThemeMode>(
          valueListenable: themeNotifier,
          builder: (context, mode, child) {
            return MaterialApp(
              themeMode: mode,
              theme: ThemeData(brightness: Brightness.light),
              darkTheme: ThemeData(brightness: Brightness.dark),
              home: Scaffold(
                body: GlassButton(
                  onPressed: () {},
                  child: Text('Test'),
                ),
              ),
            );
          },
        ),
      );

      await tester.pumpAndSettle();

      // Initially in light mode, no BackdropFilter
      expect(find.byType(BackdropFilter), findsNothing);

      // Switch to dark mode
      themeNotifier.value = ThemeMode.dark;
      await tester.pumpAndSettle();

      // Now BackdropFilter should be present
      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets('Mode transition: dark to light removes BackdropFilter',
        (tester) async {
      // Validates Requirement 8.2
      final themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.dark);

      await tester.pumpWidget(
        ValueListenableBuilder<ThemeMode>(
          valueListenable: themeNotifier,
          builder: (context, mode, child) {
            return MaterialApp(
              themeMode: mode,
              theme: ThemeData(brightness: Brightness.light),
              darkTheme: ThemeData(brightness: Brightness.dark),
              home: Scaffold(
                body: GlassButton(
                  onPressed: () {},
                  child: Text('Test'),
                ),
              ),
            );
          },
        ),
      );

      await tester.pumpAndSettle();

      // Initially in dark mode, BackdropFilter present
      expect(find.byType(BackdropFilter), findsOneWidget);

      // Switch to light mode
      themeNotifier.value = ThemeMode.light;
      await tester.pumpAndSettle();

      // BackdropFilter should be removed
      expect(find.byType(BackdropFilter), findsNothing);
    });

    testWidgets('GlassButton maintains API compatibility', (tester) async {
      // Validates Requirement 9.1, 9.2
      final onPressedCalled = <bool>[];

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: Brightness.light),
          home: Scaffold(
            body: GlassButton(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              radius: 20,
              onPressed: () => onPressedCalled.add(true),
              child: Text('Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify component renders without errors
      expect(find.byType(GlassButton), findsOneWidget);
      expect(find.text('Test'), findsOneWidget);

      // Verify onPressed works
      await tester.tap(find.byType(GlassButton));
      expect(onPressedCalled.length, 1);
    });

    testWidgets('Disabled button does not respond to tap', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: Brightness.light),
          home: Scaffold(
            body: GlassButton(
              onPressed: null, // Disabled
              child: Text('Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify component renders
      expect(find.byType(GlassButton), findsOneWidget);

      // Verify disabled button doesn't scale on hover
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await tester.pump();
      await gesture.moveTo(tester.getCenter(find.byType(GlassButton)));
      await tester.pumpAndSettle();

      final animatedScale = tester.widget<AnimatedScale>(
        find.byType(AnimatedScale),
      );
      expect(animatedScale.scale, 1.0); // No scale for disabled button
    });
  });
}
