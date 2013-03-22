//
//  Utils.h
//  FreeSMS
//
//  Created by Rajan Balana on 25/09/12.
//  Copyright (c) 2012 Rajan Balana. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject


+(NSString *) append:(id)first,...;
+(void) showAlert:(NSString *) title:(NSString *)message;
+ (BOOL)hasInternetConnection;
@end
