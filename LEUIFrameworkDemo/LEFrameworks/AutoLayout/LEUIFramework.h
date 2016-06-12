//
//  LEUIFramework.h
//  LEUIFramework
//
//  Created by Larry Emerson on 15/2/19.
//  Copyright (c) 2015年 LarryEmerson. All rights reserved.
//

#import <UIKit/UIKit.h> 
#import "AppDelegate.h"
#import "sys/sysctl.h"

typedef NS_ENUM(NSInteger, LEAnchors) {
    //Inside
    LEAnchorInsideTopLeft = 0,
    LEAnchorInsideTopCenter = 1,
    LEAnchorInsideTopRight =2,
    //
    LEAnchorInsideLeftCenter = 3,
    LEAnchorInsideCenter = 4,
    LEAnchorInsideRightCenter = 5,
    //
    LEAnchorInsideBottomLeft = 6,
    LEAnchorInsideBottomCenter = 7,
    LEAnchorInsideBottomRight = 8,
    //Outside
    LEAnchorOutside1 = 9,
    LEAnchorOutside2 = 10,
    LEAnchorOutside3 = 11,
    LEAnchorOutside4 = 12,
    //
    LEAnchorOutsideTopLeft = 13,
    LEAnchorOutsideTopCenter = 14,
    LEAnchorOutsideTopRight = 15,
    //
    LEAnchorOutsideLeftTop = 16,
    LEAnchorOutsideLeftCenter = 17,
    LEAnchorOutsideLeftBottom = 18,
    //
    LEAnchorOutsideRightTop = 19,
    LEAnchorOutsideRightCenter = 20,
    LEAnchorOutsideRightBottom =21,
    //
    LEAnchorOutsideBottomLeft = 22,
    LEAnchorOutsideBottomCenter = 23,
    LEAnchorOutsideBottomRight =24
};

#pragma Defines
#define NSLogFunc   fprintf(stderr,"=> FUNC: %s\n",__FUNCTION__);
#define NSLogObjects(...) fprintf(stderr,"=> FUNC: %s %s\n",__FUNCTION__,[[NSString stringWithFormat:@"%@", ##__VA_ARGS__] UTF8String]);
#define NSLog(FORMAT, ...) fprintf(stderr,"=> (Line:%d) %s %s\n",__LINE__,__FUNCTION__,[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

#define Screen_height  [[UIScreen mainScreen] bounds].size.height
#define Screen_width  [[UIScreen mainScreen] bounds].size.width
#define iPhone6     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750,1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242,2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define LELabelMaxSize CGSizeMake(5000, 5000)
#define LeTextShadowColor [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.3]
#define LeTextShadowSize CGSizeMake(0.5, 0.5)
#define DefaultButtonVerticalSpace 6
#define DefaultButtonHorizontalSpace 12

#define NavigationBarFontSize 20*(iPhone6Plus?1.3:1)
#define NavigationBarHeight 44*(iPhone6?1.3:(iPhone6Plus?1.5:1))
//#define StatusBarHeight 20

#pragma Define Colors
#define ColorTest         [UIColor colorWithRed:0.867 green:0.852 blue:0.539 alpha:1.000]

#define ColorGrayText [UIColor colorWithWhite:0.506 alpha:1.000]
#define ColorClear    [UIColor clearColor]
#define ColorWhite    [UIColor whiteColor]
#define ColorBlack    [UIColor blackColor]

#define ColorMask         [[UIColor alloc] initWithRed:0.1 green:0.1 blue:0.1 alpha:0.1]
#define ColorMask2         [[UIColor alloc] initWithRed:0.1 green:0.1 blue:0.1 alpha:0.2]
#define ColorMask5         [[UIColor alloc] initWithRed:0.1 green:0.1 blue:0.1 alpha:0.5]
#define ColorMask8         [[UIColor alloc] initWithRed:0.1 green:0.1 blue:0.1 alpha:0.8]

@interface UIView (Extension)
-(void) addTapEventWithSEL:(SEL) sel;
-(void) addTapEventWithSEL:(SEL)sel Target:(id) target;
@end

@interface UIImage (Extension)
-(UIImage *)middleStrechedImage;
@end

@interface UIColor (Extension)
-(UIImage *)imageWithSize:(CGSize)size;
@end

@interface NSString (Extension)
-(CGSize) getSizeWithFont:(UIFont *)font MaxSize:(CGSize) size;
-(NSObject *) getInstanceFromClassName;
@end

@interface UILabel (Extension)
- (void)alignTop;
- (void)alignBottom;
-(void) leSetText:(NSString *) text;
-(CGSize) getLabelTextSize;
-(CGSize) getLabelTextSizeWithMaxWidth:(int) width;
@end
@interface UIImageView (Extension)
-(void) leSetImage:(UIImage *) image;
-(void) leSetImage:(UIImage *) image WithSize:(CGSize) size;
@end 
@interface UIButton (Extension)
-(void) leSetText:(NSString *) text;
@end

@interface LEAutoLayoutSettings : NSObject

@property (nonatomic) UIView *leSuperView;
@property (nonatomic) UIView *leRelativeView;

@property (nonatomic) LEAnchors leAnchor;

@property (nonatomic) CGPoint leOffset;
@property (nonatomic) CGSize leSize;

@property (nonatomic) UIView *leRelativeChangeView;
@property (nonatomic) UIEdgeInsets leEdgeInsets;

