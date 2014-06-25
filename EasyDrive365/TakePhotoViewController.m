//
//  TakePhotoViewController.m
//  EasyDrive366
//
//  Created by Fu Steven on 9/5/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "TakePhotoViewController.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AppSettings.h"
#import "BMapKit.h"

@interface TakePhotoViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,BMKMapViewDelegate>{
    BMKMapView *_mapView;
}

@end

@implementation TakePhotoViewController

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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"拍照上传" style:UIBarButtonSystemItemCamera target:self action:@selector(takePhoto)];
     _mapView= [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _mapView.zoomLevel = 16;
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeNone;
    _mapView.showsUserLocation = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _mapView.showsUserLocation = NO;
    [_mapView viewWillDisappear];
    _mapView.delegate =nil;
    
}
-(void)mapViewWillStartLocatingUser:(BMKMapView *)mapView{
    NSLog(@"Start locate...");
}
-(void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation{
    if (userLocation != nil) {
		//NSLog(@"%f %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
        self.latitude = userLocation.location.coordinate.latitude;
        self.longtitude = userLocation.location.coordinate.longitude;
        _mapView.showsUserLocation = NO;
	}
}
-(void)mapViewDidStopLocatingUser:(BMKMapView *)mapView{
    NSLog(@"Stop locate.");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setImageView:nil];
    [super viewDidUnload];
}

-(void)takePhoto{
    
    UIActionSheet *menu = [[UIActionSheet alloc]
                           initWithTitle: AppTitle
                           delegate:self
                           cancelButtonTitle:@"取消"
                           destructiveButtonTitle:nil
                           otherButtonTitles:@"拍照",@"图片库",@"清除",nil];
    menu.actionSheetStyle =UIActionSheetStyleBlackTranslucent;
    
    [menu showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        [self pickImage:UIImagePickerControllerSourceTypeCamera];
    }else if(buttonIndex ==1){
        [self pickImage:UIImagePickerControllerSourceTypePhotoLibrary];
    }else if(buttonIndex==2){
        self.imageView.image = nil;
    }
}
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
   
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    if (!error){
        UIAlertView *av=[[UIAlertView alloc] initWithTitle:nil message:@"Image written to photo album"delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [av show];
    }else{
        UIAlertView *av=[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Error writing to photo album: %@",[error localizedDescription]] delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [av show];
    }
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.imageView.image =[info valueForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self saveImage:[self scaleToSize:self.imageView.image size:CGSizeMake(1024, 768)]];
}

- (void) pickImage:(UIImagePickerControllerSourceType )sourceType
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = sourceType;
    ipc.delegate =self;
    ipc.allowsEditing =NO;
    [self presentViewController:ipc animated:YES completion:nil];
   
    
}
-(void)saveImage:(UIImage *)image
{
    NSString *url =[NSString stringWithFormat:@"upload/do_upload"];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:SERVERURL]];
    NSURLRequest *request = [client multipartFormRequestWithMethod:@"POST" path:url parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData> formData) {
        NSString *filename = [NSString stringWithFormat:@"upload.png"];
        [formData appendPartWithFileData:imageData name:@"userfile" fileName:filename mimeType:@"image/png"];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%d",[AppSettings sharedSettings].userid] dataUsingEncoding:NSUTF8StringEncoding]  name:@"userid"];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%f",self.latitude] dataUsingEncoding:NSUTF8StringEncoding]  name:@"y"];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%f",self.longtitude] dataUsingEncoding:NSUTF8StringEncoding]  name:@"x"];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"iphone"] dataUsingEncoding:NSUTF8StringEncoding]  name:@"from"];
        
        
        
    }];
    AFHTTPRequestOperation *operation=[[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        id jsonResult =[NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"%@",jsonResult);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Access server error:%@,because %@",error,operation.request);
        
        
    }];
    NSOperationQueue *queue=[[NSOperationQueue alloc] init];
    [queue addOperation:operation];

}
@end
