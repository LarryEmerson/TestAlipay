//
//  LETableViewPageWithBanner.m
//  four23
//
//  Created by Larry Emerson on 15/9/8.
//  Copyright (c) 2015年 360cbs. All rights reserved.
//

#import "LETableViewPageWithBanner.h"


@implementation LEBannerContainer{
    LEUIFramework *globalVar;
    id bannerDelegate;
    HMBannerView *bannerView;
    LEBannerSubview *bannerSubview;
}
-(id) initWithFrame:(CGRect) frame Delegate:(id) delegate SubviewClassName:(NSString *) subView BannerImageViewClassName:(NSString *) bannerImageView{
    globalVar=[LEUIFramework instance];
    self=[super initWithFrame:frame];
    bannerDelegate=delegate;
    bannerView=[[HMBannerView alloc] initWithFrame:CGRectMake(0, 0, globalVar.ScreenWidth, globalVar.ScreenWidth*DefaultBannerHeightRate) scrollDirection:ScrollDirectionLandscape images:nil ImageViewClassName:bannerImageView];
    [bannerView setDelegate:self];
    [bannerView setRollingDelayTime:2];
    [bannerView setPageControlStyle:PageStyle_Middle]; 
    [self addSubview:bannerView];
    if(subView){
        bannerSubview=[[subView getInstanceFromClassName] performSelector:NSSelectorFromString(@"initWithDelegate:") withObject:self];
        [bannerSubview setFrame:CGRectMake(0, globalVar.ScreenWidth*DefaultBannerHeightRate, globalVar.ScreenWidth, DefaultBannerSubviewHeight)];
        [self addSubview:bannerSubview];
    }
    [self setFrame:CGRectMake(0, 0, globalVar.ScreenWidth, globalVar.ScreenWidth*DefaultBannerHeightRate+(bannerSubview?DefaultBannerSubviewHeight:0))];
    return self;
}
-(void) setBannerData:(NSArray *) bannerData SubviewData:(NSDictionary *)subview{
    if(bannerData){
        [bannerView reloadBannerWithData:bannerData];
        [bannerView startRolling];
    }
    if(subview){
        [bannerSubview setData:subview];
    }
}
-(void) onFrameResizedWithHeight:(int)height{
    [bannerSubview setFrame:CGRectMake(0, bannerView.bounds.size.height, globalVar.ScreenWidth, height)];
    [self setFrame:CGRectMake(0, 0, globalVar.ScreenWidth, globalVar.ScreenWidth*DefaultBannerHeightRate+height)];
    if([bannerDelegate respondsToSelector:NSSelectorFromString(@"onFrameResizedWithHeight:")]){
        [bannerDelegate onFrameResizedWithHeight:self.bounds.size.height];
    }
}
-(void) imageCachedDidFinish:(HMBannerView *)bannerView{
    
}
-(void) bannerView:(HMBannerView *)bannerView didSelectImageView:(NSInteger)index withData:(NSDictionary *)bannerData{
    if(bannerDelegate){
        [bannerDelegate onBannerSelectedWithIndex:index];
    }
}
@end

@implementation LEBannerCell{
    HMBannerView *bannerView;
    LEBannerSubview *bannerSubview;
}
-(id) initWithSelectionDelegate:(id<LETableViewCellSelectionDelegate>) delegate SubviewClassName:(NSString *) subview BannerImageViewClassName:(NSString *) bannerImageView{
    LETableViewCellSettings *settings=[[LETableViewCellSettings alloc] initWithSelectionDelegate:delegate TableViewCellStyle:UITableViewCellStyleDefault reuseIdentifier:@"Banner" EnableGesture:NO];
    self=[super initWithSettings:settings];
    bannerView=[[HMBannerView alloc] initWithFrame:CGRectMake(0, 0, self.globalVar.ScreenWidth, self.globalVar.ScreenWidth*DefaultBannerHeightRate) scrollDirection:ScrollDirectionLandscape images:nil ImageViewClassName:bannerImageView];
    [self addSubview:bannerView];
    [bannerView setDelegate:self];
    [bannerView setRollingDelayTime:2];
    [bannerView setPageControlStyle:PageStyle_Middle];
    if(subview){
        bannerSubview=[[subview getInstanceFromClassName] performSelector:NSSelectorFromString(@"initWithDelegate:") withObject:self];
        [bannerSubview setFrame:CGRectMake(0, bannerView.bounds.size.height, self.globalVar.ScreenWidth, DefaultBannerSubviewHeight)];
        [self addSubview:bannerSubview];
    }

    [self setCellHeight:self.globalVar.ScreenWidth*DefaultBannerHeightRate+(subview?DefaultBannerSubviewHeight:0)];
    return self;
}
-(void) onFrameResizedWithHeight:(int)height{
    [bannerSubview setFrame:CGRectMake(0, bannerView.bounds.size.height, self.globalVar.ScreenWidth, height)];
    [self setCellHeight:self.globalVar.ScreenWidth*DefaultBannerHeightRate+height];
}
-(void) setBannerData:(NSArray *)data IndexPath:(NSIndexPath *)path SubviewData:(NSDictionary *) subview{
    self.curIndexPath=path;
    if(data){
        [bannerView reloadBannerWithData:data];
        [bannerView startRolling];
    }
    if(subview&&bannerSubview){
        [bannerSubview setData:subview];
    }
}
-(void) imageCachedDidFinish:(HMBannerView *)bannerView{

}
-(void) bannerView:(HMBannerView *)bannerView didSelectImageView:(NSInteger)index withData:(NSDictionary *)bannerData{
    if(self.selectionDelegate){
        [self.selectionDelegate onTableViewCellSelectedWithInfo:@{KeyOfCellIndexPath:self.curIndexPath,KeyOfCellClickStatus:[NSNumber numberWithInteger:index]}];
    }
}
@end

