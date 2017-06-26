//
//  BookCell
//  AudioBookFairyTale
//
//  Created by Johnny Xu(徐景周) on 6/21/15.
//  Copyright (c) 2015 Future Studio. All rights reserved.
//
#import "BookCell.h"

@implementation BookCell

- (void)dealloc
{
   
}

- (BookModel*)book
{
    return _book;
}

- (void)setBook:(BookModel *)book
{
    _bookNameLabel.text = _book.bookName;
    _publisherLabel.text = _book.publisher;
    _priceLabel.text = _book.price;
    _ratingView.rating = _book.rating;
    _numRatingsLabel.text = [NSString stringWithFormat:@"评论 %ld", (long)_book.numRatings];
}

- (UIView*)createView{
    UIView* content = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 72)];
    
    _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 4, 64, 64)];
    [content addSubview:_iconView];
    
    
    _bookNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(92, 25, 130, 21)];
    _bookNameLabel.font = [UIFont systemFontOfSize:15];
    _bookNameLabel.backgroundColor = [UIColor clearColor];
    [content addSubview:_bookNameLabel];

    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(225, 25, 55, 21)];
    _priceLabel.backgroundColor = [UIColor clearColor];
    _priceLabel.font = [UIFont systemFontOfSize:11];
    _priceLabel.textAlignment = UITextAlignmentRight;
    [content addSubview:_priceLabel];
    
    
    _publisherLabel = [[UILabel alloc] initWithFrame:CGRectMake(92, 4, 130, 21)];
    _publisherLabel.font = [UIFont systemFontOfSize:11];
    _publisherLabel.backgroundColor = [UIColor clearColor];
    [content addSubview:_publisherLabel];
    
    _numRatingsLabel = [[UILabel alloc] initWithFrame:CGRectMake(175, 47, 87, 21)];
    _numRatingsLabel.font = [UIFont systemFontOfSize:11];
    _numRatingsLabel.backgroundColor = [UIColor clearColor];
    [content addSubview:_numRatingsLabel];
   
    
    _ratingView = [[RatingView alloc] initWithFrame:CGRectMake(92, 49, 65, 23)];
    [content addSubview:_ratingView];

    
    return content;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView* content = [self createView];
        [self.contentView addSubview:content];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}
@end
