//
//  SocialCommentsDetails.h
//  four23book_client_borrower_ios
//
//  Created by Larry Emerson on 15/10/12.
//  Copyright (c) 2015年 LarryEmerson. All rights reserved.
//

#import "LETableViewPage.h"
#import "SocialInstance.h"
#import "SocialCommentsDetailsCells.h"
#import "LE_EmojiToolBar.h"

@interface  SocialCommentsDetailsTableView : LEBaseTableView
-(void) setHeadData:(NSDictionary *) data;
-(void) setCommentData:(NSDictionary *) data;
-(void) scrollToBottom;
@end
@interface SocialCommentsDetails : LETableViewPage
-(id) initWithSuperView:(UIView *)view Title:(NSString *)title TableViewClassName:(NSString *)tableViewClassName CellClassName:(NSString *)cellClassName EmptyCellClassName:(NSString *)emptyCellClassName CommentID:(int) commentid ShowHead:(BOOL) showHead; 
-(void) onCommentReply;
@end
