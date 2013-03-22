//
//  AddressBook.h
//  FreeSMS
//
//  Created by Rajan Balana on 29/12/12.
//  Copyright (c) 2012 Rajan Balana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AddressBook : NSManagedObject

@property (nonatomic, retain) id addressbook;


+ (AddressBook *) addAddressBook:(NSManagedObjectContext *)a_context: (NSKeyedArchiver *)a_addressBook;

@end
