//
//  FreeSMSAppDelegate.m
//  NewFreeSMSApp
//
//  Created by Rajan Balana on 13/09/12.
//  Copyright (c) 2012 Rajan Balana. All rights reserved.
//

#import "FreeSMSAppDelegate.h"
#import "MenuViewController.h"
#import "SendSMSViewController.h"
#import "TemplatesViewController.h"
#import "FreeSMSGlobals.h"
#import "AddressBook.h"

@implementation FreeSMSAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize people,peopleFiltered,IDsArray;

NSDate *locationDate = nil;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    /* UIImage *starImage1 = [UIImage imageNamed:@"Compose-64.png"];
     UIImage *starImage2 = [UIImage imageNamed:@"sentmessageicon.png"];
     UIImage *starImage3 = [UIImage imageNamed:@"template.png"];
     AwesomeMenuItem *starMenuItem1 = [[AwesomeMenuItem alloc] initWithImage:starImage1
     highlightedImage:starImage1
     ContentImage:starImage1
     highlightedContentImage:nil];
     AwesomeMenuItem *starMenuItem2 = [[AwesomeMenuItem alloc] initWithImage:starImage2
     highlightedImage:starImage2
     ContentImage:starImage2
     highlightedContentImage:nil];
     AwesomeMenuItem *starMenuItem3 = [[AwesomeMenuItem alloc] initWithImage:starImage3
     highlightedImage:starImage3
     ContentImage:starImage3
     highlightedContentImage:nil];
     NSArray *menus = [NSArray arrayWithObjects:starMenuItem1, starMenuItem2, starMenuItem3, nil];*/
    //[self performSelectorOnMainThread:@selector(loadContacts) withObject:nil waitUntilDone:YES];
    [FreeSMSGlobals sharedFreeSMSGlobals].contactsFiltered = [[NSMutableArray alloc] init];
    [self performSelectorInBackground:@selector(loadContacts) withObject:nil];
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        //AwesomeMenu *masterViewController = [[AwesomeMenu alloc] initWithNibName:nil bundle:nil];
        //masterViewController.receivedArray = menus;
        //masterViewController.delegate = self;
        MenuViewController *masterViewController = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:nil];
        masterViewController.managedObjectContext = self.managedObjectContext;
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
        MWFSlideNavigationViewController * slideNavCtl = [[MWFSlideNavigationViewController alloc] initWithRootViewController:self.navigationController];
        //        slideNavCtl.panEnabled = YES;
        self.window.rootViewController = slideNavCtl;
    }
    else
    {
        MenuViewController *masterViewController = [[MenuViewController alloc] initWithNibName:@"MenuViewController~iPad" bundle:nil];
        masterViewController.managedObjectContext = self.managedObjectContext;
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
        MWFSlideNavigationViewController * slideNavCtl = [[MWFSlideNavigationViewController alloc] initWithRootViewController:self.navigationController];
        self.window.rootViewController = slideNavCtl;
    }
    [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:43.0f/255.0f green:140.0f/255.0f blue:191.0f/255.0f alpha:1.0f]];
    [self.window makeKeyAndVisible];
    return YES;
}
-(BOOL)isABAddressBookCreateWithOptionsAvailable {
    return &ABAddressBookCreateWithOptions != NULL;
}

