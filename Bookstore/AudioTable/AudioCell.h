//
//  AudioCell
//  AudioBookFairyTale
//
//  Created by Johnny Xu(Ðì¾°ÖÜ) on 6/21/15.
//  Copyright (c) 2015 Future Studio. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ProfileInfo.h"
#import "EECircularMusicPlayerControl.h"

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f \
alpha:(a)]
#define TSNavigationBarBottomSeperatorColor RGBCOLOR(255, 207, 51)
#define TSTableViewSeperatorColor RGBCOLOR(75, 72, 72)
#define TSBackgroundColor RGBCOLOR(40, 39, 37)
#define TSTableViewCellTitleColor RGBCOLOR(172, 171, 169)
#define TSTextGrayColor RGBCOLOR(148, 147, 146)

#define TableViewRowHeight 50


@interface AudioCell : UITableViewCell
{
}

@property (strong, nonatomic) EECircularMusicPlayerControl *playButton;

- (void)setObject:(ProfileInfo *)user;
- (void)setPlayStatus:(BOOL)isOn;

@end
