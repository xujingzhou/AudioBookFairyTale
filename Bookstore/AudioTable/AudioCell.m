//
//  AudioCell
//  AudioBookFairyTale
//
//  Created by Johnny Xu(Ðì¾°ÖÜ) on 6/21/15.
//  Copyright (c) 2015 Future Studio. All rights reserved.
//
#import "AudioCell.h"

@interface AudioCell()
{
}

@property (strong, nonatomic) UIImageView *avatarView;
@property (strong, nonatomic) UILabel *userNameLabel;

@end

@implementation AudioCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.backgroundColor = TSBackgroundColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        int gap = 10, height = 40;
        _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(gap, (TableViewRowHeight-height)/2, height, height)];
        _avatarView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_avatarView];
        
        int widthButton = 35;
        _playButton = [[EECircularMusicPlayerControl alloc] initWithFrame:CGRectMake(self.frame.size.width - widthButton - gap, (TableViewRowHeight-widthButton)/2, widthButton, widthButton)];
        [_playButton setBackgroundColor:[UIColor clearColor]];
        [_playButton setUserInteractionEnabled:FALSE];
        [self.contentView addSubview:_playButton];
        _playButton.hidden = TRUE;
        
        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarView.bounds.size.width + 2*gap, (TableViewRowHeight-height)/2, self.bounds.size.width - _avatarView.bounds.size.width - _playButton.bounds.size.width, height)];
        _userNameLabel.textColor = [UIColor whiteColor];
        _userNameLabel.font = [UIFont systemFontOfSize:15.0f];
        _userNameLabel.textAlignment = NSTextAlignmentLeft;
        _userNameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_userNameLabel];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setObject:(ProfileInfo *)user
{
    if (!isStringEmpty(user.iconLink))
    {
        _avatarView.image = [UIImage imageNamed:user.iconLink];
        _avatarView.layer.cornerRadius = _avatarView.bounds.size.width/2;
        _avatarView.layer.masksToBounds = YES;
        [_avatarView.layer setBorderWidth:1];
        [_avatarView.layer setBorderColor:[UIColor whiteColor].CGColor];
        
        _playButton.hidden = FALSE;
    }
    
    if (!isStringEmpty(user.name))
    {
        NSString *fileNameWithExt = [user.name lastPathComponent];
        NSLog(@"File name with extname: %@",fileNameWithExt);
        NSString *fileName = [user.name stringByDeletingPathExtension];
        NSLog(@"File name: %@",fileName);
        NSString *fileExt = [user.name pathExtension];
        NSLog(@"File ExtName: %@",fileExt);
        
        _userNameLabel.text = fileName;
    }
}

- (void)setPlayStatus:(BOOL)isOn
{
    self.playButton.playing = isOn;
}

@end
