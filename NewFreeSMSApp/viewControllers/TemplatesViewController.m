//
//  TemplatesViewController.m
//  FreeSMS
//
//  Created by Rajan Balana on 11/10/12.
//  Copyright (c) 2012 Rajan Balana. All rights reserved.
//

#import "TemplatesViewController.h"
#import "FreeSMSAppDelegate.h"

@interface TemplatesViewController ()

@end

@implementation TemplatesViewController
@synthesize context,fetchedTemplates,noResultsLabel,templates;

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
    if ( context == nil)
    {
        context = [(FreeSMSAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    NSError *_fetcherror;
    NSFetchRequest *_request = [[NSFetchRequest alloc] init];
    [_request setEntity:[NSEntityDescription entityForName:@"Templates" inManagedObjectContext:self.context]];
    fetchedTemplates = [[NSMutableArray alloc] init];
    fetchedTemplates = [[self.context executeFetchRequest:_request error:&_fetcherror] mutableCopy];
    [templates reloadData];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    label.text = NSLocalizedString(@"Templates", @"");
    [label sizeToFit];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.0f/255.0f green:115.0f/255.0f blue:209.0f/255.0f alpha:0.0f]];
    UIBarButtonItem * addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTemplateClicked)];
    [self.navigationItem setRightBarButtonItem:addButton];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [fetchedTemplates count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSManagedObject *one = [fetchedTemplates objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[one valueForKey:@"content"]];
    return cell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"deletion of Row no %d initiated",indexPath.row);
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [fetchedTemplates removeObjectAtIndex:indexPath.row];
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSError *_fetcherror;
        NSFetchRequest *_request = [[NSFetchRequest alloc] init];
        [_request setEntity:[NSEntityDescription entityForName:@"Templates" inManagedObjectContext:self.context]];
        NSArray *results = [self.context executeFetchRequest:_request error:&_fetcherror];
        NSManagedObject *one = [results objectAtIndex:indexPath.row];
        [self.context deleteObject:one];
        [self.context save:nil];
        [tableView endUpdates];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    [tableView reloadData];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        sendSMS = [[SendSMSViewController alloc] initWithNibName:@"SendSMSViewController" bundle:nil];
    }
    else
    {
        sendSMS = [[SendSMSViewController alloc] initWithNibName:@"SendSMSViewController~iPad" bundle:nil];
    }
    NSManagedObject *one = [fetchedTemplates objectAtIndex:indexPath.row];
    sendSMS.messageReceived = [one valueForKey:@"content"];
    [self.navigationController pushViewController:sendSMS animated:YES];
}
-(void)addTemplateClicked
{
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        addTemplateView = [[AddNewTemplateViewController alloc] initWithNibName:@"AddNewTemplateViewController" bundle:nil];
    }
    else
    {
        addTemplateView = [[AddNewTemplateViewController alloc] initWithNibName:@"AddNewTemplateViewController~iPad" bundle:nil];
    }
    [self.navigationController pushViewController:addTemplateView animated:YES];
}
@end
