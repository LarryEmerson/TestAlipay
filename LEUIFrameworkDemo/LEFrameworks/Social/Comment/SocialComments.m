//
//  SocialComments.m
//  four23book_client_borrower_ios
//
//  Created by Larry Emerson on 15/10/8.
//  Copyright © 2015年 LarryEmerson. All rights reserved.
//

#import "SocialComments.h"
#import "SocialCommentPopup.h"
#import "SocialCommentsDetails.h"

@implementation SocialCommentsTableView{
    NSDictionary *curHeadData;
    NSArray *curHotData;
    NSArray *curNewData;
    //
    SocialCommentsCellsSection *sectionHot;
    SocialCommentsCellsSection *sectionNew;
    //
    LEBaseTableViewCell *cellHead;
}
-(void) initTableView{
    [self setBackgroundColor:ColorWhite];
}
//
-(NSInteger) _numberOfSections{
    return 3;
}
-(CGFloat) _heightForSection:(NSInteger) section{
    if (section==0) {
        return 0;
    }else if(section==1){
        return curHotData.count>0?SocialCellSectionHeight:0;
    }else if(section==2){
        return curNewData&&curNewData.count>0?SocialCellSectionHeight:0;
    }
    return 0;
}
-(UIView *) _viewForHeaderInSection:(NSInteger) section{
    if(section==0){
        return nil;
    }else if(section==1){
        if(!sectionHot){
            sectionHot=[[SocialCommentsCellsSection alloc] initForHot];
        }
        return sectionHot;
    }else if(section==2){
        if(!sectionNew){
            sectionNew=[[SocialCommentsCellsSection alloc] initForNew];
        }
        return sectionNew;
    }
    return nil;
}
-(NSInteger) _numberOfRowsInSection:(NSInteger) section{
    if(section==0){
        return curHeadData?1:0;
    }else if(section==1){
        return curHotData?curHotData.count:0;
    }else if(section==2){
        return curNewData?curNewData.count:0;
    }else{
        return 0;
    }
}
//
-(UITableViewCell *) _cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LEBaseTableViewCell *cell=nil;
    if(indexPath.section==0){
        if(!cellHead){
            cellHead=[[SocialCommentDetailsHead getInstanceFromClassName] performSelector: NSSelectorFromString(@"initWithSettings:") withObject:[[LETableViewCellSettings alloc] initWithSelectionDelegate:self.cellSelectionDelegate]];
        }
        [cellHead setData:curHeadData IndexPath:indexPath];
        return cellHead;
    }else {
        NSDictionary *dic=nil;
        if(indexPath.section==1){
            dic=[curHotData objectAtIndex:indexPath.row];
        }else if(indexPath.section==2){
            dic=[curNewData objectAtIndex:indexPath.row];
        }
        cell=[self dequeueReusableCellWithIdentifier:@"SocialCommentsCell"];
        if(!cell){
            cell=[[SocialCommentsCell alloc] initWithSettings:[[LETableViewCellSettings alloc] initWithSelectionDelegate:self.cellSelectionDelegate TableViewCellStyle:UITableViewCellStyleDefault reuseIdentifier:@"SocialCommentsCell" EnableGesture:NO]];
        }
        [cell setData:dic IndexPath:indexPath];
    }
    return cell;
}
-(void) setDataForHead:(NSDictionary *) data{
    curHeadData=data;
    [self reloadData];
}
-(void) setDataForHot:(NSArray *) data{
    curHotData=data;
    [self reloadData];
}
-(void) setDataForNew:(NSArray *) data{
    curNewData=data;
    [self reloadData];
}
@end

