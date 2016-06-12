//
//  SocialActivityCells.m
//  four23book_client_borrower_ios
//
//  Created by Larry Emerson on 15/10/9.
//  Copyright (c) 2015年 LarryEmerson. All rights reserved.
//

#import "SocialActivityCells.h"
#import "NSDate+Category.h"
#import "SocialViewContainer.h"
@implementation SocialActivityCellPraised{
    int cellWidth;
    UIImageView *curAvatar;
    UILabel *curNickname;
    UIImageView *curSex;
    UILabel *curTime;
    UILabel *curContent;
    
    UILabel *praisePrefix;
    //
    UIView *curSubViewContainer;
    UILabel *curSubTitle;
    UILabel *curSubTime;
    UILabel *curSubContent;

}
-(void) initUI{
    cellWidth=self.globalVar.ScreenWidth-SocialAvatarSpace*3-SocialAvatarSize;
    curAvatar=[LEUIFramework getUIImageViewWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideTopLeft Offset:CGPointMake(SocialAvatarSpace, SocialAvatarSpace) CGSize:CGSizeMake(SocialAvatarSize, SocialAvatarSize)] Image:nil];
    curNickname=[LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorOutsideRightCenter RelativeView:curAvatar Offset:CGPointMake(SocialAvatarSpace, -SocialFontSizeBig) CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:nil FontSize:SocialFontSizeBig Font:nil Width:0 Height:0 Color:ColorBlack Line:1 Alignment:NSTextAlignmentLeft]];
    curSex=[LEUIFramework getUIImageViewWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorOutsideRightCenter RelativeView:curNickname Offset:CGPointMake(SocialAvatarSpace, 0) CGSize:CGSizeZero] Image:[UIImage imageNamed:@"SocialSexIconBoy"]];
    curTime=[LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideTopRight Offset:CGPointMake(-SocialAvatarSpace, SocialAvatarSpace*2) CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:nil FontSize:SocialFontSize Font:nil Width:0 Height:0 Color:ColorGrayText Line:1 Alignment:NSTextAlignmentRight]];
    praisePrefix=[LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorOutsideBottomLeft RelativeView:curNickname Offset:CGPointMake(0, SocialAvatarSpace/2) CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:@"赞" FontSize:SocialFontSizeMiddle Font:nil Width:0 Height:0 Color:ColorNavigationContent Line:1 Alignment:NSTextAlignmentLeft]];
    curContent=[LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorOutsideRightTop RelativeView:praisePrefix Offset:CGPointMake(SocialAvatarSpace/2, 0) CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:nil FontSize:SocialFontSizeMiddle Font:nil Width:cellWidth-SocialCommentCellSpace Height:0 Color:ColorBlack Line:0 Alignment:NSTextAlignmentLeft]];
    curSubViewContainer=[[UIView alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorOutsideBottomLeft RelativeView:curContent Offset:CGPointMake(-praisePrefix.bounds.size.width-SocialAvatarSpace/2, SocialCommentCellSpace) CGSize:CGSizeMake(cellWidth, 0)]];
    [curSubViewContainer setBackgroundColor:ColorMask2];
    curSubTitle=[LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:curSubViewContainer Anchor:LEAnchorInsideTopLeft Offset:CGPointMake(SocialCommentCellSpace, SocialCommentCellSpace) CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:nil FontSize:SocialCommentCellFontSize Font:nil Width:cellWidth Height:SocialCommentCellTimeHeight Color:ColorNavigationContent Line:1 Alignment:NSTextAlignmentLeft]];
    
    curSubTime=[LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:curSubViewContainer Anchor:LEAnchorInsideTopRight Offset:CGPointMake(-SocialCommentCellSpace, SocialCommentCellSpace) CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:nil FontSize:SocialFontSize Font:nil Width:0 Height:0 Color:ColorGrayText Line:1 Alignment:NSTextAlignmentRight]];
    
    curSubContent=[LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:curSubViewContainer Anchor:LEAnchorInsideBottomLeft Offset:CGPointMake(SocialCommentCellSpace, -SocialCommentCellSpace) CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:nil FontSize:SocialCommentCellFontSize Font:nil Width:cellWidth-SocialCommentCellSpace*2 Height:0 Color:ColorBlack Line:0 Alignment:NSTextAlignmentLeft]];
}

