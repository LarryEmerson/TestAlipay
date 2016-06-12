//
//  DemoViewController.m
//  LEUIFrameworkDemo
//
//  Created by emerson larry on 15/10/30.
//  Copyright © 2015年 Larry Emerson. All rights reserved.
//

#import "DemoViewController.h"
#import "LEConnections.h"
#import "LEBasePageView.h"
#import "LETableViewPage.h"
#import "LETableViewPageWithBanner.h"


//DemoTableViewPageWithBannerImageView
@interface DemoTableViewPageWithBannerImageView : HMBannerViewImageView
@end
@implementation DemoTableViewPageWithBannerImageView{
    UIImageView *curIcon;
    UILabel *curLabel;
}
-(void) initUI{
    curIcon=[LEUIFramework getUIImageViewWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideLeftCenter Offset:CGPointZero CGSize:CGSizeMake(80, 80)] Image:nil];
    curLabel=[LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideBottomRight Offset:CGPointMake(-StatusBarHeight/2, -StatusBarHeight/2) CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:nil FontSize:15 Font:nil Width:self.globalVar.ScreenWidth-StatusBarHeight Height:0 Color:ColorBlack Line:0 Alignment:NSTextAlignmentRight]];
    [curLabel setBackgroundColor:ColorMask2];
}
-(void) setData:(NSDictionary *)data{
    [curIcon leExecAutoLayout];
    if([data objectForKey:@"text"]){
        [curLabel leSetText:[data objectForKey:@"text"]];
    }else{
        [curLabel leSetText:@""];
    }
    if([data objectForKey:@"icon"]){
        [curIcon setImage:[UIImage imageNamed:[data objectForKey:@"icon"]]];
    }
    [super setData:data];
}
@end
//DemoTableViewPageWithBannerSubView
@interface DemoTableViewPageWithBannerSubView : LEBannerSubview
@end
@implementation DemoTableViewPageWithBannerSubView{
    UILabel *curText;
}
-(void) initUI{
    curText=[LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideTopLeft Offset:CGPointMake(NavigationBarHeight/4, NavigationBarHeight/4) CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:nil FontSize:15 Font:nil Width:self.globalVar.ScreenWidth-NavigationBarHeight/2 Height:0 Color:ColorBlack Line:0 Alignment:NSTextAlignmentLeft]];
    [self setBackgroundColor:[UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:0.520]];
    [curText setBackgroundColor:[UIColor colorWithRed:0.503 green:0.780 blue:1.000 alpha:0.510]];
}
-(void) setData:(NSDictionary *) data{
    [curText leSetText:[data objectForKey:@"text"]];
    [self leSetSize:CGSizeMake(self.globalVar.ScreenWidth, NavigationBarHeight/2+curText.bounds.size.height)];
    [self notifyHeightChange];
}
@end
//DemoTableViewPageWithBannerCell
@interface DemoTableViewPageWithBannerCell : LEBaseTableViewCell
@end
@implementation DemoTableViewPageWithBannerCell{
    UIView *curIcon;
}
-(void) initUI{
    self.hasArrow=YES;
    self.hasBottomSplit=YES;
    int space=10;
    curIcon=[[UIView alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideLeftCenter Offset:CGPointMake(space, 0) CGSize:CGSizeMake(DefaultCellHeight, DefaultCellHeight-space*2)]];
    [curIcon setBackgroundColor:[UIColor greenColor]];
}
-(void) setData:(NSDictionary *)data IndexPath:(NSIndexPath *)path{
    self.curIndexPath=path;
    [curIcon leSetSize:CGSizeMake(DefaultCellHeight+[[data objectForKey:KeyOfCellTitle] intValue], curIcon.bounds.size.height)];
}
@end

//DemoTableViewPageWithBanner
@interface DemoTableViewPageWithBanner : LETableViewPageWithBanner
@end
@implementation DemoTableViewPageWithBanner{
    NSString *subviewString;
}
//-(void) settingsBeforeInitInstance{
//    [super settingsBeforeInitInstance];
//    subviewString=@"这一句可以加一个回车键\这一句可以写一句很长的句子，然后测试一下看看是否自动换行";
    //
