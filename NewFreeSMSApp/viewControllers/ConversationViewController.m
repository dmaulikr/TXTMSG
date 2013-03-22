//
//  ConversationViewController.m
//  FreeSMS
//
//  Created by Rajan Balana on 27/10/12.
//  Copyright (c) 2012 Rajan Balana. All rights reserved.
//

#import "ConversationViewController.h"
#import "FreeSMSAppDelegate.h"
#import "MessageBean.h"
#import "Utils.h"
#import "FreeSMSGlobals.h"
#import "MessageSending.h"

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 260.0f
#define CELL_CONTENT_MARGIN 7.0f
#define keyboardHeight 216.0f

int messageNumber1 = 0;
int messageNumberToBeReProcessed1 = 0;
int entriesInDatabse = 0;

@interface ConversationViewController ()

@end

@implementation ConversationViewController

@synthesize recipientNumber,managedObjectContext,fetchedConversation;
@synthesize dateLabel = _dateLabel;
@synthesize message;

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
    /*BOOL allMessagesSent = YES;
    for (MessageBean *obj in [FreeSMSGlobals sharedFreeSMSGlobals].messageQueue) {
        if([[obj messageStatus] isEqualToString:@""])
        {
            allMessagesSent = NO;
        }
    }
    if(allMessagesSent)*/
    [FreeSMSGlobals sharedFreeSMSGlobals].messageQueue = nil;
    if ( managedObjectContext == nil)
    {
        managedObjectContext = [(FreeSMSAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    messageNumber1 = 0;
    messageNumberToBeReProcessed1 = 0;
    entriesInDatabse = 0;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    label.text = NSLocalizedString(recipientNumber, @"");
    [label sizeToFit];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.0f/255.0f green:115.0f/255.0f blue:209.0f/255.0f alpha:0.0f]];
    NSError *_fetcherror;
    NSFetchRequest *_request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SentSMS" inManagedObjectContext:self.managedObjectContext];
    _request.entity = entity;
    NSPredicate *predicate =  [NSPredicate predicateWithFormat:@"(recipient = %@)",recipientNumber];
    [_request setPredicate:predicate];
    fetchedConversation = [[self.managedObjectContext executeFetchRequest:_request error:&_fetcherror] mutableCopy];
    entriesInDatabse = [fetchedConversation count];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    [conversationTable addGestureRecognizer:gestureRecognizer];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated
{
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([fetchedConversation count] - 1) inSection:0];
    [conversationTable scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}
-(void)viewWillDisappear:(BOOL)animated
{
     messageNumber1 = 0;
     messageNumberToBeReProcessed1 = 0;
     entriesInDatabse = 0;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)hideKeyboard:(id)sender
{
    [UIView animateWithDuration:0.5 animations:^
     {
         [self.view endEditing:YES];
     }];
    
}

-(void)keyboardShown:(id)sender
{
    conversationTable.frame = CGRectMake(0, 0, 320, self.view.bounds.size.height - keyboardHeight - 81);
    bottomView.frame = CGRectMake(0,self.view.bounds.size.height - keyboardHeight - 79, 320, 78);
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([fetchedConversation count] - 1) inSection:0];
    [conversationTable scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

-(void)keyboardHidden:(id)sender
{
    conversationTable.frame = CGRectMake(0, 0, 320, self.view.bounds.size.height - 81);
    bottomView.frame = CGRectMake(0, self.view.bounds.size.height - 79, 320, 78);
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [fetchedConversation count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id obj = [fetchedConversation objectAtIndex:indexPath.row];
    if(![obj isKindOfClass:[MessageBean class]])
    {
        NSManagedObject *one = [fetchedConversation objectAtIndex:indexPath.row];
             UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
            backgroundImage = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"chatview.png"] resizableImageWithCapInsets:UIEdgeInsetsFromString([one valueForKey:@"message"]) resizingMode:UIImageResizingModeStretch]];
            [cell.contentView addSubview:backgroundImage];
            messageLabel = [[UITextView alloc] initWithFrame:CGRectZero];
            [messageLabel setTag:1];
            messageLabel.font = [UIFont fontWithName:@"Helvetica" size:FONT_SIZE];
            messageLabel.text = [one valueForKey:@"message"];
            messageLabel.editable = NO;
            messageLabel.userInteractionEnabled = NO;
            messageLabel.scrollEnabled = NO;
            [[cell contentView] addSubview:messageLabel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        CGSize size = [[one valueForKey:@"message"] sizeWithFont:[UIFont fontWithName:@"Helvetica" size:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        backgroundImage.frame = CGRectMake(50, 5, 270, MAX(size.height+30, 5.0f));
        [messageLabel setFrame:CGRectMake(60, 7, 250, size.height+10)];
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(190,size.height+20, 120, 10)];
        NSTimeInterval interval = [[one valueForKey:@"sentdate"] floatValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd-MMM-yyyy hh:mm:ss a"];
        _dateLabel.text = [formatter stringFromDate:date];
        _dateLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
        [cell.contentView addSubview:_dateLabel];
        return cell;
    }
    else
    {
            MessageBean *bean = [fetchedConversation objectAtIndex:indexPath.row];
            NSString *text = [bean message];
                UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
                backgroundImage = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"chatview.png"] resizableImageWithCapInsets:UIEdgeInsetsFromString(text) resizingMode:UIImageResizingModeStretch]];
                [cell.contentView addSubview:backgroundImage];
                messageLabel = [[UITextView alloc] initWithFrame:CGRectZero];
                [messageLabel setFont:[UIFont fontWithName:@"Helvetica" size:FONT_SIZE]];
                [messageLabel setTag:1];
                messageLabel.font = [UIFont systemFontOfSize:14];
                messageLabel.text = text;
                messageLabel.editable = NO;
                messageLabel.userInteractionEnabled = NO;
                messageLabel.scrollEnabled = NO;
                [[cell contentView] addSubview:messageLabel];
                if([[bean messageStatus] isEqualToString:@"YES"])
                {
                    UIImageView *sentSuccessImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"done.png"]];
                    sentSuccessImage.frame = CGRectMake(20, 9, 32, 32);
                    [[cell contentView] addSubview:sentSuccessImage];
                }
                else if ([[bean messageStatus] isEqualToString:@"NO"])
                {
                    UIButton *statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    statusButton.frame = CGRectMake(20, 9, 32, 32);
                    [statusButton setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
                    statusButton.tag = (indexPath.row - (entriesInDatabse-1))-1;
                    [statusButton addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                    [[cell contentView] addSubview:statusButton];
                }
                else if([[bean messageStatus] isEqualToString:@""])
                {
                    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                    [spinner startAnimating];
                    spinner.frame = CGRectMake(20, 9, 32, 32);
                    spinner.tag = indexPath.row;
                    [cell.contentView addSubview:spinner];
                }
                else
                {
                    UIButton *reportButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    reportButton.frame = CGRectMake(20, 9, 32, 32);
                    [reportButton setImage:[UIImage imageNamed:@"infoicon.png"] forState:UIControlStateNormal];
                    reportButton.tag = (indexPath.row - (entriesInDatabse-1))-1;
                    [reportButton addTarget:self action:@selector(infoIconTapped:) forControlEvents:UIControlEventTouchUpInside];
                    [[cell contentView] addSubview:reportButton];
                }

                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
            CGSize size = [text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
            backgroundImage.frame = CGRectMake(50, 5, 270, MAX(size.height+30, 5.0f));
            [messageLabel setFrame:CGRectMake(60, 7, 260, size.height+10)];
            if([[bean messageStatus] isEqualToString:@"YES"])
            {
                _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(190,size.height+20, 120, 10)];
                NSDate *date = [NSDate date];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"dd-MMM-yyyy hh:mm:ss a"];
                _dateLabel.text = [formatter stringFromDate:date];
                _dateLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
                [cell.contentView addSubview:_dateLabel];
            }
    
        return cell;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *one = [fetchedConversation objectAtIndex:indexPath.row];
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    CGSize size = [[one valueForKey:@"message" ] sizeWithFont:[UIFont fontWithName:@"Helvetica" size:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    CGFloat height = MAX(size.height+20, 5.0f);
    return height + (CELL_CONTENT_MARGIN * 2);
}
-(BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return YES;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
        if (action == @selector(copy:))
        {
            return YES;
        }
        return NO;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
        if(action == @selector(copy:))
        {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            MessageBean *tempobj = [fetchedConversation objectAtIndex:indexPath.row];
            NSString *text = [tempobj message];
            [pasteboard setString:text];
        }
}

-(void)messageFieldValidatior
{
    if([message.text isEqualToString:@""])
    {
        messageValidation = NO;
    }
    else
    {
        messageValidation = YES;
    }
}

-(IBAction)sendClicked
{
    [self messageFieldValidatior];
    MessageBean *object = [[MessageBean alloc] init];
    if(messageValidation)
    {
        if([Utils hasInternetConnection])
        {
            HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
            [self.navigationController.view addSubview:HUD];
            HUD.delegate = self;
            HUD.labelText = @"Please Wait!";
            [HUD show:YES];
            [FreeSMSGlobals initializeMessageQueue];
            NSMutableDictionary *pListData;
            pListData = [FreeSMSGlobals getpListData];
            NSError *_fetcherror;
            NSFetchRequest *_request = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserAccounts" inManagedObjectContext:self.managedObjectContext];
            _request.entity = entity;
            NSPredicate *predicate =  [NSPredicate predicateWithFormat:@"(accountname = %@)",[pListData valueForKey:@"defaultAccountName"]];
            [_request setPredicate:predicate];
            NSArray *userAccountRecord = [[NSArray alloc] initWithArray:[[self.managedObjectContext executeFetchRequest:_request error:&_fetcherror] mutableCopy]];
            object.message = message.text;
            object.messageStatus = @"";
            object.sentFrom = [[userAccountRecord objectAtIndex:0] valueForKey:@"username"];
            object.sentTo = recipientNumber;
            object.password = [[userAccountRecord objectAtIndex:0] valueForKey:@"password"];
            object.gatewayUsed = [[userAccountRecord objectAtIndex:0] valueForKey:@"accounttype"];
            [[FreeSMSGlobals sharedFreeSMSGlobals].messageQueue addObject:object];
            MessageSending *obj = [[MessageSending alloc] init];
            obj.delegate = self;
            [fetchedConversation addObject:object];
            [obj processMessage:messageNumber1];
            int lastRowNumber = [conversationTable numberOfRowsInSection:0];
            NSIndexPath* ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
            NSArray* rowsToReload = [NSArray arrayWithObjects:ip, nil];
            [conversationTable beginUpdates];
            [conversationTable insertRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
            [conversationTable endUpdates];
            [conversationTable scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
            message.text = @"";
            [message resignFirstResponder];
            messageNumber1++;
            characterCount.text = @"140";
        }
        else
        {
            [Utils showAlert:@"Oops!" :@"You don't have an Internet Connection!"];
        }
    }
    else
    {
        [Utils showAlert:@"Error" :@"Something is wrong!"];
    }
}
-(void)doneButtonPressed:(id)sender
{
    messageNumberToBeReProcessed1 = ((UIControl *) sender).tag;
    myActionSheet = [[UIActionSheet alloc] initWithTitle:@"What would you like to do?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Resend" otherButtonTitles:nil, nil];
    myActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    myActionSheet.tag = 1;
    [myActionSheet showInView:self.view];
}
-(void)textViewDidChange:(UITextView *)textView
{
	int maxChars = 140;
	int charsLeft = maxChars - [textView.text length];
    NSString *temp = [textView text];
	if([textView.text length] > 140)
    {
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"No more characters"
                                                         message:[NSString stringWithFormat:@"You have reached the character limit of %d.",maxChars]
                                                        delegate:nil
                                               cancelButtonTitle:@"Ok"
                                               otherButtonTitles:nil];
		[alert show];
        textView.text=[temp substringToIndex:[temp length]-1];
        charsLeft = 0;
	}
    
	characterCount.text = [NSString stringWithFormat:@"%d",charsLeft];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1)
    {
        if (buttonIndex == 0)
        {
            [self resendMessage:messageNumberToBeReProcessed1];
        }
    }
}
-(void)resendMessage:(int) messageNumber
{
    if([Utils hasInternetConnection])
    {
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.delegate = self;
        HUD.labelText = @"Please Wait!";
        [HUD show:YES];
        MessageSending *obj = [[MessageSending alloc] init];
        MessageBean *messageObject = [[FreeSMSGlobals sharedFreeSMSGlobals].messageQueue objectAtIndex:messageNumber];
        messageObject.messageStatus = @"";
        obj.delegate = self;
        NSIndexPath *rowToReload = [NSIndexPath indexPathForRow:(entriesInDatabse + messageNumber) inSection:0];
        NSArray *rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
        [conversationTable reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
        [obj processMessage:messageNumber];
    }
    else
    {
        [Utils showAlert:@"Error" :@"No Internet Connection Available"];
    }
}
-(void)infoIconTapped:(id)sender
{
    int currentMessageNumber = ((UIControl *) sender).tag;
    MessageBean *messageObject = [[FreeSMSGlobals sharedFreeSMSGlobals].messageQueue objectAtIndex:currentMessageNumber];
    UIAlertView *messageDetails;
    messageDetails = [[UIAlertView alloc] initWithTitle:@"Message Status" message:[messageObject messageStatus] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Resend", nil];
    messageDetails.tag = currentMessageNumber;
    [messageDetails show];
}
#pragma MessageQueue Delegates Functions

-(void)messageSentSuccessfuly:(int)SMSCount
{
    //HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
	//HUD.mode = MBProgressHUDModeCustomView;
    //HUD.labelText = @"Sent";
    [HUD hide:YES];
    int totalmessages = (entriesInDatabse + SMSCount);
    NSLog(@"The value of total messages : %d",totalmessages);
    NSIndexPath *rowToReload = [NSIndexPath indexPathForRow:totalmessages inSection:0];
    NSArray *rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
    [conversationTable reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
}

-(void)messageFailed:(int)SMSCount
{
    //HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"crossblue.png"]];
	//HUD.mode = MBProgressHUDModeCustomView;
    //HUD.labelText = @"Failed";
    [HUD hide:YES];
    int totalmessages = (entriesInDatabse + SMSCount);
    NSLog(@"The value of total messages : %d",totalmessages);
    NSIndexPath *rowToReload = [NSIndexPath indexPathForRow:totalmessages inSection:0];
    NSArray *rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
    [conversationTable reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
}
- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != alertView.cancelButtonIndex)
    {
        [self resendMessage:alertView.tag];
    }
}
@end
