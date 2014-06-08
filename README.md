BayesianTouchCriterion
======================

![BayesianTouchCriterion](https://github.com/fe9lix/BayesianTouchCriterion/blob/gh-pages/images/demo_app.png?raw=true)

### Bayesian Touch Criterion

*BayesianTouchCriterion* is an Objective-C implementation of the *Bayesian Target Criterion (BTC)* developed by Xiaojun Bi and Shumin Zhai. Given a touch point and some touch targets, it improves the accuracy of selections by finding the touch target with the shortest *Bayesian Touch Distance (BTD)*. This element is the one that the user intended to select. The results of the evaluation of Bi and Zhai show that selection based on *BTC* is much more precise than using the visual boundary of an element. (Visual boundary checking is how most touch frameworks determine if the finger touches a target.)

The image above shows how randomly placed touch points (the smaller, semi-transparent circles) select their corresponding targets (the nine big circles). In the user interface of a mobile app, for example, *BTC* could be used to more accurately determine which menu item the user intended to select. The point of using *BTC* instead of visual boundary checking is: The intended element is *not* necessarily the element where the user's touch lies exactly within the visual boundary of the element (e.g., the touch point might be somewhere slightly outside of the visual boundary). *BTC* has the advantage that it does not require more detailed information about the touch point (finger posture, touch area...). The only required input parameters of the formula are touch location, target center, and target diameter.

If you are interested in the full mathematical details and derivations, here's the full reference: 

> Xiaojun Bi and Shumin Zhai. Bayesian touch: A statistical criterion of target selection with finger touch. In Proceedings of the 26th Annual ACM Symposium on User Interface Software and Technology, UIST ’13, pages 51–60, New York, NY, USA, 2013. ACM.

The paper is [freely available on Research at Google](http://research.google.com/pubs/archive/41644.pdf).

### Installation

Just copy the folder `src/BayesianTouchCriterion` into your project. 

The demo project shows a simple usage example. The code creates random touch points and determines the color of each touch point based on *BTC* (see image above). It also adds some interactivity: When you touch the screen, *BTC* finds the target layer of the circle menu and sets its background color to black. 

### Usage

There are just two simple classes: `BTCCalculator` and `BTCFinder`. 

`BTCFinder` is more high-level and implements basic management for targets. Targets are of type `CALayer` (if you want to use views, just use a view's layer via `view.layer`). You can add and remove targets and find the intended target for a touch point.

Internally, `BTCFinder` uses `BTCCalculator` to calculate *BTD*. You can use `BTCCalculator` directly if you wish to implement your own logic for target management. 

It's important that you set the PPI (points per inch) value for the target device before using either `BTCFinder` or `BTCCalculator`. Since *BTC* is based on *millimeters*, the PPI value is needed to convert from millimeters to pixels per inch and vice versa. (The demo project contains simple PPI detection for current iPhones and iPads.)

### API

#### `BTCFinder`

You must set the PPI of the target device before using this class. 
Use hard-coded values or device detection logic.
```objective-c
+ (CGFloat)pointsPerInch;
+ (void)setPointsPerInch:(CGFloat)newPointsPerInch;
```

Add a `CALayer` as potential touch target, remove a layer, or remove all layers.
```objective-c
- (void)addTarget:(CALayer *)target;
- (void)removeTarget:(CALayer *)target;
- (void)removeAllTargets;
```

Find the target based on a touch point. The touch point must be located in the coordinate system of `view`. 
```objective-c
- (CALayer *)findTargetForTouchPoint:(CGPoint)touchPoint
                              inView:(UIView *)touchView;
```

#### `BTCCalculator`

You must set the PPI of the target device before using this class. 
Use hard-coded values or device detection logic.
```objective-c
+ (CGFloat)pointsPerInch;
+ (void)setPointsPerInch:(CGFloat)newPointsPerInch;
```

Calculate *BTD* based on the touch point, the center point of the target and the diameter of the target. The target with the shortest *BTD* is the intended target. (You need to add this logic yourself if you use this class directly.)

```objective-c
+ (CGFloat)bayesianTouchDistanceWithTouchPoint:(CGPoint)touchPoint
                                  targetCenter:(CGPoint)targetCenter
                                targetDiameter:(CGFloat)targetDiameter;
```

### Important Notes

- *BTC* works for circular target selection. The formula is based on target center and diameter. For objects with different shapes, you might need to check if you can use the diameter as an approximation and still achieve good results. 

- *BTC* assumes that each point selects one object on screen (i.e., it does not consider empty space between objects). You might need to add your own logic to select the final target.
