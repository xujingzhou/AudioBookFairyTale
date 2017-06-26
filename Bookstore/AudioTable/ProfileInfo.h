//
//  ProfileInfo
//  AudioBookFairyTale
//
//  Created by Johnny Xu(Ðì¾°ÖÜ) on 6/21/15.
//  Copyright (c) 2015 Future Studio. All rights reserved.
//
@interface ProfileInfo : NSObject
{
    
}

@property (copy, nonatomic) NSString   *name;
@property (copy, nonatomic) NSString   *iconLink;

- (id) initWithInfo:(NSString*)name andIcon:(NSString*)iconLink;

@end
