//
//  MenuViewController.m
//  FreeSMS
//
//  Created by Rajan Balana on 01/10/12.
//  Copyright (c) 2012 Rajan Balana. All rights reserved.
//

#import "MenuViewController.h"
#import "NSObject+DelayedBlock.h"
#import "SideSettingsViewController.h"
#import "AboutUsViewController.h"
#import "FreeSMSGlobals.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

@synthesize usernameReceived,passwordReceived;
@synthesize managedObjectContext;

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
    
    // Do any additional setup after loading the view from its nib.
}
-(void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    label.text = NSLocalizedString(@"TXTMSG", @"");
    [label sizeToFit];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.0f/255.0f green:115.0f/255.0f blue:209.0f/255.0f alpha:0.0f]];
    
    if(!(self.navigationController.viewControllers.count > 1))
    {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton addTarget:self action:@selector(slideRight:) forControlEvents:UIControlEventTouchUpInside];
        backButton.frame = CGRectMake(5.0f, 5.0f, 30.0f, 25.0f);
        [backButton setBackgroundColor:[UIColor clearColor]];
        [backButton setBackgroundImage:[UIImage imageNamed:@"ButtonMenu 2.png"] forState:UIControlStateNormal];
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = backButtonItem;
        self.navigationItem.hidesBackButton = YES;
    }
    self.slideNavigationViewController.delegate = self;
    self.slideNavigationViewController.dataSource = self;
    UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	[infoButton addTarget:self action:@selector(infoButtonAction) forControlEvents:UIControlEventTouchUpInside];
    infoButton.frame = CGRectMake(self.view.bounds.size.width-30, 0, 32, 32);
	UIBarButtonItem *modalButton = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
	[self.navigationItem setRightBarButtonItem:modalButton animated:YES];
}
-(void)infoButtonAction
{
    AboutUsViewController *view = [[AboutUsViewController alloc]initWithNibName:@"AboutUsViewController" bundle:nil];
    [self.navigationController pushViewController:view animated:YES];
}
- (void) _slide:(MWFSlideDirection)direction
{
    [self.slideNavigationViewController slideWithDirection:direction];
}
- (void) slideRight:(id)sender
{
    [self _slide:MWFSlideDirectionRight];
}
- (void) close:(id)sender {
    [self _slide:MWFSlideDirectionNone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)accountValidationCheck
{
    if (managedObjectContext == nil)
    {
        managedObjectContext = [(FreeSMSAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    NSError *_fetcherror;
    NSFetchRequest *_request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserAccounts" inManagedObjectContext:self.managedObjectContext];
    _request.entity = entity;
    NSDictionary *entityProperties = [entity propertiesByName];
    [_request setResultType:NSDictionaryResultType];
    [_request setPropertiesToFetch:[NSArray arrayWithObject:[entityProperties objectForKey:@"username"]]];
    [_request setReturnsDistinctResults:NO];
    NSMutableArray *userAccounts = [[NSMutableArray alloc]initWithArray:[self.managedObjectContext executeFetchRequest:_request error:&_fetcherror]];
    if(userAccounts.count == 0)
    {
        UIAlertView *setupAccountAlert = [[UIAlertView alloc] initWithTitle:@"Welcome!" message:@"Please setup an account, before using this App!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Setup Account", nil];
        setupAccountAlert.tag = 1;
        [setupAccountAlert show];
    }
    else
    {
        NSMutableDictionary *pListData;
        pListData = [FreeSMSGlobals getpListData];
        NSString *accountName = [pListData valueForKey:@"defaultAccountName"];
        if([accountName isEqualToString:@""])
        {
            UIAlertView *setupAccountAlert = [[UIAlertView alloc] initWithTitle:@"Welcome!" message:@"Please choose a default account, before using this Feature!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            setupAccountAlert.tag = 2;
            [setupAccountAlert show];
        }
        else
        {
            return YES;
        }
    }
        return NO;
}
-(IBAction)composeSMSClicked
{
    if ([self accountValidationCheck])
    {
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            sendSMS = [[SendSMSViewController alloc] initWithNibName:@"SendSMSViewController" bundle:nil];
        }
        else
        {
            sendSMS = [[SendSMSViewController alloc] initWithNibName:@"SendSMSViewController~iPad" bundle:nil];
        }
        [self.navigationController pushViewController:sendSMS animated:YES];
    }
}
-(IBAction)helpButtonTapped:(id)sender
{
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        helpController = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
    }
    else
    {
        helpController = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
    }
    [self.navigationController pushViewController:helpController animated:YES];
}
-(IBAction)sentSMSClicked
{
    if ([self accountValidationCheck])
    {        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                sentSMSview = [[SentSMSViewController alloc] initWithNibName:@"SentSMSViewController" bundle:nil];
            }
            else
            {
                sentSMSview = [[SentSMSViewController alloc] initWithNibName:@"SentSMSViewController~iPad" bundle:nil];
            }
            [self.navigationController pushViewController:sentSMSview animated:YES];
    }

}
-(IBAction)templatesClicked
{
    if ([self accountValidationCheck])
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            templatesController = [[TemplatesViewController alloc] initWithNibName:@"TemplatesViewController" bundle:nil];
        }
        else
        {
            templatesController = [[TemplatesViewController alloc] initWithNibName:@"TemplatesViewController~iPad" bundle:nil];
        }
        [self.navigationController pushViewController:templatesController animated:YES];
    }
}
-(IBAction)settingsClicked
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        settingsController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    }
    else
    {
        settingsController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController~iPad" bundle:nil];
    }
    [self.navigationController pushViewController:settingsController animated:YES];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        if (!(buttonIndex == alertView.cancelButtonIndex))
        {
            if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                settingsController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
                UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:settingsController];
                [self.navigationController presentModalViewController:navBar animated:YES];
            }
            else
            {
                settingsController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController~iPad" bundle:nil];
                UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:settingsController];
                [self.navigationController presentModalViewController:navBar animated:YES];
            }
        }
    }
    else if (alertView.tag == 2)
    {
        [self _slide:MWFSlideDirectionRight];
    }
}