-(void)loadContacts
{
    if ([self isABAddressBookCreateWithOptionsAvailable]) {
        CFErrorRef error = nil;
        [FreeSMSGlobals sharedFreeSMSGlobals].addressBook = ABAddressBookCreateWithOptions(NULL,&error);
        ABAddressBookRequestAccessWithCompletion([FreeSMSGlobals sharedFreeSMSGlobals].addressBook, ^(bool granted, CFErrorRef error) {
            // callback can occur in background, address book must be accessed on thread it was created on
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    NSLog(@"Error Occured while accessing Addressbook");
                } else if (!granted) {
                    NSLog(@"Access Denied for accessing Addressbook");
                } else {
                    // access granted
                    NSLog(@"Acess Granted for Addressbook");
                    ABAddressBookRegisterExternalChangeCallback([FreeSMSGlobals sharedFreeSMSGlobals].addressBook, addressBookChanged, (__bridge_retained  void *)self);
                    self.people = (__bridge_transfer NSMutableArray *)ABAddressBookCopyArrayOfAllPeople([FreeSMSGlobals sharedFreeSMSGlobals].addressBook);
                    NSError *_fetcherror;
                    NSFetchRequest *_request = [[NSFetchRequest alloc] init];
                    [_request setEntity:[NSEntityDescription entityForName:@"AddressBook" inManagedObjectContext:self.managedObjectContext]];
                    NSMutableArray *addressBookRecord = [[self.managedObjectContext executeFetchRequest:_request error:&_fetcherror] mutableCopy];
                    if(addressBookRecord.count == 0)
                    {
                        [self filterAdressBookArray];
                    }
                    else
                    {
                        NSManagedObject *obj = [addressBookRecord objectAtIndex:0];
                        NSData *data = [obj valueForKey:@"addressbook"];
                        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                        [FreeSMSGlobals sharedFreeSMSGlobals].contactsFiltered = arr;
                    }
                }
            });
        });
    } else {
        // iOS 4/5
        [FreeSMSGlobals sharedFreeSMSGlobals].addressBook = ABAddressBookCreate();
    }
}
void addressBookChanged(ABAddressBookRef ab, CFDictionaryRef info, void *context)
{
    NSDate * date = [NSDate date];
    if(locationDate == nil)
    {
        locationDate = [NSDate date];
    }
    
    NSTimeInterval differenceBetweenDates = [date timeIntervalSinceDate:locationDate];
    if(differenceBetweenDates<120)
    {
        locationDate = [NSDate date];
        return;
    }
    locationDate = [NSDate date];
    NSLog(@"ADDRESSBOOK CHANGED");
    NSMutableArray *tempIDs = [[NSMutableArray alloc] init];
    NSMutableArray *temp = (__bridge_transfer NSMutableArray *)ABAddressBookCopyArrayOfAllPeople([FreeSMSGlobals sharedFreeSMSGlobals].addressBook);
    for (id record in temp)
    {
        ABRecordRef person = (__bridge ABRecordRef)record;
        ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,kABPersonPhoneProperty);
        NSArray *phoneNos = (__bridge NSArray *)(ABMultiValueCopyArrayOfAllValues(phoneNumbers));
        if (phoneNos != nil)
        {
            ABRecordID a = ABRecordGetRecordID(person);
            [tempIDs addObject:[NSNumber numberWithInt:a]];
        }
        CFRelease(phoneNumbers);
    }
    NSLog(@"Contacts Filtered");
    [FreeSMSGlobals sharedFreeSMSGlobals].contactsFiltered = tempIDs;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tempIDs];
    NSManagedObjectContext *context1 = [(FreeSMSAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSError *_fetcherror;
    NSFetchRequest *_request = [[NSFetchRequest alloc] init];
    [_request setEntity:[NSEntityDescription entityForName:@"AddressBook" inManagedObjectContext:context1]];
    NSMutableArray *addressBookRecord = [[context1 executeFetchRequest:_request error:&_fetcherror] mutableCopy];
    NSError *_savingError;
    if(addressBookRecord.count == 0)
    {
        AddressBook *addressBook = [NSEntityDescription insertNewObjectForEntityForName:@"AddressBook" inManagedObjectContext:context1];
        addressBook.addressbook = data;
    }
    else
    {
        AddressBook *obj = [addressBookRecord objectAtIndex:0];
        [obj setValue:data forKey:@"addressbook"];
    }
    [context1 save:&_savingError];
    if(_savingError)
    {
        NSLog(@"Something went wrong while saving addressbook to database");
    }
}
-(void)filterAdressBookArray
{
    peopleFiltered = [[NSMutableArray alloc] init];
    peopleFiltered = [self.people mutableCopy];
    IDsArray = [[NSMutableArray alloc] init];
    for (id record in peopleFiltered)
    {
        ABRecordRef person = (__bridge ABRecordRef)record;
        ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,kABPersonPhoneProperty);
        NSArray *phoneNos = (__bridge NSArray *)(ABMultiValueCopyArrayOfAllValues(phoneNumbers));
        if (phoneNos != nil)
        {
            ABRecordID a = ABRecordGetRecordID(person);
            [self.IDsArray addObject:[NSNumber numberWithInt:a]];
        }
        CFRelease(phoneNumbers);
    }
    NSLog(@"Contacts Filtered");
    [FreeSMSGlobals sharedFreeSMSGlobals].contactsFiltered = self.IDsArray;
    NSLog(@"The idsarray is : %@",IDsArray);
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:IDsArray];
    NSError *_fetcherror;
    NSFetchRequest *_request = [[NSFetchRequest alloc] init];
    [_request setEntity:[NSEntityDescription entityForName:@"AddressBook" inManagedObjectContext:self.managedObjectContext]];
    NSMutableArray *addressBookRecord = [[self.managedObjectContext executeFetchRequest:_request error:&_fetcherror] mutableCopy];
    NSError *_savingError;
    if(addressBookRecord.count == 0)
    {
        AddressBook *addressBook = [NSEntityDescription insertNewObjectForEntityForName:@"AddressBook" inManagedObjectContext:_managedObjectContext];
        addressBook.addressbook = data;
    }
    else
    {
        AddressBook *obj = [addressBookRecord objectAtIndex:0];
        [obj setValue:data forKey:@"addressbook"];
    }
    [_managedObjectContext save:&_savingError];
    if(_savingError)
    {
        NSLog(@"Something went wrong while saving addressbook to database");
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FreeSMSAppDatabase" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"FreeSMSAppDatabase.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
