//
//  MessageSending.h
//  FreeSMS
//
//  Created by Rajan Balana on 25/09/12.
//  Copyright (c) 2012 Rajan Balana. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ProgressDelegate
@optional
-(void)messageSentSuccessfuly:(int)SMSCount;
-(void)messageFailed:(int)SMSCount;

@end

@class DashboardViewController;

@interface MessageSending : NSObject
{
    NSMutableURLRequest     *  urlrequest;
    NSURLConnection  *  urlconnection;
    NSMutableData    *  responseData;
    NSString         *  theAML;
    NSString         *registrationStatus;
    UIAlertView *_alert;
    UIActivityIndicatorView *indicator;
    DashboardViewController *viewController;
    id <ProgressDelegate> delegate;
}

@property (nonatomic, retain) NSManagedObjectContext *context;
@property (nonatomic, retain) id <ProgressDelegate> delegate;

-(void)processMessage:(int)messageNumber;
-(void)resultAnalysis;
-(void)createSentSMSEntryinDatabase:(int)SMSCount;
-(void)createPostRequestForDateValidity:(NSString *) urlString request:(NSString *)requestString;

@end
