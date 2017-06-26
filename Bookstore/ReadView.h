//
//  ReadView
//  AudioBookFairyTale
//
//  Created by Johnny Xu(徐景周) on 6/21/15.
//  Copyright (c) 2015 Future Studio. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "TOLAdViewController.h"

@interface ReadView : TOLAdViewController<UITextViewDelegate, UIGestureRecognizerDelegate>
{
    UITextView *textView;
    int currentPage;
    int allPage;
}

@property (nonatomic, strong) NSString *bookPath;

@end
