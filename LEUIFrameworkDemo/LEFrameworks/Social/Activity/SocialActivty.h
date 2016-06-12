//
//  SocialActivty.h
//  four23book_client_borrower_ios
//
//  Created by Larry Emerson on 15/10/8.
//  Copyright © 2015年 LarryEmerson. All rights reserved.
//

#import "LETableViewPage.h"
#import "SocialActivityCells.h"
#import "SocialInstance.h"
#import "SocialComments.h"
#import "SocialCommentsDetails.h"
@interface SocialActivtyTableView : LEBaseTableView
@end

@interface SocialActivty : LETableViewPage
-(id) initWithSuperView:(UIView *)view Title:(NSString *)title TableViewClassName:(NSString *)tableViewClassName CellClassName:(NSString *)cellClassName EmptyCellClassName:(NSString *)emptyCellClassName UserID:(int) userid;
@end
