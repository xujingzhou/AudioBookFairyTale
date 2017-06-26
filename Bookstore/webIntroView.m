
#import "webIntroView.h"

@interface webIntroView ()

@end

@implementation webIntroView
@synthesize webView = _webView;
@synthesize book = _book;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
	_webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 420)];
    [_webView setUserInteractionEnabled:YES];
    [_webView setScalesPageToFit:YES];
    [_webView setBackgroundColor:[UIColor clearColor]];
    [_webView setDelegate:self];
    [_webView setOpaque:NO];//使网页透明
    NSLog(@"%@", _book.introUrl);
    NSString *path = _book.introUrl;
    NSURL *url = [NSURL URLWithString:path];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    [self.view addSubview:_webView];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"向后" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    UIBarButtonItem *forward = [[UIBarButtonItem alloc] initWithTitle:@"向前" style:UIBarButtonItemStylePlain target:self action:@selector(forward)];
    
    NSArray *items = [[NSArray alloc] initWithObjects:forward,back, nil];
    [self.navigationItem setRightBarButtonItems:items animated:YES];
}

- (void)back
{
    [_webView goBack];
}

- (void)forward{
    [_webView goForward];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{

}

@end
