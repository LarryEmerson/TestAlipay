//
//  LEBasePageView.m
//  ticket
//
//  Created by Larry Emerson on 14-5-9.
//  Copyright (c) 2014年 360CBS. All rights reserved.
//

#import "LEBasePageView.h"

@interface LEBasePageView()
@end


@implementation LEBasePageView{
    UISwipeGestureRecognizer *recognizerRight;
    NSString *tempBackButtonImage;
}

-(id) initWithSuperView:(UIView *)view Title:(NSString *)title LeftButton:(NSString *) back {
    tempBackButtonImage=back;
    return [super initWithSuperView:view Title:title ];
}
-(id) initWithSuperView:(UIView *)view Title:(NSString *)title{
    return [self initWithSuperView:view Title:title LeftButton:IMG_ArrowLeft];
} 

-(void) setIndividualityForInheritedView{
    [super setIndividualityForInheritedView];
    if(tempBackButtonImage){
        self.leftButton=[[UIButton alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self.viewNavigation Anchor:LEAnchorInsideLeftCenter Offset:CGPointZero CGSize:CGSizeMake(NavigationBarHeight, NavigationBarHeight)]];
        [self.leftButton setImage:[UIImage imageNamed:tempBackButtonImage] forState:UIControlStateNormal];
        [self.viewNavigation addSubview:self.leftButton];
        [self.leftButton addTarget:self action:@selector(easeOutView) forControlEvents:UIControlEventTouchUpInside];
    }
    recognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipGesture:)];
    [recognizerRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self addGestureRecognizer:recognizerRight];
}
-(void) easeInView{
    [self leSetFrame:CGRectMake(self.curFrameWidth, 0, self.curFrameWidth, self.curFrameHight)];
    [UIView animateWithDuration:0.2 animations:^(void){
        [self leSetFrame:CGRectMake(0, 0, self.curFrameWidth, self.curFrameHight)];
    } completion:^(BOOL isDone){}];
}

- (void)swipGesture:(UISwipeGestureRecognizer *)recognizer {
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self easeOutView];
    }
}
-(void) easeOutViewLogic{
    [self dismissView];
}
-(void) eventCallFromChild{
    
}
-(void) easeOutView{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^(void){
        [self leSetFrame:CGRectMake(self.curFrameWidth, 0, self.curFrameWidth, self.curFrameHight)];
    } completion:^(BOOL isFinished){
        [self easeOutViewLogic];
    }];
}

@end
