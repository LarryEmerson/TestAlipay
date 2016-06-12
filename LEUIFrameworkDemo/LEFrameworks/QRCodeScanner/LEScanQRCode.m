//
//  LEScanQRCode.m
//  LEFrameworks
//
//  Created by Larry Emerson on 15/8/27.
//  Copyright (c) 2015年 LarryEmerson. All rights reserved.
//

#import "LEScanQRCode.h"
//#import "ZBarSDK.h"
#import "LEMainViewController.h" 
#import <AVFoundation/AVFoundation.h>

@interface LEScanQRCode()<AVCaptureMetadataOutputObjectsDelegate/*,ZBarReaderViewDelegate*/>
@end

@implementation LEScanQRCode{
 
    //
    UIImageView *scanLine;
    int curLineOffset;
    BOOL isLineUp;
    
    AVCaptureDevice * device;
    AVCaptureDeviceInput * input;
    AVCaptureMetadataOutput * output;
    AVCaptureSession * session;
    AVCaptureVideoPreviewLayer * preview;
    NSTimer *curTimer;
    
    float scanSpaceW;
    float scanSpaceH;
    
    
//    ZBarReaderView *curZBarReader;
//    ZBarImageScanner *curZBarScanner;
    float DefaultScanRect;
    //
    UIView *curResultView;
    UILabel *curHelper;
}

-(void) setCustomizeResultWithView:(UIView *) view{
    if(curResultView){
        [curResultView removeFromSuperview];
    }
    curResultView=view;
    [self.viewContainer addSubview:curResultView];
    [curResultView setHidden:YES];
}
-(void) easeOutViewLogic{ 
//    if(self.globalVar.IsStatusBarNotCovered){
        [session stopRunning];
        device=nil;
        input=nil;
        output=nil;
        [preview removeFromSuperlayer];
        session=nil;
//    }else{
//        [curZBarReader setReaderDelegate:nil];
//    }
}
-(void) showOrHideResultView:(BOOL) show{
    if(curResultView){
        [curResultView setHidden:NO];
    }
}
//IOS7+
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    NSString *stringValue;
    if (metadataObjects && [metadataObjects count] >0) {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        if([[metadataObject type] isEqualToString:AVMetadataObjectTypeQRCode]){
            stringValue = metadataObject.stringValue;
        }
    }
    [self switchScanLine:NO];
    [session stopRunning];
    device=nil;
    input=nil;
    output=nil;
    session=nil;
    if(stringValue){
        if(self.scanQRCodeDelegate){
            [self.scanQRCodeDelegate onScannedQRCodeWithResult:stringValue];
        }
        if(!curResultView){
            [self easeOutView];
        }
    }
}
////IOS6-
//- (void) readerView: (ZBarReaderView*) readerView didReadSymbols: (ZBarSymbolSet*) symbols fromImage: (UIImage*) image{
//    ZBarSymbol * symbol = nil;
//    for (symbol in symbols) {
//        break;
//    }
//    NSString * result;
//    if ([symbol.data canBeConvertedToEncoding:NSShiftJISStringEncoding]) {
//        result = [NSString stringWithCString:[symbol.data cStringUsingEncoding: NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
//    } else {
//        result = symbol.data;
//    }
//    [readerView stop];
//    [self switchScanLine:NO];
//    if(result&&(NSNull *)result!=[NSNull null]){
//        if(self.scanQRCodeDelegate){
//            [self.scanQRCodeDelegate onScannedQRCodeWithResult:result];
//        }
//        if(curResultView){
//            [curResultView setHidden:NO];
//        }else{
//            [self easeOutView];
//        }
//    } 
//}
//- (void) readerView: (ZBarReaderView*) readerView
//   didStopWithError: (NSError*) error{
//    [curZBarReader flushCache];
//}

