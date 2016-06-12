//
//  LEBaseTableViewCell.m
//  spark-client-ios
//
//  Created by Larry Emerson on 15/2/2.
//  Copyright (c) 2015年 Syan. All rights reserved.
//

#import "LEBaseTableViewCell.h" 

@implementation LEBaseTableViewCell{
    BOOL hasGesture;
    UIImage *imgSplit;
    UIImage *imgMask;
}
- (id)initWithSettings:(LETableViewCellSettings *) settings {
    UIColor *colorSplit=[UIColor colorWithWhite:0.000 alpha:0.250];
    UIColor *colorMask=[UIColor colorWithWhite:0.500 alpha:0.250];
    imgSplit=[colorSplit imageWithSize:CGSizeMake(1, 0.25)];
    imgMask=[colorMask imageWithSize:CGSizeMake(1,1)];
//    self.tableView=settings.tableView;
    self.selectionDelegate=settings.selectionDelegate;
    hasGesture=settings.gesture;
    self = [super initWithStyle:settings.style reuseIdentifier:settings.reuseIdentifier]; 
    if (self) {
        self.globalVar=[LEUIFramework instance];
        self.CellLeftSpace=NavigationBarHeight/2;
        self.CellRightSpace=self.globalVar.ScreenWidth-NavigationBarHeight/2;
        [self setFrame:CGRectMake(0, 0, self.globalVar.ScreenWidth, DefaultCellHeight)];
        [self setBackgroundColor:ColorWhite];
        self.hasBottomSplit=YES;
        if(hasGesture){
            self.tapEffect=[[UIButton alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self EdgeInsects:UIEdgeInsetsZero]];
            [self.tapEffect setBackgroundImage:[LEUIFramework getMiddleStrechedImage:imgMask] forState:UIControlStateHighlighted];
//            [self.tapEffect setAlpha:0.5];
            [self.tapEffect addTarget:self action:@selector(onButtonTaped) forControlEvents:UIControlEventTouchUpInside];
        } 
        [self initUI];
        [self initCellStyle];
        if(self.tapEffect){
            [self addSubview:self.tapEffect];
        }
        [self initTopClickUIS];
    }
    return self;
}

-(void) initUI{
    self.curTitle=[LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideLeftCenter Offset:CGPointMake(self.CellLeftSpace, 0) CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:@"" FontSize:NavigationBarFontSize Font:nil Width:self.CellRightSpace-self.CellLeftSpace Height:self.bounds.size.height Color:ColorBlack Line:0 Alignment:NSTextAlignmentLeft]];
}
-(void) initTopClickUIS{

}
-(void) initCellStyle{
    if(self.hasTopSplit){
        [LEUIFramework getUIImageViewWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideTopCenter Offset:CGPointZero CGSize:CGSizeMake(self.globalVar.ScreenWidth, 1)] Image:[imgSplit middleStrechedImage]];
    }
    if(self.hasBottomSplit){
        [LEUIFramework getUIImageViewWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideBottomCenter Offset:CGPointZero CGSize:CGSizeMake(self.globalVar.ScreenWidth, 1 )] Image:[imgSplit middleStrechedImage]];
    }
    if(self.hasArrow){
        self.curArrow=[LEUIFramework getUIImageViewWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideRightCenter Offset:CGPointMake(-CellArrowSpaceAs/2, 0) CGSize:CGSizeZero] Image:IMG_Cell_SolidArrow Streched:NO];
    }
}
-(void) setCellHeight:(int) height{
    [self setCellHeight:height TapWidth:self.globalVar.ScreenWidth];
}
-(void) setCellHeight:(int) height TapWidth:(int) width {
    [self leSetSize:CGSizeMake(self.globalVar.ScreenWidth, height)];
    
}

-(void) onButtonTaped{
    if([self.globalVar canItBeTapped]){
        [self onCellSelectedWithIndex:KeyOfCellClickDefaultStatus];
    }
} 
-(void) onCellSelectedWithIndex:(int) index{
    if(self.selectionDelegate){
        if(!self.curIndexPath){
            NSLogObjects(@"点击事件无效。继承LEBaseTableViewCell后，重写SetData方法中需要设置indexPath：self.curIndexPath=path;")
            return;
        }
        [self.selectionDelegate onTableViewCellSelectedWithInfo:@{KeyOfCellIndexPath:self.curIndexPath,KeyOfCellClickStatus:[NSNumber numberWithInt:index]}];
    }
}
-(void) setData:(NSDictionary *) data IndexPath:(NSIndexPath *) path{
    self.curIndexPath=path;
    [self.curTitle leSetText:[data objectForKey:KeyOfCellTitle]]; 
}
@end