//    self.curCellClassName=@"DemoTableViewPageWithBannerCell";
//    self.bannerImageViewClassName=@"DemoTableViewPageWithBannerImageView";
//    self.bannerSubviewClassName=@"DemoTableViewPageWithBannerSubView";
//    self.curBannerStyle=BannerScrollWithCells;
//    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(onRefreshData) userInfo:nil repeats:NO];
//}
-(void) setExtraViewInits{
    subviewString=@"这一句可以加一个回车键\这一句可以写一句很长的句子，然后测试一下看看是否自动换行";
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(onRefreshData) userInfo:nil repeats:NO];
}
-(void) onBannerSelectedWithIndex:(NSInteger)index{
    NSLogObjects([NSNumber numberWithInteger:index]);
    subviewString=[NSString stringWithFormat:@"%@ Banner At %d", subviewString, index];
    [self onSetBannerData:nil SubviewData:@{@"text":subviewString}];
}
-(void) onTableViewCellSelectedWithInfo:(NSDictionary *)info{
    NSLogObjects(info);
    NSIndexPath *path=[info objectForKey:@"cellindex"];
    int status=[[info objectForKey:@"cellstatus"] intValue];
    subviewString=[NSString stringWithFormat:@"%@ Cell At %d", subviewString, path.row];
    [self onSetBannerData:nil SubviewData:@{@"text":subviewString}];
}
-(void) onRefreshData{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *bannerDic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superplus/img/logo_white_ee663702.png", @"img_url", nil];
    [bannerDic1  setValue:@"这是第一段测试语句 这是第一段测试语句 这是第一段测试语句" forKey:@"text"];
    [bannerDic1 setValue:@"map_anno_store" forKey:@"icon"]; 
    [dataArray addObject:bannerDic1];
    NSMutableDictionary *bannerDic2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"http://cdn.cocimg.com/assets/images/logo.png?15018", @"img_url", nil];
    [bannerDic2  setValue:@"这是第二段段测试语句" forKey:@"text"];
    [bannerDic2 setValue:@"map_scanner" forKey:@"icon"];
    [dataArray addObject:bannerDic2];
    //
    [self onFreshDataLogic:[@[@{KeyOfCellTitle: @"50"},@{KeyOfCellTitle:@"100"},@{KeyOfCellTitle:@"150"}]mutableCopy]];
    [self onSetBannerData:dataArray SubviewData:@{@"text":subviewString}];
}
-(void) onLoadMore{
    [self onLoadMoreLogic:[@[@{KeyOfCellTitle:@"40"},@{KeyOfCellTitle:@"100"},@{KeyOfCellTitle:@"200"}]mutableCopy]];
}
@end


//DemoTableViewPage
@interface DemoTableViewPage:LETableViewPage
@end
@implementation DemoTableViewPage
-(void) setExtraViewInits{
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(onRefreshData) userInfo:nil repeats:NO];
}
-(void) onRefreshData{
    [self onFreshDataLogic:[@[
                              @{KeyOfCellTitle:@"请点击我"},
                              @{KeyOfCellTitle:@"1"},
                              @{KeyOfCellTitle:@"2"}
                              ]mutableCopy]];
}
-(void) onLoadMore{
    [self onLoadMoreLogic:[@[
                             @{KeyOfCellTitle:@"3"},
                             @{KeyOfCellTitle:@"4"}
                             ]mutableCopy]];
}
-(void) onTableViewCellSelectedWithInfo:(NSDictionary *)info{
    NSIndexPath *index=[info objectForKey:KeyOfCellIndexPath];
    if(index.row==0){
        NSString * curCellClassName=nil;
        NSString * bannerImageViewClassName=nil;
        NSString * bannerSubviewClassName=nil;
        //
        curCellClassName= @"DemoTableViewPageWithBannerCell";
        bannerImageViewClassName=@"DemoTableViewPageWithBannerImageView";
        bannerSubviewClassName= @"DemoTableViewPageWithBannerSubView";
        //
        DemoTableViewPageWithBanner *page=[[DemoTableViewPageWithBanner alloc] initWithSuperView:self Title:@"带滚动条的列表案例测试" CellClassName:curCellClassName EmptyCellClassName:@"" BannerStyle:BannerStayAtTheTop BannerImageViewClassName:bannerImageViewClassName BannerSubviewClassName:bannerSubviewClassName];
        [page easeInView];
    }
}
@end







