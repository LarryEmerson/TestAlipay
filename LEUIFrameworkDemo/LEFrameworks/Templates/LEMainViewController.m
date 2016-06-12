//
//  LEMainViewController.m
//  LEFrameworks
//
//  Created by Larry Emerson on 15/8/25.
//  Copyright (c) 2015年 LarryEmerson. All rights reserved.
//

#import "LEMainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LocalNotification.h"
#import "LELoadingAnimationView.h"
#import "LE_EmojiToolBar.h"


#import "LEScanQRCode.h"

@interface LEMainViewController ()

@end

@implementation LEMainViewController{
    UIView *curView;
    LEUIFramework *globalVar;
    LocalNotification *curMesssage;
    LELoadingAnimationView *leLoadingView;
    UIView *loadingViewMask;
    //
    BOOL isBottomViewAdded;
    BOOL isMiddleViewAdded;
    BOOL isTopViewAdded;
    BOOL isLoginViewAdded;
    //
    UIImagePickerController *imagePickerController;
    NSUInteger imagePickerSourceType;
    //
    UIView *viewForShowHDImage;
    BOOL isAvatarOrBackground;
    //
    LE_EmojiToolBar *input;
    UIView *inputToolBarOutSpaceTapArea;
    BOOL isInputToolBarOutSpaceTapAreaDisabled;
    BOOL isChildViewInited;
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
} 
static LEMainViewController *sharedInstance = nil;
+ (LEMainViewController *) instance { @synchronized(self) { if (sharedInstance == nil) { sharedInstance = [[self alloc] init]; } } return sharedInstance; }
+ (id) allocWithZone:(NSZone *)zone { @synchronized(self) { if (sharedInstance == nil) { sharedInstance = [super allocWithZone:zone]; return sharedInstance; } } return nil; }
+ (id) copyWithZone:(NSZone *)zone { return self; }
+ (id) mutableCopyWithZone:(NSZone *)zone { return self; }
//
-(void) addSubviewToController:(UIView *) view{
    [curView addSubview:view];
}
- (void)viewDidLoad {
    [super viewDidLoad];  
    [self initApp];
    [self setIsInputToolBarOutSpaceTapAreaDisabled:YES];
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(!isChildViewInited){
        isChildViewInited=YES;
        [self iniChildView];
    }
}
-(void) iniChildView{ 
}
//
-(void) initApp{
    globalVar=[LEUIFramework instance];
    curView=self.view;
    //
        [self.view setBackgroundColor:ColorWhite];
    
    self.bottomViewContainer=[[UIView alloc] initWithFrame:globalVar.ScreenBounds];
    [self addSubviewToController:self.bottomViewContainer];
    self.middleViewContainer=[[UIView alloc] initWithFrame:globalVar.ScreenBounds];
    [self addSubviewToController:self.middleViewContainer];
    self.topViewContainer=[[UIView alloc] initWithFrame:globalVar.ScreenBounds];
    [self addSubviewToController:self.topViewContainer];
    self.loginViewContainer=[[UIView alloc] initWithFrame:globalVar.ScreenBounds];
    [self addSubviewToController:self.loginViewContainer];
    [self.bottomViewContainer setHidden:YES];
    [self.middleViewContainer setHidden:YES];
    [self.topViewContainer setHidden:YES];
    [self.loginViewContainer setHidden:YES];
    //
    leLoadingView=[[LELoadingAnimationView alloc] init];
    loadingViewMask=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-leLoadingView.viewWidth, self.view.frame.size.height/2-leLoadingView.viewHeight,leLoadingView.viewWidth*2,leLoadingView.viewHeight*2)];
    loadingViewMask.layer.cornerRadius=5;
    loadingViewMask.layer.masksToBounds=YES;
    [loadingViewMask setBackgroundColor:ColorMask5];
    [loadingViewMask setHidden:YES];
    [loadingViewMask setAlpha:0];
    [loadingViewMask addSubview:leLoadingView];
    [leLoadingView setFrame:CGRectMake(leLoadingView.viewWidth/2, leLoadingView.viewHeight/2, leLoadingView.viewWidth, leLoadingView.viewHeight)];
    [self addSubviewToController:loadingViewMask];
    //
    curMesssage=[[LocalNotification alloc] init];
    [self addSubviewToController:curMesssage];
    //
    //
    viewForShowHDImage=[[UIView alloc]initWithFrame:self.view.bounds];
    [viewForShowHDImage setBackgroundColor:[UIColor blackColor]];
    [self addSubviewToController:viewForShowHDImage];
    [viewForShowHDImage setHidden:YES];
    //add the root view here
