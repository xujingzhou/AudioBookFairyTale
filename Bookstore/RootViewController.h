//
//  RootViewController
//  AudioBookFairyTale
//
//  Created by Johnny Xu(Ðì¾°ÖÜ) on 6/21/15.
//  Copyright (c) 2015 Future Studio. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BookImage.h"

@interface RootViewController : UIViewController<UISearchBarDelegate, BookImageDelegate>
{
    UIScrollView *scrollView;
    NSString* _search;
    UISearchBar *_searchBar;
}

@end
