//
//  ShowLocationViewController.m
//  EasyDrive366
//
//  Created by Fu Steven on 8/26/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "ShowLocationViewController.h"
#import "BMapKit.h"
#import "AppSettings.h"
#import "ShowDetailViewController.h"
#import "SearchShopController.h"
@interface ShowLocationViewController ()<BMKMapViewDelegate>{
    BMKMapView *_mapView;
    BMKPointAnnotation* pointAnnotation;
    CGFloat _lat;
    CGFloat _long;
    NSMutableArray *_list;
    BOOL _hasLocation;
    id _item;
}

@end

@implementation ShowLocationViewController

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
    self.title = @"附近服务商户";
    [super viewDidLoad];
     _mapView= [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    self.view = _mapView;
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(gotoNext)];
    if (self.isFull){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonSystemItemAction target:self action:@selector(searchShop)];
    }
}
-(void)searchShop{
    SearchShopController *vc = [[SearchShopController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _mapView.zoomLevel = 15;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = BMKUserTrackingModeNone;
    _mapView.showsUserLocation = YES;
    _hasLocation = NO;
    if (self.target_postion){
        [self showSingleShop:self.target_postion];
    }else if (self.target_list){
        [self showShop:self.target_list];
    }
    
    //test use
    /*
    if (_list){
        [_list removeAllObjects];
    }else{
        _list = [[NSMutableArray alloc] init];
    }
    id temp = @{@"code": @"C100000001",
                 @"name": @"金都花园",
                 @"address": @"东海西路37号",
                 @"phone": @"18605320000",
                 @"description": @"我的名字叫做jinduhuayuan建于好多年以前 这是第二行数据",
                 @"x": @"120.394318",
                 @"y": @"36.070357"};

    [self createPin:36.070357 longtitude:120.394318 title:@"aa" description:@"bb" item:temp];
    
    */
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _mapView.showsUserLocation = NO;
    [_mapView viewWillDisappear];
    _mapView.delegate =nil;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)mapViewWillStartLocatingUser:(BMKMapView *)mapView{
    NSLog(@"Start locate...");
}
-(void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation{
    if (userLocation != nil) {
		//NSLog(@"%f %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
        if (!_hasLocation){
            _hasLocation = !_hasLocation;
            if (self.isFull){
                [self showMineLocation:userLocation.location.coordinate.latitude longtitude:userLocation.location.coordinate.longitude];
            }else{
                CLLocationCoordinate2D coor;
                coor.latitude = userLocation.location.coordinate.latitude;
                coor.longitude = userLocation.location.coordinate.longitude;
                [_mapView setCenterCoordinate:coor];
            }
        }
	}
}
-(void)mapViewDidStopLocatingUser:(BMKMapView *)mapView{
    NSLog(@"Stop locate.");
}
-(void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view{
    for (id item in _list ){
        if ([view.annotation isEqual:item[@"point"]]){
            ShowDetailViewController *vc = [[ShowDetailViewController alloc] initWithNibName:@"ShowDetailViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
            [vc loadData:item[@"item"]];
            vc.target = [view.annotation coordinate];
            _item = item[@"item"];
        }
    }
    
}

-(void)goLocation:(CGFloat)latitude longtitude:(CGFloat)longtitude{
    _lat = latitude;
    _long = longtitude;
    pointAnnotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = _lat;
    coor.longitude = _long;
    pointAnnotation.coordinate = coor;
    pointAnnotation.title = @"test";
    pointAnnotation.subtitle = @"Detail information";
    

    [_mapView addAnnotation:pointAnnotation];
   
    [_mapView setCenterCoordinate:coor animated:YES];

}
-(void)createPin:(CGFloat)latitude longtitude:(CGFloat)longtitude title:(NSString *)title description:(NSString *)description item:(id)item{
    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = latitude;
    coor.longitude = longtitude;
    annotation.coordinate = coor;
    annotation.title = title;
    annotation.subtitle = description;

    [_mapView addAnnotation:annotation];
    
    [_list addObject:@{@"item":item,@"point":annotation}];
}
-(void)showShop:(id)list{
    BOOL isfirst = YES;
    if (_list){
        [_list removeAllObjects];
    }else{
        _list = [[NSMutableArray alloc] init];
    }
    for (id item  in list) {
        [self createPin:[item[@"y"] floatValue] longtitude:[item[@"x"] floatValue] title:item[@"name"] description:item[@"phone"] item:item];
        if (isfirst){
            isfirst = NO;
            CLLocationCoordinate2D coor;
            coor.latitude = [item[@"y"] floatValue];
            coor.longitude = [item[@"x"] floatValue];
            [_mapView setCenterCoordinate:coor];
        }
    }
}
-(void)showSingleShop:(id)item{
    
    if (_list){
        [_list removeAllObjects];
    }else{
        _list = [[NSMutableArray alloc] init];
    }
    [self createPin:[item[@"y"] floatValue] longtitude:[item[@"x"] floatValue] title:item[@"name"] description:item[@"phone"] item:item];
    CLLocationCoordinate2D coor;
    coor.latitude = [item[@"y"] floatValue];
    coor.longitude = [item[@"x"] floatValue];
    [_mapView setZoomLevel:16];
    [_mapView setCenterCoordinate:coor animated:YES];
    self.title = item[@"name"];

}
-(void)showMineLocation:(CGFloat)latitude longtitude:(CGFloat)longtitude{
    CLLocationCoordinate2D coor;
    coor.latitude = latitude;
    coor.longitude = longtitude;

    [_mapView setCenterCoordinate:coor animated:YES];

    NSString *url =[NSString stringWithFormat:@"api/get_position?userid=%d&x=%f&y=%f&type=09",[AppSettings sharedSettings].userid,longtitude,latitude];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            if (_list){
                [_list removeAllObjects];
            }else{
                _list = [[NSMutableArray alloc] init];
            }
            for (id item  in json[@"result"]) {
                [self createPin:[item[@"y"] floatValue] longtitude:[item[@"x"] floatValue] title:item[@"name"] description:item[@"phone"] item:item];
            }
        }
    }];
}
@end
