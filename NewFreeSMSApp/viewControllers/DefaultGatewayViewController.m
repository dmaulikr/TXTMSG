//
//  DefaultGatewayViewController.m
//  FreeSMS
//
//  Created by Rajan Balana on 20/10/12.
//  Copyright (c) 2012 Rajan Balana. All rights reserved.
//

#import "DefaultGatewayViewController.h"
#import "FreeSMSAppDelegate.h"
#import "Utils.h"

@interface DefaultGatewayViewController ()

@end

@implementation DefaultGatewayViewController
@synthesize userAccounts,managedObjectContext,defaultGatewayTable;

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
    label.text = NSLocalizedString(@"Select Default Gateway", @"");
    [label sizeToFit];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.0f/255.0f green:115.0f/255.0f blue:209.0f/255.0f alpha:0.0f]];
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grey.png"]];
    [tempImageView setFrame:self.defaultGatewayTable.frame];
    self.defaultGatewayTable.backgroundView = tempImageView;
}

- (void)viewDidLoad
{
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
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifer = @"cellIdentifier";
    
    UITableViewCell *cell;
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    NSManagedObject *one = [userAccounts objectAtIndex:indexPath.row];
    cell.textLabel.text =  [Utils append:[one valueForKey:@"accountname"],@"  --  ",[one valueForKey:@"username"], nil];
    
    if([defaultAccountName isEqualToString:[one valueForKey:@"accountname"]])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
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
@end
