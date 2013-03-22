//
//  SettingsViewController.h
//  FreeSMS
//
//  Created by Rajan Balana on 16/10/12.
//  Copyright (c) 2012 Rajan Balana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSGatewaysViewController.h"
#import <MessageUI/MessageUI.h>

@class SMSGatewaysViewController;

@interface SettingsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate>
{
    SMSGatewaysViewController *SMSGatewaysView;
}
@property (nonatomic,retain) IBOutlet UITableView *settingsTable;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSMutableArray *userAccounts;
@end
