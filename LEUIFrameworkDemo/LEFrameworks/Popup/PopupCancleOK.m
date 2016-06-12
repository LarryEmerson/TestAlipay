//
//  PopupCancleOK.m
//  spark-client-ios
//
//  Created by Larry Emerson on 15/2/13.
//  Copyright (c) 2015年 Syan. All rights reserved.
//

#import "PopupCancleOK.h"

@implementation PopupCancleOK{
    NSString *curTitle;
    NSString *curSubTitle;
}
-(id) initWithDelegate:(id) delegate Title:(NSString *) title Subtitle:(NSString *) subtitle {
    curTitle=title;
    curSubTitle=subtitle;
    return [super initWithDelegate:delegate];
}
-(void) initUI{
    UIView *v=[[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:v]; 
    [self addTapEventWithSEL:@selector(onTap)];
    self.needsEaseIn=YES;
    // 
    UIImage *imgBg=[UIImage imageNamed:@"popup_bg"];
    //
    int space=imgBg.size.width;
    int W=self.globalVar.ScreenWidth-space*2;
    int buttonW=(W-space*3)/2;
    int buttonH =NavigationBarHeight*3/4;
    int H=space*3+buttonH;
    CGSize sizeTitle=[curTitle getSizeWithFont:[UIFont systemFontOfSize:PopupTitleFontSize] MaxSize:CGSizeMake(W-space*2, LELabelMaxSize.height)];
    CGSize sizeSubTitle=[curSubTitle getSizeWithFont:[UIFont systemFontOfSize:PopupSubtitleFontSize] MaxSize:CGSizeMake(W-space*2, LELabelMaxSize.height)];
    if(curTitle){
        H+=sizeTitle.height+space;
    }
    if(curSubTitle){
        H+=sizeSubTitle.height+space;
    }
    //
    UIImageView *viewBG=[LEUIFramework getUIImageViewWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideCenter Offset:CGPointZero CGSize:CGSizeMake(W, H)] Image:[LEUIFramework getMiddleStrechedImage:imgBg]];
    [viewBG setUserInteractionEnabled:YES];
    //
    UILabel *labelTitle= [LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:viewBG Anchor:LEAnchorInsideTopCenter Offset:CGPointMake(0, space) CGSize:sizeTitle] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:curTitle FontSize:PopupTitleFontSize Font:nil Width:0 Height:0 Color:[UIColor colorWithRed:0.690 green:0.400 blue:0.463 alpha:1.000] Line:0 Alignment:NSTextAlignmentCenter]];
    //
    UIImageView *split= [LEUIFramework getUIImageViewWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:viewBG Anchor:LEAnchorOutsideBottomCenter RelativeView:labelTitle Offset:CGPointMake(0, space) CGSize:CGSizeMake(W-space*2, 1)] Image:[LEUIFramework getUIImage:@"popup_split" Streched:YES]];
    //
    UILabel *labelSubtitle=
    [LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:viewBG Anchor:LEAnchorOutsideBottomCenter RelativeView:split Offset:CGPointMake(0, space) CGSize:sizeSubTitle] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:curSubTitle FontSize:PopupSubtitleFontSize Font:nil Width:W-space*2 Height:0 Color:ColorGrayText Line:0 Alignment:NSTextAlignmentCenter]];
    //
//    UIButton *buttonCancle=
    [LEUIFramework getUIButtonWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:viewBG Anchor:LEAnchorInsideBottomRight Offset:CGPointMake(-space, -space) CGSize:CGSizeMake(buttonW, buttonH)] ButtonSettings:[[LEAutoLayoutUIButtonSettings alloc] initWithTitle:@"取消" FontSize:PopupTitleFontSize Font:nil Image:nil BackgroundImage:[LEUIFramework getUIImage:@"popup_btn_cancle" Streched:YES] Color:ColorWhite SelectedColor:ColorGrayText MaxWidth:buttonW SEL:@selector(onCancle) Target:self]];
//    UIButton *buttonOK=
    [LEUIFramework getUIButtonWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:viewBG Anchor:LEAnchorInsideBottomLeft Offset:CGPointMake(space, -space) CGSize:CGSizeMake(buttonW, buttonH)] ButtonSettings:[[LEAutoLayoutUIButtonSettings alloc] initWithTitle:@"确定" FontSize:PopupTitleFontSize Font:nil Image:nil BackgroundImage:[LEUIFramework getUIImage:@"login_btn_login" Streched:YES] Color:ColorWhite SelectedColor:ColorGrayText MaxWidth:buttonW SEL:@selector(onOK) Target:self]];
    // 
    
    
}
-(void) onTap{
    self.result=PopupCancleOK_Cancle;
    [self easeOut];
}

-(void) onCancle{
    self.result=PopupCancleOK_NO;
    [self easeOut];
}
-(void) onOK{
    self.result=PopupCancleOK_OK;
    [self easeOut];
}
@end
