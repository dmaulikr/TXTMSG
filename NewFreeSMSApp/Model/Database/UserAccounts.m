//
//  UserAccounts.m
//  FreeSMS
//
//  Created by Rajan Balana on 18/10/12.
//  Copyright (c) 2012 Rajan Balana. All rights reserved.
//

#import "UserAccounts.h"


@implementation UserAccounts

@dynamic username;
@dynamic password;
@dynamic accounttype;
@dynamic accountname;

+ (UserAccounts *) createuseraccount:(NSManagedObjectContext *)a_useraccount
                       withusername:(NSString *)a_username
                        withpassword:(NSString *)a_password
                     withaccounttype:(NSString *)a_accounttype
                     withaccountname:(NSString *)a_accountname
{
    UserAccounts *_userAccounts;
    NSError *_savingError = nil;
    if(_userAccounts == nil) {
        //Couldn't create the data base entry
    }
    _userAccounts.username = a_username;
    _userAccounts.password = a_password;
    _userAccounts.accounttype = a_accounttype;
    _userAccounts.accountname = a_accountname;
    if( [a_useraccount save:&_savingError] )
    {
        //Saved the new entry
        NSLog(@"Saved UserAccount") ;
        return _userAccounts;
    } else
    {
        //Saved failed
        NSLog(@"Unable to Save UserAccount");
        return nil;
    }
    
}

@end
