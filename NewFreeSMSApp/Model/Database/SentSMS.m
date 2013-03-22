//
//  SentSMS.m
//  FreeSMS
//
//  Created by Rajan Balana on 01/10/12.
//  Copyright (c) 2012 Rajan Balana. All rights reserved.
//

#import "SentSMS.h"


@implementation SentSMS

@dynamic recipient;
@dynamic message;
@dynamic sentdate;
@dynamic sentfrom;

+ (SentSMS *) createsentsmsdata:(NSManagedObjectContext *)a_sentsms
                  withrecipient:(NSString *)a_recipient
                  withmessage:(NSString *)a_message
                   withsentdate:(double)a_sentdate
                   withsentfrom:(NSString *)a_sentfrom
{
    SentSMS *_SentSMS;
    NSError *_savingError = nil;
    if(_SentSMS == nil) {
        //Couldn't create the data base entry
    }
    _SentSMS.recipient = a_recipient;
    _SentSMS.message = a_message;
    _SentSMS.sentdate = a_sentdate;
    _SentSMS.sentfrom = a_sentfrom;
    if( [a_sentsms save:&_savingError] )
    {
        //Saved the new entry
        NSLog(@"Saved SentSMS") ;
        return _SentSMS;
    }
    else
    {
        //Saved failed
        NSLog(@"Unable to Save SentSMS");
        return nil;
    }
    
}

@end
