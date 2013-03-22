//
//  SentSMSViewController.h
//  FreeSMS
//
//  Created by Rajan Balana on 01/10/12.
//  Copyright (c) 2012 Rajan Balana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendSMSViewController.h"

@class SendSMSViewController,DashboardViewController;

@interface SentSMSViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    SendSMSViewController *sendSMS;
    DashboardViewController *viewController;
    IBOutlet UITableView *sentMessagesTable;
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSMutableArray *fetchedSentSMSes;
@property (nonatomic, retain) IBOutlet UILabel *noResultsLabel;

@end
