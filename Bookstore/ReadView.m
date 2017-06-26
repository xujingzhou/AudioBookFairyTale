//
//  ReadView
//  AudioBookFairyTale
//
//  Created by Johnny Xu(徐景周) on 6/21/15.
//  Copyright (c) 2015 Future Studio. All rights reserved.
//
#import "ReadView.h"
#import <QuartzCore/QuartzCore.h>
#import "LARSAdController.h"
#import "TOLAdAdapter.h"
#import "GADInterstitialDelegate.h"
#import "GADInterstitial.h"

@interface ReadView ()<GADInterstitialDelegate, LARSBannerVisibilityDelegate>
{
    BOOL right;
    UIBarButtonItem *rightBarButton;
    int cont;
    CGSize winSize;
}

@property (strong, nonatomic) GADInterstitial *interstitial; // interstitial Ads by Google admob
@property (nonatomic) BOOL bannerIsVisible;                 // shows if an ad is visible on this view or not by iAd or admob

@property (nonatomic, copy) NSString *content;

@end

@implementation ReadView

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
    [[LARSAdController sharedManager] setPresentationType:(LARSAdControllerPresentationTypeBottom)];
    [[LARSAdController sharedManager] setPinningLocation:(LARSAdControllerPinLocationBottom)];
    self.bannerIsVisible = NO;
}

#pragma mark - View LifeCycle

- (void) loadView
{
    [super loadView];
    
    self.content = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.bookPath ofType:@"txt" ] encoding:NSUTF8StringEncoding error:NULL];
    if (!self.content)
    {
        self.content = [NSString stringWithContentsOfFile:self.bookPath encoding:NSUTF16StringEncoding error:NULL];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    CATransition * animation = [CATransition animation];
    animation.type = @"oglFlip";
    animation.subtype = kCATransitionFromLeft;
    animation.duration = 0.45;
    animation.removedOnCompletion = YES;
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:NO];
    
    CATransition * animation = [CATransition animation];
    animation.type = @"oglFlip";
    animation.subtype = kCATransitionFromRight;
    animation.duration = 0.45;
    animation.removedOnCompletion = YES;
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"翻页" style:UIBarButtonItemStylePlain target:self action:@selector(rightButton)];
    //UINavigationItem *item = [[[UINavigationItem alloc] initWithTitle:nil] autorelease];
    [self.navigationItem setRightBarButtonItem:rightBarButton];

    textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    textView.text = self.content;
    textView.font = [UIFont systemFontOfSize:19];
    textView.textColor = [UIColor blackColor];
    textView.editable = NO;
    winSize = textView.contentSize;
    [self.view addSubview:textView];
    
    [textView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg6.png"]]];
    NSLog(@"textView.contentSize.height: %f",textView.contentSize.height);
    
    allPage = textView.contentSize.height/430 + 1;
    currentPage = 1;
    textView.contentSize = self.view.frame.size;
    
    self.title = [NSString stringWithFormat:@"%d/%d",currentPage,allPage];
    
    //单击手势
    UITapGestureRecognizer* tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
    tapGesture.delegate=self;
    
    [self.view addGestureRecognizer:tapGesture];
    
    //左轻扫手势
    UISwipeGestureRecognizer* leftswipeGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(LeftswipeGestureAction:)];
    leftswipeGesture.direction=UISwipeGestureRecognizerDirectionLeft;
    leftswipeGesture.delegate=self;
    [self.view addGestureRecognizer:leftswipeGesture];
    
    //右轻扫手势
    UISwipeGestureRecognizer* RightswipeGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(RightswipeGestureAction:)];
    RightswipeGesture.direction=UISwipeGestureRecognizerDirectionRight;
    RightswipeGesture.delegate=self;
    [self.view addGestureRecognizer:RightswipeGesture];
    
    [self initAds];
    [self loadInterstitialAds];
}

- (void)rightButton
{
    if (right == NO)
    {
        rightBarButton.title = @"下滑";
        right = YES;
        textView.contentSize = winSize;
    }
    else
    {
        rightBarButton.title = @"翻页";
        right = NO;
        textView.contentSize = self.view.frame.size;
    }
}

-(void)tapGestureAction:(UITapGestureRecognizer*)tapGesture
{
    NSLog(@"tapGesture");
    
    if (++cont%2 == 0)
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    else
    {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        
    }
}

-(void)LeftswipeGestureAction:(UISwipeGestureRecognizer*)swipeGesture
{
    if (currentPage == allPage)
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"这已是最后一页" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    currentPage = currentPage + 1;
    
    NSLog(@"%d",currentPage);
    //[button04 setTitle:[NSString stringWithFormat:@"%d/%d",currentPage ,allPage]];
    self.title = [NSString stringWithFormat:@"%d/%d",currentPage,allPage];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [textView setContentOffset:CGPointMake(0, (currentPage - 1) * 430) animated:YES];
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
    [UIView commitAnimations];
    
    return;
}

-(void)RightswipeGestureAction:(UISwipeGestureRecognizer*)swipeGesture
{
    if (currentPage == 1)
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"这已是第一页" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    
    currentPage = currentPage - 1;
    NSLog(@"%d",currentPage);
    self.title = [NSString stringWithFormat:@"%d/%d",currentPage,allPage];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [textView setContentOffset:CGPointMake(0, (currentPage - 1) * 430) animated:YES];
    [UIView commitAnimations];
    //
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
    
    
    [UIView commitAnimations];
    
    //[button04 setTitle:[NSString stringWithFormat:@"%d/%d",currentPage,allPage]];
    return;
}

- (void) dealloc
{
    // Ads
    _interstitial.delegate = nil;
    [[LARSAdController sharedManager] removeObserver:self forKeyPath:kLARSAdObserverKeyPathIsAdVisible];
    
    //    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
