//
//  Templates.m
//  FreeSMS
//
//  Created by Rajan Balana on 11/10/12.
//  Copyright (c) 2012 Rajan Balana. All rights reserved.
//

#import "Templates.h"


@implementation Templates

@dynamic content;
+ (Templates *) createtemplatedata:(NSManagedObjectContext *)a_template
                  withcontent:(NSString *)a_content
{
    Templates *_Templates;
    NSError *_savingError = nil;
    if(_Templates == nil) {
        //Couldn't create the data base entry
    }
    _Templates.content = a_content;
    if( [a_template save:&_savingError] )
    {
        //Saved the new entry
        NSLog(@"Saved Template") ;
        return _Templates;
    } else
    {
        //Saved failed
        NSLog(@"Unable to Save Template");
        return nil;
    }
    
}

@end
