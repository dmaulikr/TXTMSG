//
//  FreeSMSAppDelegate.h
//  NewFreeSMSApp
//
//  Created by Rajan Balana on 13/09/12.
//  Copyright (c) 2012 Rajan Balana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@class DashboardViewController;

@interface FreeSMSAppDelegate : UIResponder <UIApplicationDelegate>
{

}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) NSMutableArray *people;
@property (nonatomic, retain) NSMutableArray *peopleFiltered;
@property (nonatomic, strong) NSMutableArray *IDsArray;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end
