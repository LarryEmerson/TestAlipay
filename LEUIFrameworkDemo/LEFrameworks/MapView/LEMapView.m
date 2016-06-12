//
//  LEMapView.m
//  LEFrameworks
//
//  Created by Larry Emerson on 15/8/27.
//  Copyright (c) 2015年 LarryEmerson. All rights reserved.
//

#import "LEMapView.h"
#import "LEMainViewController.h"
//#import "CommonUtility.h"

#import "LEMapViewAnnotation.h"
#import "LEMapViewAnnotationView.h"

#import "LEMapViewSearchAnnotation.h"
#import "LEMapViewSearchAnnotationView.h"

#import "LEMapViewUserAnnotationView.h"

#import "LEMapCallOutAnnotationView.h"
#import "LEMapCallOutViewAnnotation.h"

@interface LEMapView()<LEMapViewDelegate>
@end

#define MapSpan 0.02
#define RefreshZoomLevel 16
#define RefreshMoveSpace 0.003
#define ZoomSize 1200
#define TicketRadius 0.005

@implementation LEMapView{
    UIImageView *curTopView;
    MAMapView *curMapView;
    NSMutableArray *curAnnotationArray;
    CLLocationManager *locationManager;
    NSMutableArray *curAnnotationDetails;
    //
    BOOL isZoomInited;
    BOOL isRefreshDataOK;
    float lastRegion;
    float lastZoom;
    float lastZoomForRefresh;
    CLLocationCoordinate2D lastUserCoordinate;
    CLLocationCoordinate2D lastCoor;
    NSTimer *curTimer;
    NSTimer *curTipTimer;
    //
    int topHeight;
    LEMapViewUserAnnotationView *curUserAnnotationView;
    MACircle *curUserCircle;
    LEMapCallOutAnnotationView *curCallOutView;
    
    NSMutableArray *curDataArrays;
    //
    UIButton *reLocate;
}
-(id) initUIWithFrame:(CGRect) frame  AnnotationIcon:(NSString *) icon CallOutBackground:(NSString *) callOut AnnotationViewClass:(NSString *) annotationView CallOutViewClass:(NSString *) callOutClass MapDelegate:(id) delegate {
    self.curAnnotationIconString=icon;
    self.curCallOutBackgroundString=callOut;
    self.curAnnotationViewClass=annotationView;
    self.curCallOutViewClass=callOutClass;
    self.leMapDelegate=delegate;
    self=[super initWithFrame:frame];
    [self initMap];
    return self;
}

