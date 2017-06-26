//
//  AbstractView
//  AudioBookFairyTale
//
//  Created by Johnny Xu(徐景周) on 6/21/15.
//  Copyright (c) 2015 Future Studio. All rights reserved.
//
#import "AbstractView.h"
//#import "UIImageView+WebCache.h"

@interface AbstractView ()

@end

@implementation AbstractView
@synthesize icnoImage = _iconImage;
@synthesize model = _model;

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
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg1.png"]]];
	_iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 120, 150)];
//    [_iconImage setImageWithURL:[NSURL URLWithString:_model.iconUrl] placeholderImage:[UIImage imageNamed:@"MathGraph.png"]];
    [self.view addSubview:_iconImage];
    
    UILabel *bookName = [[UILabel alloc] initWithFrame:CGRectMake(140, 10, self.view.frame.size.width-140, 20)];
    bookName.backgroundColor = [UIColor clearColor];
    bookName.text = [NSString stringWithFormat:@"书名:%@", _model.bookName];
    [self.view addSubview:bookName];
    
    UILabel *autherName = [[UILabel alloc] initWithFrame:CGRectMake(140, 30, self.view.frame.size.width-140, 20)];
    autherName.backgroundColor = [UIColor clearColor];
    autherName.text = [NSString stringWithFormat:@"作者:%@", _model.autherName];
    [self.view addSubview:autherName];
    
    UILabel *translator = [[UILabel alloc] initWithFrame:CGRectMake(140, 50, self.view.frame.size.width-140, 20)];
    translator.backgroundColor = [UIColor clearColor];
    translator.text = [NSString stringWithFormat:@"译者:%@", _model.translator];
    [self.view addSubview:translator];
    
    UILabel *publisherName = [[UILabel alloc] initWithFrame:CGRectMake(140, 70, self.view.frame.size.width-140, 20)];
    publisherName.backgroundColor = [UIColor clearColor];
    publisherName.text = [NSString stringWithFormat:@"出版社:%@", _model.publisher];
    [self.view addSubview:publisherName];
    
    UILabel *pubDate = [[UILabel alloc] initWithFrame:CGRectMake(140, 90, self.view.frame.size.width-140, 20)];
    pubDate.backgroundColor = [UIColor clearColor];
    pubDate.text = [NSString stringWithFormat:@"出版年:%@", _model.pubdate];
    [self.view addSubview:pubDate];
    
    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(140, 110, self.view.frame.size.width-140, 20)];
    price.backgroundColor = [UIColor clearColor];
    price.text = [NSString stringWithFormat:@"定价:%@", _model.price];
    [self.view addSubview:price];
    
    UITextView *introView = [[UITextView alloc] initWithFrame:CGRectMake(10, 170, self.view.frame.size.width-20, 200)];
    NSString *intro = [NSString stringWithContentsOfURL:[NSURL URLWithString:_model.introUrl] encoding:NSUTF8StringEncoding error:nil];
    [self.view addSubview:introView];
    
    NSLog(@"%@", intro);
    if ([self parser:intro])
    {
        NSLog(@"成功");
    }
}

- (BOOL)parser:(NSString *)string{
    NSXMLParser *par = [[NSXMLParser alloc] initWithData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    [par setDelegate:self];
    return [par parse];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser{
    NSLog(@"开始解析");
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{

    if ([elementName isEqualToString:@"summary"])
    {
         NSLog(@"name = %@", attributeDict);
    }
   
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
}


- (void)dealloc
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
