//
//  SocialInstance.h
//  four23book_client_borrower_ios
//
//  Created by Larry Emerson on 15/10/8.
//  Copyright © 2015年 LarryEmerson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocialActivty.h"
#import "SocialComments.h"
#import "SocialMessages.h"
#import "LEBaseTableViewCell.h"
#import "LEConnections.h"

@protocol SocialInstanceDelegate <NSObject>

-(LEConnectionRequestObject *) getConnectionForCommentInfoCustomizedHeadWith:(NSDictionary *) info;
-(void) onCommentInfoCustomizedHeadCalledWith:(NSDictionary *) info;
@end
@interface SocialInstance : NSObject
+(SocialInstance *) instance;
@property id<SocialInstanceDelegate> socialInstanceDelegate;
@property (nonatomic) NSString *curUserToken;
@property (nonatomic) int curUserID;
@property (nonatomic) NSString *curNickName;



-(void) launchPageForSocialActivityWithSuperView:(UIView *) view;
-(void) launchPageForSocialActivityWithSuperView:(UIView *) view UserId:(int) userid;
-(void) launchPageForSocialMessagesWithSuperView:(UIView *) view;
-(void) launchPageForSocialCommentsWithSuperView:(UIView *) view ID:(int) id;
@end