-(void) onRefreshedData:(NSMutableArray *)data{
    curDataArrays=data;
    [curMapView removeAnnotations:curAnnotationArray];
    [curAnnotationArray removeAllObjects];
    for (int i=0; i<data.count; i++) {
        NSDictionary *dic=[data objectAtIndex:i];
        LEMapViewAnnotation *anno=[[LEMapViewAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake([[dic objectForKey:@"latitude"] floatValue], [[dic objectForKey:@"longitude"] floatValue]) Index:i AnnotationIcon:self.curAnnotationIconString];
        [curAnnotationArray addObject:anno];
    }
    [curMapView addAnnotations:curAnnotationArray];
//    [curMapView reloadMap];
//    [curMapView showAnnotations:curAnnotationArray animated:YES];
}
//
-(void) dealloc{
    self.leMapDelegate=nil;
    [curMapView setShowsUserLocation:NO];
    [curMapView setDelegate:nil];
    if(locationManager){
        [locationManager stopUpdatingLocation];
        [locationManager stopUpdatingHeading];
    }
}


-(void) initMap {
    //
    curAnnotationArray=[[NSMutableArray alloc]init];
    //
    curMapView =[[MAMapView alloc] initWithFrame:self.bounds];
    [self addSubview:curMapView];
    [curMapView setDelegate:self];
    
    [curMapView setZoomEnabled:YES];
    [curMapView setRotateEnabled:YES];
    [curMapView setRotateCameraEnabled:YES];
    [curMapView setScrollEnabled:YES];
    [curMapView setCameraDegree:45];
    [curMapView setShowsCompass:NO];
    [curMapView setShowsScale:NO];
    [curMapView removeOverlays:curMapView.overlays];
    [curMapView setShowsUserLocation:YES];
    // 
    [self checkGPSSettings];
    //
    UIImage *buttonImage=[UIImage imageNamed:@"map_relocate"];
    reLocate=[[UIButton alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideBottomLeft Offset:CGPointMake(7, -NavigationBarHeight/2) CGSize:CGSizeMake(50, 50)]];
    [self addSubview:reLocate];
    [reLocate addTarget:self action:@selector(onReLocate) forControlEvents:UIControlEventTouchUpInside];
    [reLocate setImage:buttonImage forState:UIControlStateNormal];
    
    UIImage *imgScale=[UIImage imageNamed:@"LeTicketMapScaleBG"];
    UIImageView *scaleView=[[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width-imgScale.size.width-7, reLocate.frame.origin.y+reLocate.frame.size.height-imgScale.size.height+3, 94/2,150/2)];
    [scaleView setUserInteractionEnabled:YES];
    [scaleView setImage:imgScale];
    [self addSubview:scaleView];
    UIImage *imgScaleUp=[UIImage imageNamed:@"LeTicketMapScaleUp"];
    UIImage *imgScaleUp2=[UIImage imageNamed:@"LeTicketMapScaleUp2"];
    UIImage *imgScaleDown=[UIImage imageNamed:@"LeTicketMapScaleDown"];
    UIImage *imgScaleDown2=[UIImage imageNamed:@"LeTicketMapScaleDown2"];
    UIButton *sizeUp=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 94/2, 150/2/2)];
    UIButton *sizeDown=[[UIButton alloc]initWithFrame:CGRectMake(0, 150/2/2, 94/2, 150/2/2)];
    [scaleView addSubview:sizeUp];
    [scaleView addSubview:sizeDown];
    [sizeUp setImage:imgScaleUp forState:UIControlStateNormal];
    [sizeUp setImage:imgScaleUp2 forState:UIControlStateHighlighted];
    [sizeDown setImage:imgScaleDown forState:UIControlStateNormal];
    [sizeDown setImage:imgScaleDown2 forState:UIControlStateHighlighted];
    [sizeUp addTarget:self action:@selector(onSizeDownMap) forControlEvents:UIControlEventTouchUpInside];
    [sizeDown addTarget:self action:@selector(onSizeUpMap) forControlEvents:UIControlEventTouchUpInside];
    [sizeUp setImageEdgeInsets:UIEdgeInsetsMake(6, 0, 0, 0)];
    [sizeDown setImageEdgeInsets:UIEdgeInsetsMake(-6, 0, 0, 0)];
    //
 
//    //TODO
    if(!isZoomInited){
        isZoomInited=YES;
        MACoordinateRegion zoomRegion = MACoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(31.810282,119.992165), ZoomSize, ZoomSize);
        [curMapView setRegion:zoomRegion];
        lastZoomForRefresh=curMapView.zoomLevel;
    }
    [curMapView setCenterCoordinate:CLLocationCoordinate2DMake(31.810282,119.992165) animated:YES];
}
 
