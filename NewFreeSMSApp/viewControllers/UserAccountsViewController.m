//
//  UserAccountsViewController.m
//  FreeSMS
//
//  Created by Rajan Balana on 19/10/12.
//  Copyright (c) 2012 Rajan Balana. All rights reserved.
//

#import "UserAccountsViewController.h"
#import "FreeSMSAppDelegate.h"
#import "Utils.h"

@interface UserAccountsViewController ()

@end

@implementation UserAccountsViewController
@synthesize managedObjectContext,userAccounts,userAccountsTable;

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
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editButtonTapped)];
    self.navigationItem.rightBarButtonItem = editButton;
    NSMutableDictionary *Data;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"defaultAccount.plist"];
    Data = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    defaultAccountName = [Data objectForKey:@"defaultAccountName"];
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grey.png"]];
    [tempImageView setFrame:self.userAccountsTable.frame];
    self.userAccountsTable.backgroundView = tempImageView;
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.0f/255.0f green:115.0f/255.0f blue:209.0f/255.0f alpha:0.0f]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    label.text = NSLocalizedString(@"User Accounts", @"");
    [label sizeToFit];

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
    if(section == 0)
    {
        if (userAccounts.count == 0)
        {
            CGRect frame = CGRectMake(50, 75, 210, 70);
            noResultsLabel = [[UILabel alloc] initWithFrame:frame];
            self.navigationItem.rightBarButtonItem.enabled = NO;
            noResultsLabel.text = @"No User Accounts Left!";
            noResultsLabel.textAlignment = UITextAlignmentCenter;
            noResultsLabel.textColor = [UIColor blackColor];
            noResultsLabel.backgroundColor = [UIColor clearColor];
            [self.view addSubview:noResultsLabel];
        }
        return userAccounts.count;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifer = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    NSManagedObject *one = [userAccounts objectAtIndex:indexPath.row];
    cell.textLabel.text =  [Utils append:[one valueForKey:@"accountname"],@"  --  ",[one valueForKey:@"username"], nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return @"User Accounts";
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source
        [userAccounts removeObjectAtIndex:indexPath.row];
        [userAccountsTable beginUpdates];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSError *_fetcherror;
        NSFetchRequest *_request = [[NSFetchRequest alloc] init];
        [_request setEntity:[NSEntityDescription entityForName:@"UserAccounts" inManagedObjectContext:self.managedObjectContext]];
        NSArray *results = [self.managedObjectContext executeFetchRequest:_request error:&_fetcherror];
        NSManagedObject *one = [results objectAtIndex:indexPath.row];
        if ([[one valueForKey:@"accountname"] isEqualToString:defaultAccountName])
        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *path = [documentsDirectory stringByAppendingPathComponent:@"defaultAccount.plist"];
            NSMutableDictionary *pListData;
            pListData = [NSMutableDictionary dictionaryWithContentsOfFile:path];
            [pListData setValue:@"" forKey:@"defaultAccountUsername"];
            [pListData setValue:@"" forKey:@"defaultAccountPassword"];
            [pListData setValue:@"" forKey:@"defaultAccountType"];
            [pListData setValue:@"" forKey:@"defaultAccountName"];
            [pListData writeToFile:path atomically:YES];
            [Utils showAlert:@"Alert!" :@"You Deleted your default account, \nDon't forget to choose one!"];
        }
        [self.managedObjectContext deleteObject:one];
        [self.managedObjectContext save:nil];
        [userAccountsTable endUpdates];
    }
}
-(void)editButtonTapped
{
    userAccountsTable.editing = YES;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonTapped)];
    self.navigationItem.rightBarButtonItem = doneButton;
}
-(void)doneButtonTapped
{
    self.userAccountsTable.editing = NO;
    [self.userAccountsTable reloadData];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editButtonTapped)];
    self.navigationItem.rightBarButtonItem = editButton;
}
@end
