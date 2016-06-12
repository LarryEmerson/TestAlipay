//
//  LEConnections.h
//  four23book_client_borrower_ios
//
//  Created by Larry Emerson on 15/9/17.
//  Copyright (c) 2015年 LarryEmerson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEMainViewController.h"

#define LEConnectionResponseJasonParseError 1000
#define LEConnectionRequestFailedError 2000


@interface NSString(JSONCategories)
-(id)JSONValue;
@end
@interface NSObject (JSONCategories)
-(NSString*)JSONString;
@end
    
    
@class LEConnectionsResponseObject;
@class LEConnectionRequestObject;
@protocol LEConnectionDelegate <NSObject>
-(void) request:(LEConnectionRequestObject *) request ResponedWith:(LEConnectionsResponseObject *) response ;
@end

@interface LEConnectionsResponseObject : NSObject
@property (nonatomic) int error;
@property (nonatomic) NSString *errormsg;
@property (nonatomic) id result;
-(id) initWithResponse:(id) response;
-(id) initForJsonParseError;
-(id) initForRequestFailure;
-(id) initWithHtmlData:(id) data;
@end

@interface LEConnectionRequestObject : NSObject
- (id) initRequestWithURL:(NSString *)url parameters:(NSDictionary *)parameter Delegate:(id<LEConnectionDelegate>) delegate;
@end
@interface LEConnections : NSObject
+(LEConnections *) instance;
-(LEConnectionRequestObject *) requestWithURL:(NSString *)url parameters:(NSDictionary *)parameter Delegate:(id<LEConnectionDelegate>) delegate;
@end
