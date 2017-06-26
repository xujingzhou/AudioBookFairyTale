//
//  RootViewController
//  AudioBookFairyTale
//
//  Created by Johnny Xu(徐景周) on 6/21/15.
//  Copyright (c) 2015 Future Studio. All rights reserved.
//
#import "RootViewController.h"
#import "AudioTableViewController.h"
#import "ProfileInfo.h"
#import <AVFoundation/AVFoundation.h>

@interface RootViewController ()
{
}

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar2.png"] forBarMetrics:UIBarMetricsDefault];
    self.title = @"畅销少儿有声读物";
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"sharebg.png"]];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 125*4 + 64);
    [self.view addSubview:scrollView];
    
    for (int i = 1; i <= 4; i++)
    {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"BookShelfCell.png"]];
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, (i-1)*125, self.view.frame.size.width, 100)];
        [view addSubview:imageView];
        [scrollView addSubview:view];
    }
    
    [self backgroundPlayAudioSetting];
    
    [self bookImage];
}

- (void)backgroundPlayAudioSetting
{
    // 后台播放音频设置
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void)bookImage
{
    int line = 0, column = 0;
    for (int i = 0; i < 3; i++)
    {
        line = i/3;
        column = (i%3);
        
        BookImage *book;
        int bookShelfHeight = 125;
        book = [[BookImage alloc] initWithFrame:CGRectMake(20 + column*100, 10 + line*bookShelfHeight, 80, 100) imageName:[NSString stringWithFormat:@"book%d.jpg", i+1]];
        book.tag = i;
        book.delegate = self;
        [scrollView addSubview:book];
    }
}

#pragma mark---UISearchBarDelegate methods
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if ([searchBar.text isEqualToString:@" "] || [searchBar.text length] <= 0)
    {
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"警告" message:@"请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        [UIView transitionWithView:self.navigationController.view duration:2 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            
        }completion:nil];
    }
}


#pragma mark---BookImageDelegate methods
- (void)bookImageDidClicked:(BookImage *)bookImage
{
    AudioTableViewController *audioView = [[AudioTableViewController alloc] init];
    if (bookImage.tag == 0)
    {
        NSMutableArray *audios = [[NSMutableArray alloc] initWithCapacity:1];
        [audios addObject:[[ProfileInfo alloc] initWithInfo:@"广告位" andIcon:nil]];
        for (int i=0; i<11; ++i)
        {
            NSString *name = [NSString stringWithFormat:@"世界上最优美的童话_%u.mp3", i+1];
            NSString *icon = @"book1.jpg";
            ProfileInfo *info = [[ProfileInfo alloc] initWithInfo:name andIcon:icon];
            [audios addObject:info];
            
            NSLog(@"MP3 name: %@", name);
        }
        
        audioView.allAudios = [audios copy];
    }
    else if (bookImage.tag == 1)
    {
        NSMutableArray *audios = [[NSMutableArray alloc] initWithCapacity:1];
        [audios addObject:[[ProfileInfo alloc] initWithInfo:@"广告位" andIcon:nil]];
        for (int i=0; i<16; ++i)
        {
            NSString *name = [NSString stringWithFormat:@"少儿幽默故事小屋_%u.mp3", i+1];
            NSString *icon = @"book2.jpg";
            ProfileInfo *info = [[ProfileInfo alloc] initWithInfo:name andIcon:icon];
            [audios addObject:info];
            
            NSLog(@"MP3 name: %@", name);
        }
        
        audioView.allAudios = [audios copy];
    }
    else if (bookImage.tag == 2)
    {
        NSMutableArray *audios = [[NSMutableArray alloc] initWithCapacity:1];
        [audios addObject:[[ProfileInfo alloc] initWithInfo:@"广告位" andIcon:nil]];
        for (int i=0; i<16; ++i)
        {
            NSString *name = [NSString stringWithFormat:@"成语故事_%u.mp3", i+1];
            NSString *icon = @"book3.jpg";
            ProfileInfo *info = [[ProfileInfo alloc] initWithInfo:name andIcon:icon];
            [audios addObject:info];
            
            NSLog(@"MP3 name: %@", name);
        }
        
        audioView.allAudios = [audios copy];
    }
    else
    {
        return;
    }
    
    [self.navigationController pushViewController:audioView animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
