//
//  ShareControl.m
//  EasyDrive366
//
//  Created by Steven Fu on 2/5/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "ShareControl.h"
#import "AppDelegate.h"
#import "WXApi.h"
#import "WeiboSDK.h"

@interface ShareControl()<MFMailComposeViewControllerDelegate>{
    NSString *_share_title;
    NSString *_share_inctroduce;
    NSString *_share_url;

}
@end
@implementation ShareControl
-(void)popupMenu:(NSString *)title introduce:(NSString *)introduce url:(NSString *)url;{
    _share_inctroduce = introduce;
    _share_title = title;
    _share_url = url;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"新浪微博",@"微信好友",@"微信朋友圈",/*@"邮件",*/@"短信", nil];
    [actionSheet showFromTabBar:((AppDelegate *)[[UIApplication sharedApplication] delegate]).tabbarController.tabBar];
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //_share_url =@"EasyDrive366://open?type=GDS&id=10&name=test";
    if (buttonIndex ==0){
        //sina weibo
        
        WBMessageObject *message = [WBMessageObject message];
        message.text = [NSString stringWithFormat:@"%@:%@",_share_title,_share_inctroduce];
        if (NO){
            message.text = _share_title;
        }
        if (NO)
        {
            WBImageObject *image = [WBImageObject object];
            image.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image_1" ofType:@"jpg"]];
            message.imageObject = image;
        }
        
        if (YES)
        {
            WBWebpageObject *webpage = [WBWebpageObject object];
            webpage.objectID = @"identifier1";
            webpage.title = _share_title;
            webpage.description = _share_inctroduce;
            webpage.thumbnailData = UIImagePNGRepresentation([UIImage imageNamed:@"Icon"]);//[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image_2" ofType:@"jpg"]];//[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon" ofType:@"png"]];
            
            webpage.webpageUrl = _share_url;
            message.mediaObject = webpage;
        }
        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
        /*request.userInfo = @{@"ShareMessageFrom": @"test",
                             @"Other_Info_1": [NSNumber numberWithInt:123],
                             @"Other_Info_2": @[@"obj1", @"obj2"],
                             @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
         */
        request.shouldOpenWeiboAppInstallPageIfNotInstalled = YES;
        
        [WeiboSDK sendRequest:request];
    }else if (buttonIndex==1){
        //weixin
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = _share_title;
        message.description = _share_inctroduce;
        [message setThumbImage:[UIImage imageNamed:@"Icon.png"]];
        
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl =_share_url;
        
        message.mediaObject = ext;
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneSession; //WXSceneTimeline; WXSceneFavorite;
        
        [WXApi sendReq:req];
        
    }else if (buttonIndex==2){
        //weixin friends
        //weixin
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = _share_title;
        message.description = _share_inctroduce;
        [message setThumbImage:[UIImage imageNamed:@"Icon.png"]];
        
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = _share_url;
        
        message.mediaObject = ext;
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneTimeline;// WXSceneFavorite;
        
        [WXApi sendReq:req];
    }/* else if (buttonIndex==3){
        //email

        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        
        mc.mailComposeDelegate = self;
        
        [mc setSubject:_share_title];
        
        // set some basic plain text as the message body ... but you do not need to do this :)
        [mc setMessageBody:[NSString stringWithFormat:@"%@(%@",_share_inctroduce,_share_url] isHTML:NO];
        
        // set some recipients ... but you do not need to do this :)
        [mc setToRecipients: nil];
        
        // displaying our modal view controller on the screen with standard transition
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]).tabbarController presentViewController:mc animated:YES completion:nil];
        
    }*/else if (buttonIndex==3){
        //text
        if(![MFMessageComposeViewController canSendText]) {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"设备不支持发送短信!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            return;
        }
        

        NSString *message = [NSString stringWithFormat:@"%@(%@)%@", _share_inctroduce,_share_url,_share_title];
        
        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
        messageController.messageComposeDelegate=self;
        [messageController setRecipients:nil];
        [messageController setBody:message];
        
        // Present message view controller on screen
        
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]).tabbarController presentViewController:messageController animated:YES completion:nil];
    
    }
    
    
}
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]).tabbarController  dismissViewControllerAnimated:YES completion:nil];

}
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    NSLog(@"%u",result);
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]).tabbarController  dismissViewControllerAnimated:YES completion:nil];

}
@end
