//
//  Login.h
//  FreeSMS
//
//  Created by Rajan Balana on 30/09/12.
//  Copyright (c) 2012 Rajan Balana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Login : NSManagedObject

@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * password;

+ (Login *) createregisterdata:(NSManagedObjectContext *)a_register
                  withUserName:(NSString *)a_username
                  withPassword:(NSString *)a_password;

@end
