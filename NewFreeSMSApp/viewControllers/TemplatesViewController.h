//
//  TemplatesViewController.h
//  FreeSMS
//
//  Created by Rajan Balana on 11/10/12.
//  Copyright (c) 2012 Rajan Balana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddNewTemplateViewController.h"
#import "SendSMSViewController.h"
@class SendSMSViewController,AddNewTemplateViewController;
@interface TemplatesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    AddNewTemplateViewController *addTemplateView;
    SendSMSViewController *sendSMS;
}
@property (nonatomic, retain) NSManagedObjectContext *context;
@property (nonatomic, retain) NSMutableArray *fetchedTemplates;
@property (nonatomic, retain) UILabel *noResultsLabel;
@property (nonatomic, retain) IBOutlet UITableView *templates;
-(void)addTemplateClicked;
@end