#pragma mark - MWFSlideNavigationViewControllerDelegate

#define VIEWTAG_OVERLAY 1100

- (void) slideNavigationViewController:(MWFSlideNavigationViewController *)controller willPerformSlideFor:(UIViewController *)targetController withSlideDirection:(MWFSlideDirection)slideDirection distance:(CGFloat)distance orientation:(UIInterfaceOrientation)orientation {
    
    if (slideDirection == MWFSlideDirectionNone) {
        
        UIView * overlay = [self.navigationController.view viewWithTag:VIEWTAG_OVERLAY];
        [overlay removeFromSuperview];
        
    } else {
        
        UIView * overlay = [[UIView alloc] initWithFrame:self.navigationController.view.bounds];
        overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        overlay.tag = VIEWTAG_OVERLAY;
        UITapGestureRecognizer * gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close:)];
        [overlay addGestureRecognizer:gr];
        overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.navigationController.view addSubview:overlay];
        
    }
}
- (void) slideNavigationViewController:(MWFSlideNavigationViewController *)controller animateSlideFor:(UIViewController *)targetController withSlideDirection:(MWFSlideDirection)slideDirection distance:(CGFloat)distance orientation:(UIInterfaceOrientation)orientation
{
    UIView * overlay = [self.navigationController.view viewWithTag:VIEWTAG_OVERLAY];
    if (slideDirection == MWFSlideDirectionNone)
    {
        overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    }
    else
    {
        overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
    }
}
- (NSInteger) slideNavigationViewController:(MWFSlideNavigationViewController *)controller distanceForSlideDirecton:(MWFSlideDirection)direction portraitOrientation:(BOOL)portraitOrientation
{
    if (portraitOrientation)
    {
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            return 265;
        }
        else
        {
            return 700;
        }
    }
    else
    {
        return 100;
    }
}

#pragma mark - MWFSlideNavigationViewControllerDataSource

- (UIViewController *) slideNavigationViewController:(MWFSlideNavigationViewController *)controller viewControllerForSlideDirecton:(MWFSlideDirection)direction
{
    if(self.navigationController.visibleViewController == self)
    {
        if(direction == MWFSlideDirectionRight)
        {
            SideSettingsViewController *sideSettingsView;
            if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                sideSettingsView = [[SideSettingsViewController alloc] initWithNibName:@"SideSettingsViewController" bundle:nil];
                UINavigationController * navCtl = [[UINavigationController alloc] initWithRootViewController:sideSettingsView];
                return navCtl;
            }
            else
            {
                sideSettingsView = [[SideSettingsViewController alloc] initWithNibName:@"SideSettingsViewController~iPad" bundle:nil];
                UINavigationController * navCtl = [[UINavigationController alloc] initWithRootViewController:sideSettingsView];
                return navCtl;
            }
        }
    }
    return nil;
}
@end
