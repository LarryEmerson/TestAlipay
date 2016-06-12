//
//  LEMapView.h
//  LEFrameworks
//
//  Created by Larry Emerson on 15/8/27.
//  Copyright (c) 2015年 LarryEmerson. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "LEDataDelegate.h" 

 
@interface LEMapView : UIView<MAMapViewDelegate>
@property (nonatomic) id leMapDelegate;
@property (nonatomic) NSString *curAnnotationIconString;
@property (nonatomic) NSString *curCallOutBackgroundString;
@property (nonatomic) NSString *curAnnotationViewClass;
@property (nonatomic) NSString *curCallOutViewClass;
-(id) initUIWithFrame:(CGRect) frame AnnotationIcon:(NSString *) icon CallOutBackground:(NSString *) callOut AnnotationViewClass:(NSString *) annotationView CallOutViewClass:(NSString *) callOutClass MapDelegate:(id) delegate;
-(void) initMap;
-(void) onNeedRefreshMap;
-(void) onRefreshedData:(NSMutableArray *)data;
@end
