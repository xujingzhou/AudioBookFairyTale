//
//  BookCell
//  AudioBookFairyTale
//
//  Created by Johnny Xu(Ðì¾°ÖÜ) on 6/21/15.
//  Copyright (c) 2015 Future Studio. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "RatingView.h"
#import "BookModel.h"

@interface BookCell : UITableViewCell
{
    UIImageView* _iconView;
    UILabel* _priceLabel;
    UILabel* _publisherLabel;
    UILabel* _bookNameLabel;
    UILabel* _numRatingsLabel;
    RatingView* _ratingView;
    
    BookModel* _book;
}
@property(retain, nonatomic)BookModel* book;
@end
