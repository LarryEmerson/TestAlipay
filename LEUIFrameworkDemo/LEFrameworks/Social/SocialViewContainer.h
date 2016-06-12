//
//  SocialViewContainer.h
//  four23book_client_borrower_ios
//
//  Created by Larry Emerson on 15/9/28.
//  Copyright (c) 2015年 LarryEmerson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEUIFrameworkImporter.h"
 
@interface SocialViewContainer : UIView
-(id) initWithAutoLayoutSettings:(LEAutoLayoutSettings *)settings ;
-(void) initUI;
-(void) setData:(NSDictionary *) data;
@end
