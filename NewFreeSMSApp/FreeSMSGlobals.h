//
//  FreeSMSGlobals.h
//  FreeSMS
//
//  Created by Rajan Balana on 28/10/12.
//  Copyright (c) 2012 Rajan Balana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>


@interface FreeSMSGlobals : NSObject
{
    NSManagedObjectContext *mManagedObjectContext;
    NSMutableArray *messageQueue;
}
@property (nonatomic, retain) NSManagedObjectContext *mManagedObjectContext;
@property (nonatomic, retain) NSMutableArray *messageQueue;
@property (nonatomic, retain) NSArray *contactsFiltered;
@property (assign) ABAddressBookRef addressBook;
@property (assign) int messageBeingProcessed;
@property (assign) int totalSMSesCount;

+ (NSManagedObjectContext *) context;
+ (FreeSMSGlobals *) sharedFreeSMSGlobals;
+ (NSString *) getpListPath;
+ (NSMutableDictionary *) getpListData;
+ (void) initializeMessageQueue;
@end
