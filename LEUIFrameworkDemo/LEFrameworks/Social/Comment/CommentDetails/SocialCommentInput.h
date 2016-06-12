//
//  SocialCommentInput.h
//  four23book_client_borrower_ios
//
//  Created by Larry Emerson on 15/10/12.
//  Copyright (c) 2015年 LarryEmerson. All rights reserved.
//

#import <UIKit/UIKit.h> 
#import "SocialConfigs.h"
#import "LEUIFrameworkImporter.h"
@protocol SocialCommentInputDelegate<NSObject>
-(void) onDoneInputWith:(NSString *) content;
@end

@interface SocialCommentInput : UIView
@property (nonatomic) id<SocialCommentInputDelegate> delegate;
-(id) initWithDelegate:(id) delegate;
@end
