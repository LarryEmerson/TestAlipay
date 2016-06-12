//
//  SocialCommentsDetailsCells.m
//  four23book_client_borrower_ios
//
//  Created by Larry Emerson on 15/10/12.
//  Copyright (c) 2015年 LarryEmerson. All rights reserved.
//

#import "SocialCommentsDetailsCells.h"
#import "NSDate+Category.h"

@implementation SocialCommentsDetailsCellResponse{
    UILabel *curNickName;
    UILabel *curTime;
    UILabel *curContent;
    int cellWidth;
}

-(void) initUI{
    self.hasBottomSplit=NO;
    cellWidth=[LEUIFramework instance].ScreenWidth-SocialAvatarSpace*3-SocialAvatarSize;
    curNickName=[LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideTopLeft Offset:CGPointMake(SocialAvatarSpace*2+SocialAvatarSize, SocialCommentCellSpace) CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:nil FontSize:SocialFontSizeMiddle Font:nil Width:cellWidth Height:0 Color:ColorNavigationContent Line:1 Alignment:NSTextAlignmentLeft]];
    curTime=[LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideTopRight Offset:CGPointMake(-SocialAvatarSpace, SocialCommentCellSpace) CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:nil FontSize:SocialFontSize Font:nil Width:0 Height:0 Color:ColorGrayText Line:1 Alignment:NSTextAlignmentRight]];
    curContent=[LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorOutsideBottomLeft RelativeView:curNickName Offset:CGPointMake(0, SocialAvatarSpace) CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:nil FontSize:SocialFontSizeMiddle Font:nil Width:cellWidth Height:0 Color:ColorBlack Line:0 Alignment:NSTextAlignmentLeft]];
}
-(void) setData:(NSDictionary *)data IndexPath:(NSIndexPath *)path{
    self.curIndexPath=path;
    NSString *nickname=[data objectForKey:Social_P_NickName];
    int time=[[data objectForKey:Social_P_Timestamp] intValue];
    NSString *content=[data objectForKey:Social_P_Content];
    [curNickName leSetText:nickname];
    [curTime leSetText:[[[NSDate alloc] initWithTimeIntervalSince1970:time] dateDescription]];
    [curContent leSetText:content];
    int height=curNickName.bounds.size.height+SocialAvatarSpace+curContent.bounds.size.height;
    [self setCellHeight:height+SocialCommentCellSpace*2];
}
@end

@implementation SocialCommentsDetailsCell{
    int cellWidth;
    UIImageView *curAvatar;
    UILabel *curNickname;
    UIImageView *curSex;
    UILabel *curTime;
    UILabel *curContent;
    //
    
    UIButton *avatarClick;
    UIButton *praiseClick;
    //
    NSMutableArray *curCellResponse;
    UIImageView *curSplit;
}

