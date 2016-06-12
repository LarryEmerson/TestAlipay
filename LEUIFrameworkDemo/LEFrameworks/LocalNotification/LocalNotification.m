//
//  LocalNotification.m
//  ticket
//
//  Created by Larry Emerson on 14-2-20.
//  Copyright (c) 2014年 360CBS. All rights reserved.
//

#import "LocalNotification.h"

#import "LEUIFrameworkImporter.h"

#define MessageEnterTime 0.3
#define MessagePauseTime    1.2

@implementation LocalNotification{
    UILabel *curText;
    BOOL isShowing;
    CGRect startRect;
    CGRect endRect;
    
    CATransition *transition;
    
    UIImageView *BGView;
    int height;
    LEUIFramework *globalVar;
    BOOL isEverUsed;
    int MessageBoardWidth;
    int space;
    int MessageFontSize;
    int MessageSpace;
}

- (id)initWithFrame:(CGRect)frame
{
    globalVar=[LEUIFramework instance];
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *BG=[UIImage imageNamed:@"MessageBackground"];
        height=BG.size.height;
        space=10;
        MessageFontSize =20;
        MessageSpace = 2;
        MessageBoardWidth=globalVar.ScreenWidth-space*2;
        [self setFrame:CGRectMake(space, -MessageFontSize*10, MessageBoardWidth, BG.size.height)];
        BGView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MessageBoardWidth, height)];
        [BGView setImage:[BG stretchableImageWithLeftCapWidth:BG.size.width/2 topCapHeight:BG.size.height/2]];
        [self addSubview:BGView];
        curText=[[UILabel alloc]initWithFrame:CGRectMake(MessageBoardWidth/2, MessageSpace, MessageBoardWidth-MessageSpace*2, height-MessageSpace*2)];
        [curText setContentMode:UIViewContentModeCenter];
        [curText setTextAlignment:NSTextAlignmentCenter];
        [curText setFont:[UIFont systemFontOfSize:MessageFontSize]];
        [curText setTextColor:ColorWhite];
        [curText setText:@"                         "];
        [BGView addSubview:curText];
        [BGView setClipsToBounds:YES];
        startRect=self.frame;
        endRect=self.frame;
        endRect.origin.y=20+MessageSpace;
        // effect
        transition = [CATransition animation];
        [transition setDuration:MessageEnterTime];
        [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [transition setType:kCATransitionFade];
        [transition setDelegate: self];
    }
    return self;
}
 
-(void) setText:(NSString *) text WithEnterTime:(float) time AndPauseTime:(float) pauseTime {
    if(!text){
        return;
    }
    [self setAlpha:0];
    [self setFrame:startRect];
    [curText setNumberOfLines:0];
    [curText setTextAlignment:NSTextAlignmentCenter];
    CGSize sizeContent = [text getSizeWithFont:curText.font MaxSize:CGSizeMake(MessageBoardWidth-MessageSpace*2, LELabelMaxSize.height)] ;
    endRect.size.height=MessageSpace*2+sizeContent.height;
    if(endRect.size.height<height){
        endRect.size.height=height;
    }
    [curText.layer addAnimation:transition forKey:nil];
    [curText setText:text];
    [curText setBackgroundColor:[UIColor clearColor]];
    if(!isEverUsed){
        isEverUsed=YES;
        [curText setFrame:CGRectMake((MessageBoardWidth-sizeContent.width)/2, endRect.size.height/2-sizeContent.height/2, sizeContent.width, sizeContent.height)];
    }
    [UIView  animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
        [self setFrame:endRect];
        [BGView setFrame:CGRectMake(0, 0, endRect.size.width, endRect.size.height)];
        [curText setFrame:CGRectMake((MessageBoardWidth-sizeContent.width)/2, endRect.size.height/2-sizeContent.height/2, sizeContent.width, sizeContent.height)];
        [self setAlpha:1];
    } completion:^(BOOL isFinished){
        if(isFinished){
            [UIView animateWithDuration:time delay:pauseTime options:UIViewAnimationOptionCurveEaseOut animations:^(void){
                [self setAlpha:0];
            } completion:nil];
        }
    }];
}


@end
