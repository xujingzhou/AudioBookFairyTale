
#import <UIKit/UIKit.h>
#import "BookModel.h"

@interface webIntroView : UIViewController<UIWebViewDelegate>
{
    UIWebView *_webView;
    BookModel *_book;
}
@property(nonatomic, strong)UIWebView *webView;
@property(nonatomic, strong)BookModel *book;

@end
