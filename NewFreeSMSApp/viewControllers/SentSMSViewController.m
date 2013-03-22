//
//  SentSMSViewController.m
//  FreeSMS
//
//  Created by Rajan Balana on 01/10/12.
//  Copyright (c) 2012 Rajan Balana. All rights reserved.
//

#import "SentSMSViewController.h"
#import "FreeSMSAppDelegate.h"
#import "SentSMSCell.h"
#import "ConversationViewController.h"

@interface SentSMSViewController ()

@end

@implementation SentSMSViewController
@synthesize managedObjectContext;
@synthesize fetchedSentSMSes;
@synthesize noResultsLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewWillAppear:(BOOL)animated
{
    if (managedObjectContext == nil)
    {
        managedObjectContext = [(FreeSMSAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    NSError *_fetcherror;
    NSFetchRequest *_request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SentSMS" inManagedObjectContext:self.managedObjectContext];
    _request.entity = entity;
    NSDictionary *entityProperties = [entity propertiesByName];
    [_request setResultType:NSDictionaryResultType];
    [_request setPropertiesToFetch:[NSArray arrayWithObject:[entityProperties objectForKey:@"recipient"]]];
    [_request setReturnsDistinctResults:YES];
    fetchedSentSMSes = [[NSMutableArray alloc] initWithArray:[self.managedObjectContext executeFetchRequest:_request error:&_fetcherror]];
    NSMutableArray *temparray = [[NSMutableArray alloc] initWithArray:nil];
    NSMutableArray *data = [[NSMutableArray alloc] init];
    for(id key in fetchedSentSMSes)
    {
        NSError *_fetcherror;
        NSFetchRequest *_request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"SentSMS" inManagedObjectContext:self.managedObjectContext];
        _request.entity = entity;
        NSPredicate *predicate =  [NSPredicate predicateWithFormat:@"(recipient = %@)",[key valueForKey:@"recipient"]];
        [_request setPredicate:predicate];
        temparray = [[self.managedObjectContext executeFetchRequest:_request error:&_fetcherror] mutableCopy];
        id obj = [temparray lastObject];
        [data addObject:obj];
    }
    fetchedSentSMSes = nil;
    fetchedSentSMSes = [NSMutableArray arrayWithArray:data];
    data = nil;
    temparray = nil;
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sentdate"
                                                  ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray;
    sortedArray = [fetchedSentSMSes sortedArrayUsingDescriptors:sortDescriptors];
    fetchedSentSMSes = [NSMutableArray arrayWithArray:sortedArray];
    self.navigationController.navigationBar.hidden = NO;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    label.text = NSLocalizedString(@"Sent Messages", @"");
    [label sizeToFit];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.0f/255.0f green:115.0f/255.0f blue:209.0f/255.0f alpha:0.0f]];
    [sentMessagesTable reloadData];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [fetchedSentSMSes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SentSMSCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        
        NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"SentSMSCell" owner:nil options:nil];
        
        for (UIView *view in views)
        {
            if([view isKindOfClass:[UITableViewCell class]])
            {
                cell = (SentSMSCell *)view;
            }
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSManagedObject *one = [fetchedSentSMSes objectAtIndex:indexPath.row];
    NSTimeInterval interval = [[one valueForKey:@"sentdate"] floatValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MMM-yyyy"];
    cell.sentfromlabel.text = [NSString stringWithFormat:@"%@",[one valueForKey:@"recipient"]];
    cell.sentdate.text = [formatter stringFromDate:date];
    cell.messagesent.text = [NSString stringWithFormat:@"%@",[one valueForKey:@"message"]];
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"deletion of Row no %d initiated",indexPath.row);
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSString *predicate = [[fetchedSentSMSes objectAtIndex:indexPath.row] valueForKey:@"recipient"];
        [fetchedSentSMSes removeObjectAtIndex:indexPath.row];
        [tableView beginUpdates];
        fetchedSentSMSes = [fetchedSentSMSes mutableCopy];
        NSError *_fetcherror;
        NSFetchRequest *_request = [[NSFetchRequest alloc] init];
        [_request setEntity:[NSEntityDescription entityForName:@"SentSMS" inManagedObjectContext:self.managedObjectContext]];
        NSPredicate *predicatevalue =  [NSPredicate predicateWithFormat:@"(recipient = %@)",predicate];
        [_request setPredicate:predicatevalue];
        NSArray *results = [self.managedObjectContext executeFetchRequest:_request error:&_fetcherror];
        for(NSManagedObject *one in results)
        {
            [self.managedObjectContext deleteObject:one];
        }
        [self.managedObjectContext save:nil];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    NSManagedObject *one = [fetchedSentSMSes objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ConversationViewController *conversationView;
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
     conversationView = [[ConversationViewController alloc] initWithNibName:@"ConversationViewController" bundle:nil];
    }
    else
    {
        conversationView = [[ConversationViewController alloc]initWithNibName:@"ConversationViewController~iPad" bundle:nil];
    }
    conversationView.recipientNumber = [one valueForKey:@"recipient"];
    [self.navigationController pushViewController:conversationView animated:YES];
}
@end
