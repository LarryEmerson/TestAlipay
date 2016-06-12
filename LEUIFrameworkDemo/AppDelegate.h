//
//  AppDelegate.h
//  LEUIFrameworkDemo
//
//  Created by Larry Emerson on 15/6/27.
//  Copyright (c) 2015年 Larry Emerson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AlipaySDK/AlipaySDK.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

-(void) showAlipayDic:(NSDictionary *) dic;
@end

