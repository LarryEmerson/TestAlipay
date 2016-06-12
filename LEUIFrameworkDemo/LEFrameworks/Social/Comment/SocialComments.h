//
//  SocialComments.h
//  four23book_client_borrower_ios
//
//  Created by Larry Emerson on 15/10/8.
//  Copyright © 2015年 LarryEmerson. All rights reserved.
//

#import "LETableViewPage.h"
#import "SocialCommentsCells.h"
#import "SocialInstance.h"
#import "SocialCommentInput.h"
@interface SocialCommentsTableView : LEBaseTableView
-(void) setDataForHead:(NSDictionary *) data;
-(void) setDataForHot:(NSArray *) data;
-(void) setDataForNew:(NSArray *) data;
@end
@interface SocialComments : LETableViewPage
-(id) initWithSuperView:(UIView *)view Title:(NSString *)title TableViewClassName:(NSString *)tableViewClassName CellClassName:(NSString *)cellClassName EmptyCellClassName:(NSString *)emptyCellClassName ID:(int) id ;
@end
