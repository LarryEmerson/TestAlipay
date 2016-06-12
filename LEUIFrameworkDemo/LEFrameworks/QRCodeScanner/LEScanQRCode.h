//
//  LEScanQRCode.h
//  LEFrameworks
//
//  Created by Larry Emerson on 15/8/27.
//  Copyright (c) 2015年 LarryEmerson. All rights reserved.
//

#import "LEBasePageView.h"
#import "LEUIFrameworkImporter.h"

@protocol LEScanQRCodeDelegate <NSObject>
-(void) onScannedQRCodeWithResult:(NSString *) code;
@end

@interface LEScanQRCode : LEBasePageView
@property (nonatomic) id<LEScanQRCodeDelegate> scanQRCodeDelegate;
@property (nonatomic) NSString *curScanHelperString;
-(void) setCustomizeResultWithView:(UIView *) view;
-(void) showScanView;
-(void) showOrHideResultView:(BOOL) show;
@end