-(void) checkGPSSettings{
    BOOL isOn=YES;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        locationManager=[[CLLocationManager alloc]init];
        [locationManager requestWhenInUseAuthorization];
    }
    if([CLLocationManager locationServicesEnabled]){
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            isOn=NO;
        }
    }else{
        isOn=NO;
    }
    if(isOn==NO){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位服务未开启"
                                                        message:@"请在系统设置中开启定位服务\r\n(设置>隐私>定位服务>开启常州违章)"
                                                       delegate:self
                                              cancelButtonTitle:@"知道了"
                                              otherButtonTitles:nil,nil];
        [alert show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        [curMapView setDelegate:self];
    }
}
//
-(MAAnnotationView *) mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    LEMapViewAnnotation *anno=(LEMapViewAnnotation *)annotation;
    if([annotation isKindOfClass:[LEMapCallOutViewAnnotation class]]){
        curCallOutView=(LEMapCallOutAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ReUseIdentifierForCallOutView];
        if(!curCallOutView){
            curCallOutView=[[LEMapCallOutAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ReUseIdentifierForCallOutView CallOutDelegate: self.leMapDelegate SubViewClass:self.curCallOutViewClass];
        }
        [curCallOutView setAnnotation:annotation];
        [curCallOutView setCallOutDelegate:self.leMapDelegate];
        return curCallOutView;
    }else if([annotation isKindOfClass:[MAUserLocation class]]){
        //        return nil;
        static NSString *userLocationStyleReuseIndetifier = @"LEMapViewUserAnnotationView";
        curUserAnnotationView = (LEMapViewUserAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
        if (curUserAnnotationView == nil) {
            curUserAnnotationView = [[LEMapViewUserAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:userLocationStyleReuseIndetifier];
        }
        return curUserAnnotationView;
    } else if([annotation isKindOfClass:[LEMapViewSearchAnnotation class]]){
        LEMapViewSearchAnnotation *geoAnno=(LEMapViewSearchAnnotation *)annotation;
        LEMapViewSearchAnnotationView *searchView =(LEMapViewSearchAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"TicketAroundSearchAnnotation"];
        if (searchView == nil) {
            searchView = [[LEMapViewSearchAnnotationView alloc] initWithAnnotation:geoAnno reuseIdentifier:@"TicketAroundSearchAnnotation"];
        }
        return searchView;
    } else if(![annotation isKindOfClass:[LEMapViewAnnotation class]]){
        return nil;
    } else{
        LEMapViewAnnotationView *annotationView =(LEMapViewAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier: @"annotation"];
        if (annotationView == nil) {
            annotationView = [[self.curAnnotationViewClass getInstanceFromClassName] performSelector:NSSelectorFromString(@"initWithAnnotation:reuseIdentifier:") withObject:anno withObject: @"annotation"];
        }
        [annotationView setAnnotation:annotation];
        return annotationView;
    }
}
// // //
- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    //    NSLog(@"didAddAnnotationViews %d",isZoomInited);
    if(!isZoomInited){
        [curMapView setShowsUserLocation:YES];
        MACoordinateRegion zoomRegion;
        zoomRegion = MACoordinateRegionMakeWithDistance(curMapView.userLocation.coordinate, ZoomSize, ZoomSize);
        [curMapView setRegion:zoomRegion];// animated:YES];
        //        isZoomInited=YES;
        lastZoomForRefresh=curMapView.zoomLevel;
    }
}

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    if(mapView.zoomLevel>RefreshZoomLevel && (lastZoomForRefresh!=mapView.zoomLevel  || fabsf(lastCoor.longitude-mapView.centerCoordinate.longitude)>RefreshMoveSpace||fabsf(lastCoor.latitude-mapView.centerCoordinate.latitude)>RefreshMoveSpace ) ){
        [curTimer invalidate];
        [curTipTimer invalidate];
        if(!curCallOutView){
            curTimer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(onNeedRefreshMap) userInfo:nil repeats:NO];
        }
        lastCoor=mapView.centerCoordinate;
        isRefreshDataOK=YES;
    }else if(isZoomInited && mapView.zoomLevel<=RefreshZoomLevel &&(lastZoomForRefresh!=mapView.zoomLevel ||fabsf(lastCoor.longitude-mapView.centerCoordinate.longitude)>RefreshMoveSpace||fabsf(lastCoor.latitude-mapView.centerCoordinate.latitude)>RefreshMoveSpace )){
        isRefreshDataOK=NO;
        [curTipTimer invalidate];
        curTipTimer=[NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(onShowMapTip) userInfo:nil repeats:NO];
    }
    lastRegion=mapView.region.span.longitudeDelta;
    lastZoom=curMapView.zoomLevel;
    lastZoomForRefresh=curMapView.zoomLevel;
    lastUserCoordinate=mapView.userLocation.coordinate;
    [LEMainViewController instance].userLocation=[[CLLocation alloc] initWithLatitude:lastUserCoordinate.latitude longitude:lastUserCoordinate.longitude];
}

-(void) mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    if([view isKindOfClass:[LEMapViewAnnotationView class]]){
        //add
        LEMapViewAnnotation *an=(LEMapViewAnnotation *) view.annotation;
        if(curCallOutView){
            [mapView removeAnnotations:@[curCallOutView.annotation]];
            curCallOutView=nil;
        }
        LEMapCallOutViewAnnotation *anno=[[LEMapCallOutViewAnnotation alloc] initWithCoordinate:an.coordinate Index:an.index AnnotationIcon:self.curAnnotationIconString CallOutBackground:self.curCallOutBackgroundString Data:[curDataArrays objectAtIndex:an.index] UserCoordinate:mapView.userLocation.coordinate];
        [mapView addAnnotation:anno]; 
        [curMapView setCenterCoordinate:anno.coordinate animated:YES];
    }
}
-(void) onNeedRefreshMap{
//    NSLogFunc;
    [[LEMainViewController instance]startLoadingWithMaskAndInteraction];
    CLLocationCoordinate2D location1= [curMapView convertPoint:CGPointMake(0, 0) toCoordinateFromView:curMapView];
    CLLocationCoordinate2D location2=[curMapView convertPoint:CGPointMake(curMapView.bounds.size.width,curMapView.frame.size.height) toCoordinateFromView:curMapView];
    CLLocationCoordinate2D locationCenter=[curMapView convertPoint:CGPointMake(curMapView.bounds.size.width/2, curMapView.bounds.size.height/2) toCoordinateFromView:curMapView];
    float latitudes=location1.latitude-location2.latitude;
    float longitudes=location1.longitude-location2.longitude;
    float radius=sqrtf(latitudes*latitudes+longitudes*longitudes);
    float startlongitude=0;
    float endlongitude=0;
    float startlatitude=0;
    float endlatitude=0;
    startlongitude=locationCenter.longitude-radius;
    endlongitude=locationCenter.longitude+radius;
    startlatitude=locationCenter.latitude-radius;
    endlatitude=locationCenter.latitude+radius;
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithFloat:startlongitude] forKey:@"startlongitude"];
    [parameters setObject:[NSNumber numberWithFloat:endlongitude] forKey:@"endlongitude"];
    [parameters setObject:[NSNumber numberWithFloat:startlatitude] forKey:@"startlatitude"];
    [parameters setObject:[NSNumber numberWithFloat:endlatitude] forKey:@"endlatitude"];
    if(self.leMapDelegate){
        [self.leMapDelegate onMapRequestLaunchedWithData:parameters];
    }
}
-(void) onShowMapTip{
//    NSLogFunc;
    [[LEMainViewController instance]setMessageText:@"地图范围过大，请放大后查看"];
}
-(void) mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view{
    if(curCallOutView&&curCallOutView.annotation){
        [mapView removeAnnotations:@[curCallOutView.annotation]];
        curCallOutView=nil; 
    }
}

