//
//  AlipayPage.m
//  LEUIFrameworkDemo
//
//  Created by emerson larry on 15/11/5.
//  Copyright © 2015年 Larry Emerson. All rights reserved.
//

#import "AlipayPage.h"
#import "LEConnections.h"

@interface Order : NSObject

@property(nonatomic, copy) NSString * partner;
@property(nonatomic, copy) NSString * seller;
@property(nonatomic, copy) NSString * tradeNO;
@property(nonatomic, copy) NSString * productName;
@property(nonatomic, copy) NSString * productDescription;
@property(nonatomic, copy) NSString * amount;
@property(nonatomic, copy) NSString * notifyURL;

@property(nonatomic, copy) NSString * service;
@property(nonatomic, copy) NSString * paymentType;
@property(nonatomic, copy) NSString * inputCharset;
@property(nonatomic, copy) NSString * itBPay;
@property(nonatomic, copy) NSString * showUrl;


@property(nonatomic, copy) NSString * rsaDate;//可选
@property(nonatomic, copy) NSString * appID;//可选

@property(nonatomic, readonly) NSMutableDictionary * extraParams;
@end
@implementation Order
-(id) initWithDic:(NSDictionary *) dic{
    self=[super init];
    self.partner=[dic objectForKey:@"partner"];
    self.seller=[dic objectForKey:@"seller"];
    self.tradeNO=[dic objectForKey:@"tradeNO"];
    self.productName=[dic objectForKey:@"productName"];
    self.productDescription=[dic objectForKey:@"productDescription"];
    self.amount=[dic objectForKey:@"amount"];
    self.notifyURL=[dic objectForKey:@"notifyURL"];
    
    self.service=[dic objectForKey:@"service"];
    self.paymentType=[dic objectForKey:@"paymentType"];
    self.inputCharset=[dic objectForKey:@"inputCharset"];
    self.itBPay=[dic objectForKey:@"itBPay"];
    self.showUrl=[dic objectForKey:@"showUrl"];
    
    return self;
}
- (NSString *)description {
    NSMutableString * discription = [NSMutableString string];
    if (self.partner) {
        [discription appendFormat:@"partner=\"%@\"", self.partner];
    }
    
    if (self.seller) {
        [discription appendFormat:@"&seller_id=\"%@\"", self.seller];
    }
    if (self.tradeNO) {
        [discription appendFormat:@"&out_trade_no=\"%@\"", self.tradeNO];
    }
    if (self.productName) {
        [discription appendFormat:@"&subject=\"%@\"", self.productName];
    }
    
    if (self.productDescription) {
        [discription appendFormat:@"&body=\"%@\"", self.productDescription];
    }
    if (self.amount) {
        [discription appendFormat:@"&total_fee=\"%@\"", self.amount];
    }
    if (self.notifyURL) {
        [discription appendFormat:@"&notify_url=\"%@\"", self.notifyURL];
    }
    
    if (self.service) {
        [discription appendFormat:@"&service=\"%@\"",self.service];//mobile.securitypay.pay
    }
    if (self.paymentType) {
        [discription appendFormat:@"&payment_type=\"%@\"",self.paymentType];//1
    }
    
    if (self.inputCharset) {
        [discription appendFormat:@"&_input_charset=\"%@\"",self.inputCharset];//utf-8
    }
    if (self.itBPay) {
        [discription appendFormat:@"&it_b_pay=\"%@\"",self.itBPay];//30m
    }
    if (self.showUrl) {
        [discription appendFormat:@"&show_url=\"%@\"",self.showUrl];//m.alipay.com
    }
    if (self.rsaDate) {
        [discription appendFormat:@"&sign_date=\"%@\"",self.rsaDate];
    }
    if (self.appID) {
        [discription appendFormat:@"&app_id=\"%@\"",self.appID];
    }
    for (NSString * key in [self.extraParams allKeys]) {
        [discription appendFormat:@"&%@=\"%@\"", key, [self.extraParams objectForKey:key]];
    }
    return discription;
}
@end


