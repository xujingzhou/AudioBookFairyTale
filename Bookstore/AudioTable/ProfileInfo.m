//
//  ProfileInfo
//  AudioBookFairyTale
//
//  Created by Johnny Xu(Ðì¾°ÖÜ) on 6/21/15.
//  Copyright (c) 2015 Future Studio. All rights reserved.
//
#import "ProfileInfo.h"

@interface ProfileInfo ()
{
}

@end

@implementation ProfileInfo

@synthesize name = _name;
@synthesize iconLink = _iconLink;

- (id) initWithInfo:(NSString*)name andIcon:(NSString*)iconLink
{
    self = [super init];
    
    if(self)
    {
        _name = name;
        _iconLink = iconLink;
    }
    return self;
}

@end
