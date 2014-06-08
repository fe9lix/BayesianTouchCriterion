#import <UIKit/UIKit.h>

@protocol CirclesViewDelegate;

@interface CirclesView : UIView

@property (weak, nonatomic) id<CirclesViewDelegate> delegate;

@end

@protocol CirclesViewDelegate <NSObject>

- (void)circlesView:(CirclesView *)circlesView didAddCircle:(CALayer *)circleLayer;

@end