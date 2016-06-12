//
//  LEMapCallOutViewAnnotation.h
//  four23
//
//  Created by Larry Emerson on 15/9/6.
//  Copyright (c) 2015年 360cbs. All rights reserved.
//

#import <UIKit/UIKit.h> 
#import "LEMapViewAnnotation.h"
#define ReUseIdentifierForCallOutView @"CallOut"
@interface LEMapCallOutViewAnnotation : LEMapViewAnnotation
@property (nonatomic) CLLocationCoordinate2D userCoordinate;
@property (nonatomic) NSDictionary *curData;
@property (nonatomic) NSString *callOutBackground; 
-(id) initWithCoordinate:(CLLocationCoordinate2D) coordinate Index:(int) index AnnotationIcon:(NSString *)icon  CallOutBackground:(NSString *) bg Data:(NSDictionary *) data UserCoordinate:(CLLocationCoordinate2D) userCoordinate;
@end