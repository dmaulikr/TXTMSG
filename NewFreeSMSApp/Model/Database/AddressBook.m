//
//  AddressBook.m
//  FreeSMS
//
//  Created by Rajan Balana on 29/12/12.
//  Copyright (c) 2012 Rajan Balana. All rights reserved.
//

#import "AddressBook.h"


@implementation AddressBook

@dynamic addressbook;


+ (AddressBook *) addAddressBook:(NSManagedObjectContext *)a_context: (NSKeyedArchiver *)a_addressBook;
{
    AddressBook *_addressBook;
    NSError *_savingError = nil;
    if(_addressBook == nil) {
        //Couldn't create the data base entry
    }
    _addressBook.addressbook = a_addressBook;
    if( [a_context save:&_savingError] )
    {
        //Saved the new entry
        NSLog(@"Saved addressBook") ;
        return _addressBook;
    } else
    {
        //Saved failed
        NSLog(@"Unable to Save Addressbook");
        return nil;
    }
    
}
@end