//    [self addBottomView:xxx];
    //
    
    inputToolBarOutSpaceTapArea=[[UIView alloc]initWithFrame:CGRectMake(0, NavigationBarHeight+20, globalVar.ScreenHeight, globalVar.ScreenHeight)];
    [self.view addSubview:inputToolBarOutSpaceTapArea];
    [inputToolBarOutSpaceTapArea setHidden:YES]; 
    [inputToolBarOutSpaceTapArea addTapEventWithSEL:@selector(tapOutOfInputToolBarArea) Target:self];
    //
    input=[[LE_EmojiToolBar alloc]init];
    [self.view addSubview:input];
    //    [input messageSomebody:@"@："];
    [input addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    
    UIImage *bgRect=[UIImage imageNamed:@"Le_EmojiBGRect"];
    UIImage *inputRect=[UIImage imageNamed:@"Le_EmojiInputRect"];
    UIImage *sendButton=[UIImage imageNamed:@"Le_EmojiSendButtonRect"];
    UIImage *sendButtonPressed=[UIImage imageNamed:@"Le_EmojiSendButtonRectPressed"];
    [input setCustomToolbarSkinWithToolbarBackgroundColorAs:[UIColor redColor]
                                            BackgroundImage:[bgRect stretchableImageWithLeftCapWidth:bgRect.size.width/2 topCapHeight:bgRect.size.height/2]
                                              EmojiFaceIcon:[UIImage imageNamed:@"Le_EmojiSmileFace"]
                                               KeyboardIcon:[UIImage imageNamed:@"Le_EmojiKeyboard"]
                                   InputViewBackgroundColor:nil
                                        InputViewBackground:[inputRect stretchableImageWithLeftCapWidth:inputRect.size.width/2 topCapHeight:inputRect.size.height/2]
                                         InputViewTextColor:[UIColor blackColor]
                                           PlaceholderColor:[UIColor darkGrayColor]
                                  SendButtonBackgroundColor:nil
                            SendButtonBackgroundNormalColor:[UIColor whiteColor]
                           SendButtonBackgroundPressedColor:[[UIColor alloc]initWithRed:23.0/255 green:89.0/255 blue:140.0/255 alpha:1]
                                      SendButtonNormalImage:[sendButton stretchableImageWithLeftCapWidth:sendButton.size.width/2 topCapHeight:sendButton.size.height/2]
                                     SendButtonPressedImage:[sendButtonPressed stretchableImageWithLeftCapWidth:sendButtonPressed.size.width/2 topCapHeight:sendButtonPressed.size.height/2]
                                                  IconWidth:40
                               SpaceBetweenIconAndInputView:10
                                             InputViewWidth:globalVar.ScreenWidth-60-10-20
                             SpaceBetweenInputViewAndButton:10
                                            SendButtonWidth:60
                              TopSpaceForInputViewAndButton:12
                           BottomSpaceForInputViewAndButton:6
                                              ToolbarHeight:LE_EmojiInputHeight
                                         PlaceholderOffsetX:5
                                          PlaceholderString:@"我也说两句..."
                                             SendButtonText:@"发送"
                                      InputViewTextFontSize:15
                                                EnableEmoji:NO
     ];
    [input setShowOrHideToolBar:NO];
}
-(void) tapOutOfInputToolBarArea{
    //    NSLog(@"tapOutOfInputToolBarArea");
    [self setLE_Emoji_BecomeFirstResponder:NO];
    [self.view endEditing:YES];
}
//==
//=============================
-(void) setMessageText:(NSString *) text{
    [self setMessageText:text WithEnterTime:0.3 AndPauseTime:0.8];
}
-(void) setMessageText:(NSString *) text WithEnterTime:(float) time AndPauseTime:(float) pauseTime {
    [curMesssage setText:text WithEnterTime:time  AndPauseTime:pauseTime];
}

