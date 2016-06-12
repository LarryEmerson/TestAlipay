//
//  SocialCommentsCells.m
//  four23book_client_borrower_ios
//
//  Created by Larry Emerson on 15/10/10.
//  Copyright (c) 2015年 LarryEmerson. All rights reserved.
//

#import "SocialCommentsCells.h"
#import "NSDate+Category.h"
@implementation SocialCommentsCellsSection{
    int sectionStatus;
}
-(id) initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    [self initUI];
    return self;
}
-(void) initUI{
//    [self setBackgroundColor:ColorWhite];
    UIImageView *view=
    [LEUIFramework getUIImageViewWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideLeftCenter Offset:CGPointMake(0, 0) CGSize:CGSizeMake(80, SocialCellSectionHeight-8)] Image:[[UIImage imageNamed:@"SocialSectionBar"] middleStrechedImage]];
    [LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:view Anchor:LEAnchorInsideCenter Offset:CGPointZero CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:sectionStatus?@"最新评论":@"热门评论" FontSize:SocialFontSizeBig Font:nil Width:0 Height:0 Color:ColorWhite Line:1 Alignment:NSTextAlignmentCenter]];
}
-(id) initForHot{
    sectionStatus=0;
    return [self initWithFrame:CGRectMake(0, 0, [LEUIFramework instance].ScreenWidth, SocialCellSectionHeight)];
}
-(id) initForNew{
    sectionStatus=1;
    return [self initWithFrame:CGRectMake(0, 0, [LEUIFramework instance].ScreenWidth, SocialCellSectionHeight)];
}
@end


@implementation SocialCommentsCellResponse{
    UILabel *curNickName;
    UILabel *curTime;
    UILabel *curContent;
    int cellWidth;
}

-(id) initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    [self initUI];
    return self;
}
-(void) initUI{
    [self setUserInteractionEnabled:NO];
    cellWidth=[LEUIFramework instance].ScreenWidth-SocialAvatarSpace*3-SocialAvatarSize;
    curNickName=[LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideTopLeft Offset:CGPointMake(SocialAvatarSpace*2+SocialAvatarSize, 0) CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:nil FontSize:SocialFontSizeMiddle Font:nil Width:cellWidth Height:0 Color:ColorNavigationContent Line:1 Alignment:NSTextAlignmentLeft]];
    curTime=[LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideTopRight Offset:CGPointMake(-SocialAvatarSpace, 0) CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:nil FontSize:SocialFontSize Font:nil Width:0 Height:0 Color:ColorGrayText Line:1 Alignment:NSTextAlignmentRight]];
    curContent=[LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorOutsideBottomLeft RelativeView:curNickName Offset:CGPointMake(0, SocialAvatarSpace) CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:nil FontSize:SocialFontSizeMiddle Font:nil Width:cellWidth Height:0 Color:ColorBlack Line:2 Alignment:NSTextAlignmentLeft]];
}
-(void) setData:(NSDictionary *) data Frame:(CGRect) frame{
    [self setFrame:frame];
    NSString *nickname=[data objectForKey:Social_P_NickName];
    int time=[[data objectForKey:Social_P_Timestamp] intValue];
    NSString *content=[data objectForKey:Social_P_Content];
    [curNickName leSetText:nickname];
    [curTime leSetText:[[[NSDate alloc] initWithTimeIntervalSince1970:time] dateDescription]];
    CGSize size=[content getSizeWithFont:curContent.font MaxSize:CGSizeMake(cellWidth, LELabelMaxSize.height)];
    [curContent leSetSize:CGSizeMake(cellWidth, size.height)];
    [curContent setText:content];
    int height=curNickName.bounds.size.height+SocialAvatarSpace+curContent.bounds.size.height;
    CGRect rect=self.frame;
    rect.size.height=height;
    [self setFrame:rect];
}
@end
@implementation SocialCommentsCell{
    int cellWidth;
    UIImageView *curAvatar;
    UILabel *curNickname;
    UIImageView *curSex;
    UILabel *curTime;
    UILabel *curContent;
    //
    UIButton *contentClick;
    UIButton *contentClick2;
    UIButton *avatarClick;
    UIButton *praiseClick;
    UIButton *moreClick;
    UILabel *moreLabel;
    //
    NSMutableArray *curCellResponse;
    
    UIImageView *curSplit;
}

