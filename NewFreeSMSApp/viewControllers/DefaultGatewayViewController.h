//
//  DefaultGatewayViewController.h
//  FreeSMS
//
//  Created by Rajan Balana on 20/10/12.
//  Copyright (c) 2012 Rajan Balana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DefaultGatewayViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSString *defaultAccountName;
}

@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (retain, nonatomic) NSMutableArray *userAccounts;
@property (retain, nonatomic) IBOutlet UITableView *defaultGatewayTable;
@end
