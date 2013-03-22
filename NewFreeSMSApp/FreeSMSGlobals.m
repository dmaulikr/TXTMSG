//
//  FreeSMSGlobals.m
//  FreeSMS
//
//  Created by Rajan Balana on 28/10/12.
//  Copyright (c) 2012 Rajan Balana. All rights reserved.
//

#import "FreeSMSGlobals.h"
#import "SynthesizeSingleton.h"

@implementation FreeSMSGlobals

@synthesize mManagedObjectContext,messageQueue,messageBeingProcessed,contactsFiltered;
@synthesize addressBook;
@synthesize totalSMSesCount;

SYNTHESIZE_SINGLETON_FOR_CLASS(FreeSMSGlobals)

+ (NSManagedObjectContext *) context {
    //return the context
    return [FreeSMSGlobals sharedFreeSMSGlobals].mManagedObjectContext;
}
+ (NSString *) getpListPath
{
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"defaultAccount.plist"]; //3
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"defaultAccount" ofType:@"plist"]; //5
        
        [fileManager copyItemAtPath:bundle toPath: path error:&error]; //6
    }
    return path;
}

+ (NSMutableDictionary *) getpListData
{
    return [NSMutableDictionary dictionaryWithContentsOfFile:[FreeSMSGlobals getpListPath]];
}

+(void)initializeMessageQueue
{
    if([FreeSMSGlobals sharedFreeSMSGlobals].messageQueue == NULL)
    [FreeSMSGlobals sharedFreeSMSGlobals].messageQueue = [[NSMutableArray alloc] init];
}
@end