-(void) initUI{
    curCellResponse=[[NSMutableArray alloc] initWithCapacity:2];
    cellWidth=self.globalVar.ScreenWidth-SocialAvatarSpace*3-SocialAvatarSize;
    curAvatar=[LEUIFramework getUIImageViewWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideTopLeft Offset:CGPointMake(SocialAvatarSpace, SocialAvatarSpace) CGSize:CGSizeMake(SocialAvatarSize, SocialAvatarSize)] Image:nil];
    curNickname=[LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorOutsideRightCenter RelativeView:curAvatar Offset:CGPointMake(SocialAvatarSpace, -SocialFontSizeBig) CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:nil FontSize:SocialFontSizeBig Font:nil Width:0 Height:0 Color:ColorBlack Line:1 Alignment:NSTextAlignmentLeft]];
    curSex=[LEUIFramework getUIImageViewWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorOutsideRightCenter RelativeView:curNickname Offset:CGPointMake(SocialAvatarSpace, 0) CGSize:CGSizeZero] Image:[UIImage imageNamed:@"SocialSexIconBoy"]];
    curTime=[LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorOutsideBottomLeft RelativeView:curNickname Offset:CGPointMake(0, SocialAvatarSpace/2) CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:nil FontSize:SocialFontSize Font:nil Width:0 Height:0 Color:ColorGrayText Line:1 Alignment:NSTextAlignmentRight]];
    curContent=[LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorOutsideBottomLeft RelativeView:curTime Offset:CGPointMake(0, SocialAvatarSpace/2) CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:nil FontSize:SocialFontSizeMiddle Font:nil Width:cellWidth Height:0 Color:ColorBlack Line:0 Alignment:NSTextAlignmentLeft]];
    curSplit=[LEUIFramework getUIImageViewWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorOutsideBottomLeft RelativeView:curContent Offset:CGPointMake(0, 4) CGSize:CGSizeMake(curContent.bounds.size.width, 1)] Image:[ColorMask2 imageWithSize:CGSizeMake(1, 1)]];
    //
    
}
-(void) initTopClickUIS{
    
    avatarClick=[[UIButton alloc] initWithFrame:CGRectMake(SocialAvatarSpace, SocialAvatarSpace, SocialAvatarSize, SocialAvatarSize)];
    [avatarClick addTarget:self action:@selector(onAvatarClicked) forControlEvents:UIControlEventTouchUpInside];
    [avatarClick setBackgroundImage:[ColorMask2 imageWithSize:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
    [avatarClick.layer setMasksToBounds:YES];
    [avatarClick.layer setCornerRadius:SocialAvatarSize/2];
    //
    contentClick2=[LEUIFramework getUIButtonWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorOutsideRightCenter RelativeView:curAvatar Offset:CGPointMake(SocialAvatarSpace, -SocialFontSizeBig) CGSize:CGSizeMake(cellWidth, SocialAvatarSpace+SocialAvatarSize)] ButtonSettings:[[LEAutoLayoutUIButtonSettings alloc] initWithTitle:nil FontSize:0 Font:nil Image:nil BackgroundImage:nil Color:nil SelectedColor:nil MaxWidth:0 SEL:@selector(onCommentContentClicked) Target:self]];
    //
    praiseClick=[[UIButton alloc] initWithFrame:CGRectMake(self.globalVar.ScreenWidth-SocialAvatarSize, SocialAvatarSpace, SocialAvatarSize, SocialAvatarSize/3)];
    [praiseClick setTitleColor:ColorNavigationContent forState:UIControlStateNormal];
    [praiseClick setTitleColor:ColorGrayText forState:UIControlStateHighlighted];
    [praiseClick setImage:[UIImage imageNamed:@"SocialPraisedIcon"] forState:UIControlStateNormal];
    [praiseClick.titleLabel setFont:[UIFont systemFontOfSize:SocialFontSizeMiddle]];
    [praiseClick setTitleEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 0)];
    [praiseClick addTarget:self action:@selector(onPraiseClicked) forControlEvents:UIControlEventTouchUpInside];
    //
    moreClick=[LEUIFramework getUIButtonWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorOutsideBottomLeft RelativeView:curSplit Offset:CGPointMake(0, SocialCommentCellSpace/2) CGSize:CGSizeMake(cellWidth+SocialCommentCellSpace, 0)] ButtonSettings:[[LEAutoLayoutUIButtonSettings alloc] initWithTitle:nil FontSize:0 Font:nil Image:nil BackgroundImage:nil Color:nil SelectedColor:nil MaxWidth:0 SEL:@selector(onMoreClicked) Target:self]];
    
    moreLabel=[LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideBottomRight Offset:CGPointMake(-SocialAvatarSpace, -SocialCommentCellSpace) CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:nil FontSize:SocialFontSize Font:nil Width:0 Height:0 Color:ColorNavigationContent Line:1 Alignment:NSTextAlignmentRight]];
    contentClick=[LEUIFramework getUIButtonWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorOutsideBottomLeft RelativeView:curTime Offset:CGPointMake(-SocialCommentCellSpace, SocialCommentCellSpace/2) CGSize:CGSizeMake(cellWidth+SocialCommentCellSpace, 0)] ButtonSettings:[[LEAutoLayoutUIButtonSettings alloc] initWithTitle:nil FontSize:0 Font:nil Image:nil BackgroundImage:nil Color:nil SelectedColor:nil MaxWidth:0 SEL:@selector(onCommentContentClicked) Target:self]];
    //
    [moreClick setBackgroundImage:[ColorMask imageWithSize:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
    [contentClick setBackgroundImage:[ColorMask imageWithSize:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
    [self addSubview:avatarClick];
    [self addSubview:praiseClick];
    [self addSubview:moreClick];
    // 
}
-(void) onCommentContentClicked{
    [self onCellSelectedWithIndex:0];
}
-(void) onMoreClicked{
    [self onCellSelectedWithIndex:3];
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
//    NSString *json=[data objectForKey:Social_P_SubjectContent];
    int time=[[data objectForKey:Social_P_Timestamp] intValue];
    //    int type=[[data objectForKey:Social_P_Type] intValue];
    //    int userid=[[data objectForKey:Social_P_UserId] intValue];
    NSString *starCount=[data objectForKey:Social_P_StarCount];
    int replyCount=[[data objectForKey:Social_P_ReplyCount] intValue];
    if(replyCount>2){
        [moreLabel leSetText:[NSString stringWithFormat:@"更多%d条回复...",replyCount-2]];
    }
    [moreLabel setHidden:replyCount<=2];
    //
    [curAvatar setImageWithURL:[NSURL URLWithString:[ImageDownloadPath stringByAppendingString:avatar]]];
    [curNickname leSetText:nickname];
    [curSex setImage:[UIImage imageNamed:sex?@"SocialSexIconBoy":@"SocialSexIconGirl"]];
    [curTime leSetText:[[NSDate dateWithTimeIntervalSince1970:time] dateDescription]];
    [curContent leSetText:content];
    [contentClick leSetSize:CGSizeMake(cellWidth+SocialCommentCellSpace, curContent.bounds.size.height)];
    //
//    NSDictionary *jsonDic=[json JSONValue];
//    NSString *subTitle=[jsonDic objectForKey:Social_P_NickName];
//    int subTime=[[jsonDic objectForKey:Social_P_Timestamp] intValue];
//    NSString *subContent=[jsonDic objectForKey:Social_P_Content];
    //
    //
    [praiseClick setTitle:starCount forState:UIControlStateNormal];
    BOOL isPraised=[self checkUserId:[SocialInstance instance].curUserID ExistInGroups:[data objectForKey:Social_P_StarUserIDs]];
    [praiseClick setImage:[UIImage imageNamed:isPraised?@"SocialPraisedIconSel":@"SocialPraisedIcon"] forState:UIControlStateNormal];
    [praiseClick setTitleColor:isPraised?ColorNavigationContent:ColorGrayText forState:UIControlStateNormal];
    //
    NSArray *replies=[data objectForKey:Social_P_Replies];
    [curSplit setHidden:replies.count==0]; 
    for (int i=0; i<curCellResponse.count; i++) {
        [[curCellResponse objectAtIndex:i] setHidden:YES];
    }
    int cellHeight=0;
    for (int i=0; i<(replies.count>2?2:replies.count); i++) {
        SocialCommentsCellResponse *cell=nil;
        if(i>=curCellResponse.count){
            cell=[[SocialCommentsCellResponse alloc] init];
            [curCellResponse addObject:cell];
            [self addSubview:cell];
        }else{
            cell=[curCellResponse objectAtIndex:i];
        }
        [cell setHidden:NO];
        CGSize size=cell.bounds.size;
        [cell setData:[replies objectAtIndex:i] Frame:CGRectMake(0, curContent.frame.origin.y+curContent.bounds.size.height+SocialCommentCellSpace+cellHeight, self.globalVar.ScreenWidth, size.height)];
        cellHeight+=cell.bounds.size.height+SocialCommentCellSpace;
    }
    //
    int height1=SocialAvatarSpace*4+curNickname.bounds.size.height+curContent.bounds.size.height;
    int height2=SocialCommentCellSpace+ cellHeight+(replyCount>2?SocialAvatarSize/3:0);
    [moreClick leSetSize:CGSizeMake(cellWidth+SocialCommentCellSpace, cellHeight+SocialFontSize)];
    [self setCellHeight:height1+height2];
}

@end
