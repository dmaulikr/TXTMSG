//
//  MessageBean.h
//  FreeSMS
//
//  Created by Rajan Balana on 03/11/12.
//  Copyright (c) 2012 Rajan Balana. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageBean : NSObject
{
    NSString *sentFrom;
    NSString *message;
    NSString *sentDate;
    NSString *gatewayUsed;
    NSString *sentTo;
    NSString *messageStatus;
    NSString *password;
}

@property (nonatomic, retain) NSString *sentFrom;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSString *sentDate;
@property (nonatomic, retain) NSString *gatewayUsed;
@property (nonatomic, retain) NSString *sentTo;
@property (nonatomic, retain) NSString *messageStatus;
@property (nonatomic, retain) NSString *password;

@end