@interface AlipayPageTableViewCellInput : LEBaseTableViewCell<UITextFieldDelegate>
@property (nonatomic) UITextField *curInput;
@property (nonatomic) UIButton *curButton;
@end
@implementation AlipayPageTableViewCellInput{
    
}
-(void) _setReturnKeyType:(UIReturnKeyType) type{
    [self.curInput setReturnKeyType:type];
}
-(void) _becomeFirstResponder{
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(becomeFirstResponderLogic) userInfo:nil repeats:NO];
}
-(void) becomeFirstResponderLogic{
    [self.curInput becomeFirstResponder];
}
-(void) _resignFirstResponder{
    [self.curInput resignFirstResponder];
}
-(void) initUI{
    [self setBackgroundColor:ColorClear];
    [self setCellHeight:DefaultCellHeight];
    self.hasBottomSplit=YES;
    int space =8;
    int spaceH=4;
    int inputW= self.globalVar.ScreenWidth*2/3;
    int btnW=self.globalVar.ScreenWidth/3-space*3;
    UIImageView *inputRect=[LEUIFramework getUIImageViewWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideLeftCenter Offset:CGPointZero CGSize:CGSizeMake(inputW, DefaultCellHeight-spaceH*2)] Image:[[ColorMask imageWithSize:CGSizeMake(1, 1)] middleStrechedImage]];
    self.curInput=[[UITextField alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:inputRect Anchor:LEAnchorInsideCenter Offset:CGPointZero CGSize:CGSizeMake(inputW-space*2, DefaultCellHeight-spaceH*2)]];
    [self.curInput setFont:[UIFont systemFontOfSize:12]];
    [self.curInput setDelegate:self];
    [inputRect setUserInteractionEnabled:YES];
    self.curButton=[LEUIFramework getUIButtonWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorOutsideRightCenter RelativeView:inputRect Offset:CGPointMake(space, 0) CGSize:CGSizeMake(btnW, DefaultCellHeight-spaceH*2)] ButtonSettings:[[LEAutoLayoutUIButtonSettings alloc] initWithTitle:@"购买" FontSize:12 Font:nil Image:nil BackgroundImage:[[UIColor redColor] imageWithSize:CGSizeMake(1, 1)] Color:ColorWhite SelectedColor:ColorGrayText MaxWidth:0 SEL:@selector(onClick) Target:self]];
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void) textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}
-(void) onClick{
    [self.curInput resignFirstResponder];
    if(self.curInput.text.length>0){
        [self.selectionDelegate onTableViewCellSelectedWithInfo:@{KeyOfCellIndexPath:self.curIndexPath,KeyOfCellClickStatus:self.curInput.text}];
    }
}
@end
@interface AlipayPageTableViewCellOrder : LEBaseTableViewCell
@property (nonatomic) UIButton *curButton;
@end
@implementation AlipayPageTableViewCellOrder{
    UILabel *curLabel;
}
-(void) initUI{
    self.hasBottomSplit=YES;
    [self setCellHeight:DefaultCellHeight];
    [self setBackgroundColor:ColorClear];
    
    
    int space =8;
    int spaceH=4;
    int inputW= self.globalVar.ScreenWidth*2/3;
    int btnW=self.globalVar.ScreenWidth/3-space*3;
    UIImageView *inputRect=[LEUIFramework getUIImageViewWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideLeftCenter Offset:CGPointZero CGSize:CGSizeMake(inputW, DefaultCellHeight-spaceH*2)] Image:[[ColorMask imageWithSize:CGSizeMake(1, 1)] middleStrechedImage]];
    curLabel=[LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:inputRect Anchor:LEAnchorInsideCenter Offset:CGPointZero CGSize:CGSizeMake(inputW-space*2, DefaultCellHeight-spaceH*2)] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:@"" FontSize:9 Font:nil Width:inputW Height:DefaultCellHeight-spaceH*2 Color:ColorBlack Line:0 Alignment:NSTextAlignmentLeft]];
    self.curButton=[LEUIFramework getUIButtonWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorOutsideRightCenter RelativeView:inputRect Offset:CGPointMake(space, 0) CGSize:CGSizeMake(btnW, DefaultCellHeight-spaceH*2)] ButtonSettings:[[LEAutoLayoutUIButtonSettings alloc] initWithTitle:@"退款" FontSize:12 Font:nil Image:nil BackgroundImage:[[UIColor redColor] imageWithSize:CGSizeMake(1, 1)] Color:ColorWhite SelectedColor:ColorGrayText MaxWidth:0 SEL:@selector(onClick) Target:self]];
    
}
-(void) setData:(NSDictionary *)data IndexPath:(NSIndexPath *)path{
    self.curIndexPath=path;
    NSString *str=@"";
    str=[[str stringByAppendingString:[data objectForKey:@"productid"]] stringByAppendingString:@" | "];
    str=[[str stringByAppendingString:[data objectForKey:@"out_trade_no"]] stringByAppendingString:@" | "];
    str=[[str stringByAppendingString:[data objectForKey:@"total_fee"]] stringByAppendingString:@" | "];
    str=[[str stringByAppendingString:[data objectForKey:@"gmt_create"]] stringByAppendingString:@" | "];
    str=[[str stringByAppendingString:[data objectForKey:@"notify_time"]] stringByAppendingString:@" | "];
    str=[[str stringByAppendingString:[data objectForKey:@"trade_no"]] stringByAppendingString:@" | "];
    
    [curLabel leSetText:str];
}
-(void) onClick{
    [self onCellSelectedWithIndex:0];
}
@end
@interface AlipayPageTableViewCell : LEBaseTableViewCell
@property (nonatomic) UILabel *curTip;
@end
@implementation AlipayPageTableViewCell
-(void) initUI{
    self.hasBottomSplit=YES;
    [self setCellHeight:DefaultCellHeight];
    [self setBackgroundColor:[UIColor clearColor]];
    self.curTip=[LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideCenter Offset:CGPointZero CGSize:CGSizeMake(self.globalVar.ScreenWidth, DefaultCellHeight)] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:@"" FontSize:9 Font:nil Width:self.bounds.size.width Height:self.bounds.size.height Color:ColorBlack Line:0 Alignment:NSTextAlignmentLeft]];
}
@end
@interface AlipayPageTableView : LEBaseTableView
-(void) setTradeListWith:(NSArray *) waitForPay Paid:(NSArray *) paid Finished:(NSArray *) finished Closed:(NSArray *) closed;
@end
@implementation AlipayPageTableView{
    AlipayPageTableViewCell *loginIngo;
    AlipayPageTableViewCellInput *inputUser;
    AlipayPageTableViewCellInput *inputGID;
    NSArray *arrayWaitForPay;
    NSArray *arrayPaid;
    NSArray *arrayFinished;
    NSArray *arrayClosed;
    
    LEBaseTableViewSection *section0;
    LEBaseTableViewSection *section1;
    LEBaseTableViewSection *section2;
    LEBaseTableViewSection *section3;
    LEBaseTableViewSection *section4;
}
-(void) initTableView{
    arrayWaitForPay=[[NSArray alloc] init];
    arrayPaid=[[NSArray alloc] init];
    arrayFinished=[[NSArray alloc] init];
    arrayClosed=[[NSArray alloc] init];
}
-(void) setUserID:(NSString *) userid{
    [loginIngo.curTip leSetText:[@"当前已登录用户：" stringByAppendingString:userid]];
}
-(void) setTradeListWith:(NSArray *) waitForPay Paid:(NSArray *) paid Finished:(NSArray *) finished Closed:(NSArray *) closed{
    arrayWaitForPay=waitForPay;
    arrayPaid=paid;
    arrayFinished=finished;
    arrayClosed=closed;
    [self reloadData];
    [self onRefreshedWithData:[@[] mutableCopy]];
}
-(CGFloat) _heightForSection:(NSInteger)section{
    return DefaultSectionHeight;
}
-(UIView *) _viewForHeaderInSection:(NSInteger)section{
    LEBaseTableViewSection *view=nil;
    if(section==0){
        if(!section0){
            section0=[[LEBaseTableViewSection alloc] initWithSectionText:@"登录与购买"];
        }
        view=section0;
    }else if(section==1){
        if(!section1){
            section1=[[LEBaseTableViewSection alloc] initWithSectionText:@"订单列表"];
        }
        view=section1;
    }else if(section==2){
        if(!section2){
            section2=[[LEBaseTableViewSection alloc] initWithSectionText:@"已付款列表"];
        }
        view=section2;
    }else if(section==3){
        if(!section3){
            section3=[[LEBaseTableViewSection alloc] initWithSectionText:@"已结束列表"];
        }
        view=section3;
    }else if(section==4){
        if(!section4){
            section4=[[LEBaseTableViewSection alloc] initWithSectionText:@"已关闭列表"];
        }
        view=section4;
    }
    [view setBackgroundColor:[UIColor colorWithRed:0.377 green:0.798 blue:0.659 alpha:1.000]];
    return view;
}
-(NSInteger) _numberOfSections{
    return 5;
}
-(NSInteger) _numberOfRowsInSection:(NSInteger)section{
    if(section==0){
        return 3;
    }else if(section==1){
        return arrayWaitForPay.count;
    }else if(section==2){
        return arrayPaid.count;
    }else if(section==3){
        return arrayFinished.count;
    }else if(section==4){
        return arrayClosed.count;
    }
    return 0;
}
-(UITableViewCell *) _cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LEBaseTableViewCell *cell=nil;
    if(indexPath.section==0){
        if(indexPath.row==0){
            if(!inputUser){
                inputUser=[[AlipayPageTableViewCellInput alloc] initWithSettings:[[LETableViewCellSettings alloc] initWithSelectionDelegate:self.cellSelectionDelegate EnableGesture:NO]];
                [inputUser.curInput setPlaceholder:@"请输入用户ID"];
                [inputUser.curButton setTitle:@"登录" forState:UIControlStateNormal];
            }
            cell=inputUser;
        }else if(indexPath.row==1){
            if(!loginIngo){
                loginIngo=[[AlipayPageTableViewCell alloc] initWithSettings:[[LETableViewCellSettings alloc] initWithSelectionDelegate:nil EnableGesture:NO]];
                [loginIngo.curTip leSetText:@"当前未登录"];
                
            }
            cell=loginIngo;
        }else {
            if(!inputGID){
                inputGID=[[AlipayPageTableViewCellInput alloc] initWithSettings:[[LETableViewCellSettings alloc] initWithSelectionDelegate:self.cellSelectionDelegate EnableGesture:NO]];
                [inputGID.curInput setPlaceholder:@"请输入商品ID"];
                [inputGID.curButton setTitle:@"购买" forState:UIControlStateNormal];
            }
            cell=inputGID;
        }
        [cell setCurIndexPath:indexPath];
    }else {
        cell=[self dequeueReusableCellWithIdentifier:@"order"];
        if(!cell){
            cell=[[AlipayPageTableViewCellOrder alloc] initWithSettings:[[LETableViewCellSettings alloc] initWithSelectionDelegate:self.cellSelectionDelegate TableViewCellStyle:UITableViewCellStyleDefault reuseIdentifier:@"order" EnableGesture:NO]];
        }
        if(indexPath.section==1){
            [[(AlipayPageTableViewCellOrder *)cell curButton] setTitle:@"付款" forState:UIControlStateNormal];
            [[(AlipayPageTableViewCellOrder *)cell curButton] setEnabled:YES];
            [cell setData:[arrayWaitForPay objectAtIndex:indexPath.row] IndexPath:indexPath];
        }else if(indexPath.section==2){
            [[(AlipayPageTableViewCellOrder *)cell curButton] setTitle:@"退款" forState:UIControlStateNormal];
            [[(AlipayPageTableViewCellOrder *)cell curButton] setEnabled:YES];
            [cell setData:[arrayPaid objectAtIndex:indexPath.row] IndexPath:indexPath];
        }else if(indexPath.section==3){
            [[(AlipayPageTableViewCellOrder *)cell curButton] setTitle:@"已结束" forState:UIControlStateNormal];
            [[(AlipayPageTableViewCellOrder *)cell curButton] setEnabled:NO];
            [cell setData:[arrayFinished objectAtIndex:indexPath.row] IndexPath:indexPath];
        }else if(indexPath.section==4){
            [[(AlipayPageTableViewCellOrder *)cell curButton] setTitle:@"已关闭" forState:UIControlStateNormal];
            [[(AlipayPageTableViewCellOrder *)cell curButton] setEnabled:NO];
            [cell setData:[arrayClosed objectAtIndex:indexPath.row] IndexPath:indexPath];
        }
    }
    return cell;
}
@end

