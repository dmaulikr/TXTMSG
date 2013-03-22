//
//  SMSGatewaysViewController.h
//  FreeSMS
//
//  Created by Rajan Balana on 16/10/12.
//  Copyright (c) 2012 Rajan Balana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMSGatewaysViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, retain) IBOutlet UITableView *SMSGatewaysTable;

@end