@interface SocialComments()<LEConnectionDelegate,LEBasePopupEmptyPageDelegate,SocialCommentInputDelegate>
@end
@implementation SocialComments{
    int curID;
    LEConnectionRequestObject *requestHead;
    LEConnectionRequestObject *requestHot;
    LEConnectionRequestObject *requestNew;
    
    LEConnectionRequestObject *requestHotStar;
    LEConnectionRequestObject *requestNewStar;
    
    LEConnectionRequestObject *requestReport;
    LEConnectionRequestObject *requestComment;
    int targetCommentID;
    int targetForumID;
    int targetSubjectID;
    NSDictionary *curHeadData;
    NSMutableArray *curHotData;
    NSMutableArray *curNewData;
    
    int pageNew;
    BOOL isNoMoreToLoad;
    BOOL isLoadMoreOnTheWay;
    UIButton *buttonComment;
}
-(id) initWithSuperView:(UIView *)view Title:(NSString *)title TableViewClassName:(NSString *)tableViewClassName CellClassName:(NSString *)cellClassName EmptyCellClassName:(NSString *)emptyCellClassName ID:(int) id { 
    curID=id;
    self= [super initWithSuperView:view Title:title TableViewClassName:tableViewClassName CellClassName:cellClassName EmptyCellClassName:emptyCellClassName];
    [self.viewContainer leSetSize:CGSizeMake(self.globalVar.ScreenWidth, self.viewContainer.bounds.size.height-NavigationBarHeight)];
    [self.curTableView leSetSize:self.viewContainer.bounds.size];
//    [self.curTableView setBackgroundColor:ColorMask2];
    UIView *inputView=[[UIView alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideBottomCenter Offset:CGPointZero CGSize:CGSizeMake(self.globalVar.ScreenWidth, NavigationBarHeight)]];
    [inputView setBackgroundColor:ColorWhite];
    [LEUIFramework getUIImageViewWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:inputView Anchor:LEAnchorInsideTopCenter Offset:CGPointZero CGSize:CGSizeMake(self.globalVar.ScreenWidth, 1)] Image:[ColorMask imageWithSize:CGSizeMake(1, 1)]];
    UIImageView *inputRect=[LEUIFramework getUIImageViewWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:inputView Anchor:LEAnchorInsideCenter Offset:CGPointZero CGSize:CGSizeMake(self.globalVar.ScreenWidth-NavigationBarHeight/2, NavigationBarHeight-StatusBarHeight/2)] Image:[[UIImage imageNamed:@"Le_EmojiInputRect"] middleStrechedImage]];
    [LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:inputRect Anchor:LEAnchorInsideLeftCenter Offset:CGPointMake(StatusBarHeight, 0) CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:@"我也说两句..." FontSize:SocialFontSizeMiddle Font:nil Width:0 Height:0 Color:ColorGrayText Line:1 Alignment:NSTextAlignmentLeft]];
    buttonComment=[LEUIFramework getUIButtonWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideBottomCenter Offset:CGPointZero CGSize:CGSizeMake(self.globalVar.ScreenWidth, NavigationBarHeight)] ButtonSettings:[[LEAutoLayoutUIButtonSettings alloc] initWithTitle:nil FontSize:0 Font:nil Image:nil BackgroundImage:nil Color:nil SelectedColor:nil MaxWidth:0 SEL:@selector(onShowCommentInput) Target:self]];
    return self;
}
 
