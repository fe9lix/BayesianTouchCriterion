#import <Foundation/Foundation.h>

@interface BTCFinder : NSObject

+ (CGFloat)pointsPerInch;
+ (void)setPointsPerInch:(CGFloat)newPointsPerInch;

- (CALayer *)findTargetForTouchPoint:(CGPoint)touchPoint
                              inView:(UIView *)touchView;
- (void)addTarget:(CALayer *)target;
- (void)removeTarget:(CALayer *)target;
- (void)removeAllTargets;

@end