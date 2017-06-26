//
//  AbstractView
//  AudioBookFairyTale
//
//  Created by Johnny Xu(徐景周) on 6/21/15.
//  Copyright (c) 2015 Future Studio. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BookModel.h"
#import "RatingView.h"

@interface AbstractView : UIViewController<NSXMLParserDelegate>
{
    UIImageView *_iconImage;
    BookModel *_model;
}

@property (nonatomic, strong)UIImageView *icnoImage;
@property (nonatomic, strong)BookModel *model;

@end