@property (nonatomic) int leLabelMaxWidth;
@property (nonatomic) int leLabelMaxHeight;
@property (nonatomic) int leLabelNumberOfLines;
@property (nonatomic) int leButtonMaxWidth;
//AutoLayout
-(id) initWithSuperView:(UIView *) superView Anchor:(LEAnchors) anchor Offset:(CGPoint) offset CGSize:(CGSize) size;
-(id) initWithSuperView:(UIView *) superView Anchor:(LEAnchors) anchor RelativeView:(UIView *) relativeView Offset:(CGPoint) offset CGSize:(CGSize) size;
-(id) initWithSuperView:(UIView *)superView EdgeInsects:(UIEdgeInsets) edge;
//AutoResize
-(void) setRelativeChangeView:(UIView *) changeView EdgeInsects:(UIEdgeInsets) edge;
@end

@interface UIView (LEUIViewFrameWorks)
+(CGRect) getFrameWithAutoLayoutSettings:(LEAutoLayoutSettings *) settings;
@property (nonatomic) LEAutoLayoutSettings *leAutoLayoutSettings;
@property (nonatomic) NSMutableArray *leAutoLayoutObservers;
@property (nonatomic) NSMutableArray *leAutoResizeObservers;
-(instancetype) initWithAutoLayoutSettings:(LEAutoLayoutSettings *) settings;
-(void) addAutoResizeRelativeView:(UIView *) changeView EdgeInsects:(UIEdgeInsets) edge;
-(void) leSetFrame:(CGRect) rect;
-(void) leSetOffset:(CGPoint) offset;
-(void) leSetSize:(CGSize) size;
-(void) leSetLeAutoLayoutSettings:(LEAutoLayoutSettings *) settings;
-(void) leExecAutoLayout;
-(void) leExecAutoResize;
-(void) leExecAutoResizeWithEdgeInsets:(UIEdgeInsets) edge;
@end

@interface LEAutoLayoutLabelSettings : NSObject
@property (nonatomic) NSString *leText;
@property (nonatomic) int leFontSize;
@property (nonatomic) UIFont *leFont;
@property (nonatomic) int leWidth;
@property (nonatomic) int leHeight;
@property (nonatomic) UIColor *leColor;
@property (nonatomic) int leLine;
@property (nonatomic) NSTextAlignment leAlignment;
-(id) initWithText:(NSString *) text FontSize:(int) fontSize Font:(UIFont *) font Width:(int) width Height:(int) height Color:(UIColor *) color Line:(int) line Alignment:(NSTextAlignment) alignment;
@end

@interface LEAutoLayoutUIButtonSettings : NSObject
@property (nonatomic) NSString *leTitle;
@property (nonatomic) int leTitleFontSize;
@property (nonatomic) UIFont *leTitleFont;
@property (nonatomic) UIImage *leImage;
@property (nonatomic) UIImage *leBackgroundImage;
@property (nonatomic) UIColor *leColorNormal;
@property (nonatomic) UIColor *leColorSelected;
@property (nonatomic) SEL leSEL;
@property (nonatomic) int leMaxWidth;
@property (nonatomic) UIView *leTargetView;
-(id) initWithTitle:(NSString *) title FontSize:(int) fontSize Font:(UIFont *) font Image:(UIImage *) image BackgroundImage:(UIImage *) background Color:(UIColor *) color SelectedColor:(UIColor *) colorSelected MaxWidth:(int) width SEL:(SEL) sel Target:(UIView *) view;
@end

@interface LEUIFramework : NSObject
#pragma Singleton
+(LEUIFramework *) instance;
#pragma public Variables
@property (nonatomic) AppDelegate *appDelegate;
//
@property (nonatomic) int ScreenWidth;
@property (nonatomic) int ScreenHeight;
//@property (nonatomic) BOOL IsStatusBarNotCovered;
@property (nonatomic) CGRect ScreenBounds;
@property (nonatomic) NSString *SystemVersion;
@property (nonatomic) BOOL IsIOS7;
@property (nonatomic) BOOL IsIOS8;
@property (nonatomic) BOOL IsIOS8OrLater;
//
@property (nonatomic) NSDateFormatter *dateFormatter;

@property (nonatomic) BOOL canItBeTappedVariable;
-(BOOL) canItBeTapped;
#pragma Common
+(NSString *) intToString:(int) i;
+(UIFont *) getSystemFontWithSize:(int) size;
#pragma UIImage
+(UIImage *) getMiddleStrechedImage:(UIImage *) image ;
+(CGSize) getMiddleStrechedSize:(CGSize) size ;
+(UIImage *) getUIImage:(NSString *) name ;
+(UIImage *) getUIImage:(NSString *) name Streched:(BOOL) isStreched ;
+(CGSize) getSizeWithValue:(int) value;
#pragma UIImageView
+(UIImageView *) getUIImageViewWithSettings:(LEAutoLayoutSettings *) settings Image:(NSString *) image Streched:(BOOL) isStreched;
+(UIImageView *) getUIImageViewWithSettings:(LEAutoLayoutSettings *) settings Image:(UIImage *) image ;
#pragma UILabel
+(UILabel *) getUILabelWithSettings:(LEAutoLayoutSettings *) settings LabelSettings:(LEAutoLayoutLabelSettings *) labelSettings ;
#pragma UIButton
+(UIButton *) getUIButtonWithSettings:(LEAutoLayoutSettings *) settings ButtonSettings:(LEAutoLayoutUIButtonSettings *) buttonSettings ;

+(UIImage *)createQRForString:(NSString *)qrString Size:(CGFloat) size;
+(UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue;

+ (BOOL)validateMobile:(NSString *)mobileNum ;
@end













