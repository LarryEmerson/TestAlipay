//
//  SocialCommentsCells.h
//  four23book_client_borrower_ios
//
//  Created by Larry Emerson on 15/10/10.
//  Copyright (c) 2015年 LarryEmerson. All rights reserved.
//

#import "LEBaseTableViewCell.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "LEConnections.h"
#import "SocialConfigs.h"
#import "SocialInstance.h"
@interface SocialCommentsCellsSection : UIView
-(id) initForHot;
-(id) initForNew;
@end

@interface SocialCommentsCellResponse : UIView
-(void) setData:(NSDictionary *) data Frame:(CGRect) frame;
@end
@interface SocialCommentsCell : LEBaseTableViewCell

@end