@interface AlipayPage()<UITextFieldDelegate,LEConnectionDelegate>
@end
@implementation AlipayPage{
    BOOL isLoggedIn;
    NSString *curUserID;
    
    LEConnectionRequestObject *requestGetOrder;
    LEConnectionRequestObject *requestRefund;
    LEConnectionRequestObject *requestGetTradeList;
    
    NSMutableArray *arrayWaitForPay;
    NSMutableArray *arrayPaid;
    NSMutableArray *arrayFinished;
    NSMutableArray *arrayClosed;
}
-(void) setExtraViewInits{
    arrayWaitForPay=[[NSMutableArray alloc] init];
    arrayPaid=[[NSMutableArray alloc] init];
    arrayFinished=[[NSMutableArray alloc] init];
    arrayClosed=[[NSMutableArray alloc] init];
    [self.curTableView setBottomRefresh:NO];
    [self.viewContainer setBackgroundColor:[UIColor colorWithRed:0.561 green:0.667 blue:0.710 alpha:1.000]];
 
}
-(void) onTableViewCellSelectedWithInfo:(NSDictionary *)info{
    NSIndexPath *index=[info objectForKey:KeyOfCellIndexPath];
    NSString *status=[info objectForKey:KeyOfCellClickStatus];
    if(index.section==0){
        if(index.row==0){
            curUserID=status;
            isLoggedIn=YES;
            [[LEMainViewController instance] setMessageText:[@"已登录" stringByAppendingString:curUserID]];
            [(AlipayPageTableView *)self.curTableView setUserID:curUserID];
            [self onRefreshData];
        }else{
            if(isLoggedIn){
                [self onPurchaseWithProductID:status];
            }else{
                [[LEMainViewController instance] setMessageText:@"尚未登录"];
            }
        }
    }else{
        if(isLoggedIn){
            if(index.section==1){
                [self onPurchaseWithOrderID:[[arrayWaitForPay objectAtIndex:index.row] objectForKey:@"id"]];
            }else if(index.section==2){
                [self onRefundWithTradeID:[[arrayPaid objectAtIndex:index.row] objectForKey:@"id"]];
            }
        }else{
            [[LEMainViewController instance] setMessageText:@"尚未登录"];
        };
    }
}

