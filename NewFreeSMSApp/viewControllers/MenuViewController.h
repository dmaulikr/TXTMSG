//
//  MenuViewController.h
//  FreeSMS
//
//  Created by Rajan Balana on 01/10/12.
//  Copyright (c) 2012 Rajan Balana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SentSMSViewController.h"
#import "SendSMSViewController.h"
#import "FreeSMSAppDelegate.h"
#import "TemplatesViewController.h"
#import "SettingsViewController.h"
#import "MWFSlideNavigationViewController.h"
#import "HelpViewController.h"

@class SentSMSViewController,SendSMSViewController,DashboardViewController,TemplatesViewController,SettingsViewController;

@interface MenuViewController : UIViewController <UIAlertViewDelegate,MWFSlideNavigationViewControllerDelegate, MWFSlideNavigationViewControllerDataSource>
{
    SentSMSViewController *sentSMSview;
    SendSMSViewController *sendSMS;
    DashboardViewController *viewController;
    TemplatesViewController *templatesController;
    SettingsViewController *settingsController;
    HelpViewController *helpController;
    IBOutlet UILabel *username;
}

@property (nonatomic, strong) NSString *usernameReceived;
@property (nonatomic, strong) NSString *passwordReceived;
@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;
-(IBAction)composeSMSClicked;
-(IBAction)sentSMSClicked;
-(IBAction)templatesClicked;
-(IBAction)settingsClicked;
@end
