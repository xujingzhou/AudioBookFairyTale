#import "RatingView.h"

@implementation RatingView
- (void)dealloc{
    
}

- (CGFloat)rating{
    return _rating;
}
- (void)setRating:(CGFloat)rating{
    _rating = rating;
    CGRect rect = CGRectMake(foregroundImageView.frame.origin.x, foregroundImageView.frame.origin.y, backgroundImageView.frame.size.width*(_rating/10), foregroundImageView.frame.size.height);
    foregroundImageView.frame = rect;
}

- (UIView*)createView{
    UIImage* bgImage = [UIImage imageNamed:@"StarsBackground1.png"];
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)] ;
    
    backgroundImageView = [[UIImageView alloc] initWithImage:bgImage];
    [view addSubview:backgroundImageView];
    
    UIImage* fgImage = [UIImage imageNamed:@"StarsForeground1.png"];
    foregroundImageView = [[UIImageView alloc] initWithImage:fgImage];

    foregroundImageView.contentMode = UIViewContentModeTopLeft;
        foregroundImageView.clipsToBounds = YES;
    [view addSubview:foregroundImageView];
    
    
    return view;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView* view = [self createView];
        [self addSubview:view];
    }
    return self;
}



@end
