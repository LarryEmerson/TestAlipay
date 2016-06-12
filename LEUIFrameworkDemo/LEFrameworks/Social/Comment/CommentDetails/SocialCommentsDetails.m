//
//  SocialCommentsDetails.m
//  four23book_client_borrower_ios
//
//  Created by Larry Emerson on 15/10/12.
//  Copyright (c) 2015年 LarryEmerson. All rights reserved.
//

#import "SocialCommentsDetails.h"
#import "SocialCommentsDetailsCells.h"
#import "SocialCommentPopup.h"

@implementation SocialCommentsDetailsTableView{
    NSDictionary *curHeadData;
    NSDictionary *curCommentData;
    //
    LEBaseTableViewCell *cellHead;
    SocialCommentsDetailsCell *cellComment;
}
-(void) setHeadData:(NSDictionary *) data{
    curHeadData=data;
    [self reloadData];
}
-(void) setCommentData:(NSDictionary *) data{
    curCommentData=data;
    [self reloadData];
}

-(NSInteger) _numberOfSections{
    return (curHeadData?1:0)+(curCommentData?2:0);
}
-(NSInteger) _numberOfRowsInSection:(NSInteger)section{
    if(section==0){
        return 1;
    }else {
        if(section==1&&curHeadData){
            return 1;
        }else{
            return [[curCommentData objectForKey:Social_P_Replies] count];
        }
    }
}
-(UITableViewCell *) _cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0 && curHeadData){
        if(!cellHead){
            cellHead=[[SocialCommentDetailsHead getInstanceFromClassName] performSelector: NSSelectorFromString(@"initWithSettings:") withObject:[[LETableViewCellSettings alloc] initWithSelectionDelegate:self.cellSelectionDelegate]];
        }
        [cellHead setData:curHeadData IndexPath:indexPath];
        return cellHead;
    }else if((indexPath.section==0 && !curHeadData)||(indexPath.section==1&&curHeadData)){
        if(!cellComment){
            cellComment=[[SocialCommentsDetailsCell alloc] initWithSettings:[[LETableViewCellSettings alloc] initWithSelectionDelegate:self.cellSelectionDelegate]];
        }
        [cellComment setData:curCommentData IndexPath:indexPath];
        return cellComment;
    }else{
        LEBaseTableViewCell *cell=[self dequeueReusableCellWithIdentifier:@"SocialCommentsDetailsCellResponse"];
        if(!cell){
            cell=[[SocialCommentsDetailsCellResponse alloc] initWithSettings:[[LETableViewCellSettings alloc] initWithSelectionDelegate:self.cellSelectionDelegate TableViewCellStyle:UITableViewCellStyleDefault reuseIdentifier:@"SocialCommentsDetailsCellResponse"]];
        }
        [cell setData:[[curCommentData objectForKey:Social_P_Replies] objectAtIndex:indexPath.row] IndexPath:indexPath];
        return cell;
    }
}
-(void) scrollToBottom{
    NSIndexPath *index=[NSIndexPath indexPathForRow:[[curCommentData objectForKey:Social_P_Replies] count]-1 inSection: (curHeadData?1:0)+1];
    [self scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
@end

@interface SocialCommentsDetails()<LEConnectionDelegate,LEBasePopupEmptyPageDelegate,EmojiTextDelegate>

@end
@implementation SocialCommentsDetails{
    int curCommentID;
    BOOL curShowHead;
    NSDictionary *curHeadData;
    NSMutableDictionary *curCommentData;
    LEConnectionRequestObject *requestHead;
    LEConnectionRequestObject *requestComment;
    LEConnectionRequestObject *requestReply;
    LEConnectionRequestObject *requestReport;
    LEConnectionRequestObject *requestStar;
    BOOL isInputStatus;
    NSString *curInputString;
}
-(void) setFinishedText:(NSString *)text{
    if(text.length>0){
        curInputString=text;
        requestReply=[[LEConnections instance] requestWithURL:RequestSocialReply parameters:@{Social_P_Token:[SocialInstance instance].curUserToken,Social_P_CommentID:[LEUIFramework intToString:curCommentID],Social_P_Content:text} Delegate:self];
    }
    [self hideLE_Emoji];
}
-(void) setFinishedText:(NSString *)text IsStillToTheOne:(BOOL)isToSB{
    
} 
-(id) initWithSuperView:(UIView *)view Title:(NSString *)title TableViewClassName:(NSString *)tableViewClassName CellClassName:(NSString *)cellClassName EmptyCellClassName:(NSString *)emptyCellClassName CommentID:(int)commentid ShowHead:(BOOL)showHead{
    curCommentID=commentid;
    curShowHead=showHead;
    self= [super initWithSuperView:view Title:title TableViewClassName:tableViewClassName CellClassName:cellClassName EmptyCellClassName:emptyCellClassName];
    [self onRefreshData];
    return self;
}

-(void) onCommentReply{
    [self showLE_Emoji];
}
-(void) onDoneEaseOut:(NSString *)result{
    if([result isEqualToString:SocialCommentPopupReply]){
        [self onCommentReply];
    }else if([result isEqualToString:SocialCommentPopupReport]){
       requestReport= [[LEConnections instance] requestWithURL:RequestSocialReportComment parameters:@{Social_P_Token:[SocialInstance instance].curUserToken,Social_P_CommentID:[LEUIFramework intToString:curCommentID]} Delegate:self];
    }
}
-(void) onRefreshData{
    requestComment= [[LEConnections instance] requestWithURL:RequestSocialUICommentInfo parameters:@{Social_P_Token:[SocialInstance instance].curUserToken,Social_P_CommentID:[LEUIFramework intToString:curCommentID]} Delegate:self];
}
-(void) onLoadMore{
    
}
-(void) request:(LEConnectionRequestObject *)request ResponedWith:(LEConnectionsResponseObject *)response{
//    NSLogObjects(response.result);
    if(response.result){
        if([request isEqual:requestComment]||[request isEqual:requestStar]){
            curCommentData=[response.result mutableCopy];
            [(SocialCommentsDetailsTableView *)self.curTableView setCommentData:curCommentData];
            [self onFreshDataLogic:[@[] mutableCopy]];
            if(curShowHead&&!requestHead&&[SocialInstance instance].socialInstanceDelegate){
                requestHead= [[SocialInstance instance].socialInstanceDelegate getConnectionForCommentInfoCustomizedHeadWith:@{Social_P_Token:[SocialInstance instance].curUserToken,Social_P_SubjectID:[curCommentData objectForKey:Social_P_SubjectID],SocialPageConnectionDelegate:self}];
            }
            
        }else if([request isEqual:requestHead]){
            curHeadData=response.result;
            [(SocialCommentsDetailsTableView *)self.curTableView setHeadData:curHeadData];
        }else if([request isEqual:requestReply]){
            NSMutableArray *array=[[NSMutableArray alloc] initWithArray:[curCommentData objectForKey:Social_P_Replies]];
            [array addObject:@{Social_P_NickName:[SocialInstance instance].curNickName,Social_P_Timestamp:[LEUIFramework intToString:[[NSDate date] timeIntervalSince1970]],Social_P_Content:curInputString}];
            [curCommentData setValue:array forKey:Social_P_Replies];
            [(SocialCommentsDetailsTableView *)self.curTableView setCommentData:curCommentData];
            [self.curTableView performSelector:NSSelectorFromString(@"scrollToBottom")];
        }else if([request isEqual:requestReport]){
            [[LEMainViewController instance] setMessageText:@"举报成功"];
        }
    }
}
-(void) onTableViewCellSelectedWithInfo:(NSDictionary *)info{
    if(isInputStatus){
        [self hideLE_Emoji];
        return;
    }
//    NSLogObjects(info);
    NSIndexPath *index=[info objectForKey:KeyOfCellIndexPath];
    int cellStatus=[[info objectForKey:KeyOfCellClickStatus] intValue];
    if(index.section==0 && curHeadData){
        if([SocialInstance instance].socialInstanceDelegate){
            [[SocialInstance instance].socialInstanceDelegate onCommentInfoCustomizedHeadCalledWith:curHeadData];
        }
    }else if((index.section==0 && !curHeadData)||(index.section==1&&curHeadData)){
        if(cellStatus==0){
            [self addSubview:[[SocialCommentPopup alloc] initWithDelegate:self]];
        }else if(cellStatus==1){
            int userid=[[curCommentData objectForKey:Social_P_UserId] intValue];
            if(userid!=[SocialInstance instance].curUserID){
                [[SocialInstance instance] launchPageForSocialActivityWithSuperView:self UserId:userid];
            }
        }else if(cellStatus==2){
            requestStar=[[LEConnections instance] requestWithURL:RequestSocialStar parameters:@{Social_P_Token:[SocialInstance instance].curUserToken,Social_P_CommentID:[curCommentData objectForKey:Social_P_ID]} Delegate:self];
        }
    }else{
        
    }
}
-(void) showLE_Emoji{
    [[LEMainViewController instance] setShowLE_Emoji:self];
    [[LEMainViewController instance] setLE_EmojiIsNotClearMessage:YES];
    [[LEMainViewController instance] setLE_Emoji_BecomeFirstResponder:YES];
    isInputStatus=YES;
}
-(void) hideLE_Emoji{
    isInputStatus=NO;
    [[LEMainViewController instance] setLE_Emoji_BecomeFirstResponder:NO];
    [[LEMainViewController instance] setHideLE_Emoji];
}
-(void) easeOutViewLogic{
    [self hideLE_Emoji];
}

@end
