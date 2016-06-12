//
//  LEBaseTableView.m
//  spark-client-ios
//
//  Created by Larry Emerson on 15/2/4.
//  Copyright (c) 2015年 Syan. All rights reserved.
//

#import "LEBaseTableView.h"

@implementation LETableViewCellSettings
-(id) initWithSelectionDelegate:(id<LETableViewCellSelectionDelegate>) delegate EnableGesture:(BOOL) gesture{
    return [self initWithSelectionDelegate:delegate TableViewCellStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell" EnableGesture:gesture];
}
-(id) initWithSelectionDelegate:(id<LETableViewCellSelectionDelegate>) delegate{
    return [self initWithSelectionDelegate:delegate TableViewCellStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
}
-(id) initWithSelectionDelegate:(id<LETableViewCellSelectionDelegate>) delegate TableViewCellStyle:(UITableViewCellStyle) style reuseIdentifier:(NSString *) reuseIdentifier{
    return [self initWithSelectionDelegate:delegate TableViewCellStyle:style reuseIdentifier:reuseIdentifier EnableGesture:YES];
}
-(id) initWithSelectionDelegate:(id<LETableViewCellSelectionDelegate>) delegate TableViewCellStyle:(UITableViewCellStyle) style reuseIdentifier:(NSString *) reuseIdentifier  EnableGesture:(BOOL) gesture{
    self=[super init];
//    self.tableView=table;
    self.selectionDelegate=delegate;
    self.style=style;
    self.reuseIdentifier=reuseIdentifier;
    self.gesture=gesture;
    return self;
}
@end
@implementation LETableViewCellSelectionSettings
-(id) initWithIndexPath:(NSIndexPath *) index ClickStatus:(TableViewCellClickStatus) status{
    self=[super init];
    self.indexPath=index;
    self.clickStatus=status;
    return self;
}
@end
@implementation LETableViewSettings
-(id) initWithSuperViewContainer:(UIView *) superView ParentView:(UIView *) parent TableViewCell:(NSString *) cell EmptyTableViewCell:(NSString *) empty GetDataDelegate:(id<LEGetDataDelegate>) get   TableViewCellSelectionDelegate:(id<LETableViewCellSelectionDelegate>) selection{
    self=[super init];
    self.superViewContainer=superView;
    self.parentView=parent;
    self.tableViewCellClassName=cell;
    self.emptyTableViewCellClassName=empty;
    self.getDataDelegate=get; 
    self.tableViewCellSelectionDelegate=selection;
    return self;
}
@end

@interface LEBaseTableView()<UITableViewDelegate,UITableViewDataSource,DJRefreshDelegate>
@property (nonatomic) DJRefresh *refresh;
@property (nonatomic) NSTimer *curTimer;
@property (nonatomic) DJRefreshDirection curDirection;
@end
@implementation LEBaseTableView
- (id) initWithSettings:(LETableViewSettings *) settings{
    self.emptyTableViewCellClassName=settings.emptyTableViewCellClassName;
    self.tableViewCellClassName=settings.tableViewCellClassName;
    UIView *superView=settings.superViewContainer;
    UIView *parentView=settings.parentView;
    id<LEGetDataDelegate> getDatadelegate=settings.getDataDelegate;
    [self setGetDataDelegate:getDatadelegate];
    [self setCellSelectionDelegate:settings.tableViewCellSelectionDelegate];
    self = [super initWithFrame:parentView.bounds style:UITableViewStylePlain];
    [self setLeAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:parentView EdgeInsects:UIEdgeInsetsZero]];
    [self leExecAutoLayout];
    self.superViewContainer=superView;
    [parentView addSubview:self];
    if (self) {
        self.itemsArray=[[NSMutableArray alloc] init];
        [self setBackgroundColor:ColorClear];
        [self setDelegate:self];
        [self setDataSource:self];
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self setAllowsSelection:NO];
        //
        self.refresh=[DJRefresh refreshWithScrollView:self];
        [self.refresh setDelegate:self];
        [self.refresh setTopEnabled:YES];
        [self.refresh setBottomEnabled:YES];
        [self initTableView];
        //        [self onDelegateRefreshData];
//        [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(onDelegateRefreshData) userInfo:nil repeats:NO];
    }
    return self;
} 
-(void) initTableView{
}
//
-(void) setTopRefresh:(BOOL) enable{
    [self.refresh setTopEnabled:enable];
}
-(void) setBottomRefresh:(BOOL) enable{
    [self.refresh setBottomEnabled:enable];
}
- (void)refresh:(DJRefresh *)refresh didEngageRefreshDirection:(DJRefreshDirection)direction {
    self.curDirection=direction;
    [self.curTimer invalidate];
    self.curTimer=[NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(onStopRefreshLogic) userInfo:nil repeats:NO];
//    [self setUserInteractionEnabled:NO];
    if(direction==DJRefreshDirectionTop){
        [self onDelegateRefreshData];
    }else {
        [self onDelegateLoadMore];
    }
}
//
-(void) onStopRefresh {
    [self.curTimer invalidate];
    self.curTimer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(onStopRefreshLogic) userInfo:nil repeats:NO];
}
-(void) onStopRefreshLogic{
    [self.curTimer invalidate];
    [self reloadData];
    [self.refresh finishRefreshingDirection:self.curDirection animation:YES];
//    [self setUserInteractionEnabled:YES];
}
//
-(void) onDelegateRefreshData{
    if(self.getDataDelegate){
        [self.getDataDelegate onRefreshData];
    }
}
-(void) onDelegateLoadMore{
    if(self.getDataDelegate){
        [self.getDataDelegate onLoadMore];
    }
}
//
-(void) onRefreshedWithData:(NSMutableArray *)data{
    if(data){
        self.itemsArray=[data mutableCopy];
        self.curDirection=DJRefreshDirectionTop;
        [self onStopRefresh];
    }
}
-(void) onLoadedMoreWithData:(NSMutableArray *)data{
    if(data){
        [self.itemsArray addObjectsFromArray:data];
        self.curDirection=DJRefreshDirectionBottom;
        [self onStopRefresh];
    }
}
//
-(NSInteger) _numberOfSections{
    return 1;
}
-(CGFloat) _heightForSection:(NSInteger) section{
    return 0;
}
-(UIView *) _viewForHeaderInSection:(NSInteger) section{
    return nil;
}
-(NSInteger) _numberOfRowsInSection:(NSInteger) section{
//    NSLogObjects(self.itemsArray);
    return self.itemsArray.count;
}
-(UITableViewCell *) _cellForRowAtIndexPath:(NSIndexPath *) indexPath{
    if(indexPath.section==0){
        UITableViewCell *cell=[self dequeueReusableCellWithIdentifier:self.tableViewCellClassName];
        if(!cell){
            cell=[[self.tableViewCellClassName getInstanceFromClassName] performSelector:NSSelectorFromString(@"initWithSettings:") withObject:[[LETableViewCellSettings alloc] initWithSelectionDelegate:self.cellSelectionDelegate]];
        }
        [cell performSelector:NSSelectorFromString(@"setData:IndexPath:") withObject:[self.itemsArray objectAtIndex:indexPath.row] withObject:indexPath];
        return cell;
    }
    return nil;
}
//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self _numberOfSections];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self _heightForSection:section];
}
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self _viewForHeaderInSection:section];
}
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows=[self _numberOfRowsInSection:section];
    if(rows==0 && section==0 && [self _numberOfSections] <=1){
        return 1;
    }else{
        return [self _numberOfRowsInSection:section];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0 && [self _numberOfRowsInSection:0]==0 && [self _numberOfSections] <=1){
        if(!self.emptyTableViewCell){
            self.emptyTableViewCell=[[self.emptyTableViewCellClassName getInstanceFromClassName] performSelector:NSSelectorFromString(@"initWithSettings:") withObject:@{KeyOfCellTitle:@"暂无内容"}];
        }
        return self.emptyTableViewCell;
    }
    return [self _cellForRowAtIndexPath:indexPath];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:tableView cellForRowAtIndexPath:indexPath].frame.size.height;
}
@end
