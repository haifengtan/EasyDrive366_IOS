//
//  UploadPhotoController.m
//  EasyDrive366
//
//  Created by Steven Fu on 2/22/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "UploadPhotoController.h"
#import "AppSettings.h"
#import "Browser2Controller.h"
#import "UIImageView+AFNetworking.h"
#import "AFHTTPClient.h"
#import "SVProgressHUD.h"

@interface UploadPhotoController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    id _json;
    UIImageView *_imageView;
    UIImage *_image;
    id _current;
}

@end

@implementation UploadPhotoController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"照片上传";
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(complete)];
    [self load_data];
}
-(void)complete{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)load_data{
    NSString *url = [NSString stringWithFormat:@"order/order_upload?userid=%d&orderid=%@",[AppSettings sharedSettings].userid,self.order_id];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            _json = json[@"result"];
            [self.tableView reloadData];
        }
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{


    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
        return [_json[@"action"] count];
    else
        return [_json[@"help"] count];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0)
        return @"照片";
    else
        return @"说明";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    if (indexPath.section==0){
        id item = [_json[@"action"] objectAtIndex:indexPath.row];
        cell.textLabel.text =item[@"title"];
        UIImageView* imageCell= [[UIImageView alloc] initWithFrame:CGRectMake(240, 2, 40, 40)];
        imageCell.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnSmallImage:)];
        imageCell.userInteractionEnabled = YES;
        
        imageCell.tag = indexPath.row;
        [imageCell addGestureRecognizer:tap];
    
        [imageCell setImageWithURLWithoutCache:[NSURL URLWithString:item[@"photourl"]] placeholderImage:[UIImage imageNamed:@"w"]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell addSubview:imageCell];
    }else{
        id item = [_json[@"help"] objectAtIndex:indexPath.row];
        cell.textLabel.text = item[@"title"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

        
    
    return cell;
}
-(void)tapOnSmallImage:(UITapGestureRecognizer *)tap{
    
    int index =tap.view.tag;
    id item = [_json[@"action"] objectAtIndex:index];
    NSString *url = [NSString stringWithFormat:@"upload/get_photo?userid=%d&typeid=%@&orderid=%@",[AppSettings sharedSettings].userid,item[@"id"],self.order_id];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            [self showBigImage:json[@"result"]];
        }
    }];
}
-(void)showBigImage:(NSString *)url{
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 50, 300, 300)];
    _imageView.contentMode = UIViewContentModeCenter;
    if ([url hasPrefix:@"http://"]){
        [_imageView setImageWithURLWithoutCache:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"m"]];
    }else{
        _imageView.image = [UIImage imageNamed:url];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnBigImage)];
    [_imageView addGestureRecognizer:tap];
    _imageView.userInteractionEnabled = YES;
    [_imageView removeFromSuperview];
    [self.view addSubview:_imageView];
}
-(void)tapOnBigImage{
    [_imageView removeFromSuperview];
    _imageView = nil;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1){
        id item = [_json[@"help"] objectAtIndex:indexPath.row];
        Browser2Controller *vc =[[Browser2Controller alloc] initWithNibName:@"Browser2Controller" bundle:nil];
        vc.url = item[@"url"];
        vc.title = item[@"title"];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        _current = [_json[@"action"] objectAtIndex:indexPath.row];
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
        [actionSheet showInView:self.view];
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        [self pickImage:UIImagePickerControllerSourceTypeCamera];
    }else if(buttonIndex ==1){
        [self pickImage:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
- (UIImage *)scaleImage:(UIImage *) image maxWidth:(float) maxWidth maxHeight:(float) maxHeight
{
    CGImageRef imgRef = image.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    if (width <= maxWidth && height <= maxHeight)
    {
        return image;
    }
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > maxWidth || height > maxHeight)
    {
        CGFloat ratio = width/height;
        if (ratio > 1)
        {
            bounds.size.width = maxWidth;
            bounds.size.height = bounds.size.width / ratio;
        }
        else
        {
            bounds.size.height = maxHeight;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    CGFloat scaleRatio = bounds.size.width / width;
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, scaleRatio, -scaleRatio);
    CGContextTranslateCTM(context, 0, -height);
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
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
    _image =[info valueForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //[self saveImage:[self scaleToSize:_image size:CGSizeMake(600, 600)]];
    [self saveImage:[self scaleImage:_image maxWidth:640 maxHeight:960]];
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
    NSString *url =[NSString stringWithFormat:@"upload/upload_carins?userid=%d&typeid=%@&orderid=%@",[AppSettings sharedSettings].userid,_current[@"id"],self.order_id];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:SERVERURL]];
    NSURLRequest *request = [client multipartFormRequestWithMethod:@"POST" path:url parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData> formData) {
        NSString *filename = [NSString stringWithFormat:@"upload.png"];
        [formData appendPartWithFileData:imageData name:@"userfile" fileName:filename mimeType:@"image/png"];
        //[formData appendPartWithFormData:[[NSString stringWithFormat:@"%d",[AppSettings sharedSettings].userid] dataUsingEncoding:NSUTF8StringEncoding]  name:@"userid"];
        
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"iphone"] dataUsingEncoding:NSUTF8StringEncoding]  name:@"from"];
        
        
        
    }];
    AFHTTPRequestOperation *operation=[[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        id jsonResult =[NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"%@",jsonResult);
        if ([[AppSettings sharedSettings] isSuccess:jsonResult]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_USER_PROFILE object:nil];
            _current[@"photourl"]=jsonResult[@"result"];
            [self.tableView reloadData];
        }
        if (![[jsonResult objectForKey:@"status"] isEqualToString:@"success"]){
            NSString *message = @"发生异常，请稍后再试.";
            if ([[jsonResult allKeys] containsObject:@"message"]){
                message = [jsonResult objectForKey:@"message"];
            }
            [SVProgressHUD dismissWithSuccess:message afterDelay:3];
        }else{
            id alertMsg = jsonResult[@"alertmsg"];
            if (alertMsg && ![alertMsg isKindOfClass:[NSNull class]] && ![alertMsg isEqualToString:@""]){
                [SVProgressHUD dismissWithSuccess:alertMsg afterDelay:3];
            }else{
                [SVProgressHUD dismissWithSuccess:@"图片上传成功！" afterDelay:3];
            }
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Access server error:%@,because %@",error,operation.request);
        
        
    }];
    [SVProgressHUD showWithStatus:@"正在上传图片..."];
    NSOperationQueue *queue=[[NSOperationQueue alloc] init];
    [queue addOperation:operation];
    
}
@end
