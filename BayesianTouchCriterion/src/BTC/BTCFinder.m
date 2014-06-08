#import "BTCFinder.h"
#import "BTCCalculator.h"

@interface BTCFinder ()

@property (strong, nonatomic) NSMutableDictionary *targets;

@end

@implementation BTCFinder

+ (CGFloat)pointsPerInch {
    return [BTCCalculator pointsPerInch];
}

+ (void)setPointsPerInch:(CGFloat)newPointsPerInch {
    [BTCCalculator setPointsPerInch:newPointsPerInch];
}

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.targets = [NSMutableDictionary dictionary];
}

- (CALayer *)findTargetForTouchPoint:(CGPoint)touchPoint
                              inView:(UIView *)touchView {
    
    CGFloat minBayesianTouchDistance = CGFLOAT_MAX;
    id minTargetLayer = nil;
    
    for (NSValue *key in self.targets) {
        CALayer *targetLayer = [self.targets objectForKey:key];
        CGPoint targetCenter = [targetLayer.superlayer convertPoint:targetLayer.position
                                                            toLayer:touchView.layer];
        CGFloat targetDiameter = targetLayer.bounds.size.width;
        
        CGFloat bayesianTouchDistance = [BTCCalculator bayesianTouchDistanceWithTouchPoint:touchPoint
                                                                              targetCenter:targetCenter
                                                                            targetDiameter:targetDiameter];
        
        if (bayesianTouchDistance < minBayesianTouchDistance) {
            minBayesianTouchDistance = bayesianTouchDistance;
            minTargetLayer = targetLayer;
        }
    }
    
    return minTargetLayer;
}

- (void)addTarget:(CALayer *)targetLayer {
    NSValue *key = [NSValue valueWithNonretainedObject:targetLayer];
    [self.targets setObject:targetLayer
                     forKey:key];
}

- (void)removeTarget:(CALayer *)targetLayer {
    NSValue *key = [NSValue valueWithNonretainedObject:targetLayer];
    [self.targets removeObjectForKey:key];
}

- (void)removeAllTargets {
    [self.targets removeAllObjects];
}

@end