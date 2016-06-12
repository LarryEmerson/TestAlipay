//
//  LEImageCache.m
//  LEFrameworks
//
//  Created by Larry Emerson on 15/8/26.
//  Copyright (c) 2015年 LarryEmerson. All rights reserved.
//

#import "LEImageCache.h"

@implementation LEImageCache
static NSMutableDictionary *cachedImageLib;
static LEImageCache *curImageCache = nil;
+ (LEImageCache *) instance {
    @synchronized(self) {
        if (curImageCache == nil) {
            curImageCache = [[self alloc] init];
            cachedImageLib=[[NSMutableDictionary alloc] init];
        }
    } return curImageCache;
}
-(void) addImage:(UIImage *) image ForKey:(NSString *) key{
    [cachedImageLib setObject:image forKey:key];
}
-(NSMutableDictionary *) getHDImageCache{
    return cachedImageLib;
}
@end
