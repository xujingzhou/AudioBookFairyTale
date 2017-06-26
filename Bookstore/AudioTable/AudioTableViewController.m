//
//  AudioTableViewController
//  AudioBookFairyTale
//
//  Created by Johnny Xu(Ðì¾°ÖÜ) on 6/21/15.
//  Copyright (c) 2015 Future Studio. All rights reserved.
//
#import "AudioTableViewController.h"
#import "AudioCell.h"
#import <QuartzCore/QuartzCore.h>
#import "LARSAdController.h"
#import "TOLAdAdapter.h"
#import "GADInterstitialDelegate.h"
#import "GADInterstitial.h"

NSString *reuseIdentifier = @"SNAudioCell";

@interface AudioTableViewController()<EECircularMusicPlayerControlDelegate, AVAudioPlayerDelegate, GADInterstitialDelegate, LARSBannerVisibilityDelegate>
{
}

@property (strong, nonatomic) GADInterstitial *interstitial; // interstitial Ads by Google admob
@property (nonatomic) BOOL bannerIsVisible;                 // shows if an ad is visible on this view or not by iAd or admob

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) NSIndexPath *lastSelectRow;

@end

@implementation AudioTableViewController

#pragma mark GADInterstitialDelegate
- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial
{
    // Show the interstitial.
    [self.interstitial presentFromRootViewController:self];
}

- (void)interstitial:(GADInterstitial *)interstitial
didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"GADRequestError: %@", [error localizedDescription]);
}

// Insterstitial Ads
- (GADRequest *)request
{
    GADRequest *request = [GADRequest request];
    return request;
}

- (void)loadInterstitialAds
{
    // Create a new GADInterstitial each time.  A GADInterstitial will only show one request in its
    // lifetime. The property will release the old one and set the new one.
    self.interstitial = [[GADInterstitial alloc] init];
    self.interstitial.delegate = self;
    
    self.interstitial.adUnitID = kGoogleInterstitialAdUnitID;
    [self.interstitial loadRequest:[self request]];
}

#pragma mark - Ads by iAD and Admob
- (BOOL)shouldDisplayAds
{
    return YES;
}

#pragma mark - LARSBannerVisibilityDelegate
- (void)adController:(LARSAdController *)adController bannerChangedVisibility:(BOOL)anyBannerVisible
{
    NSLog(@"Changing visibility: %@", anyBannerVisible ? @"visible" : @"hidden");
}

// Ads observe for iAd and Admob
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:kLARSAdObserverKeyPathIsAdVisible])
    {
        NSLog(@"Observing keypath \"%@\"", keyPath);
        
        BOOL anyAdsVisible = [change[NSKeyValueChangeNewKey] boolValue];
        
        // Get a reference to the banner that is currently visible
        UIView *bannerView;
        NSArray *instances = [[[LARSAdController sharedManager] adapterInstances] allValues];
        for (id <TOLAdAdapter> adapterInstance in instances)
        {
            if (adapterInstance.adVisible)
            {
                bannerView = adapterInstance.bannerView;
            }
        }
        
        if (anyAdsVisible)
        {
            self.bannerIsVisible = YES;
        }
        else
        {
            // No ads are visible, but if the banner is still showing, so move it back down
            if (self.bannerIsVisible)
            {
                self.bannerIsVisible = NO;
            }
        }
    }
}

- (void)initAds
{
    [[LARSAdController sharedManager] addObserver:self
                                       forKeyPath:kLARSAdObserverKeyPathIsAdVisible
                                          options:NSKeyValueObservingOptionNew
                                          context:nil];
    
    [[LARSAdController sharedManager] setDelegate:self];
    [[LARSAdController sharedManager] setPresentationType:(LARSAdControllerPresentationTypeTop)];
    [[LARSAdController sharedManager] setPinningLocation:(LARSAdControllerPinLocationTop)];
    self.bannerIsVisible = NO;
}

#pragma mark - View LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = TSBackgroundColor;
    self.tableView.separatorColor = TSTableViewSeperatorColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    // Ads
    [self initAds];
    [self loadInterstitialAds];
    
    _lastSelectRow = nil;
    
    // Load data
    [self loadData];
}

- (void) dealloc
{
    // Ads
    _interstitial.delegate = nil;
    [[LARSAdController sharedManager] removeObserver:self forKeyPath:kLARSAdObserverKeyPathIsAdVisible];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TableViewRowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath != nil)
    {
        if (indexPath.row == 0)
        {
            return;
        }
        
        ProfileInfo *user = [_allAudios objectAtIndex:indexPath.row];
        AudioCell *cell = (AudioCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        
        if (_lastSelectRow.hash == indexPath.hash)
        {
            BOOL startsPlaying = !self.audioPlayer.playing;
            cell.playButton.playing = startsPlaying;
            if (startsPlaying)
            {
                [self.audioPlayer play];
            }
            else
            {
                [self.audioPlayer pause];
                [cell.playButton setCurrentTime:[self currentTime] animated:YES];
            }
        }
        else
        {
            AudioCell *cellLast = (AudioCell*)[self.tableView cellForRowAtIndexPath:self.lastSelectRow];
            cellLast.playButton.playing = NO;
            [self.audioPlayer stop];
            
            NSString *fileName = [user.name stringByDeletingPathExtension];
            NSLog(@"File name: %@",fileName);
            NSString *fileExt = [user.name pathExtension];
            NSLog(@"File ExtName: %@",fileExt);
            
            NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:fileExt];
            NSURL *url = [NSURL fileURLWithPath:path];
            self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
            self.audioPlayer.delegate = self;
            [self.audioPlayer play];
            
            cell.playButton.duration = self.audioPlayer.duration;
            cell.playButton.delegate = self;
            cell.playButton.playing = YES;
            [cell.playButton setCurrentTime:[self currentTime] animated:YES];
            
            self.lastSelectRow = indexPath;
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_allAudios count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        AudioCell *cell = [[AudioCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        return cell;
    }
    
    id object = [_allAudios objectAtIndex:indexPath.row];
    AudioCell *cell = [self userCellFor:object];
    if (self.lastSelectRow && self.lastSelectRow.hash == indexPath.hash)
    {
        if (cell)
        {
            cell.playButton.playing = self.audioPlayer.playing;
            [cell.playButton setCurrentTime:[self currentTime] animated:YES];
        }
    }
    
    return cell;
}

#pragma mark - EECircularMusicPlayerControlDelegate
- (NSTimeInterval)currentTime
{
    return self.audioPlayer.currentTime;
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"lastSelectRow.row: %ld, [self.allAudios count]: %ld", (long)self.lastSelectRow.row, (unsigned long)[self.allAudios count]);
    
    if (self.lastSelectRow && self.lastSelectRow.row < [self.allAudios count]-1)
    {
        [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:self.lastSelectRow.row+1 inSection:0]];
    }
}

#pragma mark - Private Methods
- (AudioCell *)userCellFor:(id)object
{
    AudioCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell)
    {
        cell = [[AudioCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    ProfileInfo *user = (ProfileInfo *)object;
    [(AudioCell *)cell setObject:user];
    [(AudioCell *)cell setPlayStatus:NO];
    
    return cell;
}

- (void)reloadData
{
    if (_allAudios && [_allAudios count] > 0)
    {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    else
    {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    [self.tableView reloadData];
    
}

- (void) loadData
{
    [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

@end