-(void) initUI{
    self.hasBottomSplit=NO;
    curCellResponse=[[NSMutableArray alloc] initWithCapacity:2];
    cellWidth=self.globalVar.ScreenWidth-SocialAvatarSpace*3-SocialAvatarSize;
    curAvatar=[LEUIFramework getUIImageViewWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideTopLeft Offset:CGPointMake(SocialAvatarSpace, SocialAvatarSpace) CGSize:CGSizeMake(SocialAvatarSize, SocialAvatarSize)] Image:nil];
    curNickname=[LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorOutsideRightCenter RelativeView:curAvatar Offset:CGPointMake(SocialAvatarSpace, -SocialFontSizeBig) CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:nil FontSize:SocialFontSizeBig Font:nil Width:0 Height:0 Color:ColorBlack Line:1 Alignment:NSTextAlignmentLeft]];
    curSex=[LEUIFramework getUIImageViewWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorOutsideRightCenter RelativeView:curNickname Offset:CGPointMake(SocialAvatarSpace, 0) CGSize:CGSizeZero] Image:[UIImage imageNamed:@"SocialSexIconBoy"]];
    curTime=[LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorOutsideBottomLeft RelativeView:curNickname Offset:CGPointMake(0, SocialAvatarSpace/2) CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:nil FontSize:SocialFontSize Font:nil Width:0 Height:0 Color:ColorGrayText Line:1 Alignment:NSTextAlignmentRight]];
    curContent=[LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorOutsideBottomLeft RelativeView:curTime Offset:CGPointMake(0, SocialAvatarSpace/2) CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:nil FontSize:SocialFontSizeMiddle Font:nil Width:cellWidth Height:0 Color:ColorBlack Line:0 Alignment:NSTextAlignmentLeft]];
    curSplit=[LEUIFramework getUIImageViewWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideBottomRight Offset:CGPointMake(-SocialCommentCellSpace, 0) CGSize:CGSizeMake(cellWidth, 1)] Image:[[ColorMask2 imageWithSize:CGSizeMake(1, 1)] middleStrechedImage]];
}
-(void) initTopClickUIS{
    avatarClick=[[UIButton alloc] initWithFrame:CGRectMake(SocialAvatarSpace, SocialAvatarSpace, SocialAvatarSize, SocialAvatarSize)];
    [avatarClick addTarget:self action:@selector(onAvatarClicked) forControlEvents:UIControlEventTouchUpInside];
    [avatarClick setBackgroundImage:[ColorMask2 imageWithSize:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
    [avatarClick.layer setMasksToBounds:YES];
    [avatarClick.layer setCornerRadius:SocialAvatarSize/2];
    //
    praiseClick=[[UIButton alloc] initWithFrame:CGRectMake(self.globalVar.ScreenWidth-SocialAvatarSize, SocialAvatarSpace, SocialAvatarSize, SocialAvatarSize/3)];
    [praiseClick setTitleColor:ColorNavigationContent forState:UIControlStateNormal];
    [praiseClick setTitleColor:ColorGrayText forState:UIControlStateHighlighted];
    [praiseClick setImage:[UIImage imageNamed:@"SocialPraisedIcon"] forState:UIControlStateNormal];
    [praiseClick.titleLabel setFont:[UIFont systemFontOfSize:SocialFontSizeMiddle]];
    [praiseClick setTitleEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 0)];
    [praiseClick addTarget:self action:@selector(onPraiseClicked) forControlEvents:UIControlEventTouchUpInside];
    //
    [self addSubview:avatarClick];
    [self addSubview:praiseClick];
    
}
-(void) onPraiseClicked{
    [self onCellSelectedWithIndex:2];
}
-(void) onAvatarClicked{
    [self onCellSelectedWithIndex:1];
}
-(BOOL) checkUserId:(int) userid ExistInGroups:(NSArray *) array{
    BOOL isFound=NO;
    for (int i=0; i<array.count; i++) {
        NSDictionary *dic=[array objectAtIndex:i];
        if(userid==[[dic objectForKey:Social_P_UserId] intValue]){
            isFound=YES;
            break;
        }
    }
    return isFound;
}
-(void) setData:(NSDictionary *)data IndexPath:(NSIndexPath *)path{
//    NSLogObjects(data);
    self.curIndexPath=path;
    //
    NSString *avatar=[data objectForKey:Social_P_Avatar];
    NSString *content=[data objectForKey:Social_P_Content];
    NSString *nickname=[data objectForKey:Social_P_NickName];
    BOOL sex=[[data objectForKey:Social_P_Sex] boolValue];
    int time=[[data objectForKey:Social_P_Timestamp] intValue];
    NSString *starCount=[data objectForKey:Social_P_StarCount];
    //
    [curAvatar setImageWithURL:[NSURL URLWithString:[ImageDownloadPath stringByAppendingString:avatar]]];
    [curNickname leSetText:nickname];
    [curSex setImage:[UIImage imageNamed:sex?@"SocialSexIconBoy":@"SocialSexIconGirl"]];
    [curTime leSetText:[[NSDate dateWithTimeIntervalSince1970:time] dateDescription]];
    [curContent leSetText:content];
    //
    [praiseClick setTitle:starCount forState:UIControlStateNormal];
    BOOL isPraised=[self checkUserId:[SocialInstance instance].curUserID ExistInGroups:[data objectForKey:Social_P_StarUserIDs]];
    [praiseClick setImage:[UIImage imageNamed:isPraised?@"SocialPraisedIconSel":@"SocialPraisedIcon"] forState:UIControlStateNormal];
    [praiseClick setTitleColor:isPraised?ColorNavigationContent:ColorGrayText forState:UIControlStateNormal];
    
    int height1=SocialAvatarSpace*4+curNickname.bounds.size.height+curContent.bounds.size.height;
    [self setCellHeight:height1+SocialCommentCellSpace];
}

@end
