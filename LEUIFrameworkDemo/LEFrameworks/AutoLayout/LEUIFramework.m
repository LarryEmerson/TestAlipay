//
//  LEUIFramework.m
//  LEUIFramework
//
//  Created by Larry Emerson on 15/2/19.
//  Copyright (c) 2015年 LarryEmerson. All rights reserved.
//

#import "LEUIFramework.h"
#import <objc/runtime.h>

#define IntToString(__int) [NSString stringWithFormat:@"%d",(int)__int]
#define NSIntegerToInt(__int) (int)__int

@implementation UIView (Extension)
-(void) addTapEventWithSEL:(SEL) sel{ 
    [self addTapEventWithSEL:sel Target:self ];
}
-(void) addTapEventWithSEL:(SEL)sel Target:(id) target{
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:target action:sel]];
}
@end

@implementation UITableView (Extension)
-(BOOL) touchesShouldCancelInContentView:(UIView *)view{
    return YES;
}
@end

@implementation UIImage (Extension)
-(UIImage *)middleStrechedImage{
    return [self stretchableImageWithLeftCapWidth:self.size.width/2 topCapHeight:self.size.height/2];
}
@end

@implementation UIColor (Extension)
-(UIImage *)imageWithSize:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [self CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end

@implementation NSString (Extension)
 
-(NSObject *) getInstanceFromClassName{
    NSObject *obj=[NSClassFromString(self) alloc];
    NSAssert(obj!=nil,([NSString stringWithFormat:@"请检查类名是否正确：%@",self]));
    return obj;
}
//返回字符串所占用的尺寸.
-(CGSize) getSizeWithFont:(UIFont *)font MaxSize:(CGSize) size{
    if(!self){
        return CGSizeZero;
    }
    if([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]){
        NSDictionary *attributes = @{NSFontAttributeName: font};
        CGRect rect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes  context:nil];
        rect.size.height=(int)rect.size.height+2;
        return rect.size;
    } else{
        CGSize strSize= [self sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        strSize.width=size.width;
        strSize.height=(int)strSize.height+2;
        return strSize;
    }

}
@end

@implementation UILabel (Extension)
- (void)alignTop {
    CGSize fontSize = [self.text sizeWithFont:self.font];
    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth = self.frame.size.width;    //expected width of label
    CGSize theStringSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
    int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
    for(int i=0; i<newLinesToPad; i++)
        self.text = [self.text stringByAppendingString:@"\n "];
}

- (void)alignBottom {
    CGSize fontSize = [self.text sizeWithFont:self.font];
    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth = self.frame.size.width;    //expected width of label
    CGSize theStringSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
    int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
    for(int i=0; i<newLinesToPad; i++)
        self.text = [NSString stringWithFormat:@" \n%@",self.text];
}
-(void) leSetText:(NSString *) text{
    if(self.leAutoLayoutSettings){
        int width=self.leAutoLayoutSettings.leLabelMaxWidth;
        int height=self.leAutoLayoutSettings.leLabelMaxHeight;
        if(width==0||width>[LEUIFramework instance].ScreenWidth){
            width=[LEUIFramework instance].ScreenWidth;
        }
        CGSize size=CGSizeZero;
        if(text){
            if(self.leAutoLayoutSettings.leLabelNumberOfLines==0){
                size=[text getSizeWithFont:self.font MaxSize:CGSizeMake(width, LELabelMaxSize.height)];
            }else if(self.leAutoLayoutSettings.leLabelNumberOfLines>=1){
                size=[text getSizeWithFont:self.font MaxSize:CGSizeMake(width, LELabelMaxSize.height)];
                if(height!=0){
                    size.height=height;
                } 
            }
        }else{
            size=CGSizeMake(self.leAutoLayoutSettings.leLabelMaxWidth, self.leAutoLayoutSettings.leLabelMaxHeight);
        }
        self.leAutoLayoutSettings.leSize=size;
        [self leSetSize:size];
    }
    [self setText:text];
    [self alignTop];
}
-(CGSize) getLabelTextSize{
    return [self.text getSizeWithFont:self.font MaxSize:LELabelMaxSize];
}
-(CGSize) getLabelTextSizeWithMaxWidth:(int) width{
    return [self.text getSizeWithFont:self.font MaxSize:CGSizeMake(width, LELabelMaxSize.height)];
} 
@end

@implementation UIImageView (Extension)
-(void) leSetImage:(UIImage *) image{
    if(self.leAutoLayoutSettings){
        self.leAutoLayoutSettings.leSize=image.size;
        [self leSetSize:image.size];
    }
    [self setImage:image];
}
-(void) leSetImage:(UIImage *) image WithSize:(CGSize) size{
    if(self.leAutoLayoutSettings){
        self.leAutoLayoutSettings.leSize=size;
        [self leSetSize:size];
    }
    [self setImage:image];
}
@end

@implementation UIButton (Extension)
-(void) leSetText:(NSString *) text{
    [self setTitle:text forState:UIControlStateNormal];
    //
    CGSize finalSize=self.leAutoLayoutSettings.leSize;
    while (YES) {
        CGSize textSize=[self.titleLabel getLabelTextSize];
        if(textSize.width+DefaultButtonHorizontalSpace*2>finalSize.width){
            finalSize.width = textSize.width+DefaultButtonHorizontalSpace*2;
        }
        if(textSize.height+DefaultButtonVerticalSpace*2>finalSize.height){
            finalSize.height = textSize.height+DefaultButtonVerticalSpace*2;
        }
        if(self.leAutoLayoutSettings.leButtonMaxWidth>0 && finalSize.width>self.leAutoLayoutSettings.leButtonMaxWidth){
            finalSize.width=self.leAutoLayoutSettings.leButtonMaxWidth;
            self.titleLabel.font=[self.titleLabel.font fontWithSize:self.titleLabel.font.pointSize-0.2];
        }else{
            break;
        }
    }
    self.leAutoLayoutSettings.leSize=finalSize;
    [self leExecAutoLayout];
}
@end

@implementation LEAutoLayoutSettings
-(id) initWithSuperView:(UIView *) superView Anchor:(LEAnchors) anchor Offset:(CGPoint) offset CGSize:(CGSize) size {
    return [self initWithSuperView:superView Anchor:anchor RelativeView:superView Offset:offset CGSize:size];
}
-(id) initWithSuperView:(UIView *) superView Anchor:(LEAnchors) anchor RelativeView:(UIView *) relativeView Offset:(CGPoint) offset CGSize:(CGSize) size {
    self=[super init];
    self.leSuperView=superView;
    self.leAnchor=anchor;
    self.leRelativeView=relativeView;
    self.leSize=size;
    self.leOffset=offset;
    
    return self;
}

-(id) initWithSuperView:(UIView *)superView EdgeInsects:(UIEdgeInsets) edge{
    CGSize relativeSize=superView.frame.size;
    edge.left=-abs(edge.left);
    edge.right=-abs(edge.right);
    edge.top=-abs(edge.top);
    edge.bottom=-abs(edge.bottom);
    self=[self initWithSuperView:superView Anchor:LEAnchorInsideTopLeft Offset:CGPointMake(-edge.left, -edge.top) CGSize:CGSizeMake(relativeSize.width+edge.left+edge.right, relativeSize.height+edge.top+edge.bottom)];
    [self setRelativeChangeView:superView EdgeInsects:edge];
    return self;
}

-(void) setRelativeChangeView:(UIView *) changeView EdgeInsects:(UIEdgeInsets) edge{
    self.leRelativeChangeView=changeView;
    self.leEdgeInsets=edge;
    //
    if(!changeView.leAutoResizeObservers){
        changeView.leAutoResizeObservers=[[NSMutableArray alloc] init];
    }
}

@end

static void * LEAutoLayoutSettingsKey = (void *) @"LEAutoLayoutSettings";
static void * LEAutoLayoutObserversKey = (void *) @"LEAutoLayoutObservers";
static void * LEAutoResizeObserversKey = (void *) @"LEAutoResizeObservers";
@implementation UIView (LEUIViewFrameWorks)

+ (CGRect) getFrameWithAutoLayoutSettings:(LEAutoLayoutSettings *) settings{
    LEAnchors anchor=settings.leAnchor;
    UIView *relativeView=settings.leRelativeView;
    CGPoint offset=settings.leOffset;
    CGSize size=settings.leSize;
    //
    CGRect frame;
    if((int)anchor>=9){
        frame=relativeView.frame;
        frame.origin.x+=offset.x;
        frame.origin.y+=offset.y;
        frame.size=size;
    }else{
        frame=CGRectMake(offset.x, offset.y, size.width, size.height);
    }
    CGRect relativeFrame=relativeView.frame;
    switch (anchor) {
            //Inside
        case LEAnchorInsideTopLeft:
            break;
        case LEAnchorInsideTopCenter:
            frame.origin.x+=relativeFrame.size.width/2-size.width/2;
            break;
        case LEAnchorInsideTopRight:
            frame.origin.x+=relativeFrame.size.width-size.width;
            break;
            //
        case LEAnchorInsideLeftCenter:
            frame.origin.y+=relativeFrame.size.height/2-size.height/2;
            break;
        case LEAnchorInsideCenter:
            frame.origin.x+=relativeFrame.size.width/2-size.width/2;
            frame.origin.y+=relativeFrame.size.height/2-size.height/2;
            break;
        case LEAnchorInsideRightCenter:
            frame.origin.x+=relativeFrame.size.width-size.width;
            frame.origin.y+=relativeFrame.size.height/2-size.height/2;
            break;
            //
        case LEAnchorInsideBottomLeft:
            frame.origin.y+=relativeFrame.size.height-size.height;
            break;
        case LEAnchorInsideBottomCenter:
            frame.origin.x+=relativeFrame.size.width/2-size.width/2;
            frame.origin.y+=relativeFrame.size.height-size.height;
            break;
        case LEAnchorInsideBottomRight:
            frame.origin.x+=relativeFrame.size.width-size.width;
            frame.origin.y+=relativeFrame.size.height-size.height;
            break;
            //OutSide
        case LEAnchorOutside1:
            frame.origin.x+=-size.width;
            frame.origin.y+=-size.height;
            break;
        case LEAnchorOutside2:
            frame.origin.x+=relativeFrame.size.width;
            frame.origin.y+=-size.height;
            break;
        case LEAnchorOutside3:
            frame.origin.x+=-size.width;
            frame.origin.y+=relativeFrame.size.height;
            break;
        case LEAnchorOutside4:
            frame.origin.x+=relativeFrame.size.width;
            frame.origin.y+=relativeFrame.size.height;
            break;
            //
        case LEAnchorOutsideTopLeft:
            frame.origin.y+=-size.height;
            break;
        case LEAnchorOutsideTopCenter:
            frame.origin.x+=relativeFrame.size.width/2-size.width/2;
            frame.origin.y+=-size.height;
            break;
        case LEAnchorOutsideTopRight:
            frame.origin.x+=relativeFrame.size.width-size.width;
            frame.origin.y+=-size.height;
            break;
            //
        case LEAnchorOutsideLeftTop:
            frame.origin.x+=-size.width;
            break;
        case LEAnchorOutsideLeftCenter:
            frame.origin.x+=-size.width;
            frame.origin.y+=relativeFrame.size.height/2-size.height/2;
            break;
        case LEAnchorOutsideLeftBottom:
            frame.origin.x+=-size.width;
            frame.origin.y+=relativeFrame.size.height-size.height;
            break;
            //
        case LEAnchorOutsideRightTop:
            frame.origin.x+=relativeFrame.size.width;
            break;
        case LEAnchorOutsideRightCenter:
            frame.origin.x+=relativeFrame.size.width;
            frame.origin.y+=relativeFrame.size.height/2-size.height/2;
            break;
        case LEAnchorOutsideRightBottom:
            frame.origin.x+=relativeFrame.size.width;
            frame.origin.y+=relativeFrame.size.height-size.height;
            break;
            //
        case LEAnchorOutsideBottomLeft:
            frame.origin.y+=relativeFrame.size.height;
            break;
        case LEAnchorOutsideBottomCenter:
            frame.origin.x+=relativeFrame.size.width/2-size.width/2;
            frame.origin.y+=relativeFrame.size.height;
            break;
        case LEAnchorOutsideBottomRight:
            frame.origin.x+=relativeFrame.size.width-size.width;
            frame.origin.y+=relativeFrame.size.height;
            break;
        default:
            break;
    }
    return frame;
}
//
- (LEAutoLayoutSettings *) leAutoLayoutSettings {
    return objc_getAssociatedObject(self, LEAutoLayoutSettingsKey);
}
- (void) setLeAutoLayoutSettings:(LEAutoLayoutSettings *)leAutoLayoutSettings {
    objc_setAssociatedObject(self, LEAutoLayoutSettingsKey, leAutoLayoutSettings, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSMutableArray *) leAutoLayoutObservers {
    return objc_getAssociatedObject(self, LEAutoLayoutObserversKey);
}
- (void) setLeAutoLayoutObservers:(NSMutableArray *)leAutoLayoutObservers {
    objc_setAssociatedObject(self, LEAutoLayoutObserversKey, leAutoLayoutObservers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSMutableArray *) leAutoResizeObservers {
    return objc_getAssociatedObject(self, LEAutoResizeObserversKey);
}
- (void) setLeAutoResizeObservers:(NSMutableArray *)leAutoResizeObservers {
    objc_setAssociatedObject(self, LEAutoResizeObserversKey, leAutoResizeObservers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//

-(instancetype) initWithAutoLayoutSettings:(LEAutoLayoutSettings *) settings{
    self=[self initWithFrame:[UIView getFrameWithAutoLayoutSettings:settings]];
    //
    self.leAutoLayoutSettings=settings;
    self.leAutoLayoutObservers=[[NSMutableArray alloc] init];
    self.leAutoResizeObservers=[[NSMutableArray alloc] init];
    [settings.leSuperView addSubview:self];
    if(settings.leRelativeView){
        if(!settings.leRelativeView.leAutoLayoutObservers){
            settings.leRelativeView.leAutoLayoutObservers=[[NSMutableArray alloc] init];
        }
        [settings.leRelativeView.leAutoLayoutObservers addObject:self];
    }
    if(settings.leRelativeChangeView){
        [settings.leRelativeChangeView.leAutoResizeObservers addObject:self];
    }
    return self;
}
-(void) addAutoResizeRelativeView:(UIView *) changeView EdgeInsects:(UIEdgeInsets) edge{
    if(!self.leAutoLayoutSettings){
        self.leAutoLayoutSettings=[[LEAutoLayoutSettings alloc] init];
    }
    self.leAutoLayoutSettings.leRelativeChangeView=changeView;
    if(changeView==self.leAutoLayoutSettings.leSuperView){
        edge.left=-abs(edge.left);
        edge.right=-abs(edge.right);
        edge.top=-abs(edge.top);
        edge.bottom=-abs(edge.bottom);
    }
    self.leAutoLayoutSettings.leEdgeInsets=edge;
    if(!changeView.leAutoResizeObservers){
        changeView.leAutoResizeObservers=[[NSMutableArray alloc] init];
    }
    [changeView.leAutoResizeObservers addObject:self];
}

-(void) leSetFrame:(CGRect) rect {
    if(self.leAutoLayoutSettings){
        self.leAutoLayoutSettings.leOffset=rect.origin;
        self.leAutoLayoutSettings.leSize=rect.size;
        [self leExecAutoLayout];
    }else{
        if(!CGRectEqualToRect(rect, self.frame)){
            [self setFrame:rect];
            [self leExecAutoLayoutSubviews];
        }
    }
}
-(void) leSetOffset:(CGPoint) offset{
    if(self.leAutoLayoutSettings){
        self.leAutoLayoutSettings.leOffset=offset;
        [self leExecAutoLayout];
    }else {
        CGRect frame=self.frame;
        frame.origin=offset;
        if(!CGRectEqualToRect(frame, self.frame)){
            [self setFrame:frame];
            [self leExecAutoLayoutSubviews];
        }
    }
}
-(void) leSetSize:(CGSize) size{
    if(self.leAutoLayoutSettings){
        self.leAutoLayoutSettings.leSize=size;
        [self leExecAutoLayout];
    }else{
        CGRect frame=self.frame;
        frame.size=size;
        if(!CGRectEqualToRect(frame, self.frame)){
            [self setFrame:frame];
            [self leExecAutoLayoutSubviews];
        }
    }
}
-(void) leSetLeAutoLayoutSettings:(LEAutoLayoutSettings *) settings{
    self.leAutoLayoutSettings=settings;
    [self leExecAutoLayout];
}
-(void) leExecAutoLayout{
    if(self.leAutoLayoutSettings){
        CGRect frame=[UIView getFrameWithAutoLayoutSettings:self.leAutoLayoutSettings];
        if(!CGRectEqualToRect(frame, self.frame)){
            [self setFrame:frame];
            [self leExecAutoLayoutSubviews];
        }
    }
}
-(void) leExecAutoResizeWithEdgeInsets:(UIEdgeInsets) edge{
    if(self.leAutoLayoutSettings.leRelativeChangeView==self.leAutoLayoutSettings.leSuperView){
        edge.left=-abs(edge.left);
        edge.right=-abs(edge.right);
        edge.top=-abs(edge.top);
        edge.bottom=-abs(edge.bottom);
    }
    self.leAutoLayoutSettings.leEdgeInsets=edge;
    [self leExecAutoResize];
}
-(void) leExecAutoResize{
    CGSize relativeSize=self.leAutoLayoutSettings.leRelativeChangeView.bounds.size;
    UIEdgeInsets edge=self.leAutoLayoutSettings.leEdgeInsets;
    CGSize size=CGSizeMake(relativeSize.width+edge.left+edge.right, relativeSize.height+edge.top+edge.bottom);
    if(!CGSizeEqualToSize(size, self.frame.size)){
        [self leSetSize:size];
    }
}
-(void) leExecAutoLayoutSubviews{
    for (UIView *view in self.leAutoResizeObservers) {
        if(view){
            [view leExecAutoResize];
        }
    }
    for (UIView *view in self.leAutoLayoutObservers) {
        if(view){
            [view leExecAutoLayout];
        }
    }
}

@end

@implementation LEAutoLayoutLabelSettings

-(id) initWithText:(NSString *) text FontSize:(int) fontSize Font:(UIFont *) font Width:(int) width Height:(int) height Color:(UIColor *) color Line:(int) line Alignment:(NSTextAlignment) alignment{
    self=[super init];
    if(self){
        self.leText=text;
        self.leFontSize=fontSize;
        self.leFont=font;
        self.leWidth=width;
        self.leHeight=height;
        self.leColor=color;
        self.leLine=line;
        self.leAlignment=alignment;
        if(self.leFontSize>0) {
            self.leFont=[UIFont systemFontOfSize:self.leFontSize];
        }
    }
    return self;
}
@end

@implementation LEAutoLayoutUIButtonSettings
-(id) initWithTitle:(NSString *) title FontSize:(int) fontSize Font:(UIFont *) font Image:(UIImage *) image BackgroundImage:(UIImage *) background Color:(UIColor *) color SelectedColor:(UIColor *) colorSelected  MaxWidth:(int) width SEL:(SEL) sel Target:(UIView *) view{
    self=[super init];
    if(self){
        self.leTitle=title;
        self.leTitleFontSize=fontSize;
        self.leTitleFont=font;
        self.leImage=image;
        self.leBackgroundImage=background;
        self.leColorNormal=color;
        self.leColorSelected=colorSelected;
        self.leSEL=sel;
        self.leMaxWidth=width;
        if(self.leTitleFontSize>0) {
            self.leTitleFont=[UIFont systemFontOfSize:self.leTitleFontSize];
        }
        self.leTargetView=view;
    }
    return self;
}
@end

@implementation LEUIFramework{
    NSMutableDictionary *relativeViews;
    int viewTagIncrement;
}

#pragma Singleton
static LEUIFramework *sharedInstance = nil;
+ (LEUIFramework *) instance { @synchronized(self) { if (sharedInstance == nil) { sharedInstance = [[self alloc] init]; } } return sharedInstance; }
+ (id) allocWithZone:(NSZone *)zone { @synchronized(self) { if (sharedInstance == nil) { sharedInstance = [super allocWithZone:zone]; return sharedInstance; } } return nil; }
+ (id) copyWithZone:(NSZone *)zone { return self; }
+ (id) mutableCopyWithZone:(NSZone *)zone { return self; }
//

-(BOOL) canItBeTapped{
    if(self.canItBeTappedVariable){
        return NO;
    }else{
        self.canItBeTappedVariable=YES;
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(tapVariableLogic) userInfo:nil repeats:NO];
        return YES;
    }
}
-(void) tapVariableLogic{
    self.canItBeTappedVariable=NO;
}
-(id) init{
    self=[super init];
    if(self){
        self.appDelegate=[UIApplication sharedApplication].delegate;
        self.ScreenBounds=[LEUIFramework ScreenBounds];
        self.ScreenWidth=self.ScreenBounds.size.width;
        self.ScreenHeight=self.ScreenBounds.size.height;
        self.SystemVersion=[LEUIFramework SystemVersion];
        self.IsIOS7=[self.SystemVersion floatValue]==7;
        self.IsIOS8=[self.SystemVersion floatValue]==8;
        self.IsIOS8OrLater=[self.SystemVersion floatValue]>=8;
//        self.IsStatusBarNotCovered=[self.SystemVersion floatValue]>=7;
        //
        [self extraInits];
    }
    return self;
}
//--------------------Init
-(void) extraInits{
    self.dateFormatter=[[NSDateFormatter alloc]init];
    [self.dateFormatter setDateFormat:@"yyyy.MM.dd HH:mm"];
}
#pragma System
+ (NSString *)SystemVersion {
    return [UIDevice currentDevice].systemVersion;
}
+ (CGRect)ScreenBounds{
    return [UIScreen mainScreen].bounds;
}
#pragma  Common
+(NSString *) intToString:(int) i{
    return [NSString stringWithFormat:@"%d",i];
}
+(UIFont *) getSystemFontWithSize:(int)size{
    return [UIFont systemFontOfSize:size];
}
#pragma UIImage
+ (UIImage *) getMiddleStrechedImage:(UIImage *) image{
    CGSize size=[LEUIFramework getMiddleStrechedSize:image.size];
    return [image stretchableImageWithLeftCapWidth:size.width topCapHeight:size.height];
}
+ (CGSize) getMiddleStrechedSize:(CGSize) size{
    return CGSizeMake(size.width/2, size.height/2);
}
+ (UIImage *) getUIImage:(NSString *) name{
    return [UIImage imageNamed:name];
}
+ (UIImage *) getUIImage:(NSString *) name Streched:(BOOL) isStreched {
    UIImage *img=[LEUIFramework getUIImage:name];
    if(isStreched){
        img=[LEUIFramework getMiddleStrechedImage:img];
    }
    return img;
}
+ (CGSize) getSizeWithValue:(int) value{
    return CGSizeMake(value, value);
}

#pragma UIImageView
+(UIImageView *) getUIImageViewWithSettings:(LEAutoLayoutSettings *) settings Image:(NSString *) image Streched:(BOOL) isStreched{
    return  [self getUIImageViewWithSettings:settings Image:[LEUIFramework getUIImage:image Streched:isStreched]];
}
+(UIImageView *) getUIImageViewWithSettings:(LEAutoLayoutSettings *) settings Image:(UIImage *) image{
    if(CGSizeEqualToSize(settings.leSize, CGSizeZero)){
        settings.leSize=image.size;
    }
    UIImageView *view=[[UIImageView alloc] initWithAutoLayoutSettings:settings];
    [view setImage:image];
    return view;
}
#pragma UILabel

+(UILabel *) getUILabelWithSettings:(LEAutoLayoutSettings *) settings LabelSettings:(LEAutoLayoutLabelSettings *) labelSettings {
    CGSize size;
    int width=labelSettings.leWidth;
    int height=labelSettings.leHeight;
    if(width==0||width>[LEUIFramework instance].ScreenWidth){
        width=[LEUIFramework instance].ScreenWidth;
    }
    if(labelSettings.leText){
        if(labelSettings.leLine==0){
            size=[labelSettings.leText getSizeWithFont:labelSettings.leFont MaxSize:CGSizeMake(width, LELabelMaxSize.height)];
        }else if(labelSettings.leLine>=1){
            size=[labelSettings.leText getSizeWithFont:labelSettings.leFont MaxSize:CGSizeMake(width, LELabelMaxSize.height)];
            if(height!=0){
                size.height=height;
            }
        }
    }else{
        size=CGSizeMake(labelSettings.leWidth, labelSettings.leHeight);
    }
    settings.leSize=size;
    UILabel *label=[[UILabel alloc] initWithAutoLayoutSettings:settings];  
    [label setTextAlignment:labelSettings.leAlignment];
    [label setTextColor:labelSettings.leColor];
    [label setFont:labelSettings.leFont];
    [label setNumberOfLines:labelSettings.leLine];
    [label setBackgroundColor:ColorClear];
//    [label setLineBreakMode:NSLineBreakByWordWrapping];
    label.leAutoLayoutSettings.leLabelMaxWidth=labelSettings.leWidth==0?[LEUIFramework instance].ScreenWidth:labelSettings.leWidth;
    label.leAutoLayoutSettings.leLabelMaxHeight=height;
    label.leAutoLayoutSettings.leLabelNumberOfLines=labelSettings.leLine;
    [label setText:labelSettings.leText];
     
    
    return label;
}

#pragma UIButton

+(UIButton *) getUIButtonWithSettings:(LEAutoLayoutSettings *) settings ButtonSettings:(LEAutoLayoutUIButtonSettings *) buttonSettings {
    if(!settings||!buttonSettings){
        return nil;
    }
    UIButton *button=[[UIButton alloc] initWithAutoLayoutSettings:settings];
    [button setTitle:buttonSettings.leTitle forState:UIControlStateNormal];
    [button setTitleColor:buttonSettings.leColorNormal forState:UIControlStateNormal];
    [button setTitleColor:buttonSettings.leColorSelected forState:UIControlStateHighlighted];
    [button setImage:buttonSettings.leImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonSettings.leBackgroundImage forState:UIControlStateNormal];
    [button addTarget:buttonSettings.leTargetView action:buttonSettings.leSEL forControlEvents:UIControlEventTouchUpInside];
    [settings.leSuperView addSubview:button];
    [button.titleLabel setFont:buttonSettings.leTitleFont];
    settings.leButtonMaxWidth=buttonSettings.leMaxWidth;
    //
    CGSize finalSize=settings.leSize;
    while (YES) {
        CGSize textSize=[button.titleLabel getLabelTextSize];
        if(textSize.width+DefaultButtonHorizontalSpace*2>finalSize.width){
            finalSize.width = textSize.width+DefaultButtonHorizontalSpace*2;
        }
        if(textSize.height+DefaultButtonVerticalSpace*2>finalSize.height){
            finalSize.height = textSize.height+DefaultButtonVerticalSpace*2;
        }
        if(buttonSettings.leMaxWidth>0 && finalSize.width>buttonSettings.leMaxWidth){
            buttonSettings.leTitleFont=[buttonSettings.leTitleFont fontWithSize:buttonSettings.leTitleFont.pointSize-0.2];
        }else{
            break;
        }
    }
    settings.leSize=finalSize;
    [button leExecAutoLayout];
    return button;
}


+ (UIImage *)createQRForString:(NSString *)qrString Size:(CGFloat) size {
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // 创建filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 设置内容和纠错级别
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // 返回CIImage
    return [LEUIFramework createNonInterpolatedUIImageFormCIImage:qrFilter.outputImage withSize:size];
}
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}
+ (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900)    // 将白色变成透明
        {
            // 改成下面的代码，会将图片转成想要的颜色
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }
        else
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // 输出图片
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // 清理空间
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}

+ (BOOL)validateMobile:(NSString *)mobileNum {
    if ([[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^1\\d{10}$"] evaluateWithObject:mobileNum]) {
        return YES;
    }  else {
        return NO;
    }
}











@end