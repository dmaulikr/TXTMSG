//
//  Login.m
//  FreeSMS
//
//  Created by Rajan Balana on 30/09/12.
//  Copyright (c) 2012 Rajan Balana. All rights reserved.
//

#import "Login.h"


@implementation Login

@dynamic username;
@dynamic password;

+ (Login *) createregisterdata:(NSManagedObjectContext *)a_register
                         withUserName:(NSString *)a_username
                         withPassword:(NSString *)a_password
{
    Login *_Login;
    NSError *_savingError = nil;
    if(_Login == nil) {
    //Couldn't create the data base entry
    }
    _Login.username = a_username;
    _Login.password = a_password;
    if( [a_register save:&_savingError] )
    {
        //Saved the new entry
        NSLog(@"Saved Login Information") ;
        return _Login;
    } else
    {
        //Saved failed
        NSLog(@"Unable to Save Login Information");
        return nil;
    }
    
}
@end
