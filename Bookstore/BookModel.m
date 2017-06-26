//
//  BookModel
//  AudioBookFairyTale
//
//  Created by Johnny Xu(Ðì¾°ÖÜ) on 6/21/15.
//  Copyright (c) 2015 Future Studio. All rights reserved.
//
#import "BookModel.h"

@implementation BookModel
@synthesize bookName = _bookName;
@synthesize iconUrl = _iconUrl;
@synthesize publisher = _publisher;
@synthesize price = _price;
@synthesize numRatings = _numRatings;
@synthesize rating = _rating;
@synthesize autherName = _autherName;
@synthesize pubdate = _pubdate;
@synthesize translator = _translator;
@synthesize introUrl = _introUrl;

- (void)dealloc
{

}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@end
