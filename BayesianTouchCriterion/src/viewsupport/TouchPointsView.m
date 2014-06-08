#import "TouchPointsView.h"

static NSInteger const NumTouchPoints = 1000;
static CGSize const TouchPointSize = { 44.0f, 44.0f };

@implementation TouchPointsView

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
    
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    
    [self removeAllTouchPoints];
    [self addTouchPoints];
}

- (void)addTouchPoints {
    for (NSInteger i = 0; i < NumTouchPoints; i++) {
        [self addRandomTouchPoint];
    }
}

- (void)addRandomTouchPoint {
    CALayer *touchPointLayer = [CALayer layer];
    touchPointLayer.opacity = 0.1f;
    
    touchPointLayer.frame = CGRectMake(arc4random() % (NSInteger)self.bounds.size.width,
                                       arc4random() % (NSInteger)self.bounds.size.height,
                                       TouchPointSize.width,
                                       TouchPointSize.height);
    
    touchPointLayer.backgroundColor = [[self.delegate touchPointsView:self
                                           colorForTouchPointAtCenter:touchPointLayer.position] CGColor];
    touchPointLayer.cornerRadius = TouchPointSize.width * 0.5f;
    
    [self.layer addSublayer:touchPointLayer];
}

- (void)removeAllTouchPoints {
    NSArray *touchPointLayers = [self.layer.sublayers copy];
    for (CALayer *touchPointLayer in touchPointLayers) {
        [touchPointLayer removeFromSuperlayer];
    }
    self.layer.sublayers = nil;
}

@end