//
//  AddGatewayViewController.m
//  FreeSMS
//
//  Created by Rajan Balana on 18/10/12.
//  Copyright (c) 2012 Rajan Balana. All rights reserved.
//

#import "AddGatewayViewController.h"
#import "FreeSMSAppDelegate.h"
#import "UserAccounts.h"
#import "Utils.h"
#import "FreeSMSGlobals.h"
#import "SettingsViewController.h"


@interface AddGatewayViewController ()

@end

@implementation AddGatewayViewController

@synthesize gateway,usernameField,passwordField,context,accountNameField,addGatewayTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    if (context == nil)
    {
        context = [(FreeSMSAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    label.text = NSLocalizedString(@"Add Account", @"");
    [label sizeToFit];
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grey.png"]];
    [tempImageView setFrame:self.addGatewayTable.frame];
    self.addGatewayTable.backgroundView = tempImageView;
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.0f/255.0f green:115.0f/255.0f blue:209.0f/255.0f alpha:0.0f]];
    self.navigationController.navigationBar.hidden = NO;
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleDone target:self action:@selector(saveButtonTapped)];
    self.navigationItem.rightBarButtonItem = saveButton;
}
- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(accountNameTextChanged:)
     name:UITextFieldTextDidChangeNotification
     object:accountNameField];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if(indexPath.row == 0)
    {
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        cell.textLabel.text = @"140 Characters SMS Supported";
        cell.userInteractionEnabled = NO;
    }
    if(indexPath.row == 1)
    {
        UILabel *username = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 100, 20)];
        username.text = @"Mobile No:";
        username.textColor = [UIColor blackColor];
        username.font = [UIFont fontWithName:@"Helvetica" size:17];
        username.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:username];
        usernameField = [[UITextField alloc] initWithFrame:CGRectMake(90, 6, 200, 30)];
        usernameField.borderStyle = UITextBorderStyleRoundedRect;
        usernameField.textColor = [UIColor blackColor];
        usernameField.font = [UIFont fontWithName:@"Helvetica" size:15];
        usernameField.placeholder = @"Mobile Number";
        usernameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        usernameField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        usernameField.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
        [username becomeFirstResponder];
        usernameField.autocapitalizationType =UITextAutocorrectionTypeNo;
        usernameField.keyboardType = UIKeyboardTypeNumberPad;	// use the default type input method (entire keyboard)
        usernameField.returnKeyType = UIReturnKeyDone;
        usernameField.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
        [cell.contentView addSubview:usernameField];
    }
    if (indexPath.row == 2)
    {
        UILabel *password = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 100, 20)];
        password.text = @"Password:";
        password.textColor = [UIColor blackColor];
        password.font = [UIFont fontWithName:@"Helvetica" size:17];
        password.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:password];
        passwordField = [[UITextField alloc] initWithFrame:CGRectMake(90, 6, 200, 30)];
        passwordField.borderStyle = UITextBorderStyleRoundedRect;
        passwordField.textColor = [UIColor blackColor];
        passwordField.font = [UIFont fontWithName:@"Helvetica" size:15];
        passwordField.placeholder = @"Password";
        passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        passwordField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        passwordField.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
        passwordField.secureTextEntry = YES;
        passwordField.autocapitalizationType =UITextAutocorrectionTypeNo;
        passwordField.keyboardType = UIKeyboardTypeDefault;	// use the default type input method (entire keyboard)
        passwordField.returnKeyType = UIReturnKeyDone;
        passwordField.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
        [cell.contentView addSubview:passwordField];
    }
    else if (indexPath.row == 3)
    {
        UILabel *accountName = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 100, 20)];
        accountName.text = @"A/C Name:";
        accountName.textColor = [UIColor blackColor];
        accountName.font = [UIFont fontWithName:@"Helvetica" size:17];
        accountName.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:accountName];
        accountNameField = [[UITextField alloc] initWithFrame:CGRectMake(90, 6, 200, 30)];
        accountNameField.borderStyle = UITextBorderStyleRoundedRect;
        accountNameField.textColor = [UIColor blackColor];
        accountNameField.font = [UIFont fontWithName:@"Helvetica" size:15];
        accountNameField.placeholder = @"Unique Account Name";
        accountNameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        accountNameField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        accountNameField.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
        accountNameField.autocapitalizationType =UITextAutocorrectionTypeNo;
        accountNameField.keyboardType = UIKeyboardTypeDefault;	// use the default type input method (entire keyboard)
        accountNameField.returnKeyType = UIReturnKeyDone;
        accountNameField.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
        [cell.contentView addSubview:accountNameField];
    }
    return cell;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
    [accountNameField resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
    [accountNameField resignFirstResponder];
    return YES;
}
-(void)accountNameTextChanged:(id)sender
{
    NSString *temp = [accountNameField text];
	if([accountNameField.text length] > 10)
    {
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"No more characters"
                                                         message:@"Account Name should not be more than 10 Characters!"
                                                        delegate:nil
                                               cancelButtonTitle:@"Ok"
                                               otherButtonTitles:nil];
		[alert show];
        accountNameField.text=[temp substringToIndex:[temp length]-1];
	}
}
-(void)saveButtonTapped
{
    if([usernameField.text length] != 10)
    {
        [Utils showAlert:@"Oops!" :@"Mobile Number should be of 10 Digits!"];
    }
    else if([passwordField.text length] ==0)
    {
        [Utils showAlert:@"Oops!" :@"Don't Leave Password Empty Baby!"];
    }
    else if ([accountNameField.text length] == 0)
    {
        [Utils showAlert:@"Oops!" :@"Please Provide a unique Account Name Baby!"];
    }
    else if(![Utils hasInternetConnection])
    {
        [Utils showAlert:@"Error!" :@"No Internet Connection Available"];
    }
    else
    {
        NSError *_fetcherror;
        NSFetchRequest *_request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserAccounts" inManagedObjectContext:self.context];
        _request.entity = entity;
        NSDictionary *entityProperties = [entity propertiesByName];
        [_request setResultType:NSDictionaryResultType];
        [_request setPropertiesToFetch:[NSArray arrayWithObject:[entityProperties objectForKey:@"accountname"]]];
        NSArray *tempuseraccount = [[NSArray alloc]initWithArray:[self.context executeFetchRequest:_request error:&_fetcherror]];
        BOOL isAccountNameExists = NO;
        for (id key in tempuseraccount)
        {
            if ([[key objectForKey:@"accountname"] isEqualToString:accountNameField.text])
            {
                isAccountNameExists = YES;
            }
        }
        if (isAccountNameExists)
        {
            [Utils showAlert:@"Oops!" :@"Account Name Already Exists!!"];
        }
        else
        {
            [self.view endEditing:YES];
            HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
            [self.navigationController.view addSubview:HUD];
            HUD.delegate = self;
            HUD.labelText = @"Authenticating! \n Please Wait!";
            [HUD show:YES];
            AuthenticationCheck *requestObject = [[AuthenticationCheck alloc] init];
            requestObject.delegate = self;
            [requestObject sendAuthenticationRequestToServer:usernameField.text :passwordField.text :gateway];
        }
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return nil;
    }
    return 0;
}
-(void)authenticatedSuccessfully
{
    [HUD hide:YES];
    context = [(FreeSMSAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSError *_savingError;
    UserAccounts *UserAccounts = [NSEntityDescription
                                  insertNewObjectForEntityForName:@"UserAccounts"
                                  inManagedObjectContext:context];
    UserAccounts.username = usernameField.text;
    UserAccounts.password = passwordField.text;
    UserAccounts.accounttype = gateway;
    UserAccounts.accountname = accountNameField.text;
    [context save:&_savingError];
    
    if(_savingError)
    {
        [Utils showAlert:@"Unable to save account" :@"OK"];
    }
    else
    {
        [Utils showAlert:@"WhooHoo!" :@"Account Added"];
        NSMutableDictionary *pListData;
        pListData = [FreeSMSGlobals getpListData];
        if([[pListData valueForKey:@"defaultAccountUsername"] isEqualToString:@""])
        {
            [pListData setValue:usernameField.text forKey:@"defaultAccountUsername"];
            [pListData setValue:passwordField.text forKey:@"defaultAccountPassword"];
            [pListData setValue:gateway forKey:@"defaultAccountType"];
            [pListData setValue:accountNameField.text forKey:@"defaultAccountName"];
            [pListData writeToFile:[FreeSMSGlobals getpListPath] atomically:YES];
        }
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }
}
-(void)authenticationFailed
{
    [HUD hide:YES];
}
@end
