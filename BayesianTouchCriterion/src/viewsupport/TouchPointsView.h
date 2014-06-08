#import <UIKit/UIKit.h>

@protocol TouchPointsViewDelegate;

@interface TouchPointsView : UIView

@property (weak, nonatomic) id<TouchPointsViewDelegate> delegate;

@end

@protocol TouchPointsViewDelegate <NSObject>

- (UIColor *)touchPointsView:(TouchPointsView *)touchPointsView colorForTouchPointAtCenter:(CGPoint)center;

@end
