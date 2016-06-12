//
//  LEMapViewAnnotation.h
//  LEFrameworks
//
//  Created by Larry Emerson on 15/8/27.
//  Copyright (c) 2015年 LarryEmerson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>

@protocol LEMapViewDelegate <NSObject>
-(void) onCallOutViewClickedWithData:(NSDictionary *) data;
-(void) onMapRequestLaunchedWithData:(NSDictionary *) data;
@end

@interface LEMapViewAnnotation : NSObject<MAAnnotation>{
@private
    CLLocationCoordinate2D _coordinate;
    NSString *_title;
    NSString *_subtitle;
}
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic) int index;
@property (nonatomic) NSString *curAnnotationIcon;
-(id) initWithCoordinate:(CLLocationCoordinate2D) coordinate Index:(int) index AnnotationIcon:(NSString *) icon;
@end