-(void) setData:(NSDictionary *)data IndexPath:(NSIndexPath *)path{
    NSLogObjects(data);
    self.curIndexPath=path;
    //
    int type=[[data objectForKey:Social_P_Type] intValue];
    if(type==3){
        [praisePrefix leSetText:@"赞"];
    }else if(type==4){
        [praisePrefix leSetText:@"取消"];
    }
    [curContent.leAutoLayoutSettings setLeLabelMaxWidth:cellWidth-SocialCommentCellSpace-praisePrefix.bounds.size.width];
    [curSubViewContainer leSetOffset:CGPointMake(-praisePrefix.bounds.size.width-SocialAvatarSpace/2, SocialCommentCellSpace)];
    NSString *avatar=[data objectForKey:Social_P_Avatar];
    NSString *content=[data objectForKey:Social_P_Content];
    NSString *nickname=[data objectForKey:Social_P_NickName];
    BOOL sex=[[data objectForKey:Social_P_Sex] boolValue];
    NSString *json=[data objectForKey:Social_P_SubjectContent];
    int time=[[data objectForKey:Social_P_Timestamp] intValue];
    //
    [curAvatar setImageWithURL:[NSURL URLWithString:[ImageDownloadPath stringByAppendingString:avatar]]];
    [curNickname leSetText:nickname];
    [curSex setImage:[UIImage imageNamed:sex?@"SocialSexIconBoy":@"SocialSexIconGirl"]];
    [curTime leSetText:[[NSDate dateWithTimeIntervalSince1970:time] dateDescription]];
    if(type==3||type==4){
        if(type==3){
            content=[NSString stringWithFormat:@"了%@的评论",content];
        }else if(type==4){
            content=[NSString stringWithFormat:@"了对%@的赞",content];
        }
    }
    [curContent leSetText:content];
    //
    NSDictionary *jsonDic=[json JSONValue];
    NSString *subTitle=[jsonDic objectForKey:Social_P_NickName];
    int subTime=[[jsonDic objectForKey:Social_P_Timestamp] intValue];
    NSString *subContent=[jsonDic objectForKey:Social_P_Content];

    //
    [curSubTime leSetText:[[NSDate dateWithTimeIntervalSince1970:subTime] dateDescription]];
    [curSubContent leSetText:subContent];
    [curSubTitle.leAutoLayoutSettings setLeLabelMaxWidth:cellWidth-SocialCommentCellSpace*3-curSubTime.bounds.size.width];
    [curSubTitle leSetText:[subTitle stringByAppendingString:@"："]];
    //
    int height1=SocialAvatarSpace*4+curNickname.bounds.size.height+curContent.bounds.size.height;
    int height2=SocialCommentCellSpace*2+SocialCommentCellTimeHeight+curSubContent.bounds.size.height;
    [curSubViewContainer leSetSize:CGSizeMake(cellWidth, height2)];
    [self setCellHeight:height1+height2];
}

@end
 
