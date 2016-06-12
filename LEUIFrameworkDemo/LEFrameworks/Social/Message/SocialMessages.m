//
//  SocialMessages.m
//  four23book_client_borrower_ios
//
//  Created by Larry Emerson on 15/10/8.
//  Copyright © 2015年 LarryEmerson. All rights reserved.
//

#import "SocialMessages.h" 
#import "SocialCommentsDetails.h"
@implementation SocialMessagesTableView

-(UITableViewCell *) _cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic=[self.itemsArray objectAtIndex:indexPath.row];
    int type=[[dic objectForKey:Social_P_Type] intValue];
    LEBaseTableViewCell *cell=nil;
    switch (type) {
        case 2:
            cell=[self dequeueReusableCellWithIdentifier:@"SocialMessagesCellResponded"];
            if(!cell){
                cell=[[SocialMessagesCellResponded alloc] initWithSettings:[[LETableViewCellSettings alloc] initWithSelectionDelegate:self.cellSelectionDelegate TableViewCellStyle:UITableViewCellStyleDefault reuseIdentifier:@"SocialMessagesCellResponded"]];
            }
            break;
        case 3:
        case 4:
            cell=[self dequeueReusableCellWithIdentifier:@"SocialMessagesCellPraised"];
            if(!cell){
                cell=[[SocialMessagesCellPraised alloc] initWithSettings:[[LETableViewCellSettings alloc] initWithSelectionDelegate:self.cellSelectionDelegate TableViewCellStyle:UITableViewCellStyleDefault reuseIdentifier:@"SocialMessagesCellPraised"]];
            }
            break;
        default:
            break;
    }
    if(cell){
        [cell setData:[self.itemsArray objectAtIndex:indexPath.row] IndexPath:indexPath];
    }
    return cell;
}
@end

@interface SocialMessages()<LEConnectionDelegate>
@end

@implementation SocialMessages{
    NSArray *curData;
}
 
-(void) setExtraViewInits{
//    [self onRefreshData];
}
-(void) getMessages{
    [[LEConnections instance] requestWithURL:RequestSocialUIMessage parameters:@{Social_P_Token:[SocialInstance instance].curUserToken} Delegate:self];
}
-(void) onRefreshData{
    [self getMessages];
}
-(void) onLoadMore{
    
}
-(void) request:(LEConnectionRequestObject *)request ResponedWith:(LEConnectionsResponseObject *)response{ 
    curData=response.result;
    [self onFreshDataLogic:[curData mutableCopy]];
}
-(void) onTableViewCellSelectedWithInfo:(NSDictionary *)info{
    NSIndexPath *index=[info objectForKey:KeyOfCellIndexPath];
    int cellStatus=[[info objectForKey:KeyOfCellClickStatus] intValue];
    NSDictionary *dic=[curData objectAtIndex:index.row];
//    int type=[[dic objectForKey:Social_P_Type] intValue];
    int userid=[[dic objectForKey:Social_P_UserId] intValue];
    if(cellStatus==0){
        SocialCommentsDetails *details= [[SocialCommentsDetails alloc] initWithSuperView:self Title:@"评论详情" TableViewClassName:@"SocialCommentsDetailsTableView" CellClassName:nil EmptyCellClassName:nil CommentID:[[dic objectForKey:Social_P_SubjectID] intValue] ShowHead:YES];
         [self addSubview:details];
         [details easeInView];
    }else if(cellStatus==1){
        [[SocialInstance instance] launchPageForSocialActivityWithSuperView:self UserId:userid];
    }
}
@end
