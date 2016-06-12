//
//  SocialActivty.m
//  four23book_client_borrower_ios
//
//  Created by Larry Emerson on 15/10/8.
//  Copyright © 2015年 LarryEmerson. All rights reserved.
//

#import "SocialActivty.h"
@implementation SocialActivtyTableView{
    NSTimer *curReloadTimer;
}

-(UITableViewCell *) _cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic=[self.itemsArray objectAtIndex:indexPath.row];
    int type=[[dic objectForKey:Social_P_Type] intValue];
    LEBaseTableViewCell *cell=nil;
    switch (type) {
        case 1:
            cell=[self dequeueReusableCellWithIdentifier:@"SocialActivityCellCommented"];
            if(!cell){
                LETableViewCellSettings *settings=[[LETableViewCellSettings alloc] initWithSelectionDelegate:self.cellSelectionDelegate TableViewCellStyle:UITableViewCellStyleDefault reuseIdentifier:@"SocialActivityCellCommented"]; 
                cell=[[SocialActivityCellCommented alloc] initWithSettings:settings];
            }
            break;
        case 2:
            cell=[self dequeueReusableCellWithIdentifier:@"SocialActivityCellResponded"];
            if(!cell){
                cell=[[SocialActivityCellResponded alloc] initWithSettings:[[LETableViewCellSettings alloc] initWithSelectionDelegate:self.cellSelectionDelegate TableViewCellStyle:UITableViewCellStyleDefault reuseIdentifier:@"SocialActivityCellResponded"]];
            }
            break;
        case 3:
        case 4:
            cell=[self dequeueReusableCellWithIdentifier:@"SocialActivityCellPraised"];
            if(!cell){
                cell=[[SocialActivityCellPraised alloc] initWithSettings:[[LETableViewCellSettings alloc] initWithSelectionDelegate:self.cellSelectionDelegate TableViewCellStyle:UITableViewCellStyleDefault reuseIdentifier:@"SocialActivityCellPraised"]];
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

@interface SocialActivty()<LEConnectionDelegate>
@end

@implementation SocialActivty{
    int curUserId;
    NSArray *curData;
}
-(id) initWithSuperView:(UIView *)view Title:(NSString *)title TableViewClassName:(NSString *)tableViewClassName CellClassName:(NSString *)cellClassName EmptyCellClassName:(NSString *)emptyCellClassName UserID:(int) userid {
//-(id) initWithSuperView:(UIView *)view Title:(NSString *)title UserId:(int) userid{
    curUserId=userid;
    return [super initWithSuperView:view Title:title TableViewClassName:tableViewClassName CellClassName:cellClassName EmptyCellClassName:emptyCellClassName];
}
-(void) setExtraViewInits{ 
//    [self onRefreshData];
}
-(void) getActivity{
    NSMutableDictionary *dic=[@{Social_P_Token:[SocialInstance instance].curUserToken} mutableCopy];
    if(curUserId>=0){
        [dic setValue:[NSString stringWithFormat:@"%d",curUserId] forKey:Social_P_UserId];
    }
    [[LEConnections instance] requestWithURL:RequestSocialUIActivity parameters:dic Delegate:self];
}
-(void) onRefreshData{ 
    [self getActivity];
}
-(void) onLoadMore{
    
}
-(void) request:(LEConnectionRequestObject *)request ResponedWith:(LEConnectionsResponseObject *)response{
    curData=response.result;
    [self onFreshDataLogic:[curData mutableCopy]];
}
-(void) onTableViewCellSelectedWithInfo:(NSDictionary *)info{
    NSIndexPath *index=[info objectForKey:KeyOfCellIndexPath];
//    int cellStatus=[[info objectForKey:KeyOfCellClickStatus] intValue];
    NSDictionary *dic=[curData objectAtIndex:index.row];
    int type=[[dic objectForKey:Social_P_Type] intValue];
    if(type==1){
        SocialComments *comment= [[SocialComments alloc] initWithSuperView:self Title:@"评论" TableViewClassName:@"SocialCommentsTableView" CellClassName:nil EmptyCellClassName:nil ID:[[dic objectForKey:Social_P_SubjectID] intValue] ];
        [self addSubview:comment];
        [comment easeInView];
    }else  {
        SocialCommentsDetails *details= [[SocialCommentsDetails alloc] initWithSuperView:self Title:@"评论详情" TableViewClassName:@"SocialCommentsDetailsTableView" CellClassName:nil EmptyCellClassName:nil CommentID:[[dic objectForKey:Social_P_SubjectID] intValue] ShowHead:NO];
        [self addSubview:details];
        [details easeInView];
    } 
}
@end
