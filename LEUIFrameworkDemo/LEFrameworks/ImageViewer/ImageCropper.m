//
//  ImageCropper.m
//  Created by http://github.com/iosdeveloper
//

#import "ImageCropper.h"


@implementation ImageCropper{
    LEUIFramework *globalVar;
}

@synthesize scrollView, imageView;
@synthesize delegate;

- (id)initWithImage:(UIImage *)image AvatarOrBackground:(BOOL) isAvatar{
    self = [super init];
    if (self) {
        //        NSLog(@"image size %@",NSStringFromCGSize(image.size));
        globalVar=[LEUIFramework instance];
        [self.view setFrame:CGRectMake(0, 0, globalVar.ScreenWidth, globalVar.ScreenHeight)];
        [self.view setBackgroundColor:[UIColor colorWithRed:0.412 green:0.396 blue:0.409 alpha:1.000]];
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, (globalVar.ScreenHeight-globalVar.ScreenWidth/(isAvatar?1:2)-NavigationBarHeight)/2,globalVar.ScreenWidth,globalVar.ScreenWidth/(isAvatar?1:2))];
        [scrollView setBackgroundColor:[UIColor clearColor]];
        [scrollView setDelegate:self];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        [scrollView setShowsVerticalScrollIndicator:NO];
        [scrollView setMaximumZoomScale:100];
        float smallValue=image.size.width>image.size.height?image.size.height:image.size.width;
        float miniAspect=globalVar.ScreenWidth/ smallValue;
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        [imageView setImage:image];
        [scrollView setContentSize:[imageView frame].size];
        [scrollView setMinimumZoomScale:miniAspect];
        [scrollView setZoomScale:[scrollView minimumZoomScale]];
        [scrollView addSubview:imageView];
        
        [scrollView setMaximumZoomScale:2.5<miniAspect?miniAspect:2.5];
        [scrollView setClipsToBounds:NO];
        
        [[self view] addSubview:scrollView];
        
        UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, globalVar.ScreenHeight-NavigationBarHeight, globalVar.ScreenWidth, NavigationBarHeight)];
        [navigationBar setBarStyle:UIBarStyleBlack];
        [navigationBar setTranslucent:YES];
        
        UINavigationItem *aNavigationItem = [[UINavigationItem alloc] initWithTitle:@""];
        [aNavigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelCropping)]];
        [aNavigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finishCropping)]];
        [navigationBar setItems:[NSArray arrayWithObject:aNavigationItem]];
        [[self view] addSubview:navigationBar];
        UIView *topCover=[[UIView alloc]initWithFrame:CGRectMake(0, 0, globalVar.ScreenWidth, scrollView.frame.origin.y)];
        [topCover setBackgroundColor:ColorMask5];
        [self.view addSubview:topCover];
        UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, scrollView.frame.origin.y+scrollView.bounds.size.height, globalVar.ScreenWidth, navigationBar.frame.origin.y-scrollView.frame.origin.y-scrollView.bounds.size.height)];
        [self.view addSubview:bottomView];
        [bottomView setBackgroundColor:ColorMask5];
    }
    return self;
}

- (void)cancelCropping {
    [delegate imageCropperDidCancel:self];
}
-(UIImage*)captureView{
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size,NO,[[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContextWithOptions(scrollView.bounds.size,NO,[[UIScreen mainScreen] scale]);
    [img drawAtPoint:CGPointMake(0, -scrollView.frame.origin.y)];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


- (void)finishCropping {
    //	float zoomScale = 1.0 / [scrollView zoomScale];
    //	CGRect rect;
    //    rect.size.width = [scrollView bounds].size.width * zoomScale;
    //    rect.size.height = [scrollView bounds].size.height * zoomScale;
    //	rect.origin.x = [scrollView contentOffset].x * zoomScale;
    //	rect.origin.y = [scrollView contentOffset].y * zoomScale;
    
    //    if(rect.origin.x<0){
    //        rect.origin.x=0;
    //    }else if(rect.origin.x+rect.size.width>scrollView.contentSize.width){
    //        rect.origin.x=scrollView.contentSize.width-rect.size.width;
    //    }
    //    if(rect.origin.y<0){
    //        rect.origin.y=0;
    //    }else if(rect.origin.y+rect.size.height>scrollView.contentSize.height){
    //        rect.origin.y=scrollView.contentSize.height-rect.size.height;
    //    }
    //
    //    NSLog(@"zxc %@",NSStringFromCGRect(rect));
    //	CGImageRef cr = CGImageCreateWithImageInRect(imageView.image.CGImage, rect);
    //	UIImage *cropped = [UIImage imageWithCGImage:cr];
    //	CGImageRelease(cr);
    //	[delegate imageCropper:self didFinishCroppingWithImage:[ImageCropper cropImage:imageView.image toRect:rect]];
    //    [delegate imageCropper:self didFinishCroppingWithImage:[self captureView:scrollView frame:scrollView.frame]];
    
    [delegate imageCropper:self didFinishCroppingWithImage:[self captureView]];
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return imageView;
}

@end