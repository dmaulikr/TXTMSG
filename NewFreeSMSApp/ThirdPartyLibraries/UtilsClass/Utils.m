//
//  Utils.m
//  FreeSMS
//
//  Created by Rajan Balana on 25/09/12.
//  Copyright (c) 2012 Rajan Balana. All rights reserved.
//

#import "Utils.h"
#import "Reachability.h"

@implementation Utils

+(void) showAlert:(NSString *) title:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
+(NSString *) append:(id)first, ...
{
    NSString *result = @"";
    id eachArg;
    va_list alist;
    if(first)
    {
        result = [result stringByAppendingString:first];
        va_start(alist, first);
        while ((eachArg = va_arg(alist,id)))
        result=[result stringByAppendingString:eachArg];
        va_end(alist);
    }
    return result;
}
+ (BOOL)hasInternetConnection
{
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        return NO;
    } else {
        return YES;
    }
}
@end
