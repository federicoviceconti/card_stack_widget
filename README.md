# 📦 card_stack_widget

A vertical dismissible stack of cards for a Flutter application. The widget provided is
**_CardStackWidget_**. You can customize the position and scale factor of the card list with the
property *positionFactor* and *scaleFactor*.

### 🚀 Supported properties

**CardStackWidget**
| Property | Type |
| ------ | ------ |
| cardList | List of CardModel |
| cardDismissOrientation | SwipeOrientation (enum) |
| reverseOrder | bool |
| alignment | Alignment |
| scaleFactor | double |
| positionFactor | double |
| swipeOrientation | SwipeOrientation (enum) |

**CardModel**
| Property | Type |
| ------ | ------ |
| shadowColor | Color |
| backgroundColor | Color |
| radius | double |
| child | Widget |

Example:

<img src="https://github.com/federicoviceconti/card_stack_widget/blob/master/example/screenshots/example.png" alt="example card widget" width="200">
