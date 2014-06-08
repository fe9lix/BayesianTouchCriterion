#import "CirclesView.h"

static CGFloat const CircleRadius = 40.0f;
static CGFloat const CenterRadius = 110.0f;

@implementation CirclesView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)setup {
    self.backgroundColor = [UIColor clearColor];
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    
    [self removeAllCircles];
    [self addCenterCircle];
    [self addCircles];
}

- (void)addCenterCircle {
    CALayer *centerCircle = [CALayer layer];
    centerCircle.bounds = CGRectMake(0.0f,
                                     0.0f,
                                     (CenterRadius - CircleRadius) * 2.0f,
                                     (CenterRadius - CircleRadius) * 2.0f);
    centerCircle.position = self.layer.position;
    centerCircle.borderColor = [[UIColor grayColor] CGColor];
    centerCircle.borderWidth = 4.0f;
    centerCircle.cornerRadius = CenterRadius - CircleRadius;
    
    [self.layer addSublayer:centerCircle];
    
    [self.delegate circlesView:self
                  didAddCircle:centerCircle];
}

- (void)addCircles {
    NSArray *colors = @[[UIColor orangeColor],
                        [UIColor yellowColor],
                        [UIColor greenColor],
                        [UIColor cyanColor],
                        [UIColor blueColor],
                        [UIColor purpleColor],
                        [UIColor magentaColor],
                        [UIColor redColor]];
    
    for (NSInteger i = 0; i < [colors count]; i++) {
        UIColor *color = colors[i];
        [self addCircleWithColor:color
                         atIndex:i];
    }
    
    self.layer.position = CGPointMake(self.bounds.size.width * 0.5f,
                                      self.bounds.size.height * 0.5f);
}

- (void)addCircleWithColor:(UIColor *)color
                   atIndex:(NSInteger)index {
    
    CALayer *circleLayer = [CALayer layer];
    circleLayer.borderColor = [color CGColor];
    circleLayer.borderWidth = 4.0f;
    circleLayer.bounds = CGRectMake(0.0f,
                                    0.0f,
                                    CircleRadius * 2.0f,
                                    CircleRadius * 2.0f);
    circleLayer.cornerRadius = CircleRadius;
    circleLayer.position = [self positionAtAngle:45.0f * index];
    
    [self.layer addSublayer:circleLayer];
    
    [self.delegate circlesView:self
                  didAddCircle:circleLayer];
}

- (CGPoint)positionAtAngle:(CGFloat)degrees {
    CGFloat radians = degrees * M_PI / 180;
    
    return CGPointMake(floor(self.center.x + (CenterRadius * cos(radians))),
                       floor(self.center.y + (CenterRadius * sin(radians))));
}

- (void)removeAllCircles {
    NSArray *circleLayers = [self.layer.sublayers copy];
    for (CALayer *circleLayer in circleLayers) {
        [circleLayer removeFromSuperlayer];
    }
    self.layer.sublayers = nil;
}

@end