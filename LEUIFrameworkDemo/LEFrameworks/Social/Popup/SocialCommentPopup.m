//
//  SocialCommentPopup.m
//  four23book_client_borrower_ios
//
//  Created by Larry Emerson on 15/10/10.
//  Copyright (c) 2015年 LarryEmerson. All rights reserved.
//

#import "SocialCommentPopup.h"

@implementation SocialCommentPopup

-(void) initUI{
    UIView *v=[[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:v];
    [self addTapEventWithSEL:@selector(onCancle)];
    self.needsEaseIn=YES;
    //
    UIImage *imgBg=[UIImage imageNamed:@"SocialPopupBackground"];
    int space=18;
    int popupSpace=50;
    int buttonH=40;
    UIImageView *bg=[LEUIFramework getUIImageViewWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideCenter Offset:CGPointZero CGSize:CGSizeMake(self.globalVar.ScreenWidth-popupSpace*2, space*4+buttonH*3)] Image:[imgBg middleStrechedImage]];
    [bg setUserInteractionEnabled:YES];
    int buttonW=bg.bounds.size.width-space*2;
    [LEUIFramework getUIButtonWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:bg Anchor:LEAnchorInsideTopCenter Offset:CGPointMake(0, space) CGSize:CGSizeMake(buttonW, buttonH)] ButtonSettings:[[LEAutoLayoutUIButtonSettings alloc] initWithTitle:@"回复" FontSize:SocialFontSizeBig Font:nil Image:nil BackgroundImage:[imgBg middleStrechedImage] Color:ColorGrayText SelectedColor:ColorMask2 MaxWidth:0 SEL:@selector(onReply) Target:self]];
    [LEUIFramework getUIButtonWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:bg Anchor:LEAnchorInsideTopCenter Offset:CGPointMake(0, space*2+buttonH) CGSize:CGSizeMake(buttonW, buttonH)] ButtonSettings:[[LEAutoLayoutUIButtonSettings alloc] initWithTitle:@"举报" FontSize:SocialFontSizeBig Font:nil Image:nil BackgroundImage:[imgBg middleStrechedImage] Color:ColorGrayText SelectedColor:ColorMask2 MaxWidth:0 SEL:@selector(onReport) Target:self]];
    [LEUIFramework getUIButtonWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:bg Anchor:LEAnchorInsideTopCenter Offset:CGPointMake(0, space*3+buttonH*2) CGSize:CGSizeMake(buttonW, buttonH)] ButtonSettings:[[LEAutoLayoutUIButtonSettings alloc] initWithTitle:@"取消" FontSize:SocialFontSizeBig Font:nil Image:nil BackgroundImage:[imgBg middleStrechedImage] Color:ColorGrayText SelectedColor:ColorMask2 MaxWidth:0 SEL:@selector(onCancle) Target:self]];
}

-(void) onCancle{
    self.result=SocialCommentPopupCancle;
    [self easeOut];
}
-(void) onReply{
    self.result=SocialCommentPopupReply;
    [self easeOut];
}
-(void) onReport{
    self.result=SocialCommentPopupReport;
    [self easeOut];
}
@end
