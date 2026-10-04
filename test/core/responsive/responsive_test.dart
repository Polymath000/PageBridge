import 'package:flutter_test/flutter_test.dart';
import 'package:pagebridge/core/responsive/responsive_scale.dart';
import 'package:pagebridge/core/responsive/window_size.dart';
import 'package:pagebridge/core/responsive/clamped_text_scaler.dart';
import 'package:flutter/widgets.dart';

void main() {
  group('WindowSize', () {
    test('fromWidth maps correctly', () {
      expect(WindowSize.fromWidth(500), WindowSize.compact);
      expect(WindowSize.fromWidth(600), WindowSize.medium);
      expect(WindowSize.fromWidth(839), WindowSize.medium);
      expect(WindowSize.fromWidth(840), WindowSize.expanded);
      expect(WindowSize.fromWidth(1200), WindowSize.expanded);
    });

    test('isCompact getter', () {
      expect(WindowSize.compact.isCompact, isTrue);
      expect(WindowSize.medium.isCompact, isFalse);
      expect(WindowSize.expanded.isCompact, isFalse);
    });

    test('columns getter', () {
      expect(WindowSize.compact.columns, 1);
      expect(WindowSize.medium.columns, 2);
      expect(WindowSize.expanded.columns, 3);
    });
  });

  group('ResponsiveScale', () {
    test('uses phone design for compact width', () {
      final size = ResponsiveScale.designSizeFor(const Size(400, 800));
      expect(size.width, 360);
      expect(size.height, 690);
    });

    test('uses phone design for compact landscape (by shortestSide)', () {
      final size = ResponsiveScale.designSizeFor(const Size(800, 400));
      expect(size.width, 690);
      expect(size.height, 360);
    });

    test('uses tablet design for medium/expanded width', () {
      final size = ResponsiveScale.designSizeFor(const Size(800, 1000));
      expect(size.width, 768);
      expect(size.height, 1024);
    });
  });

  group('ClampedTextScaler', () {
    testWidgets('clamps text scale at bounds', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(0.5)),
          child: Builder(
            builder: (context) {
              return ClampedTextScaler(
                child: Builder(
                  builder: (innerContext) {
                    final mq = MediaQuery.of(innerContext);
                    expect(
                      mq.textScaler.scale(10),
                      closeTo(10 * ClampedTextScaler.minScale, 0.01),
                    );
                    return const SizedBox();
                  },
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
          child: Builder(
            builder: (context) {
              return ClampedTextScaler(
                child: Builder(
                  builder: (innerContext) {
                    final mq = MediaQuery.of(innerContext);
                    expect(
                      mq.textScaler.scale(10),
                      closeTo(10 * ClampedTextScaler.maxScale, 0.01),
                    );
                    return const SizedBox();
                  },
                ),
              );
            },
          ),
        ),
      );
    });
  });
}
