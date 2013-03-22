//
//  AuthenticationCheck.h
//  TXTMSG
//
//  Created by Rajan Balana on 12/01/13.
//  Copyright (c) 2013 Rajan Balana. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AuthenticationDelegate
@optional
-(void)authenticatedSuccessfully;
-(void)authenticationFailed;

@end

@interface AuthenticationCheck : NSObject
{
    NSMutableURLRequest     *  urlrequest;
    NSURLConnection  *  urlconnection;
    NSMutableData    *  responseData;
    NSString         *  theAML;
    id <AuthenticationDelegate> delegate;
}

@property (nonatomic, retain) id <AuthenticationDelegate> delegate;

- (void) createPostRequestForDateValidity:(NSString *) urlString request:(NSString *)requestString;
-(void)sendAuthenticationRequestToServer:(NSString *) username:(NSString *)password : (NSString *)gateway;
-(void)resultAnalysis;
@end
