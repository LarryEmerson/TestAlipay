//
//  PopupCancleOK.h
//  spark-client-ios
//
//  Created by Larry Emerson on 15/2/13.
//  Copyright (c) 2015年 Syan. All rights reserved.
//

#import "LEBasePopupEmptyPage.h"
#import "LEUIFrameworkImporter.h"
#define PopupCancleOK_OK @"PopupCancleOK_OK"
#define PopupCancleOK_Cancle @"PopupCancleOK_Cancle"
#define PopupCancleOK_NO @"PopupCancleOK_NO"
@interface PopupCancleOK : LEBasePopupEmptyPage
-(id) initWithDelegate:(id) delegate Title:(NSString *) title Subtitle:(NSString *) subtitle;
@end
