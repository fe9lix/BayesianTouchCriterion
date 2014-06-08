#import "ViewController.h"
#import "BTCFinder.h"
#import "CirclesView.h"
#import "TouchPointsView.h"

@interface ViewController () <TouchPointsViewDelegate, CirclesViewDelegate>

@property (strong, nonatomic) BTCFinder *btcFinder;
@property (weak, nonatomic) IBOutlet TouchPointsView *touchPointsView;
@property (weak, nonatomic) IBOutlet CirclesView *circlesView;
@property (strong, nonatomic) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (weak, nonatomic) CALayer *selectedLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBTCFinder];
    [self setupCirclesView];
    [self setupTouchPointsView];
    [self setupLongPressGesture];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)setupBTCFinder {
    // NOTE: This doesn't work for the iPad Mini!
    // Either hard-code the PPI value for new devices or use more advanced device detection logic.
    CGFloat ppi = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 132.0f : 163.0f;
    [BTCFinder setPointsPerInch:ppi];
    
    self.btcFinder = [BTCFinder new];
}

- (void)setupCirclesView {
    self.circlesView.delegate = self;
}

- (void)setupTouchPointsView {
    self.touchPointsView.delegate = self;
}

- (void)setupLongPressGesture {
    self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(longPressGesture:)];
    self.longPressGestureRecognizer.minimumPressDuration = 0.0f;
    [self.view addGestureRecognizer:self.longPressGestureRecognizer];
}

- (void)circlesView:(CirclesView *)circlesView
       didAddCircle:(CALayer *)circleLayer {
    
    [self.btcFinder addTarget:circleLayer];
}

- (UIColor *)touchPointsView:(TouchPointsView *)touchPointsView
  colorForTouchPointAtCenter:(CGPoint)center {
    
    CALayer *targetLayer = [self.btcFinder findTargetForTouchPoint:center
                                                            inView:self.view];
    
    return targetLayer ? [UIColor colorWithCGColor:targetLayer.borderColor] : [UIColor blackColor];
}

- (void)longPressGesture:(UILongPressGestureRecognizer *)longPressGestureRecognizer {
    self.selectedLayer.backgroundColor = [UIColor clearColor].CGColor;
    
    switch (longPressGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged: {
            CGPoint point = [longPressGestureRecognizer locationInView:self.view];
            self.selectedLayer = [self.btcFinder findTargetForTouchPoint:point
                                                                  inView:self.view];
            self.selectedLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f].CGColor;
            break;
        }
        default:
            break;
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration {
    
    [self.btcFinder removeAllTargets];
    [self.circlesView setNeedsLayout];
    [self.touchPointsView setNeedsLayout];
}

@end