-(void) onSizeUpMap{
    [curMapView setZoomLevel:curMapView.zoomLevel-0.5 animated:YES];
    //    NSLog(@"onSizeUp %f",lastZoom);
}
-(void) onSizeDownMap{
    [curMapView setZoomLevel:curMapView.zoomLevel+0.5 animated:YES];
    //    NSLog(@"onSizeDown %f",lastZoom);
}
-(void) onReLocate{
    //    NSLog(@"onReLocate");
    [curMapView setShowsUserLocation:YES];
    [curMapView setCenterCoordinate:curMapView.userLocation.coordinate animated:YES];
}
- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay {
    if ([overlay isKindOfClass:[MACircle class]]) {
        MACircleView *circleView = [[MACircleView alloc] initWithCircle:overlay];
        circleView.lineWidth   = 1.5f;
        circleView.strokeColor = [UIColor colorWithRed:0.110 green:0.494 blue:1.000 alpha:0.750];
        circleView.fillColor   = [UIColor colorWithRed:0.213 green:0.519 blue:0.757 alpha:0.250];
        return circleView;
    }
    return nil;
}
-(void) mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation{
    //    31.809794 119.992120
    lastUserCoordinate=userLocation.coordinate;
    [LEMainViewController instance].userLocation=[[CLLocation alloc] initWithLatitude:lastUserCoordinate.latitude longitude:lastUserCoordinate.longitude];
    [curMapView removeOverlays:curMapView.overlays];
    curUserCircle=[MACircle circleWithCenterCoordinate:lastUserCoordinate radius:500];
    [curMapView addOverlay:curUserCircle];
    
    if(!isZoomInited){
        isZoomInited=YES;
        MACoordinateRegion zoomRegion = MACoordinateRegionMakeWithDistance(curMapView.userLocation.coordinate, ZoomSize, ZoomSize);
        [curMapView setRegion:zoomRegion];
        lastZoomForRefresh=curMapView.zoomLevel;
    }
}

- (void)mapViewDidStopLocatingUser:(MAMapView *)mapView{
    //    NSLog(@"mapViewDidStopLocatingUser");
}
- (void)mapViewWillStartLocatingUser:(MAMapView *)mapView{
    //    NSLog(@"mapViewWillStartLocatingUser");
}
//
NSInteger sortBylatitude(id obj1, id obj2, void *context){
    float latitude1 =[[obj1 objectForKey:@"latitude02"] floatValue]; // ibj1  和 obj2 来自与你的数组中，其实，个人觉得是苹果自己实现了一个冒泡排序给大家使用
    float latitude2 =[[obj2 objectForKey:@"latitude02"] floatValue];
    
    if (latitude1 <= latitude2) {
        return NSOrderedDescending;
    }
    return NSOrderedAscending;
}
NSInteger sortBylongitude(id obj1, id obj2, void *context){
    float longitude1 =[[obj1 objectForKey:@"longitude02"] floatValue]; // ibj1  和 obj2 来自与你的数组中，其实，个人觉得是苹果自己实现了一个冒泡排序给大家使用
    float longitude2 =[[obj2 objectForKey:@"longitude02"] floatValue];
    
    if (longitude1 > longitude2) {
        return NSOrderedDescending;
    }
    return NSOrderedAscending;
}

- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    NSLog(@"didFailToLocateUserWithError");
}
@end