@implementation LEBannerSubview{
    id<LEBannerSubviewFrameDelegate> frameDelegate;
}
-(id) initWithDelegate:(id)delegate{
    frameDelegate=delegate;
    self.globalVar=[LEUIFramework instance];
    self= [super init];
    [self initUI];
    if(frameDelegate){
        [frameDelegate onFrameResizedWithHeight:self.frame.size.height];
    }
    return self;
}
-(void) setData:(NSDictionary *) data{
    //set your subview's contents here and reset subview's frame
    [self notifyHeightChange];
}
-(void) initUI{
    
}
-(void) notifyHeightChange{
    if(frameDelegate){
        [frameDelegate onFrameResizedWithHeight:self.frame.size.height];
    }
}
@end
@implementation LEBannerTableView{
    LEBannerCell *bannerCell;
    NSArray *curBannerData;
    NSDictionary *curSubViewData;
    NSString *subViewClassName;
    TableViewBannerStyle bannerStyle;
    NSString * bannerImageViewClassName;
}

-(NSInteger) _numberOfRowsInSection:(NSInteger) section{
    if(bannerStyle==BannerStayAtTheTop){
        return self.itemsArray.count;
    }else{
        return self.itemsArray.count+(curBannerData?1:0);
    }
}
-(void) setBannerData:(NSArray *)bannerData SubviewData:(NSDictionary *) subView{
    if(bannerData){
        curBannerData=bannerData;
    }
    if(subView){
        curSubViewData=subView;
    }
    if(bannerData||subView){
        [self reloadData];
    }
}

-(UITableViewCell *) _cellForRowAtIndexPath:(NSIndexPath *) indexPath{
    if(bannerStyle==BannerStayAtTheTop){
        UITableViewCell *cell=[self dequeueReusableCellWithIdentifier:self.tableViewCellClassName];
        if(!cell){
            cell=[[self.tableViewCellClassName getInstanceFromClassName] performSelector:NSSelectorFromString(@"initWithSettings:") withObject:[[LETableViewCellSettings alloc] initWithSelectionDelegate:self.cellSelectionDelegate]];
        }
        [cell performSelector:NSSelectorFromString(@"setData:IndexPath:") withObject:[self.itemsArray objectAtIndex:indexPath.row] withObject:indexPath];
        return cell;
    }else{
        if(indexPath.section==0){
            if(indexPath.row==0&&curBannerData){
                if(!bannerCell){
                    bannerCell=[[LEBannerCell alloc] initWithSelectionDelegate:self.cellSelectionDelegate SubviewClassName:subViewClassName BannerImageViewClassName:bannerImageViewClassName];
                }
                if(curBannerData){
                    [bannerCell setBannerData:curBannerData IndexPath:indexPath SubviewData:curSubViewData];
                }
                return bannerCell;
            }else{
                UITableViewCell *cell=[self dequeueReusableCellWithIdentifier:self.tableViewCellClassName];
                if(!cell){
                    cell=[[self.tableViewCellClassName getInstanceFromClassName] performSelector:NSSelectorFromString(@"initWithSettings:") withObject:[[LETableViewCellSettings alloc] initWithSelectionDelegate:self.cellSelectionDelegate]];
                }
                int index=indexPath.row-(curBannerData?1:0);
                if(index<self.itemsArray.count){
                    [cell performSelector:NSSelectorFromString(@"setData:IndexPath:") withObject:[self.itemsArray objectAtIndex:index] withObject:indexPath];
                }
                return cell;
            }
        }
    }
    return nil;
}
- (id) initWithSettings:(LETableViewSettings *) settings BannerSubviewClassName:(NSString *) subView BannerStyle:(TableViewBannerStyle)style  BannerImageViewClassName:(NSString *) bannerImageView{
    subViewClassName=subView;
    bannerStyle=style;
    bannerImageViewClassName=bannerImageView;
    return [super initWithSettings:settings];
}
@end

@interface LETableViewPageWithBanner ()<LEGetDataDelegate,LETableViewCellSelectionDelegate,LEBannerSubviewFrameDelegate,LEBannerViewSelectionDelegate>
@end
@implementation LETableViewPageWithBanner{ 
    LEBannerTableView *curTableView;
    LEBannerContainer *bannerContainer;
    UIView *tableViewContainer;
    TableViewBannerStyle curBannerStyle;
}
-(void) setTopRefresh:(BOOL) top BottomRefresh:(BOOL) bottom{
    [curTableView setTopRefresh:top];
    [curTableView setBottomRefresh:bottom];
}

