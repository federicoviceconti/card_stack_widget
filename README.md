# CardStackWidget
A vertical dismissable stack of cards for a Flutter application. The widget provided is **_CardStackWidget_**. You can customize the position and scale factor of the card list with the property *positionFactor* and *scaleFactor*.

#### Supported properties
**CardStackWidget**
| Property | Type |
| ------ | ------ |
| cardList | List<CardModel> |
| cardDismissOrientation | DismissOrientation (enum) |
| reverseOrder | bool |
| alignment | Alignment |
| scaleFactor | double |
| positionFactor | double |

**CardModel**
| Property | Type |
| ------ | ------ |
| cardList | List<CardModel> |
| shadowColor | Color |
| backgroundColor | Color |
| radius | double |
| child | Widget |

<img src="https://github.com/federicoviceconti/CardStackWidget/blob/master/screenshots/example.png" alt="example card widget" width="200">

