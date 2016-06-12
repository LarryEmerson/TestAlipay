//
//  LocalNotification.h
//  ticket
//
//  Created by Larry Emerson on 14-2-20.
//  Copyright (c) 2014年 360CBS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocalNotification : UIView

-(void) setText:(NSString *) text WithEnterTime:(float) time AndPauseTime:(float) pauseTime ;
@end