@implementation SocialActivityCellCommented{
    int cellWidth;
    UIImageView *curAvatar;
    UILabel *curNickname;
    UIImageView *curSex;
    UILabel *curTime;
    UILabel *curContent;
    //
    SocialViewContainer *curSubViewContainer;
//    UILabel *curSubTitle;
//    UIImageView *curBook;
//    UILabel *curSubContent;
    
}
-(void) initUI{
    cellWidth=self.globalVar.ScreenWidth-SocialAvatarSpace*3-SocialAvatarSize;
    curAvatar=[LEUIFramework getUIImageViewWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideTopLeft Offset:CGPointMake(SocialAvatarSpace, SocialAvatarSpace) CGSize:CGSizeMake(SocialAvatarSize, SocialAvatarSize)] Image:nil];
    [curAvatar.layer setMasksToBounds:YES];
    [curAvatar.layer setCornerRadius:SocialAvatarSize/2];
    curNickname=[LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorOutsideRightCenter RelativeView:curAvatar Offset:CGPointMake(SocialAvatarSpace, -SocialFontSizeBig) CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:nil FontSize:SocialFontSizeBig Font:nil Width:0 Height:0 Color:ColorBlack Line:1 Alignment:NSTextAlignmentLeft]];
    curSex=[LEUIFramework getUIImageViewWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorOutsideRightCenter RelativeView:curNickname Offset:CGPointMake(SocialAvatarSpace, 0) CGSize:CGSizeZero] Image:[UIImage imageNamed:@"SocialSexIconBoy"]];
    curTime=[LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideTopRight Offset:CGPointMake(-SocialAvatarSpace, SocialAvatarSpace*2) CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:nil FontSize:SocialFontSize Font:nil Width:0 Height:0 Color:ColorGrayText Line:1 Alignment:NSTextAlignmentRight]];
    curContent=[LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorOutsideBottomLeft RelativeView:curNickname Offset:CGPointMake(0, SocialAvatarSpace/2) CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:nil FontSize:SocialFontSizeMiddle Font:nil Width:cellWidth Height:0 Color:ColorBlack Line:0 Alignment:NSTextAlignmentLeft]];
    curSubViewContainer=[[SocialActivityCommentCellClassName getInstanceFromClassName] performSelector:NSSelectorFromString(@"initWithAutoLayoutSettings:") withObject:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorOutsideBottomLeft RelativeView:curContent Offset:CGPointMake(0, SocialCommentCellSpace) CGSize:CGSizeMake(cellWidth, SocialCommentedHeadCellSize)]];
    [curSubViewContainer setBackgroundColor:ColorMask2];
}

-(void) setData:(NSDictionary *)data IndexPath:(NSIndexPath *)path{
    self.curIndexPath=path;
    //
    NSString *avatar=[data objectForKey:Social_P_Avatar];
    NSString *content=[data objectForKey:Social_P_Content];
//    NSString *nickname=[data objectForKey:Social_P_NickName];
    BOOL sex=[[data objectForKey:Social_P_Sex] boolValue];
    NSString *json=[data objectForKey:Social_P_SubjectContent];
    int time=[[data objectForKey:Social_P_Timestamp] intValue];
    //
    [curAvatar setImageWithURL:[NSURL URLWithString:[ImageDownloadPath stringByAppendingString:avatar]]];
    [curNickname leSetText:[data objectForKey:Social_P_ToNickName]];
    [curSex setImage:[UIImage imageNamed:sex?@"SocialSexIconBoy":@"SocialSexIconGirl"]];
    [curTime leSetText:[[NSDate dateWithTimeIntervalSince1970:time] dateDescription]];
    [curContent leSetText:content];
    //
    NSDictionary *jsonDic=[json JSONValue];
    //
    [curSubViewContainer performSelector:NSSelectorFromString(@"setData:") withObject:jsonDic];
    //
    int height=SocialAvatarSpace*3.5+curNickname.bounds.size.height+curContent.bounds.size.height+SocialCommentCellSpace+curSubViewContainer.bounds.size.height;
    [self setCellHeight:height];
}

