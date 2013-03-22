//
//  Templates.h
//  FreeSMS
//
//  Created by Rajan Balana on 11/10/12.
//  Copyright (c) 2012 Rajan Balana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Templates : NSManagedObject

@property (nonatomic, retain) NSString *content;
+ (Templates *) createtemplatedata:(NSManagedObjectContext *)a_template
                       withcontent:(NSString *)a_content;
@end
