//
//  AuthenticationCheck.m
//  TXTMSG
//
//  Created by Rajan Balana on 12/01/13.
//  Copyright (c) 2013 Rajan Balana. All rights reserved.
//

#import "AuthenticationCheck.h"

@implementation AuthenticationCheck

@synthesize delegate;

-(void)sendAuthenticationRequestToServer:(NSString *) username:(NSString *)password : (NSString *)gateway
{
    NSString *loginUrl,*requestString;
    requestString = [NSString stringWithFormat:@"usr=%@&pwd=%@&site=%@",username,password,gateway];
    if(![gateway isEqualToString:@"FullOnSMS"])
    loginUrl = @"http://www.codeoi.com/smsapis/newgateway/logincheck.php";
    else
    loginUrl = @"http://www.codeoi.com/smsapis/newgateway/fullonsmslogincheck.php";
    [self createPostRequestForDateValidity:loginUrl request:requestString];
}
- (void) createPostRequestForDateValidity:(NSString *) urlString request:(NSString *)requestString
{
    NSData *postData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    urlrequest = [[NSMutableURLRequest alloc] init];
    [urlrequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]]];
    [urlrequest setHTTPMethod:@"POST"];
    [urlrequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [urlrequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [urlrequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [urlrequest setHTTPBody:postData];
    urlconnection = [[NSURLConnection alloc] initWithRequest:urlrequest delegate:self];
    NSLog(@"%@",urlconnection);
    if (urlconnection == nil)
    {
        NSLog(@"Connection Error");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Couldn't Connect to Server!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [delegate authenticationFailed];
	}
	else
    {
        NSLog(@"success");
        responseData = [NSMutableData alloc];
    }
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog(@"error :%@",error);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Couldn't Connect to Server!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [delegate authenticationFailed];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	theAML = [[NSString alloc] initWithBytes: [responseData mutableBytes] length:[responseData length] encoding:NSISO2022JPStringEncoding];
    NSLog(@"The AML is : %@", theAML);
    [self resultAnalysis];
}
-(void)resultAnalysis
{
    if ([theAML rangeOfString:@"1"].location != NSNotFound)
    {
        [delegate authenticatedSuccessfully];
    }
    else if ([theAML rangeOfString:@"access error"].location != NSNotFound)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Gateway's Server is Down!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [delegate authenticationFailed];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error!" message:@"Wrong Username/Password.\n Try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [delegate authenticationFailed];
    }
}

@end
