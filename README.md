# 📦 card_stack_widget

A vertical dismissible and customizable stack of cards for a Flutter application.

## Usage

`CardStackWidget` requires a list of `CardModel`, in order to create a stack of cards. You can
customize their swipe or dismiss orientation, change the scale or the position factor. You can also
apply an opacity, that change on drag movement.

Below, you can find an example of the usage of `CardStackWidget` and `CardModel`:

```dart
CardStackWidget _buildCardStackWidget(BuildContext context) {
  final mockList = _buildMockList(context, size: 4);

  return CardStackWidget(
    opacityChangeOnDrag: true,
    swipeOrientation: CardOrientation.both,
    cardDismissOrientation: CardOrientation.both,
    positionFactor: 3,
    scaleFactor: 1.5,
    alignment: Alignment.center,
    reverseOrder: true,
    cardList: mockList,
  );
}

/// Create a mock list of `CardModel` to use inside `CardStackWidget`
_buildMockList(BuildContext context, {int size = 0}) {
  final double containerWidth = MediaQuery
      .of(context)
      .size
      .width - 16;

  var list = <CardModel>[];
  for (int i = 0; i < size; i++) {
    var color = Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0)
        .withOpacity(1.0);

    list.add(
      CardModel(
        backgroundColor: color,
        radius: 8,
        shadowColor: Colors.black.withOpacity(0.2),
        child: SizedBox(
          height: 310,
          width: containerWidth,
          child: Container(), // Whatever you want
        ),
      ),
    );
  }

  return list;
}
```

## Preview

<img src="https://github.com/federicoviceconti/card_stack_widget/blob/master/example/gif/change_example_1.gif?raw=true" alt="GIF example card widget 1" width="200">

<img src="https://github.com/federicoviceconti/card_stack_widget/blob/master/example/gif/change_example_2.gif?raw=true" alt="GIF example card widget 2" width="200">

## 🚀 Supported properties

**CardStackWidget**:
- cardList: List of CardModel
- cardDismissOrientation: CardOrientation (enum)
- reverseOrder: bool
- alignment: Alignment
- scaleFactor: double
- positionFactor: double
- swipeOrientation: CardOrientation (enum)
- opacityChangeOnDrag: bool

**CardModel**:
- key: Key
- shadowColor: Color
- backgroundColor: Color
- radius: Radius
- child: Widget

🚧 Roadmap
* Adding animation for cards in list
