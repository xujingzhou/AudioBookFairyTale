#import <UIKit/UIKit.h>

@interface RatingView : UIView
{
    UIImageView* backgroundImageView;
    UIImageView* foregroundImageView;
    CGFloat _rating;
}
@property(assign, nonatomic)CGFloat rating;
@end
