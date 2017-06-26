
#import <UIKit/UIKit.h>
#import "BookModel.h"

@interface SearchView : UIViewController<NSURLConnectionDataDelegate, UITableViewDelegate, UITableViewDataSource>{
    UITableView* _tableView;
    NSString* _search;
    
    NSMutableArray* bookArr;
    BookModel* model;
    NSURLConnection* Myconnection;
    
    NSMutableData* MyJSONData;
    
    int starIndex;
    int maxResult;
}
@property (nonatomic, strong) NSString *search;
@property (nonatomic, strong) UITableView *tableView;

@end