-(void) onPurchaseWithProductID:(NSString *) gid{
    requestGetOrder= [[LEConnections instance] requestWithURL:[ServerPath stringByAppendingString: @"PHP-UTF-8/getorder.php"] parameters:@{@"productid":gid,@"userid":curUserID} Delegate:self];
}
-(void) onPurchaseWithOrderID:(NSString *) oid{
    requestGetOrder= [[LEConnections instance] requestWithURL:[ServerPath stringByAppendingString: @"PHP-UTF-8/getorder.php"] parameters:@{@"id":oid} Delegate:self];
}
-(void) onRefundWithTradeID:(NSString *) tid{
    requestRefund=  [[LEConnections instance] requestWithURL:[ServerPath stringByAppendingString: @"refund_fastpay_by_platform_pwd-PHP-UTF-8/alipayapi.php"] parameters:@{@"id":tid} Delegate:self];
}
//
-(void) onRefreshData{
    if(isLoggedIn){
        requestGetTradeList=[[LEConnections instance] requestWithURL:[ServerPath stringByAppendingString: @"PHP-UTF-8/gettradelist.php"] parameters:@{@"userid":curUserID} Delegate:self];
    }
}
//
-(void) request:(LEConnectionRequestObject *)request ResponedWith:(LEConnectionsResponseObject *)response{
    if([requestGetOrder isEqual:request]){
        if(response.result){
            if(response.error==0){
                NSString *sign=[response.result objectForKey:@"sign"];
                NSString *orderSpec=[response.result objectForKey:@"order"];
                NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"", orderSpec, sign, @"RSA"];
                NSLogObjects(orderString);
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"TestAlipay" callback:^(NSDictionary *resultDic) {
                    NSLog(@"reslut = %@",resultDic);
                    [self onRefreshData];
                    [self.globalVar.appDelegate showAlipayDic:resultDic];
//                    if([self.globalVar.appDelegate respondsToSelector:NSSelectorFromString(@"showAlipayDic")]) 
//                    [self.globalVar.appDelegate performSelector:NSSelectorFromString(@"showAlipayDic") withObject:resultDic];
                    
//                    {
//                        memo = "";
//                        result = "partner=\"2088511678677741\"&seller_id=\"pay@360cbs.com\"&out_trade_no=\"ABCDEFG1234567\"&subject=\"\U652f\U4ed8\U5b9d\U6d4b\U8bd5\U5546\U54c1\U6807\U9898\"&body=\"\U652f\U4ed8\U5b9d\U6d4b\U8bd5\U5546\U54c1\U63cf\U8ff0\"&total_fee=\"0.01\"&notify_url=\"http://360cbs.hicp.net:8001/PHP-UTF-8/notify_url.php\"&service=\"mobile.securitypay.pay\"&payment_type=\"1\"&_input_charset=\"utf-8\"&it_b_pay=\"30m\"&show_url=\"m.alipay.com\"&success=\"true\"&sign_type=\"RSA\"&sign=\"brGpY0mocDJmiEb09uVgA4eGcdetpgPsMLpbnm0bQbCd2Q88L5AhxE08TQd9bjLuX1r2oLE7rdgMksUVFBFmgNtClwWKf0gJUkmU/B52hTVQqwt3Ao23FEwNgDfomlOO+kEaKzHFL8cxGaAtjUEmObwoFXOWiBsyhBW7WvM0wLo=\"";
//                        resultStatus = 9000;
//                    }
                }];
            }else if(response.error==2){
                [self performSelector:@selector(onPurchaseWithOrderID:) withObject:response.result afterDelay:1];
            }
        }
    }else if([requestGetTradeList isEqual:request]){
        [self dealWithTradeList:response.result];
        [(AlipayPageTableView *)self.curTableView setTradeListWith:arrayWaitForPay Paid:arrayPaid Finished:arrayFinished Closed:arrayClosed];
    }else if([requestRefund isEqual:request]){
        NSLogObjects(response.result);
        LEWebView *web=[[LEWebView alloc] initWithSuperView:self Title:@"退款"];
        [web easeInView];
        UIWebView *webView=[web getWeb];
        [webView loadData:response.result MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:nil];
    }
}
//WAIT_BUYER_PAY/TRADE_SUCCESS/TRADE_FINISHED/TRADE_CLOSED
-(void) dealWithTradeList:(NSArray *) list{
    [arrayWaitForPay removeAllObjects];
    [arrayPaid removeAllObjects];
    [arrayFinished removeAllObjects];
    [arrayClosed removeAllObjects];
    for (int i=0; i<list.count; i++) {
        NSDictionary *dic=[list objectAtIndex:i];
        NSString *status=[dic objectForKey:@"trade_status"];
        if([status isEqualToString:@"WAIT_BUYER_PAY"]){
            [arrayWaitForPay addObject:dic];
        }else if([status isEqualToString:@"TRADE_SUCCESS"]){
            [arrayPaid addObject:dic];
        }else if([status isEqualToString:@"TRADE_FINISHED"]){
            [arrayFinished addObject:dic];
        }else if([status isEqualToString:@"TRADE_CLOSED"]){
            [arrayClosed addObject:dic];
        }
    }
}
@end
