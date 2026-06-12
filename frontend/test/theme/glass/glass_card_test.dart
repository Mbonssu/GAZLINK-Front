import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gazlink_app/theme/glass/glass_components.dart';
import 'package:gazlink_app/theme/glass/glass_constants.dart';

void main() {
  group('GlassCard - Task 2: Conditional Rendering', () {
    testWidgets('2.1: GlassCard detects brightness correctly in light mode',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: Brightness.light),
          home: Scaffold(
            body: GlassCard(child: Text('Test')),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify no BackdropFilter in light mode
      expect(find.byType(BackdropFilter), findsNothing);
    });

    testWidgets('2.1: GlassCard detects brightness correctly in dark mode',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: Brightness.dark),
          home: Scaffold(
            body: GlassCard(child: Text('Test')),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify BackdropFilter is present in dark mode
      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets('2.2: BackdropFilter is conditionally rendered in light mode',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: Brightness.light),
          home: Scaffold(
            body: GlassCard(child: Text('Test')),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Validates Requirement 1.1, 1.3 - No BackdropFilter in light mode
      expect(find.byType(BackdropFilter), findsNothing);
    });

    testWidgets('2.2: BackdropFilter is conditionally rendered in dark mode',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: Brightness.dark),
          home: Scaffold(
            body: GlassCard(child: Text('Test')),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Validates Requirement 1.2 - BackdropFilter present in dark mode
      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets('2.2: GlassCard uses opaque color in light mode',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: Brightness.light),
          home: Scaffold(
            body: GlassCard(child: Text('Test')),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Validates Requirement 2.1, 2.3 - Opaque surface in light mode
      final container = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer).first,
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color!.a, 1.0);
    });

    testWidgets('2.2: GlassCard uses transparent color in dark mode',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: Brightness.dark),
          home: Scaffold(
            body: GlassCard(child: Text('Test')),
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

    testWidgets('2.3: Border is preserved in light mode', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: Brightness.light),
          home: Scaffold(
            body: GlassCard(child: Text('Test')),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Validates Requirement 5.1, 5.3 - Border preserved
      final container = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer).first,
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border, isNotNull);
    });

    testWidgets('2.3: Shadow is preserved in light mode', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: Brightness.light),
          home: Scaffold(
            body: GlassCard(child: Text('Test')),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Validates Requirement 5.2, 5.3 - Shadow preserved
      final container = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer).first,
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.boxShadow, isNotEmpty);
    });

    testWidgets('2.3: AnimatedScale is preserved in light mode',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: Brightness.light),
          home: Scaffold(
            body: GlassCard(child: Text('Test')),
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

    testWidgets('2.3: AnimatedContainer is preserved in light mode',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: Brightness.light),
          home: Scaffold(
            body: GlassCard(child: Text('Test')),
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

    testWidgets('2.3: MouseRegion hover interaction works in light mode',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: Brightness.light),
          home: Scaffold(
            body: GlassCard(child: Text('Test')),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Validates Requirement 6.2 - Hover behavior preserved
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await tester.pump();
      await gesture.moveTo(tester.getCenter(find.byType(GlassCard)));
      await tester.pumpAndSettle();

      final animatedScale = tester.widget<AnimatedScale>(
        find.byType(AnimatedScale),
      );
      expect(animatedScale.scale, 1.01);
    });

    testWidgets('2.3: MouseRegion hover interaction works in dark mode',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: Brightness.dark),
          home: Scaffold(
            body: GlassCard(child: Text('Test')),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Validates Requirement 6.2 - Hover behavior identical in both modes
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await tester.pump();
      await gesture.moveTo(tester.getCenter(find.byType(GlassCard)));
      await tester.pumpAndSettle();

      final animatedScale = tester.widget<AnimatedScale>(
        find.byType(AnimatedScale),
      );
      expect(animatedScale.scale, 1.01);
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
                body: GlassCard(child: Text('Test')),
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
                body: GlassCard(child: Text('Test')),
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

    testWidgets('GlassCard maintains API compatibility', (tester) async {
      // Validates Requirement 9.1, 9.2
      final onTapCalled = <bool>[];

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: Brightness.light),
          home: Scaffold(
            body: GlassCard(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(10),
              radius: 30,
              blur: 15,
              onTap: () => onTapCalled.add(true),
              color: Colors.blue.withValues(alpha: 0.5),
              child: Text('Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify component renders without errors
      expect(find.byType(GlassCard), findsOneWidget);
      expect(find.text('Test'), findsOneWidget);

      // Verify onTap works
      await tester.tap(find.byType(GlassCard));
      expect(onTapCalled.length, 1);
    });
  });
}
