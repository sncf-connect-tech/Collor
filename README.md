<br/>
<p align="center"><img src="https://raw.githubusercontent.com/voyages-sncf-technologies/Collor/master/resources/logo.png" alt="Collor logo"></p>

[![CI Status](https://travis-ci.org/voyages-sncf-technologies/Collor.svg?branch=master)](https://travis-ci.org/voyages-sncf-technologies/Collor/)
[![Coverage Status](https://coveralls.io/repos/github/voyages-sncf-technologies/Collor/badge.svg?branch=master)](https://coveralls.io/github/voyages-sncf-technologies/Collor?branch=master)
[![Version](https://img.shields.io/cocoapods/v/Collor.svg?style=flat)](http://cocoapods.org/pods/Collor)
[![License](https://img.shields.io/cocoapods/l/Collor.svg?style=flat)](http://cocoapods.org/pods/Collor)
[![Platform](https://img.shields.io/cocoapods/p/Collor.svg?style=flat)](http://cocoapods.org/pods/Collor)

## About

Collor is a MVVM data-oriented framework for accelerating, simplifying and ensuring UICollectionView building.<br>
Collor was created for and improved in the Voyages-sncf.com app.

## Features

Here is the list of all the features:
- [x] Easy to use.
- [x] A readable collectionView model.
- [x] Architectured for reusing cell.
- [x] Protocol / Struct oriented.
- [x] Scalable.
- [x] Never use ```IndexPath```.
- [x] Never register a cell.
- [x] Update the collectionView model easily.
- [x] Diffing data or section(s)
- [x] 🆕 **Diffing handles *deletes*, *inserts*, *moves* and *updates***
- [x] 🆕 **Manage decoration views in our custom layout easily.**
- [x] Make easier building custom layout.
- [x] Swift 4 (use 1.0.x for swift 3 compatibility).
- [x] Well tested.

<p align="center"><img src="https://raw.githubusercontent.com/voyages-sncf-technologies/Collor/master/resources/random.gif" alt="Collor Random Sample"> <img src="https://raw.githubusercontent.com/voyages-sncf-technologies/Collor/master/resources/weather.gif" alt="Collor Weather Sample"></p>


## Getting started
- A [medium article](https://medium.com/p/b55e73d81a59/) which explains the purpose and how to use Collor.
- Another [medium article](https://medium.com/p/8f37064de388/) to understand the diffing feature.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.<br>
There are 4 examples:
- Menu : Simple collectionView with userEvent propagation example
- Random : Diffing entire data + custom layout
- Weather : Diffing sections + custom layout
- Pantone : Adding and remove items using CollectionDatas.
- RealTime : Complex diffing (insert, delete, reload) + custom layout handling with `DecorationViewHandler`.

## Usage

The UICollectionView is represented by a collectionData object which contains sectionDescriptors which contain themself cellDescriptors.
Each item or cell in Collor is composed by 3 objects:
- The ```UICollectionViewCell``` (XIB + swift file) which implements ```CollectionCellAdaptable```
- A cellDescriptor which implements ```CollectionCellDescribable```
- An adapter (view model) which implements ```CollectionAdapter```

##### CellDescriptor
It describes the cell and is the link between the cell and the viewModel. Logically, one type of cell needs only one cellDescriptor. It owns the cell identifier, the cell className and handles the size of the cell.
The collectionData handles cell registering and dequeuing using these properties.
```swift
final class WeatherDayDescriptor: CollectionCellDescribable {

    let identifier: String = "WeatherDayCollectionViewCell"
    let className: String = "WeatherDayCollectionViewCell"
    var selectable:Bool = false

    let adapter: WeatherDayAdapter

    init(adapter:WeatherDayAdapter) {
        self.adapter = adapter
    }

    func size(_ collectionView: UICollectionView, sectionDescriptor: CollectionSectionDescribable) -> CGSize {
        let sectionInset = sectionDescriptor.sectionInset(collectionView)
        let width:CGFloat = collectionView.bounds.width - sectionInset.left - sectionInset.right
        return CGSize(width:width, height:60)
    }

    public func getAdapter() -> CollectionAdapter {
        return adapter
    }
}
```

##### Adapter
An adapter is a viewModel object. It transforms your model in a human readable data used by the cell.
```swift
struct WeatherDayAdapter: CollectionAdapter {

    let date:NSAttributedString

    static let dateFormatter:DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "EEEE d MMMM"
        return df
    }()

    init(day:WeatherDay) {

        let dateString = WeatherDayAdapter.dateFormatter.string(from: day.date)
        date = NSAttributedString(string: dateString, attributes: [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18),
            NSForegroundColorAttributeName: UIColor.black
        ])
    }
}
```

When a cell is dequeued, the collectionData updates the cell with this object.
```swift
final class WeatherDayCollectionViewCell: UICollectionViewCell, CollectionCellAdaptable {
  @IBOutlet weak var label: UILabel!

  func update(with adapter: CollectionAdapter) {
        guard let adapter = adapter as? WeatherDayAdapter else {
            fatalError("WeatherDayAdapter required")
        }
        label.attributedText = adapter.date
    }
}
```
##### ViewController

Create the dataSource and the delegate:

```swift
lazy var collectionViewDelegate: CollectionDelegate = CollectionDelegate(delegate: self)
lazy var collectionViewDatasource: CollectionDataSource = CollectionDataSource(delegate: self)
```

Create the collectionData:
```swift
let collectionData = MyCollectionData()
```

Bind the collectionView with the data, the datasource and the delegate:
```swift
bind(collectionView: collectionView, with: collectionData, and: collectionViewDelegate, and: collectionViewDatasource)
```

Create a section and one cell in the collectionData:
```swift
final class MyCollectionData : CollectionData {

    override func reloadData() {
        super.reloadData()

        let section = MySectionDescriptor().reloadSection { (cells) in
                let cell = MyColorDescriptor(adapter: MyColorAdapter(model: "someThing"))
                cells.append(cell)
            })
        }
        sections.append(section)
    }
}
```

MySectionDescriptor:
```swift
final class MySectionDescriptor : CollectionSectionDescribable {

  func sectionInset(_ collectionView: UICollectionView) -> UIEdgeInsets {
      return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
  }
}
```

You get a readable data which represents your UICollectionView, without code duplication, reusing cell and with a good separation of code.

## Diffing and updating

Collor provides some features to easily update your collectionData.
##### Updating
Just append or remove cells or sections using ```CollectionData.update(_:)``` method. This means an end to fiddling around with ```IndexPath```:
```swift
let newCellDescriptor = NewCellDescriptor(...)
let result = collectionData.update { updater in
    updater.append(cells: [newCellDescriptor], after: anotherCellDescriptor)
}
collectionView.performUpdates(with: result)
```
Here is the list of all update methods available:
- append(cells:after:)
- append(cells:before:)
- append(cells:in:)
- remove(cells:)
- reload(cells:)
- append(sections:after:)
- append(sections:before:)
- append(sections:)
- remove(sections:)
- reload(sections:)


##### Diffing
Collor is using a home made algorithm for getting the "diff" between two updates of your collectionData.
- Diffing some sections:

```swift
sectionDescriptor.isExpanded = !sectionDescriptor.isExpanded
let result = collectionData.update{ updater in
    updater.diff(sections: [sectionDescriptor])
}
collectionView.performUpdates(with: result)
```
- Diffing entire data

```swift
model.someUpdates()
let result = collectionData.update { updater in
    collectionData.reload(model: model)
    updater.diff()
}
collectionView.performUpdates(with: result)
```

- Effortless management of decoration views

With `DecorationViewHandler`, you no longer need to implement code to manage your decoration views:

```swift
// register decoration view or class:
decorationViewHandler.register(viewClass: SimpleDecorationView.self, for: sectionBackgroundKind)
// caching
decorationViewHandler.add(attributes: backgroundAttributes)
// compute elements in rect
decorationViewHandler.attributes(in:rect)
// retrieving
decorationViewHandler.attributes(for: elementKind, at: atIndexPath)
// update handling
decorationViewHandler.prepare(forCollectionViewUpdates: updateItems)
return decorationViewHandler.inserted(for: elementKind)
return decorationViewHandler.deleted(for: elementKind)
```

<p align="center"><img src="https://raw.githubusercontent.com/voyages-sncf-technologies/Collor/master/resources/realtime.gif" alt="Collor Realtime Sample"></p>


For more information, have a look at this [medium article](https://medium.com/p/8f37064de388/).

## XCTemplates

Collor is published with 3 xctemplates for helping you creating ViewController, SectionDescriptor and CellDescriptor.

To install them, just go in xctemplates directory and run this command in a terminal:
```shell
sh install.sh
```

<p align="center"><img src="https://raw.githubusercontent.com/voyages-sncf-technologies/Collor/master/resources//xctemplates.png" alt="XCTemplates"></p>

## Requirements
- iOS 8.0+
- Swift 4.0+ (get the 1.0.3 release for swift3)
- Xcode 9.0+

## Installation
### CocoaPods
Collor is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Collor"
```
### Carthage
Collor doesn't yet support Carthage. Work in progress...

## Documentation

[Documentation](https://voyages-sncf-technologies.github.io/Collor/index.html)

Work in progress... 1% documented

## Credits

Collor is owned and maintained by [Voyages-sncf.com](http://www.voyages-sncf.com/).

Collor was originally created by [Gwenn Guihal](https://github.com/gwennguihal).

## License

Collor is available under the BSD license. See the LICENSE file for more info.
