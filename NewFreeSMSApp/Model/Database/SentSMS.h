//
//  SentSMS.h
//  FreeSMS
//
//  Created by Rajan Balana on 01/10/12.
//  Copyright (c) 2012 Rajan Balana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SentSMS : NSManagedObject

@property (nonatomic, retain) NSString * recipient;
@property (nonatomic, retain) NSString * message;
@property (assign) double sentdate;
@property (nonatomic, retain) NSString * sentfrom;
+ (SentSMS *) createsentsmsdata:(NSManagedObjectContext *)a_sentsms
                  withrecipient:(NSString *)a_recipient
                    withmessage:(NSString *)a_message
                   withsentdate:(double)a_sentdate
                   withsentfrom:(NSString *)a_sentfrom;
@end
