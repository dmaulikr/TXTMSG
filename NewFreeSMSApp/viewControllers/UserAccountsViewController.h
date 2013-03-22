//
//  UserAccountsViewController.h
//  FreeSMS
//
//  Created by Rajan Balana on 19/10/12.
//  Copyright (c) 2012 Rajan Balana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserAccountsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    UILabel *noResultsLabel;
    NSString *defaultAccountName;
}
@property (nonatomic, strong) IBOutlet UITableView *userAccountsTable;
@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (retain, nonatomic) NSMutableArray *userAccounts;
@end