-(id) initWithSuperView:(UIView *)view Title:(NSString *)title CellClassName:(NSString *) cellClassName EmptyCellClassName:(NSString *) emptyCellClassName BannerStyle:(TableViewBannerStyle) bannerStyle BannerImageViewClassName:(NSString *) bannerImageViewClassName BannerSubviewClassName:(NSString *) bannerSubviewClassName {
    curBannerStyle=bannerStyle;
    if(!cellClassName||cellClassName.length==0){
        cellClassName=@"LEBaseTableViewCell";
    }
    if(!emptyCellClassName||emptyCellClassName.length==0){
        emptyCellClassName=@"LEBaseEmptyTableViewCell";
    }
    if(!bannerImageViewClassName||bannerImageViewClassName.length==0){
        bannerImageViewClassName=@"HMBannerViewImageView";
    }
    if(bannerSubviewClassName&&bannerSubviewClassName.length==0){
        bannerSubviewClassName=nil;
    }
    self= [super initWithSuperView:view Title:title];
    if(bannerStyle==BannerStayAtTheTop){
        bannerContainer=[[LEBannerContainer alloc] initWithFrame:CGRectMake(0, 0, self.globalVar.ScreenWidth, self.globalVar.ScreenWidth*DefaultBannerHeightRate) Delegate:self SubviewClassName:bannerSubviewClassName BannerImageViewClassName:bannerImageViewClassName];
        [self.viewContainer addSubview:bannerContainer];
        tableViewContainer=[[UIView alloc] initWithFrame:CGRectMake(0, bannerContainer.bounds.size.height, self.globalVar.ScreenWidth, self.viewContainer.bounds.size.height-bannerContainer.bounds.size.height)];
        [self.viewContainer addSubview:tableViewContainer];
        curTableView=[[LEBannerTableView alloc] initWithSettings:[[LETableViewSettings alloc] initWithSuperViewContainer:self.superViewContainer ParentView:tableViewContainer TableViewCell:cellClassName EmptyTableViewCell:emptyCellClassName GetDataDelegate:self TableViewCellSelectionDelegate:self] BannerSubviewClassName:bannerSubviewClassName BannerStyle:bannerStyle BannerImageViewClassName:bannerImageViewClassName];
    }else{
        curTableView=[[LEBannerTableView alloc] initWithSettings:[[LETableViewSettings alloc] initWithSuperViewContainer:self.superViewContainer ParentView:self.viewContainer TableViewCell:cellClassName EmptyTableViewCell:emptyCellClassName GetDataDelegate:self TableViewCellSelectionDelegate:self] BannerSubviewClassName:bannerSubviewClassName BannerStyle:bannerStyle BannerImageViewClassName:bannerImageViewClassName];
    }
    [curTableView setAlpha:0];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^(void){
        [curTableView setAlpha:1];
    } completion:^(BOOL isDone){
        
    }];
    return self;
}
//点击事件
-(void) onBannerSelectedWithIndex:(NSInteger)index{
    NSLog(@"触发Banner点击事件，子类需要重写onBannerSelectedWithIndex方法。当前点击了第%@张Banner",[NSNumber numberWithInteger:index]);
}
-(void) onTableViewCellSelectedWithInfo:(NSDictionary *)info{
    NSLog(@"参数tableViewDelegate=nil, 调用父类onTableViewCellSelectedWithInfo。%@",info);
}
//数据请求
-(void) onRefreshData{
    NSLog(@"触发下拉刷新，子类需要重写onRefreshData方法，待获取到数据后需要执行onFreshDataLogic方法");
}
-(void) onLoadMore{
    NSLog(@"上拉获取更多，子类需要重写onLoadMore方法，待获取到数据后需要执行onLoadMoreLogic");
}
//高度变动通知
-(void) onFrameResizedWithHeight:(int)height{
    [bannerContainer setFrame:CGRectMake(0, 0, self.globalVar.ScreenWidth, height)];
    [tableViewContainer setFrame:CGRectMake(0, bannerContainer.bounds.size.height, self.globalVar.ScreenWidth, self.viewContainer.bounds.size.height-height)];
    [curTableView leSetFrame:tableViewContainer.bounds];
}
//Banner数据
-(void) onSetBannerData:(NSArray *) bannerData SubviewData:(NSDictionary *) subviewData{
    if(curBannerStyle==BannerStayAtTheTop){
        if(bannerContainer){
            [bannerContainer setBannerData:bannerData SubviewData:subviewData];
        }
    }else{
        if(curTableView){
            [curTableView setBannerData:bannerData SubviewData:subviewData];
        }
    }
}
//数据
-(void) onFreshDataLogic:(NSMutableArray *) data{
    if(curTableView){
        [curTableView onRefreshedWithData:data];
    }
}
-(void) onLoadMoreLogic:(NSMutableArray *) data{
    if(curTableView){
        [curTableView onLoadedMoreWithData:data];
    }
}
@end