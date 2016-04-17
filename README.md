# ISUActionMenu

[![CI Status](http://img.shields.io/travis/Samuel/ISUActionMenu.svg?style=flat)](https://travis-ci.org/Samuel/ISUActionMenu)
[![Version](https://img.shields.io/cocoapods/v/ISUActionMenu.svg?style=flat)](http://cocoapods.org/pods/ISUActionMenu)
[![License](https://img.shields.io/cocoapods/l/ISUActionMenu.svg?style=flat)](http://cocoapods.org/pods/ISUActionMenu)
[![Platform](https://img.shields.io/cocoapods/p/ISUActionMenu.svg?style=flat)](http://cocoapods.org/pods/ISUActionMenu)

ISUActionMenu provides an interactive action menu which is similar to the actino menu used by ISSUU APP.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage

At first, import `ISUActionMenuSupport`
```
#import <ISUActionMenu/ISUActionMenuSupport.h>
```
Then just add a `ISUActionMenuGestureRecognizer` object that acts as trigger gesture for the action menu, and simply initialize the gesture as:
```
   self.ActionMenuGesture = [[ISUActionMenuGestureRecognizer alloc] init];
```
The `ISUActionMenu` is highly customizable, to meet your need, initialize the action menu as:
```
   self.ActionMenuGesture = [[ISUActionMenuGestureRecognizer alloc]
                             initWithTarget:self
                             action:@selector(handleActionMenuGesture:)
                             initializationHandler:^ISUActionMenuView * _Nonnull {
                                 ISUActionMenuView *actionMenuView = [[ISUActionMenuView alloc] init];
                                 return actionMenuView;
                             }];
```
With your customizable setting in `initializationHandler` like:
```
actionMenuView.indicatorPathColor = [UIColor redColor];
```
Further customizable property can be founded in `ISUActionMenuView.h`

## Requirements

## Installation

ISUActionMenu is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ISUActionMenu"
```

## Author

Samuel, citysite1025@gmail.com

## License

ISUActionMenu is available under the MIT license. See the LICENSE file for more info.
=======
An interactive action menu button with gesture.
>>>>>>> 2445981cd6249e5ddfca190e6143aa6afc8bd19e
