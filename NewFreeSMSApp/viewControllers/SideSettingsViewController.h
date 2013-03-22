//
//  SideSettingsViewController.h
//  FreeSMS
//
//  Created by Rajan Balana on 08/12/12.
//  Copyright (c) 2012 Rajan Balana. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SideSettingsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    NSString *defaultAccountName;
    UIActionSheet *actionSheet;
}

@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (retain, nonatomic) NSMutableArray *userAccounts;
@property (nonatomic, retain) IBOutlet UITableView *sideSettingsTable;

@end
