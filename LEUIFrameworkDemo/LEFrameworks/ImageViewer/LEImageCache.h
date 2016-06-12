//
//  LEImageCache.h
//  LEFrameworks
//
//  Created by Larry Emerson on 15/8/26.
//  Copyright (c) 2015年 LarryEmerson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface LEImageCache : NSObject
+(LEImageCache *) instance;
-(void) addImage:(UIImage *) image ForKey:(NSString *) key;
-(NSMutableDictionary *) getHDImageCache;
@end
