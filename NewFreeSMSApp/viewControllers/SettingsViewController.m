//
//  SettingsViewController.m
//  FreeSMS
//
//  Created by Rajan Balana on 16/10/12.
//  Copyright (c) 2012 Rajan Balana. All rights reserved.
//

#import "SettingsViewController.h"
#import "FreeSMSAppDelegate.h"
#import "UserAccountsViewController.h"
#import "DefaultGatewayViewController.h"
#import "FreeSMSGlobals.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize settingsTable,managedObjectContext,userAccounts;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (managedObjectContext == nil)
    {
        managedObjectContext = [(FreeSMSAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grey.png"]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];

    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    label.text = NSLocalizedString(@"Configuration", @"");
    [label sizeToFit];
    self.settingsTable.backgroundView = imageView;
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton addTarget:self action:@selector(cancelTapped:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.frame = CGRectMake(5.0f, 5.0f, 60.0f, 30.0f);
    [cancelButton setBackgroundColor:[UIColor clearColor]];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"cancelButton.png"] forState:UIControlStateNormal];
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
    self.navigationItem.hidesBackButton = YES;
    NSError *_fetcherror;
    NSFetchRequest *_request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SentSMS" inManagedObjectContext:self.managedObjectContext];
    _request.entity = entity;
    NSMutableArray *fetchedSentSMSes = [[NSMutableArray alloc] initWithArray:[self.managedObjectContext executeFetchRequest:_request error:&_fetcherror]];
    [FreeSMSGlobals sharedFreeSMSGlobals].totalSMSesCount = [fetchedSentSMSes count];
    
}
-(void)cancelTapped:(id)sender
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}
-(void)saveTapped:(id)sender
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.0f/255.0f green:115.0f/255.0f blue:209.0f/255.0f alpha:0.0f]];
    [settingsTable reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        if (managedObjectContext == nil)
        {
            managedObjectContext = [(FreeSMSAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        }
        NSError *_fetcherror;
        NSFetchRequest *_request = [[NSFetchRequest alloc] init];
        [_request setEntity:[NSEntityDescription entityForName:@"UserAccounts" inManagedObjectContext:self.managedObjectContext]];
        userAccounts = [[self.managedObjectContext executeFetchRequest:_request error:&_fetcherror] mutableCopy];
        if(userAccounts.count == 0)
        {
            return 1;
        }
        else
        {
            return 3;
        }
    }
    else
    {
        return 1;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            cell.textLabel.text = @"Setup SMS Gateways";
            cell.imageView.image = [UIImage imageNamed:@"configurationicon.png"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if(indexPath.row == 1)
        {
            cell.textLabel.text = @"Select Default Gateway";
            cell.imageView.image = [UIImage imageNamed:@"defaulticon.png"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if(indexPath.row == 2)
        {
            cell.textLabel.text = @"User Accounts";
            cell.imageView.image = [UIImage imageNamed:@"useraccounts.png"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    else if(indexPath.section == 1)
    {
        if(indexPath.row ==0)
        {
            cell.textLabel.text = @"Report a Bug/Suggest a Feature";
            cell.imageView.image = [UIImage imageNamed:@"bugicon.png"];            
        }
    }
    else if(indexPath.section == 2)
    {
        if(indexPath.row == 0)
        {
            cell.textLabel.text = [NSString stringWithFormat:@"SMS Count: %d",[FreeSMSGlobals sharedFreeSMSGlobals].totalSMSesCount];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.imageView.image = [UIImage imageNamed:@"messagesicon.png"];             
            cell.userInteractionEnabled = NO;
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                SMSGatewaysView = [[SMSGatewaysViewController alloc] initWithNibName:@"SMSGatewaysViewController" bundle:nil];
            }
            else
            {
                SMSGatewaysView = [[SMSGatewaysViewController alloc] initWithNibName:@"SMSGatewaysViewController~iPad" bundle:nil];
            }
            [self.navigationController pushViewController:SMSGatewaysView animated:YES];
        }
        else if(indexPath.row == 1)
        {
            DefaultGatewayViewController *defaultGatewayView;
            if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                defaultGatewayView = [[DefaultGatewayViewController alloc] initWithNibName:@"DefaultGatewayViewController" bundle:nil];
            }
            else
            {
                defaultGatewayView = [[DefaultGatewayViewController alloc] initWithNibName:@"DefaultGatewayViewController~iPad" bundle:nil];
            }
            [self.navigationController pushViewController:defaultGatewayView animated:YES];
        }
        else if (indexPath.row == 2)
        {
            UserAccountsViewController *userAccountsView;
            if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                userAccountsView = [[UserAccountsViewController alloc] initWithNibName:@"UserAccountsViewController" bundle:nil];
            }
            else
            {
                userAccountsView = [[UserAccountsViewController alloc] initWithNibName:@"UserAccountsViewController~iPad" bundle:nil];
            }
            [self.navigationController pushViewController:userAccountsView animated:YES];
        }
    }
    else if (indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {
            [self bugReportButtonTapped];
        }
    }
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return @"Free SMS Gateways";
    }
    else if(section == 1)
    {
        return @"Contact Developer";
    }
    else if(section ==2)
    {
        return @"SMS Counter";
    }
    else if(section == 3)
    {
        return @"App Details";
    }
return 0;
}
-(IBAction)bugReportButtonTapped
{
    NSArray *toRecipents = [NSArray arrayWithObject:@"rajan@codeoi.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:@"Bug/Feature Report to TXTMSG Team"];
    //[mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
}
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
