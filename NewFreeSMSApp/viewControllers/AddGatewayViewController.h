//
//  AddGatewayViewController.h
//  FreeSMS
//
//  Created by Rajan Balana on 18/10/12.
//  Copyright (c) 2012 Rajan Balana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthenticationCheck.h"
#import "MBProgressHUD.h"

@interface AddGatewayViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate,AuthenticationDelegate,MBProgressHUDDelegate>
{
    UITextField *usernameField;
    UITextField *passwordField;
    UITextField *accountNameField;
    MBProgressHUD *HUD;
}
@property (nonatomic, retain) NSString *gateway;
@property (nonatomic, retain) UITextField *usernameField;
@property (nonatomic, retain) UITextField *passwordField;
@property (nonatomic, retain) UITextField *accountNameField;
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong , nonatomic) IBOutlet UITableView *addGatewayTable;

@end