-(void) startLoading{
    [leLoadingView startAnimation];
    [self.view setUserInteractionEnabled:NO];
}
-(void) stopLoading{
    [leLoadingView stopAnimation];
    [self.view setUserInteractionEnabled:YES];
}
-(void) startLoadingWithMaskAndInteraction{
    [leLoadingView startAnimation];
    [self.view setUserInteractionEnabled:YES];
    [loadingViewMask setHidden:NO];
    [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        [loadingViewMask setAlpha:1];
    } completion:^(BOOL isDone){
    }];
}
-(void) startLoadingWithMask{
    [leLoadingView startAnimation];
    [self.view setUserInteractionEnabled:NO];
    [loadingViewMask setHidden:NO];
    [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        [loadingViewMask setAlpha:1];
    } completion:^(BOOL isDone){
    }];
}
-(void) stopLoadingWithMask{
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(stopLoadingWithMaskLogic:) userInfo:nil repeats:NO];
}
-(void) stopLoadingWithMaskLogic:(NSTimer *)timer{
    [leLoadingView stopAnimation];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        [loadingViewMask setAlpha:0];
    } completion:^(BOOL isDone){
        [loadingViewMask setHidden:YES];
        [self.view setUserInteractionEnabled:YES];
        [timer invalidate];
    }];
}
-(void) stopLoadingWithMaskWithDuration:(float) time{
    [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(stopLoadingWithMaskLogic:) userInfo:nil repeats:NO];
}
//View
-(void) addBottomView:(UIView *) view{
    if(!isBottomViewAdded) {
        isBottomViewAdded=YES;
        [self.bottomViewContainer addSubview:view];
        [self.bottomViewContainer setHidden:NO];
    }
}
-(void) removeBottomView:(UIView *) view{
    isBottomViewAdded=NO;
    [view removeFromSuperview];
    [self.bottomViewContainer setHidden:YES];
}
//
-(void) addMiddleView:(UIView *) view{
    if(!isMiddleViewAdded) {
        isMiddleViewAdded=YES;
        [self.middleViewContainer addSubview:view];
        [self.middleViewContainer setHidden:NO];
    }
}
-(void) removeMiddleView:(UIView *) view{
    isMiddleViewAdded=NO;
    [view removeFromSuperview];
    [self.middleViewContainer setHidden:YES];
}
//
-(void) addTopView:(UIView *) view{
    if(!isTopViewAdded) {
        isTopViewAdded=YES;
        [self.topViewContainer addSubview:view];
        [self.topViewContainer setHidden:NO];
    }
}
-(void) removeTopView:(UIView *) view{
    isTopViewAdded=NO;
    [view removeFromSuperview];
    [self.topViewContainer setHidden:YES];
}

//

//load user image
- (void) getPhotoImageForAvatarOrHomebackground:(BOOL)isAvatar  Delegate:(id) delegate{
    self.delegateForSelectingImageFromCell=delegate;
    isAvatarOrBackground=isAvatar;
    UIActionSheet *sheet;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sheet = [[UIActionSheet alloc] initWithTitle:isAvatar?@"请选择头像图片":@"请选择背景图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"本地相册", nil];
    } else {
        sheet = [[UIActionSheet alloc] initWithTitle:isAvatar?@"请选择头像图片":@"请选择背景图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"本地相册", nil];
    }
    sheet.tag = 255;
    [sheet showInView:self.view];
}

#pragma mark - action sheet delegte
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //    NSLog(@"index %d",buttonIndex);
    if (actionSheet.tag == 255) {
        imagePickerSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    imagePickerSourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 1: //相机
                    imagePickerSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                case 2: //相册
                    return;
            }
        } else {
            if (buttonIndex == 0) {
                imagePickerSourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            } else {
                return;
            }
        }
        // 跳转到相机或相册页面
        imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = NO;
        imagePickerController.sourceType = imagePickerSourceType;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
}