//DemoPage
@interface DemoPage:LEBasePageView
@end
@implementation DemoPage{
    UIButton *topButton;
    int counter;
    UILabel *label;
    UILabel *multiLineLabel;
}
-(void) setExtraViewInits{
    [self setBackgroundColor:[UIColor redColor]];
    topButton=[LEUIFramework getUIButtonWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self.viewContainer Anchor:LEAnchorInsideTopCenter Offset:CGPointMake(0, 10) CGSize:CGSizeMake(100, 100)] ButtonSettings:[[LEAutoLayoutUIButtonSettings alloc] initWithTitle:@"点击改变大小" FontSize:10 Font:nil Image:[[UIColor redColor] imageWithSize:CGSizeMake(20, 20)] BackgroundImage:[[[UIColor yellowColor] imageWithSize:CGSizeMake(1,1)] middleStrechedImage] Color:ColorBlack SelectedColor:ColorMask5 MaxWidth:100 SEL:@selector(onClick:) Target:self]];
    label=[LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self.viewContainer Anchor:LEAnchorOutsideBottomCenter RelativeView:topButton Offset:CGPointMake(0, 10) CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:@"" FontSize:10 Font:nil Width:0 Height:0 Color:ColorBlack Line:1 Alignment:NSTextAlignmentCenter]];
    multiLineLabel=[LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self.viewContainer Anchor:LEAnchorInsideBottomCenter  Offset:CGPointMake(0, -10) CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:@"" FontSize:15 Font:nil Width:self.globalVar.ScreenWidth-20 Height:0 Color:ColorBlack Line:0 Alignment:NSTextAlignmentCenter]];
    [LEUIFramework getUIButtonWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self.viewContainer Anchor:LEAnchorOutsideTopCenter RelativeView:multiLineLabel Offset:CGPointMake(0, -10) CGSize:CGSizeMake(100, 30)] ButtonSettings:[[LEAutoLayoutUIButtonSettings alloc] initWithTitle:@"点击进入列表测试页面" FontSize:10 Font:nil Image:[[UIColor redColor] imageWithSize:CGSizeMake(20, 20)] BackgroundImage:[[[UIColor yellowColor] imageWithSize:CGSizeMake(1,1)] middleStrechedImage] Color:ColorBlack SelectedColor:ColorMask5 MaxWidth:0 SEL:@selector(onClick:) Target:self]];
}
-(void) onClick:(UIButton *) btn{
    if([btn isEqual:topButton]){
        counter++;
        CGSize size=topButton.bounds.size;
        size.width+=5;
        size.height+=5;
        [label leSetText:[NSString stringWithFormat:@"点击了第%d次，目前按钮大小为%@",counter,NSStringFromCGSize(size)]];
        [topButton leSetSize:size];
        NSString *text=@"";
        for (int i=0; i<counter; i++) {
            text=[text stringByAppendingString:@"测试的句子"];
        }
        [multiLineLabel leSetText:text];
    }else{
        DemoTableViewPage *page=[[DemoTableViewPage alloc] initWithSuperView:self Title:@"列表封装测试案例-数据源" TableViewClassName:nil CellClassName:nil EmptyCellClassName:nil];
        [page easeInView];
    }
}
@end




















@interface DemoViewController ()
@end
@implementation DemoViewController
-(void) iniChildView{
    [LEConnections instance];
    AlipayPage *alipay=[[AlipayPage alloc] initWithSuperView:self.view Title:@"支付宝测试" TableViewClassName:@"AlipayPageTableView" CellClassName:nil EmptyCellClassName:nil];
    [alipay easeInView];
    [self addBottomView:alipay];
//    DemoPage *page =[[DemoPage alloc] initWithSuperView:self.view Title:@"Demo 测试自动排版"];
//    [self.view addSubview:page];
//    [page easeInView];
}
@end
