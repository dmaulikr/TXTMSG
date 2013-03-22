//
//  MessageSending.m
//  FreeSMS
//
//  Created by Rajan Balana on 25/09/12.
//  Copyright (c) 2012 Rajan Balana. All rights reserved.
//

#import "MessageSending.h"
#import "FreeSMSAppDelegate.h"
#import "SentSMS.h"
#import "FreeSMSGlobals.h"
#import "MessageBean.h"
#import "JSON.h"
#import "Utils.h"

@implementation MessageSending

@synthesize context,delegate;

-(void)resultAnalysis
{
    NSArray *data = [theAML JSONValue];
    MessageBean *one = [[FreeSMSGlobals sharedFreeSMSGlobals].messageQueue objectAtIndex:[FreeSMSGlobals sharedFreeSMSGlobals].messageBeingProcessed];
    if(data == nil)
    {
        one.messageStatus = @"NO";
        [delegate messageFailed:[FreeSMSGlobals sharedFreeSMSGlobals].messageBeingProcessed];
    }
    else if([data count] != 1)
    {
        NSString *newstring = [NSString string];
        NSString *completeStatus = [NSString string];
        BOOL allMessagesSent = YES;
        for(id obj in data)
        {
            if([[obj valueForKey:@"status"] isEqualToString:@"1"])
            {
                completeStatus = [NSString stringWithFormat:@"Message Sent to : %@",[obj valueForKey:@"number"]];
            }
            else
            {
                allMessagesSent = NO;
                completeStatus = [NSString stringWithFormat:@"Message Not Sent to : %@",[obj valueForKey:@"number"]];
            }
            newstring = [Utils append:completeStatus,@"\n",newstring,nil];
        }
        if(allMessagesSent)
        {
            [self createSentSMSEntryinDatabase:[FreeSMSGlobals sharedFreeSMSGlobals].messageBeingProcessed];
            one.messageStatus = @"YES";
        }
        else
        {
            one.messageStatus = newstring;
        }
        [delegate messageSentSuccessfuly:[FreeSMSGlobals sharedFreeSMSGlobals].messageBeingProcessed];
    }
    else
    {
        id singleObject = [data objectAtIndex:0];
        if([[singleObject valueForKey:@"status"] isEqualToString:@"1"])
        {
            one.messageStatus = @"YES";
            [self createSentSMSEntryinDatabase:[FreeSMSGlobals sharedFreeSMSGlobals].messageBeingProcessed];
            [delegate messageSentSuccessfuly:[FreeSMSGlobals sharedFreeSMSGlobals].messageBeingProcessed];
        }
        else
        {
            one.messageStatus = @"NO";
            [delegate messageFailed:[FreeSMSGlobals sharedFreeSMSGlobals].messageBeingProcessed];
        }
    }
}
-(void)processMessage:(int)messageNumber
{
    [FreeSMSGlobals sharedFreeSMSGlobals].messageBeingProcessed = messageNumber;
    NSString *loginUrl,*requestString;
    if([[FreeSMSGlobals sharedFreeSMSGlobals].messageQueue count]!=0)
    {
        MessageBean *one = [[FreeSMSGlobals sharedFreeSMSGlobals].messageQueue objectAtIndex:messageNumber];
        requestString = [NSString stringWithFormat:@"usr=%@&pwd=%@&site=%@&to=%@&mes=%@&randomstring=1",[one sentFrom],[one password],[one gatewayUsed],[one sentTo],[one message]];
            if([[one gatewayUsed] isEqualToString:@"Way2SMS"])
            {
                loginUrl = @"http://www.codeoi.com/smsapis/newgateway/smsapi.php";
            }
            else if([[one gatewayUsed] isEqualToString:@"160by2"])
            {
                loginUrl = @"http://www.codeoi.com/smsapis/newgateway/smsapi.php";
            }
            else if ([[one gatewayUsed] isEqualToString:@"FullOnSMS"])
            {
                loginUrl = @"http://www.codeoi.com/smsapis/newgateway/smsapi.php";
            }
            else if ([[one gatewayUsed]isEqualToString:@"Site2SMS"])
            {
                loginUrl = @"http://www.codeoi.com/smsapis/newgateway/smsapi.php";
            }
        }
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
    MessageBean *one = [[FreeSMSGlobals sharedFreeSMSGlobals].messageQueue objectAtIndex:[FreeSMSGlobals sharedFreeSMSGlobals].messageBeingProcessed];
        one.messageStatus = @"NO";
            [delegate messageFailed:[FreeSMSGlobals sharedFreeSMSGlobals].messageBeingProcessed];
	}
	else
    {
        NSLog(@"success");
        responseData = [NSMutableData alloc];
    }
}
-(void)createSentSMSEntryinDatabase:(int)SMSCount
{
    context = [(FreeSMSAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    MessageBean *one = [[FreeSMSGlobals sharedFreeSMSGlobals].messageQueue objectAtIndex:SMSCount];
    NSError *_savingError;
    SentSMS *SentSMS = [NSEntityDescription insertNewObjectForEntityForName:@"SentSMS" inManagedObjectContext:context];
    NSDate *date = [NSDate date];
    //NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //[formatter setDateFormat:@"dd-MMM-yyyy hh:mm:ssa"];
    double sentd = [date timeIntervalSince1970];
    SentSMS.sentfrom = [one sentFrom];
    SentSMS.recipient = [one sentTo];
    SentSMS.sentdate = sentd;
    SentSMS.message = [one message];
    [context save:&_savingError];
    if(_savingError)
    {
        NSLog(@"Something went wrong while saving sent sms to database");
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
    MessageBean *one = [[FreeSMSGlobals sharedFreeSMSGlobals].messageQueue objectAtIndex:[FreeSMSGlobals sharedFreeSMSGlobals].messageBeingProcessed];
    one.messageStatus = @"NO";
    [delegate messageFailed:[FreeSMSGlobals sharedFreeSMSGlobals].messageBeingProcessed];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	theAML = [[NSString alloc] initWithBytes: [responseData mutableBytes] length:[responseData length] encoding:NSISO2022JPStringEncoding];
    NSLog(@"The AML is :%@", theAML);
    [self resultAnalysis];
}

@end