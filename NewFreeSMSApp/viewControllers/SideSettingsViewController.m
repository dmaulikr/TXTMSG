//
//  SideSettingsViewController.m
//  FreeSMS
//
//  Created by Rajan Balana on 08/12/12.
//  Copyright (c) 2012 Rajan Balana. All rights reserved.
//

#import "SideSettingsViewController.h"
#import "SettingsViewController.h"
#import "FreeSMSAppDelegate.h"
#import "Utils.h"
#import "FreeSMSGlobals.h"

@interface SideSettingsViewController ()

@end

@implementation SideSettingsViewController
@synthesize sideSettingsTable;
@synthesize managedObjectContext,userAccounts;

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
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    if (managedObjectContext == nil)
    {
        managedObjectContext = [(FreeSMSAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    NSError *_fetcherror;
    NSFetchRequest *_request = [[NSFetchRequest alloc] init];
    [_request setEntity:[NSEntityDescription entityForName:@"UserAccounts" inManagedObjectContext:self.managedObjectContext]];
    userAccounts = [[self.managedObjectContext executeFetchRequest:_request error:&_fetcherror] mutableCopy];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    label.text = NSLocalizedString(@"Settings", @"");
    [label sizeToFit];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.0f/255.0f green:115.0f/255.0f blue:209.0f/255.0f alpha:0.0f]];
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingsButton addTarget:self action:@selector(settingsTapped:) forControlEvents:UIControlEventTouchUpInside];
    settingsButton.frame = CGRectMake(5.0f, 5.0f, 32.0f, 32.0f);
    [settingsButton setBackgroundColor:[UIColor clearColor]];
    [settingsButton setBackgroundImage:[UIImage imageNamed:@"toolsicon.png"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grey.png"]];
    [tempImageView setFrame:self.sideSettingsTable.frame];
    self.sideSettingsTable.backgroundView = tempImageView;
    /*[AddThisSDK setFacebookAuthenticationMode:ATFacebookAuthenticationTypeFBConnect];
    [AddThisSDK setFacebookAPIKey:@"333610690008805"];
    [AddThisSDK setTwitterAuthenticationMode:ATTwitterAuthenticationTypeOAuth];
    [AddThisSDK setTwitterConsumerKey:@"ykarzTQgl3xdp6ZwvpphSg"];
    [AddThisSDK setTwitterConsumerSecret:@"8pJGkKtooHkwzHaV1NHWqKKr8HOkVbCa4UR4SZh0iU"];
    [AddThisSDK setTwitterCallBackURL:@"http://www.careerdesire.com/index.php"];
    [AddThisSDK setAddThisPubId:@""];
    [AddThisSDK setAddThisApplicationId:@""];
    [AddThisSDK setAddThisUserName:@""];*/
}
-(void)settingsTapped:(id)sender
{
    SettingsViewController *viewController;
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        viewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    }
    else
    {
        viewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController~iPad" bundle:nil];
    }
    UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:viewController];
    [self.navigationController presentModalViewController:navBar animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        NSMutableDictionary *data;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"defaultAccount.plist"];
        data = [NSMutableDictionary dictionaryWithContentsOfFile:path];
        defaultAccountName = [data objectForKey:@"defaultAccountName"];
        return userAccounts.count;
    }
    else if (section == 1)
    {
        return 0;
    }
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifer = @"cellIdentifier";
    
    UITableViewCell *cell;
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    if(indexPath.section == 0)
    {
        NSManagedObject *one = [userAccounts objectAtIndex:indexPath.row];
        cell.textLabel.text =  [Utils append:[one valueForKey:@"accountname"],@"  --  ",[one valueForKey:@"username"], nil];
        if([defaultAccountName isEqualToString:[one valueForKey:@"accountname"]])
        {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selectedicon.png"]];
            cell.accessoryView = imageView;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if (indexPath.section == 1)
    {
       // if(indexPath.row == 0)
       // {
        //    cell.textLabel.text = @"Share FreeSMS";
         //   cell.imageView.image = [UIImage imageNamed:@"shareicon.png"];
        //}
       // else if (indexPath.row == 1)
       // {
      //      cell.textLabel.text = @"Praise FreeSMS";
       //     cell.imageView.image = [UIImage imageNamed:@"loveicon.png"];
       // }
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"defaultAccount.plist"];
        NSMutableDictionary *pListData;
        pListData = [NSMutableDictionary dictionaryWithContentsOfFile:path];
        NSManagedObject *one = [userAccounts objectAtIndex:indexPath.row];
        [pListData setValue:[one valueForKey:@"username"] forKey:@"defaultAccountUsername"];
        [pListData setValue:[one valueForKey:@"password"] forKey:@"defaultAccountPassword"];
        [pListData setValue:[one valueForKey:@"accounttype"] forKey:@"defaultAccountType"];
        [pListData setValue:[one valueForKey:@"accountname"] forKey:@"defaultAccountName"];
        [pListData writeToFile:path atomically:YES];
        [tableView reloadData];
    }
    else if (indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {
            actionSheet = [[UIActionSheet alloc] initWithTitle:@"Invite Friends" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Email",@"Twitter",@"Facebook", nil];
            actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
            [actionSheet showInView:self.view];
        }
        else if (indexPath.row == 1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://userpub.itunes.apple.com/WebObjects/MZUserPublishing.woa/wa/addUserReview?id=337064413&type=Purple+Software"]];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
       /* [AddThisSDK shareURL:@"http://www.example.com"
                 withService:@"email"
                       title:@"Check this out"
                 description:@"Lorem ipsum dolor sit amet, consectetuer adipisci"];*/
        
    }
    else if (buttonIndex == 1)
    {
       /* [AddThisSDK shareURL:@"http://www.example.com"
                 withService:@"twitter"
                       title:@"Check this out"
                 description:@"Lorem ipsum dolor sit amet, consectetuer adipisci"];*/
    }
    else if (buttonIndex == 2)
    {
       /* [AddThisSDK shareURL:@"http://www.example.com"
                 withService:@"facebook"
                       title:@"Check this out"
                 description:@"Lorem ipsum dolor sit amet, consectetuer adipisci"];*/
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return @"Your Default Account";
    }
   // else if (section == 1)
   // {
  //      return @"Love FreeSMS?";
   // }
    return 0;
}

@end

