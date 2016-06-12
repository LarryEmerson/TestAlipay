//
//  LEShowHDImage.m
//  ticket
//
//  Created by Larry Emerson on 14-8-14.
//  Copyright (c) 2014年 360CBS. All rights reserved.
//

#import "LEShowHDImage.h"
#import "LEUIFrameworkImporter.h"
#import "LEMainViewController.h"
#import "PZPhotoView.h"
#import "LELoadingAnimationView.h"

 

@implementation LEShowHDImage{
    LEUIFramework *globalVar;
    PZPhotoView *pzView;
    LELoadingAnimationView *loading;
} 
- (id)initWithUrl:(NSString *) url AndAspect:(float) aspect
{
    self = [super init];
    if (self) {
        [self setAlpha:0];
        globalVar = [LEUIFramework instance];
        [self setFrame:CGRectMake(0, 0, globalVar.ScreenWidth, globalVar.ScreenHeight)];
        [self setBackgroundColor:[UIColor blackColor]];
        loading=[[LELoadingAnimationView alloc]init];
        
        [loading startAnimation];
        [loading setFrame:CGRectMake(globalVar.ScreenWidth/2-loading.viewWidth/2, globalVar.ScreenHeight/2-loading.viewHeight/2, loading.viewWidth, loading.viewHeight)];
        //
        pzView=[[PZPhotoView alloc]initWithFrame:CGRectMake(0, 0, globalVar.ScreenWidth, globalVar.ScreenHeight)];
        [pzView setPhotoViewDelegate:self];
        [loading startAnimation];
        [pzView setImageURL:url AndAspect:aspect];
        
        [self addSubview:pzView];
        [self addSubview:loading];
        //
        [UIView animateWithDuration:0.25 animations:^(void){
            [self setAlpha:1];
        } completion:^(BOOL isDone){
        }];
    }
    return self;
}
- (void)photoViewDidDownloadedImage{
//    NSLog(@"photoViewDidDownloadedImage");
    [loading stopAnimation];
}
- (void)photoViewDidSingleTap:(PZPhotoView *)photoView{
    [loading stopAnimation];
    [UIView animateWithDuration:0.25 animations:^(void) {
        [self setAlpha:0];
    } completion:^(BOOL isDone){
        [pzView setDelegate:nil];
        [[LEMainViewController instance]releaseViewForHDImage];
        [self removeFromSuperview];
    }];
}
- (void)photoViewDidDoubleTap:(PZPhotoView *)photoView{
    
}
- (void)photoViewDidTwoFingerTap:(PZPhotoView *)photoView{
    
}
- (void)photoViewDidDoubleTwoFingerTap:(PZPhotoView *)photoView{
    
}
@end
