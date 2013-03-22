//
//  UserAccounts.h
//  FreeSMS
//
//  Created by Rajan Balana on 18/10/12.
//  Copyright (c) 2012 Rajan Balana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserAccounts : NSManagedObject

@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * accounttype;
@property (nonatomic, retain) NSString * accountname;
+ (UserAccounts *) createuseraccount:(NSManagedObjectContext *)a_useraccount
                        withusername:(NSString *)a_username
                        withpassword:(NSString *)a_password
                     withaccounttype:(NSString *)a_accounttype
                     withaccountname:(NSString *)a_accountname;
@end