@end
@implementation SocialActivityCellResponded{
    int cellWidth;
    UIImageView *curAvatar;
    UILabel *curNickname;
    UIImageView *curSex;
    UILabel *curTime;
    UILabel *curContent;
    //
    UIView *curSubViewContainer;
    UILabel *curSubTitle;
    UILabel *curSubTime;
    UILabel *curSubContent;
    
}
-(void) initUI{
    cellWidth=self.globalVar.ScreenWidth-SocialAvatarSpace*3-SocialAvatarSize;
    curAvatar=[LEUIFramework getUIImageViewWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideTopLeft Offset:CGPointMake(SocialAvatarSpace, SocialAvatarSpace) CGSize:CGSizeMake(SocialAvatarSize, SocialAvatarSize)] Image:nil];
    curNickname=[LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorOutsideRightCenter RelativeView:curAvatar Offset:CGPointMake(SocialAvatarSpace, -SocialFontSizeBig) CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:nil FontSize:SocialFontSizeBig Font:nil Width:0 Height:0 Color:ColorBlack Line:1 Alignment:NSTextAlignmentLeft]];
    curSex=[LEUIFramework getUIImageViewWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorOutsideRightCenter RelativeView:curNickname Offset:CGPointMake(SocialAvatarSpace, 0) CGSize:CGSizeZero] Image:[UIImage imageNamed:@"SocialSexIconBoy"]];
    curTime=[LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideTopRight Offset:CGPointMake(-SocialAvatarSpace, SocialAvatarSpace*2) CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:nil FontSize:SocialFontSize Font:nil Width:0 Height:0 Color:ColorGrayText Line:1 Alignment:NSTextAlignmentRight]];
    curContent=[LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorOutsideBottomLeft RelativeView:curNickname Offset:CGPointMake(0, SocialAvatarSpace/2) CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:nil FontSize:SocialFontSizeMiddle Font:nil Width:cellWidth Height:0 Color:ColorBlack Line:0 Alignment:NSTextAlignmentLeft]];
    curSubViewContainer=[[UIView alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorOutsideBottomLeft RelativeView:curContent Offset:CGPointMake(0, SocialCommentCellSpace) CGSize:CGSizeMake(cellWidth, 0)]];
    [curSubViewContainer setBackgroundColor:ColorMask2];
    curSubTitle=[LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:curSubViewContainer Anchor:LEAnchorInsideTopLeft Offset:CGPointMake(SocialCommentCellSpace, SocialCommentCellSpace) CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:nil FontSize:SocialCommentCellFontSize Font:nil Width:cellWidth Height:SocialCommentCellTimeHeight Color:ColorNavigationContent Line:1 Alignment:NSTextAlignmentLeft]];
    
    curSubTime=[LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:curSubViewContainer Anchor:LEAnchorInsideTopRight Offset:CGPointMake(-SocialCommentCellSpace, SocialCommentCellSpace) CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:nil FontSize:SocialFontSize Font:nil Width:0 Height:0 Color:ColorGrayText Line:1 Alignment:NSTextAlignmentRight]];
    
    curSubContent=[LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:curSubViewContainer Anchor:LEAnchorInsideBottomLeft Offset:CGPointMake(SocialCommentCellSpace, -SocialCommentCellSpace) CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:nil FontSize:SocialCommentCellFontSize Font:nil Width:cellWidth-SocialCommentCellSpace*2 Height:0 Color:ColorBlack Line:0 Alignment:NSTextAlignmentLeft]];
}

-(void) setData:(NSDictionary *)data IndexPath:(NSIndexPath *)path{
    self.curIndexPath=path;
    //
    NSString *avatar=[data objectForKey:Social_P_Avatar];
    NSString *content=[data objectForKey:Social_P_Content];
    NSString *nickname=[data objectForKey:Social_P_NickName];
    BOOL sex=[[data objectForKey:Social_P_Sex] boolValue];
    NSString *json=[data objectForKey:Social_P_SubjectContent];
    int time=[[data objectForKey:Social_P_Timestamp] intValue];
    //
    [curAvatar setImageWithURL:[NSURL URLWithString:[ImageDownloadPath stringByAppendingString:avatar]]];
    [curNickname leSetText:nickname];
    [curSex setImage:[UIImage imageNamed:sex?@"SocialSexIconBoy":@"SocialSexIconGirl"]];
    [curTime leSetText:[[NSDate dateWithTimeIntervalSince1970:time] dateDescription]];
    [curContent leSetText:content];
    //
    NSDictionary *jsonDic=[json JSONValue];
    NSString *subTitle=[jsonDic objectForKey:Social_P_NickName];
    int subTime=[[jsonDic objectForKey:Social_P_Timestamp] intValue];
    NSString *subContent=[jsonDic objectForKey:Social_P_Content];
    
    //
    [curSubTime leSetText:[[NSDate dateWithTimeIntervalSince1970:subTime] dateDescription]];
    [curSubContent leSetText:subContent];
    [curSubTitle.leAutoLayoutSettings setLeLabelMaxWidth:cellWidth-SocialCommentCellSpace*3-curSubTime.bounds.size.width];
    [curSubTitle leSetText:[subTitle stringByAppendingString:@"："]];
    //
    int height1=SocialAvatarSpace*4+curNickname.bounds.size.height+curContent.bounds.size.height;
    int height2=SocialCommentCellSpace*2+SocialCommentCellTimeHeight+curSubContent.bounds.size.height;
    [curSubViewContainer leSetSize:CGSizeMake(cellWidth, height2)];
    [self setCellHeight:height1+height2];
}

@end