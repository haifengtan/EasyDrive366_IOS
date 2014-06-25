//
//  ArticleListController.h
//  EasyDrive366
//
//  Created by Steven Fu on 12/12/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "NetTableViewController.h"

@interface ArticleListController : NetTableViewController
@property (nonatomic) NSString *searchKey;
@property (nonatomic) NSString *searchTypes;
@property (nonatomic) BOOL isSearch;

@end
