//
//  LETableViewPage.h
//  LEUIFrameworkDemo
//
//  Created by Larry Emerson on 15/8/25.
//  Copyright (c) 2015年 Larry Emerson. All rights reserved.
//

#import "LEBasePageView.h"
#import "LEBaseTableView.h" 
#import "LEDataDelegate.h"
@interface LETableViewPage : LEBasePageView<LEGetDataDelegate,LETableViewCellSelectionDelegate>
@property (nonatomic) LEBaseTableView *curTableView;

-(id) initWithSuperView:(UIView *)view Title:(NSString *)title TableViewClassName:(NSString *) tableViewClassName CellClassName:(NSString *) cellClassName EmptyCellClassName:(NSString *) emptyCellClassName;
//
-(void) onTableViewCellSelectedWithInfo:(NSDictionary *)info;
-(void) onRefreshData;
-(void) onLoadMore;
-(void) onFreshDataLogic:(NSMutableArray *) data;
-(void) onLoadMoreLogic:(NSMutableArray *) data;

@end
