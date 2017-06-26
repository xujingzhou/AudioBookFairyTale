//
//  BookImage
//  AudioBookFairyTale
//
//  Created by Johnny Xu(徐景周) on 6/21/15.
//  Copyright (c) 2015 Future Studio. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BookModel.h"
@protocol BookImageDelegate;

@interface BookImage : UIButton
{
    BookModel* bookModel;
    UIImageView* _bookImage;
}
@property(nonatomic,retain)UIImageView* bookImage;
@property(strong,nonatomic)id<BookImageDelegate> delegate;
- (id)initWithFrame:(CGRect)frame imageName:(NSString *)imagename;
@end

@protocol BookImageDelegate <NSObject>

- (void) bookImageDidClicked:(BookImage *)bookImage;

@end
