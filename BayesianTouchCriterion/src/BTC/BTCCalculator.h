#import <Foundation/Foundation.h>

@interface BTCCalculator : NSObject

+ (CGFloat)pointsPerInch;
+ (void)setPointsPerInch:(CGFloat)newPointsPerInch;
+ (CGFloat)bayesianTouchDistanceWithTouchPoint:(CGPoint)touchPoint
                                  targetCenter:(CGPoint)targetCenter
                                targetDiameter:(CGFloat)targetDiameter;

@end