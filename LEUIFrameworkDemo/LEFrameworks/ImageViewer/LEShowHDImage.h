//
//  LEShowHDImage.h
//  ticket
//
//  Created by Larry Emerson on 14-8-14.
//  Copyright (c) 2014年 360CBS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PZPhotoView.h"

@interface LEShowHDImage : UIView<UIScrollViewDelegate,PZPhotoViewDelegate>
- (id)initWithUrl:(NSString *) url AndAspect:(float) aspect;
@end
