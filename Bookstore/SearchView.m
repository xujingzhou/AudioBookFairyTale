//
//  RootViewController
//  SearchView
//
//  Created by Johnny Xu(徐景周) on 6/21/15.
//  Copyright (c) 2015 Future Studio. All rights reserved.
//
#import "SearchView.h"
#import "SBJson.h"
#import "NSString+URLEncoding.h"
#import "BookCell.h"
#import "AbstractView.h"
#import "webIntroView.h"

@interface SearchView ()

@end

@implementation SearchView
@synthesize search = _search;
@synthesize tableView = _tableView;

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
    bookArr = [[NSMutableArray alloc] initWithCapacity:0];
	starIndex=1;
    maxResult=10;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44)];
    [_tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg1.png"]]];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    NSLog(@"%@", _search);
    [self search:_search];
}

-(void)search:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return;
    }
    [bookArr removeAllObjects];
    starIndex=1;
    maxResult=10;
    
    NSString *searchWord = [string urlEncodeString];
    NSString* searchurl=[NSString stringWithFormat:@"http://api.douban.com/book/subjects?q=%@&start-index=%d&max-results=%d&apikey=04f1ae6738f2fc450ed50b35aad8f4cf&alt=json",searchWord,starIndex,maxResult];
    NSURL *url = [NSURL URLWithString:searchurl];
    [self downloadASIHTTPResquest:url];
}

-(void)downloadASIHTTPResquest:(NSURL*)url{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.delegate=self;
    [request startAsynchronous];
}

-(void)requestFinished:(ASIHTTPRequest *)request{
    NSLog(@"----%@",request.responseString);
    [self parseJSONData:request.responseData];
}

- (void)parseJSONData:(NSData *)data
{
    NSDictionary *json = [data JSONValue];
    NSArray *allBooks = [json objectForKey:@"entry"];
    for (NSDictionary *book in allBooks) {
        NSString* bookName = [[book objectForKey:@"title"] objectForKey:@"$t"];
        model = [[[BookModel alloc] init] autorelease];
        model.bookName = bookName;
        
        NSArray *authorArr = [book objectForKey:@"author"];
        NSMutableString* authorName=[NSMutableString string];
        for (NSDictionary* author in authorArr){
            NSString* oneAuthor=[[author objectForKey:@"name"]objectForKey:@"$t"];
            [authorName appendFormat:@"%@", oneAuthor];
        }
        model.autherName = authorName;
        NSString *imageURL = [[[book objectForKey:@"link"] objectAtIndex:2] objectForKey:@"@href"];
        model.iconUrl=imageURL;
        NSString *introURL = [[[book objectForKey:@"link"] objectAtIndex:3] objectForKey:@"@href"];
        model.introUrl = introURL;
        
        NSArray* publishers=[book objectForKey:@"db:attribute"];
        for (NSDictionary* dict in publishers) {
            if ([[dict objectForKey:@"@name"]isEqualToString:@"publisher"]) {
                model.publisher=[dict objectForKey:@"$t"];
                
            }
            if ([[dict objectForKey:@"@name"]isEqualToString:@"price"]) {
                model.price=[dict objectForKey:@"$t"];
                
            }
            if ([[dict objectForKey:@"@name"]isEqualToString:@"pubdate"]) {
                model.pubdate=[dict objectForKey:@"$t"];
                
            }
            if ([[dict objectForKey:@"@name"]isEqualToString:@"translator"]) {
                model.translator=[dict objectForKey:@"$t"];
                
            }
        }
        int numRatings=[[[book objectForKey:@"gd:rating"]objectForKey:@"@numRaters"]intValue];
        model.numRatings=numRatings;
        float rating=[[[book objectForKey:@"gd:rating"]objectForKey:@"@average"]floatValue];
        model.rating=rating;
        [bookArr addObject:model];
        starIndex++;
    }
    [_tableView reloadData];
}
#pragma mark UITableViewDelegate&DataSource methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==[bookArr count]) {
        NSString* searchStr=[_search urlEncodeString];
        NSString* seachUrl=[NSString stringWithFormat:@"http://api.douban.com/book/subjects?q=%@&start-index=%d&max-results=%d&apikey=04f1ae6738f2fc450ed50b35aad8f4cf&alt=json",searchStr,starIndex,maxResult];
        NSURL* url=[NSURL URLWithString:seachUrl];
        [self downloadASIHTTPResquest:url];
    }else{
        /*
        AbstractView *abstractView = [[[AbstractView alloc] init] autorelease];
        abstractView.model = [bookArr objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:abstractView animated:YES];
         */
        webIntroView *webView = [[[webIntroView alloc] init] autorelease];
        webView.book = [bookArr objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:webView animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==[bookArr count]) {
        return 44;
    }
    return 72;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [bookArr count]+1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == [bookArr count]) {
        static NSString* ENDCELL = @"end";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:ENDCELL];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ENDCELL] autorelease];
        }
        cell.textLabel.text = @"更多";
        return cell;
    }
    static NSString* CellID=@"cell";
    BookCell* cell=(BookCell*)[tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell) {
        cell=[[[BookCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID]autorelease];
    }
    cell.book=[bookArr objectAtIndex:indexPath.row];
    return cell;
}


- (void)dealloc
{
    [_search release];
    [super dealloc];
    [_tableView release];
    [bookArr release];
    [MyJSONData release];
    [Myconnection release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