-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
- (void)imageCropper:(ImageCropper *)cropper didFinishCroppingWithImage:(UIImage *)image{
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    UIImage *compressedImage = [UIImage imageWithData:imageData];
    if(self.delegateForSelectingImageFromCell){
        [self.delegateForSelectingImageFromCell doneSelectingImageFromCell:compressedImage];
    }
    self.delegateForSelectingImageFromCell=nil;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        [cropper.view setFrame:CGRectMake(0, globalVar.ScreenHeight, globalVar.ScreenWidth, globalVar.ScreenHeight)];
    } completion:^(BOOL isDone){
        [cropper.view removeFromSuperview];
        [cropper removeFromParentViewController];
    }];
}
- (void)imageCropperDidCancel:(ImageCropper *)cropper{
    imagePickerController = [[UIImagePickerController alloc] init];
    [imagePickerController setDelegate:self];
    imagePickerController.allowsEditing = NO;
    imagePickerController.sourceType = imagePickerSourceType;
    [self presentViewController:imagePickerController animated:YES completion:^{}];
    [cropper.view removeFromSuperview];
    [cropper removeFromParentViewController];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *oriImage = [info objectForKeyedSubscript:@"UIImagePickerControllerOriginalImage"];
    ImageCropper *cropper = [[ImageCropper alloc] initWithImage:oriImage AvatarOrBackground:isAvatarOrBackground];
    [cropper setDelegate:self];
    [cropper.view setFrame:CGRectMake(0, globalVar.ScreenHeight, globalVar.ScreenWidth, globalVar.ScreenHeight)];
    [self.view addSubview:cropper.view];
    [self addChildViewController:cropper];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        [cropper.view setFrame:CGRectMake(0, 0, globalVar.ScreenWidth, globalVar.ScreenHeight)];
    } completion:^(BOOL isDone){
    }];
}
-(UIImage *) getImageWithBlackBoard:(UIImage *)image {
    int x=(640-image.size.width)/2;
    int y=(640-image.size.height)/2;
    UIGraphicsBeginImageContext(CGSizeMake(640, 640));
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, 640, 640));
    
    [image drawInRect:CGRectMake(x, y, 640-x*2, 640-y*2)];
    UIImage* img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


-(void) showViewForHDImageWithURL:(NSString *) url AndAspect:(float) aspect{
    [viewForShowHDImage setHidden:NO];
    [viewForShowHDImage addSubview:[[LEShowHDImage alloc] initWithUrl:url AndAspect:aspect]];
}
-(void) releaseViewForHDImage{
    [viewForShowHDImage setHidden:YES];
}

-(void) shareToUMengWithDelegate:(id) delegate  {
    
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:UMengKey
//                                      shareText:nil
//                                     shareImage:nil
//                                shareToSnsNames:[NSArray arrayWithObjects:
//                                                 UMShareToSina,
//                                                 UMShareToWechatSession,
//                                                 UMShareToWechatTimeline,
//                                                 //                                                   UMShareToQzone,
//                                                 UMShareToQQ,
//                                                 nil]
//                                       delegate:delegate];
}

//-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
//{
//    //    NSLog(@"didFinishGetUMSocialDataInViewController %@",response);
//    //根据`responseCode`得到发送结果,如果分享成功
//    if(response.responseCode == UMSResponseCodeSuccess) {
//        //得到分享到的微博平台名
//        //        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
//    }
//}
-(void) setLE_Emoji_BecomeFirstResponder:(BOOL) isResponder{
    [input setBecomeFirstResponder:isResponder];
}
-(void) setLE_EmojiIsNotClearMessage:(BOOL) isNotClear{
    [input setNotClearMessage:isNotClear];
}
-(void) setShowLE_Emoji:(id) delegate{
    [input setDelegate:delegate];
    [input setShowOrHideToolBar:YES];
}
-(void) setHideLE_Emoji{
    [input setDelegate:nil];
    [input setBecomeFirstResponder:NO];
    [input setShowOrHideToolBar:NO];
}
-(void) messageSomebody:(NSString *) somebody{
    [input messageSomebody:somebody];
}
//
-(void) setIsInputToolBarOutSpaceTapAreaDisabled:(BOOL) isDisabled{
    isInputToolBarOutSpaceTapAreaDisabled=isDisabled;
}
-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"frame"]&&!isInputToolBarOutSpaceTapAreaDisabled){
        float y=[[change objectForKey:NSKeyValueChangeNewKey]CGRectValue].origin.y;
        if(y>globalVar.ScreenHeight/5&&y<globalVar.ScreenHeight*4/5/*&&!input.isHidden*/){
            [inputToolBarOutSpaceTapArea setHidden:NO];
        }else{
            [inputToolBarOutSpaceTapArea setHidden:YES];
        }
    }
}

 @end