-(void) setExtraViewInits {
    //
    DefaultScanRect=self.globalVar.ScreenWidth*2.0/3;
    scanSpaceH=NavigationBarHeight*1.5;
//    float topRate=scanSpaceH/self.viewContainer.bounds.size.height;
//    if(self.globalVar.IsStatusBarNotCovered){
        device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        if(input){
            output = [[AVCaptureMetadataOutput alloc]init];
            [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
            session = [[AVCaptureSession alloc]init];
            [session setSessionPreset:AVCaptureSessionPresetHigh];
            if ([session canAddInput:input]) {
                [session addInput:input];
            }
            if ([session canAddOutput:output]) {
                [session addOutput:output];
            }
            output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
            preview =[AVCaptureVideoPreviewLayer layerWithSession:session];
            preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
            preview.frame =self.viewContainer.bounds;
            [self.viewContainer.layer insertSublayer: preview atIndex:0];
            [session startRunning];
        }
//    }else{
//        curZBarScanner=[[ZBarImageScanner alloc] init];
//        curZBarReader=[[ZBarReaderView alloc] initWithImageScanner:curZBarScanner];
//        [curZBarReader setReaderDelegate:self];
//        [curZBarReader setTorchMode:0];
//        [curZBarReader setFrame:self.viewContainer.bounds];
//        [curZBarScanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
//        [self.viewContainer addSubview:curZBarReader];
//        [curZBarReader setScanCrop:CGRectMake(topRate, 1.0/6, DefaultScanRect*1.0/self.viewContainer.bounds.size.height, 2.0/3)];
//        //[y,x,h,w]
//        [curZBarReader start];
//        [curZBarReader setEnableCache:YES];
//        [curZBarReader setBackgroundColor:ColorBlack];
//        [curZBarReader setTrackingColor:[UIColor clearColor]];
//        [curZBarReader setTracksSymbols:NO];
//        [curZBarReader setAllowsPinchZoom:NO];
//        [curZBarReader willRotateToInterfaceOrientation: UIInterfaceOrientationPortrait duration: [[UIApplication sharedApplication] statusBarOrientationAnimationDuration]];
//    }
    [self switchScanLine:YES];
    //
    scanSpaceW=(self.globalVar.ScreenWidth-DefaultScanRect)/2;
    //
    UIImage *imgScanPickBG=[UIImage imageNamed:@"main_scan_pick_bg"];
    UIImageView *viewScanRect=[[UIImageView alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self.viewContainer Anchor:LEAnchorInsideTopCenter Offset:CGPointMake(0, scanSpaceH) CGSize:CGSizeMake(DefaultScanRect, DefaultScanRect)]];
    [self.viewContainer addSubview:viewScanRect];
    [viewScanRect setBackgroundColor:[UIColor clearColor]];
    [viewScanRect setImage:imgScanPickBG];
    
    UIImage *imgScanLine=[UIImage imageNamed:@"scan_line"];
    scanLine=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DefaultScanRect, imgScanLine.size.height)];
    [scanLine setImage:imgScanLine];
    [viewScanRect addSubview:scanLine];
    
    UIView *viewTop=[[UIView alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self.viewContainer Anchor:LEAnchorInsideTopCenter Offset:CGPointZero CGSize:CGSizeMake(self.globalVar.ScreenWidth, scanSpaceH)]];
    UIView *viewLeft=[[UIView alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self.viewContainer Anchor:LEAnchorOutsideBottomLeft RelativeView:viewTop Offset:CGPointZero CGSize:CGSizeMake(scanSpaceW, DefaultScanRect)]];
    UIView *viewRight=[[UIView alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self.viewContainer Anchor:LEAnchorOutsideBottomRight RelativeView:viewTop Offset:CGPointZero CGSize:CGSizeMake( scanSpaceW, DefaultScanRect)]];
    UIView *viewBottom=[[UIView alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self.viewContainer Anchor:LEAnchorInsideBottomCenter Offset:CGPointZero CGSize:CGSizeMake(self.globalVar.ScreenWidth, self.viewContainer.bounds.size.height-scanSpaceH-DefaultScanRect)]];
    [viewTop setBackgroundColor:[UIColor colorWithWhite:0.000 alpha:0.500]];
    [viewLeft setBackgroundColor:[UIColor colorWithWhite:0.000 alpha:0.500]];
    [viewRight setBackgroundColor:[UIColor colorWithWhite:0.000 alpha:0.500]];
    [viewBottom setBackgroundColor:[UIColor colorWithWhite:0.000 alpha:0.500]];
    
    NSString *tip2=@"将框对准二维码";
    curHelper=[LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:viewBottom Anchor:LEAnchorInsideTopCenter Offset:CGPointMake(0, NavigationBarHeight) CGSize:CGSizeMake(self.globalVar.ScreenWidth, scanSpaceH*2/3)] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:tip2 FontSize:12 Font:nil Width:self.globalVar.ScreenWidth-NavigationBarHeight Height:0 Color:ColorWhite Line:0 Alignment:NSTextAlignmentCenter]];
}
-(void) setCurScanHelperString:(NSString *)curScanHelperString{
    [curHelper leSetText:curScanHelperString];
}
-(void) switchScanLine:(BOOL) isON{
    if(isON){
        if(curTimer){
            [curTimer invalidate];
        }
        curTimer=[NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(onScanLineLogic) userInfo:nil repeats:YES];
//        if(self.globalVar.IsStatusBarNotCovered){
            [session startRunning];
//        }else{
//            [curZBarReader start];
//        }
    }else{
        [curTimer invalidate];
//        if(self.globalVar.IsStatusBarNotCovered){
            [session stopRunning];
//        }else{
//            [curZBarReader stop];
//        }
    }
}
//scan line
-(void) onScanLineLogic {
    curLineOffset+=(isLineUp?-2:2);
    if(curLineOffset<10){
        isLineUp=NO;
    }else if(curLineOffset>DefaultScanRect-15){
        isLineUp=YES;
    }
    [scanLine setFrame:CGRectMake(0, curLineOffset, DefaultScanRect, scanLine.bounds.size.height)];
}
 
//
-(void) showScanView{
    [self switchScanLine:YES];
//    if(self.globalVar.IsStatusBarNotCovered){
        [session stopRunning];
        device=nil;
        input=nil;
        output=nil;
        [preview removeFromSuperlayer];
        preview=nil;
        session=nil;
        device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        if(input){
            output = [[AVCaptureMetadataOutput alloc]init];
            [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
            session = [[AVCaptureSession alloc]init];
            [session setSessionPreset:AVCaptureSessionPresetHigh];
            if ([session canAddInput:input]) {
                [session addInput:input];
            }
            if ([session canAddOutput:output]) {
                [session addOutput:output];
            }
            output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
            // Preview
            preview =[AVCaptureVideoPreviewLayer layerWithSession:session];
            preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
            preview.frame =self.viewContainer.bounds;
            [self.viewContainer.layer insertSublayer: preview atIndex:0];
            [session startRunning];
        }
//    }else{
//        [curZBarReader start];
//        [curZBarReader flushCache];
//    }
}

@end
