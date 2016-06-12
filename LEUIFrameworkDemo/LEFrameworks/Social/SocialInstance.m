//
//  SocialInstance.m
//  four23book_client_borrower_ios
//
//  Created by Larry Emerson on 15/10/8.
//  Copyright © 2015年 LarryEmerson. All rights reserved.
//

#import "SocialInstance.h"

@implementation SocialInstance
static SocialInstance *sharedInstance = nil;
+ (SocialInstance *) instance { @synchronized(self) { if (sharedInstance == nil) { sharedInstance = [[self alloc] init]; } } return sharedInstance; }
+ (id) allocWithZone:(NSZone *)zone { @synchronized(self) { if (sharedInstance == nil) { sharedInstance = [super allocWithZone:zone]; return sharedInstance; } } return nil; }
+ (id) copyWithZone:(NSZone *)zone { return self; }
+ (id) mutableCopyWithZone:(NSZone *)zone { return self; }

-(void) launchPageForSocialActivityWithSuperView:(UIView *) view{
    SocialActivty *activity=[[SocialActivty alloc] initWithSuperView:view Title:@"动态" TableViewClassName:@"SocialActivtyTableView" CellClassName:nil EmptyCellClassName:nil UserID:-1];
    [view addSubview:activity];
    [activity easeInView];
}
-(void) launchPageForSocialActivityWithSuperView:(UIView *) view UserId:(int) userid{
    SocialActivty *activity=[[SocialActivty alloc] initWithSuperView:view Title:@"动态" TableViewClassName:@"SocialActivtyTableView" CellClassName:nil EmptyCellClassName:nil UserID:userid];
    [view addSubview:activity];
    [activity easeInView];
}
-(void) launchPageForSocialMessagesWithSuperView:(UIView *) view{
    SocialMessages *message=[[SocialMessages alloc] initWithSuperView:view Title:@"消息" TableViewClassName:@"SocialMessagesTableView" CellClassName:nil EmptyCellClassName:nil];
    [view addSubview:message];
    [message easeInView];
}

-(void) launchPageForSocialCommentsWithSuperView:(UIView *) view ID:(int) id{
    SocialComments *comments=[[SocialComments alloc] initWithSuperView:view Title:@"评论" TableViewClassName:@"SocialCommentsTableView" CellClassName:nil EmptyCellClassName:nil ID:id];
    [view addSubview:comments];
    [comments easeInView];
}
@end