-(void) onShowCommentInput{
    SocialCommentInput *input=[[SocialCommentInput alloc] initWithDelegate:self];
    [self addSubview:input];
}
-(void) onDoneInputWith:(NSString *)content{
    if(content.length>0&&curHeadData){
        requestComment= [[LEConnections instance] requestWithURL:RequestSocialComment parameters:@{Social_P_Token:[SocialInstance instance].curUserToken,Social_P_SubjectID:[LEUIFramework intToString:curID],Social_P_Content:content} Delegate:self];
    }
}
-(void) setExtraViewInits{
    curNewData=[[NSMutableArray alloc] init];
    curHotData=[[NSMutableArray alloc] init];
//    [self onRefreshData];
}
-(void) getHeadData{
    requestHead= [[SocialInstance instance].socialInstanceDelegate getConnectionForCommentInfoCustomizedHeadWith:@{Social_P_Token:[SocialInstance instance].curUserToken,Social_P_SubjectID:[NSString stringWithFormat:@"%d",curID],SocialPageConnectionDelegate:self}];
}
-(void) getHotData{
    requestHot=[[LEConnections instance] requestWithURL:RequestSocialUIHotComments parameters:@{Social_P_ForumID:[LEUIFramework intToString:1],Social_P_SubjectID:[LEUIFramework intToString:curID]} Delegate:self];
}
-(void) getNewData{
    requestNew=[[LEConnections instance] requestWithURL:RequestSocialUINormalComments parameters:@{Social_P_ForumID:[LEUIFramework intToString:1],Social_P_SubjectID:[LEUIFramework intToString:curID],Social_P_Page:[LEUIFramework intToString:pageNew],Social_P_Perpage:[LEUIFramework intToString:SocialCommentsPerPage]} Delegate:self];
}
-(void) onRefreshData{
    pageNew=0;
    [curNewData removeAllObjects];
    isNoMoreToLoad=NO;
    [self getHotData];
    [self getNewData];
    [self getHeadData];
}
-(void) onLoadMore{
    if(isNoMoreToLoad){
        [[LEMainViewController instance] setMessageText:@"没有可加载内容"];
        [self onLoadMoreLogic:[@[]mutableCopy]];
    }else{
        isLoadMoreOnTheWay=YES;
        ++pageNew;
        [self getNewData];
    }
}
-(void) request:(LEConnectionRequestObject *)request ResponedWith:(LEConnectionsResponseObject *)response{
//    NSLogObjects(response.result);
    if([requestComment isEqual:request]){
        NSDictionary *dic=response.result;
        if(dic&&dic.count>0){
            [curNewData insertObject:dic atIndex:0];
            [(SocialCommentsTableView *)self.curTableView setDataForNew:curNewData];
            requestComment=nil;
        }
        
    }else if([requestNewStar isEqual:request]||[requestHotStar isEqual:request]){
        if([requestNewStar isEqual:request]){
            NSDictionary *newDic=response.result;
            for (int i=0; i<curNewData.count; i++) {
                NSDictionary *dic=[curNewData objectAtIndex:i];
                if([[dic objectForKey:Social_P_ID] intValue]==[[newDic objectForKey:Social_P_ID] intValue]){
                    [curNewData replaceObjectAtIndex:i withObject:newDic];
                    [(SocialCommentsTableView *)self.curTableView setDataForNew:curNewData];
                    requestNewStar=nil;
                    break;
                }
            }
        }else if([requestHotStar isEqual:request]){
            NSDictionary *newDic=response.result;
            for (int i=0; i<curHotData.count; i++) {
                NSDictionary *dic=[curHotData objectAtIndex:i];
                if([[dic objectForKey:Social_P_ID] intValue]==[[newDic objectForKey:Social_P_ID] intValue]){
                    [curHotData replaceObjectAtIndex:i withObject:[newDic mutableCopy]];
                    [(SocialCommentsTableView *)self.curTableView setDataForHot:curHotData];
                    requestHotStar=nil;
                    break;
                }
            }
        }
    }else if([requestReport isEqual:request]){
        [[LEMainViewController instance] setMessageText:@"举报成功"];
    }else if([request isEqual:requestHead]){
        curHeadData=response.result;
        [(SocialCommentsTableView *)self.curTableView  setDataForHead:curHeadData];
        requestHead=nil;
    }else if([request isEqual:requestHot]){
        curHotData=[response.result mutableCopy];
        [(SocialCommentsTableView *)self.curTableView setDataForHot:curHotData];
        requestHot=nil;
    }else if([request isEqual:requestNew]){
        if(isLoadMoreOnTheWay){
            isLoadMoreOnTheWay=NO;
            [self onLoadMoreLogic:[@[]mutableCopy]];
        }
        isNoMoreToLoad=[response.result count]==0;
        for (int i=0; i<[response.result count]; i++) {
            [curNewData addObject:[response.result objectAtIndex:i]];
        }
        [(SocialCommentsTableView *)self.curTableView setDataForNew:curNewData];
        requestNew=nil;
    }
    if(requestHead==nil&&requestHot==nil&&requestNew==nil){
        [self onFreshDataLogic:[@[] mutableCopy]];
    }
}
-(void) onTableViewCellSelectedWithInfo:(NSDictionary *)info{
//    NSLogObjects(info);
    NSIndexPath *index=[info objectForKey:KeyOfCellIndexPath];
    int cellStatus=[[info objectForKey:KeyOfCellClickStatus] intValue];
    if(index.section==0){
        [self easeOutView];
    }else if(index.section==1||index.section==2){
        NSDictionary *dic=[(index.section==1?curHotData:curNewData) objectAtIndex:index.row];
        targetCommentID=[[dic objectForKey:Social_P_ID] intValue];
        targetForumID=[[dic objectForKey:Social_P_ForumID] intValue];
        targetSubjectID=[[dic objectForKey:Social_P_SubjectID] intValue];
        int userid=[[dic objectForKey:Social_P_UserId] intValue];
        if(cellStatus==0){
            SocialCommentPopup *popup=[[SocialCommentPopup alloc] initWithDelegate:self];
            [self addSubview:popup];
            [popup easeIn];
        }else if(cellStatus==1){
            if(userid!=[SocialInstance instance].curUserID){
                [[SocialInstance instance] launchPageForSocialActivityWithSuperView:self UserId:userid];
            }
        }else if(cellStatus==2){
            if(index.section==1){
                requestHotStar = [[LEConnections instance] requestWithURL:RequestSocialStar parameters:@{Social_P_Token:[SocialInstance instance].curUserToken,Social_P_CommentID:[dic objectForKey:Social_P_ID]} Delegate:self];
            }else if(index.section==2){
                requestNewStar=[[LEConnections instance] requestWithURL:RequestSocialStar parameters:@{Social_P_Token:[SocialInstance instance].curUserToken,Social_P_CommentID:[dic objectForKey:Social_P_ID]} Delegate:self];
            }
        }else if(cellStatus==3){
            SocialCommentsDetails *details= [[SocialCommentsDetails alloc] initWithSuperView:self Title:@"评论详情" TableViewClassName:@"SocialCommentsDetailsTableView" CellClassName:nil EmptyCellClassName:nil CommentID:(int)targetCommentID ShowHead:NO];
            [self addSubview:details];
            [details easeInView];
        }
    } 
}
-(void) onDoneEaseOut:(NSString *)result{
    NSLogObjects(result);
    if([result isEqualToString:SocialCommentPopupReply]){
        SocialCommentsDetails *details= [[SocialCommentsDetails alloc] initWithSuperView:self Title:@"评论详情" TableViewClassName:@"SocialCommentsDetailsTableView" CellClassName:nil EmptyCellClassName:nil CommentID:(int)targetCommentID ShowHead:NO];
        [self addSubview:details];
        [details easeInView];
        [details onCommentReply];
    }else if([result isEqualToString:SocialCommentPopupReport]){
        requestReport= [[LEConnections instance] requestWithURL:RequestSocialReportComment parameters:@{Social_P_Token:[SocialInstance instance].curUserToken,Social_P_CommentID:[LEUIFramework intToString:targetCommentID]} Delegate:self];
    }
}

@end
