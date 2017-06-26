//
//  BookImage
//  AudioBookFairyTale
//
//  Created by Johnny Xu(徐景周) on 6/21/15.
//  Copyright (c) 2015 Future Studio. All rights reserved.
//
#import "BookImage.h"

@implementation BookImage
@synthesize bookImage=_bookImage;
@synthesize delegate;
-(void)dealloc{
   
}

- (id)initWithFrame:(CGRect)frame imageName:(NSString *)imagename
{
    if (self = [super init])
    {
        [self setBackgroundImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
        self.frame = frame;
        UITapGestureRecognizer *tapPress  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickItem:)];
        tapPress.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapPress];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressedLong:)];
        [self addGestureRecognizer:longPress];
    }
    return self;
}

- (void)clickItem:(id)sender
{
    [delegate bookImageDidClicked:self];
}

- (void) pressedLong:(UILongPressGestureRecognizer *) gestureRecognizer
{
    switch (gestureRecognizer.state)
    {
        case UIGestureRecognizerStateBegan:
            NSLog(@"长按开始");
            self.alpha = 0.5;
            break;
        case UIGestureRecognizerStateEnded:
            NSLog(@"长按结束");
            self.alpha = 1;
            break;
        case UIGestureRecognizerStateFailed:
            NSLog(@"长按失败");
            break;
        case UIGestureRecognizerStateChanged:
            NSLog(@"长按变化中");
            break;
        default:
            break;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
