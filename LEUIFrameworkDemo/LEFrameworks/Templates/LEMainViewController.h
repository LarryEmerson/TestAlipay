//
//  LEMainViewController.h
//  LEFrameworks
//
//  Created by Larry Emerson on 15/8/25.
//  Copyright (c) 2015年 LarryEmerson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ImageCropper.h"
#import "LEShowHDImage.h"

@protocol DoneSelectingImageFromCellDelegate <NSObject>
-(void) doneSelectingImageFromCell:(UIImage *)image;
@end

@interface LEMainViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,ImageCropperDelegate,UIActionSheetDelegate>
+(LEMainViewController *) instance;
@property (nonatomic) CLLocation *userLocation;
@property (nonatomic) id<DoneSelectingImageFromCellDelegate> delegateForSelectingImageFromCell;
-(void) iniChildView;
//
-(void) startLoading;
-(void) stopLoading;
-(void) startLoadingWithMask;
-(void) startLoadingWithMaskAndInteraction;
-(void) stopLoadingWithMask;
-(void) stopLoadingWithMaskWithDuration:(float) time;
-(void) setMessageText:(NSString *) text;
//-(void) setMessageAsLoading;
-(void) setMessageText:(NSString *) text WithEnterTime:(float) time AndPauseTime:(float) pauseTime;
//
-(void) addBottomView:(UIView *) view;
-(void) removeBottomView:(UIView *) view;

-(void) addMiddleView:(UIView *) view;
-(void) removeMiddleView:(UIView *) view;

-(void) addTopView:(UIView *) view;
-(void) removeTopView:(UIView *) view;
//
@property (nonatomic) UIView *bottomViewContainer;
@property (nonatomic) UIView *middleViewContainer;
@property (nonatomic) UIView *topViewContainer;
@property (nonatomic) UIView *loginViewContainer;
@property (nonatomic) NSString *curCellphone;
//

-(void) getPhotoImageForAvatarOrHomebackground:(BOOL)isAvatar Delegate:(id) delegate;
-(void) showViewForHDImageWithURL:(NSString *) url AndAspect:(float) aspect;
-(void) releaseViewForHDImage;
//-(void) shareUMeng;

-(void) setLE_Emoji_BecomeFirstResponder:(BOOL) isResponder;
-(void) setShowLE_Emoji:(id) delegate;
-(void) setHideLE_Emoji;
-(void) setLE_EmojiIsNotClearMessage:(BOOL) isNotClear;
-(void) messageSomebody:(NSString *) somebody;

-(void) setIsInputToolBarOutSpaceTapAreaDisabled:(BOOL) isDisabled;
@end
