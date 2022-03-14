import 'package:card_stack_widget/card_stack_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_utility.dart';

void main() {
  group('CardStackWidget properties test group', () {
    test('Has an empty list of card', () {
      const widget = CardStackWidget(cardList: <CardModel>[]);
      expect(
        widget.cardList,
        isEmpty,
        reason: 'Expected empty card list!',
      );
    });

    test('Has not an empty list of card', () {
      final widget = CardStackWidget(
        cardList: <CardModel>[
          CardModel(),
        ],
      );
      expect(
        widget.cardList,
        isNotEmpty,
        reason: 'Expected not empty card list!',
      );
    });

    test('Has not the card list reversed', () {
      const reverseOrder = false;
      final first = CardModel();
      final second = CardModel();
      final widget = CardStackWidget(
        cardList: <CardModel>[
          first,
          second,
        ],
        reverseOrder: reverseOrder,
      );
      expect(
        widget.cardList.first,
        equals(first),
        reason: 'List is in reverse order!',
      );
    });

    test('Is the opacity change enabled', () {
      const widget = CardStackWidget(
        cardList: <CardModel>[],
        opacityChangeOnDrag: true,
      );

      expect(widget.opacityChangeOnDrag, isTrue);
    });
  });

  group('CardStackWidget widget test', () {
    testWidgets('Create test widget successfully', (tester) async {
      final first = CardModel();

      final widget = CardStackWidget(
        cardList: <CardModel>[
          first,
        ],
      );

      await tester.pumpWidget(
        TestApp(
          child: widget,
        ),
      );

      expect(find.byWidget(widget), isNotNull);
    });

    testWidgets('Has the card list reversed', (tester) async {
      const reverseOrder = true;
      const keyParent = Key('CardStackWidget');
      const keyFirst = Key('CardModel1');
      const keySecond = Key('CardModel2');

      final first = CardModel(key: keyFirst);
      final second = CardModel(key: keySecond);

      await tester.pumpWidget(
        TestApp(
          child: CardStackWidget(
            key: keyParent,
            scaleFactor: 1.0,
            positionFactor: 1.0,
            cardList: <CardModel>[
              first,
              second,
            ],
            reverseOrder: reverseOrder,
          ),
        ),
      );

      final widgets = tester.widgetList(find.byType(Positioned));

      expect(
        widgets.first.key,
        equals(second.key),
        reason: 'List is not reversed!',
      );
    });

    testWidgets('Is element moved', (tester) async {
      const keyParent = Key('CardStackWidget');
      const keyFirst = Key('CardModel1');
      const keySecond = Key('CardModel2');

      final first = CardModel(
        key: keyFirst,
        child: const SizedBox(height: 300, width: 300),
      );
      final second = CardModel(
        key: keySecond,
        child: const SizedBox(height: 300, width: 300),
      );

      await tester.pumpWidget(
        TestApp(
          child: SizedBox(
            width: 1000,
            height: 1000,
            child: CardStackWidget(
              key: keyParent,
              scaleFactor: 2.0,
              positionFactor: 2.0,
              cardList: <CardModel>[
                first,
                second,
              ],
              reverseOrder: true,
            ),
          ),
        ),
      );

      final beforeDrag = tester.widget(find.byKey(keyFirst));

      await tester.drag(
        find.byKey(keyFirst),
        const Offset(0.0, 500.0),
      );
      await tester.pump(const Duration(milliseconds: 1000));

      final afterDrag = tester.widget(find.byKey(keyFirst));

      expect(
        (beforeDrag as Positioned).top,
        isNot((afterDrag as Positioned).top),
      );
    });
  });
}
