// Calculation of the Bayesian Touch Criterion based on the paper:
// http://research.google.com/pubs/archive/41644.pdf

#import "BTCCalculator.h"

static CGFloat pointsPerInch = 0.0f;
static CGFloat pixelsPerInch = 0.0f;

@implementation BTCCalculator

+ (CGFloat)bayesianTouchDistanceWithTouchPoint:(CGPoint)touchPoint
                                  targetCenter:(CGPoint)targetCenter
                                targetDiameter:(CGFloat)targetDiameter {
    
    NSAssert(pointsPerInch != 0.0f,
             @"pointsPerInch not set!");
    
    CGFloat sx = [self pointsToMillimeters:touchPoint.x];
    CGFloat sy = [self pointsToMillimeters:touchPoint.y];
    CGFloat cx = [self pointsToMillimeters:targetCenter.x];
    CGFloat cy = [self pointsToMillimeters:targetCenter.y];
    CGFloat d = [self pointsToMillimeters:targetDiameter];
    CGFloat d2 = d * d;
    
    CGFloat btd =
    (0.5f * ((((sx - cx) * (sx - cx)) / ((0.0075 * d2) + 1.68f)) +
             (((sy - cy) * (sy - cy)) / ((0.0108f * d2) + 1.33f)))) +
    (0.5f * log((0.0075f * d2) + 1.68f)) +
    (0.5f * log((0.0108f * d2) + 1.33f));
    
    return [self millimetersToPoints:btd];
}

+ (CGFloat)pointsToMillimeters:(CGFloat)points {
    CGFloat onePointInMillimeters = (1.0f / pixelsPerInch) * 25.4f;
    return onePointInMillimeters * points;
}

+ (CGFloat)millimetersToPoints:(CGFloat)millimeters {
    CGFloat oneMillimeterInPoints = pixelsPerInch / 25.4f;
    return oneMillimeterInPoints * millimeters;
}

+ (CGFloat)pointsPerInch {
    return pointsPerInch;
}

+ (void)setPointsPerInch:(CGFloat)newPointsPerInch {
    pointsPerInch = newPointsPerInch;
    pixelsPerInch = [UIScreen mainScreen].scale * pointsPerInch;
}

@end