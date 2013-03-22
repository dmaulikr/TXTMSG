//
//  SendSMSViewController.m
//  FreeSMS
//
//  Created by Rajan Balana on 13/09/12.
//  Copyright (c) 2012 Rajan Balana. All rights reserved.
//

#import "SendSMSViewController.h"
#import "Utils.h"
#import "MessageSending.h"
#import "FreeSMSAppDelegate.h"
#import "FreeSMSGlobals.h"
#import "MessageBean.h"

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 260.0f
#define CELL_CONTENT_MARGIN 7.0f
#define kKeyboardHeight 216.0f
#define IS_IPHONE_5 ( [ [ UIScreen mainScreen ] bounds ].size.height == 568 )

int messageNumber = 0;
int messageNumberToBeReProcessed = 0;
NSArray *phoneNos;
NSString *contactFirstName;

@implementation SendSMSViewController

@synthesize scrollView;
@synthesize messageReceived,contactsReceived;
@synthesize messageStatus,contactValidation,messageValidation,managedObjectContext,value;
@synthesize contacts,message,characterCount,chatViewTable;
@synthesize dateLabel = _dateLabel;
@synthesize people,contactsTableView,filteredPeople,contactPickerView,selectedContacts,peopleFiltered,contactsLabel;

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShown:) name:UIKeyboardWillShowNotification object:nil];
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
    if (managedObjectContext == nil)
    {
        managedObjectContext = [(FreeSMSAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    NSError *_fetcherror;
    NSFetchRequest *_request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserAccounts" inManagedObjectContext:self.managedObjectContext];
    _request.entity = entity;
    [_request setResultType:NSDictionaryResultType];
    userAccounts = [[NSMutableArray alloc] init];
    userAccounts = [[self.managedObjectContext executeFetchRequest:_request error:&_fetcherror] mutableCopy];
    self.filteredPeople = [NSMutableArray array];
    self.selectedContacts = [NSMutableDictionary dictionary];
    self.contactPickerView = [[THContactPickerView alloc] initWithFrame:CGRectMake(0, 0, (self.view.frame.size.width)-38, 100)];
    self.contactPickerView.delegate = self;
    [self.contactPickerView setPlaceholderString:@"Start Typing the Contact Name/Number"];
    [self.view addSubview:self.contactPickerView];
    self.contactsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.contactPickerView.frame.size.height)+15, self.view.frame.size.width, self.view.frame.size.height - self.contactPickerView.frame.size.height - kKeyboardHeight-10) style:UITableViewStylePlain];
    contactsTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.contactsTableView.dataSource = self;
    self.contactsTableView.delegate = self;
    [self.contactsTableView setHidden:YES];
    [self.view insertSubview:self.contactsTableView belowSubview:self.contactPickerView];
    contactButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [contactButton setBackgroundImage:[UIImage imageNamed:@"plusicon.png"] forState:UIControlStateNormal];
    [contactButton addTarget:self action:@selector(hiiClicked) forControlEvents:UIControlEventTouchUpInside];
    contactButton.frame = CGRectMake((self.view.frame.size.width)-35,7, 30, 30);
    [self.view insertSubview:contactButton aboveSubview:contactPickerView];
    backgroundTextBox = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"horizontalline.png"]];
    backgroundTextBox.frame = CGRectMake(0, (self.contactPickerView.frame.size.height)+10, 320, 4);
  //  [self.view insertSubview:backgroundTextBox belowSubview:self.contactPickerView];
    [contactsTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    topView.hidden = YES;
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [topView addGestureRecognizer:singleFingerTap];
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grey.png"]];
    self.chatViewTable.backgroundView = tempImageView;
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    [self.chatViewTable addGestureRecognizer:gestureRecognizer];
    keyboardHideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [keyboardHideButton setBackgroundImage:[UIImage imageNamed:@"keyboardicon.png"] forState:UIControlStateNormal];
    if(IS_IPHONE_5)
    {
        keyboardHideButton.frame = CGRectMake(0, self.view.frame.size.height -kKeyboardHeight -110 + 86, 30, 30);
    }
    else
    {
        keyboardHideButton.frame = CGRectMake(0, self.view.frame.size.height -kKeyboardHeight -110 , 30, 30);
    }
    [keyboardHideButton addTarget:self action:@selector(keyboardHidden:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:keyboardHideButton aboveSubview:self.chatViewTable];
    [super viewDidLoad];
}

-(void)dealloc
{
    
}
-(void)hideKeyboard:(id)sender
{
    [UIView animateWithDuration:0.5 animations:^
     {
         [self keyboardHidden:nil];
     }];
    
}
-(void)keyboardShown:(id)sender
{
    keyboardHideButton.hidden = NO;
    bottomView.frame = CGRectMake(0,self.view.bounds.size.height - kKeyboardHeight - 80, 320, 78);
}
-(void)keyboardHidden:(id)sender
{
    [UIView animateWithDuration:0.5 animations:^
     {
         bottomView.hidden = NO;
         bottomView.frame = CGRectMake(0, self.view.bounds.size.height - 81, 320, 78);
         [self showTopView];
         [self.view endEditing:YES];
         self.contactsTableView.hidden = YES;
         keyboardHideButton.hidden = YES;
     }];
}
-(void)viewWillAppear:(BOOL)animated
{
    [FreeSMSGlobals sharedFreeSMSGlobals].messageQueue = nil;
    [FreeSMSGlobals sharedFreeSMSGlobals].messageBeingProcessed = 0;
    self.navigationController.navigationBar.hidden = NO;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    label.text = NSLocalizedString(@"Compose Message", @"");
    [label sizeToFit];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.0f/255.0f green:115.0f/255.0f blue:209.0f/255.0f alpha:0.0f]];
    self.navigationItem.hidesBackButton = NO;
    if(messageReceived != NULL || contactsReceived != NULL)
    {
        NSString *string = [NSString stringWithFormat:@"%@",contactsReceived];
        contacts.text = string;
        message.text = messageReceived;
        characterCount.text = [NSString stringWithFormat:@"%d", 140 - message.text.length];
    }
    message.font = [UIFont fontWithName:@"Helvetica" size:17];
    if([FreeSMSGlobals sharedFreeSMSGlobals].contactsFiltered == NULL)
    {
        [FreeSMSGlobals sharedFreeSMSGlobals].contactsFiltered = nil;
    }
}
- (void)adjustTableViewFrame
{
    CGRect frame = self.contactsTableView.frame;
    frame.origin.y = self.contactPickerView.frame.size.height+ 12;
    frame.size.height = self.view.frame.size.height - self.contactPickerView.frame.size.height - kKeyboardHeight-20;
    self.contactsTableView.frame = frame;
   // self.chatViewTable.frame = CGRectMake(0, self.contactPickerView.frame.size.height, 320, 290);
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)viewWillDisappear:(BOOL)animated
{
    messageNumber = 0;
    messageNumberToBeReProcessed = 0;
    [FreeSMSGlobals sharedFreeSMSGlobals].messageBeingProcessed = 0;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)cancelNumberPad{
    [contacts resignFirstResponder];
    [message resignFirstResponder];
    [self.contactsTableView setHidden:YES];
}

-(void)doneWithNumberPad
{
    [contacts resignFirstResponder];
    [message resignFirstResponder];
    [self.contactsTableView setHidden:YES];
}

-(IBAction)hiiClicked
{
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty], nil];
    picker.displayedProperties = displayedItems;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    return YES;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    [self selectedContact:person:identifier];
    [self dismissViewControllerAnimated:YES completion:nil];
    return NO;
}

-(void)selectedContact:(ABRecordRef)person:(ABMultiValueIdentifier)identifier
{
    NSString *phone = nil;
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,kABPersonPhoneProperty);
    CFIndex temp = ABMultiValueGetIndexForIdentifier(phoneNumbers,identifier);
    phone = (__bridge_transfer NSString*) ABMultiValueCopyValueAtIndex(phoneNumbers, temp);
    NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    [self.contactPickerView addContact:phone withName:firstName];
    [self.selectedContacts setValue:firstName forKey:phone];
    CFRelease(phoneNumbers);
    [self showTopView];
}

- (void)filterContentForSearchText:(NSString*)searchText
{
    bottomView.hidden = YES;
	// First clear the filtered array.
	[filteredPeople removeAllObjects];
    
	// beginswith[cd] predicate
	NSPredicate *beginsPredicate = [NSPredicate predicateWithFormat:@"(SELF beginswith[cd] %@)", searchText];
    
	/*
	 Search the main list for people whose name OR organization matches searchText;
     add items that match to the filtered array.
	 */
    
	for (id recordid in [FreeSMSGlobals sharedFreeSMSGlobals].contactsFiltered)
    {
        ABRecordID abRecordID = (ABRecordID)[recordid intValue];
        ABRecordRef person = ABAddressBookGetPersonWithRecordID([FreeSMSGlobals sharedFreeSMSGlobals].addressBook,abRecordID);
        NSString *compositeName = (__bridge_transfer NSString *)ABRecordCopyCompositeName(person);
        NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
        NSString *organization = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonOrganizationProperty);
        
        // Match by name or organization
        if ([beginsPredicate evaluateWithObject:compositeName] ||
            [beginsPredicate evaluateWithObject:firstName] ||
            [beginsPredicate evaluateWithObject:lastName] ||
            [beginsPredicate evaluateWithObject:organization])
        {
            ABRecordID abRecordID = ABRecordGetRecordID(person);
            // Add the matching abRecordID to filteredPeople
            [filteredPeople addObject:[NSNumber numberWithInt:abRecordID]];
        }
	}
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [contacts resignFirstResponder];
    [message resignFirstResponder];
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.contactsTableView setHidden:YES];
    [self showTopView];
}
-(void)showTopView
{
    NSDictionary *selected = [self.contactPickerView getAllContacts];
    if([[selected allKeys] count] !=0)
    {
        topView.hidden = NO;
        self.contactPickerView.hidden = YES;
        backgroundTextBox.hidden = YES;
        if(self.contactPickerView.frame.size.height == 76.000000)
        {
            self.chatViewTable.frame = CGRectMake(0, 40, 320, self.view.bounds.size.height - 80);
            if([[selected allKeys] count] > 1)
            {
                THContactBubble *obj = [[selected allValues] lastObject];
                contactsLabel.text = [NSString stringWithFormat:@"%@ & %d more",obj.name,[[selected allKeys] count]-1];
            }
            else
            {
                THContactBubble *obj = [[selected allValues] lastObject];
                contactsLabel.text = [NSString stringWithFormat:@"%@",obj.name];
            }
        }
        else
        {
            self.contactPickerView.hidden = NO;
            topView.hidden = YES;
            backgroundTextBox.hidden = NO;
        }
    }
}
-(void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    self.contactPickerView.hidden = NO;
    backgroundTextBox.hidden = NO;
    topView.hidden = YES;
    self.chatViewTable.frame = CGRectMake(0, 76, 320,self.view.bounds.size.height - kKeyboardHeight - 80);
    [contactPickerView makeContactPickerFirstResponder];
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

-(void)contactFieldValidatior
{
    if(![[self.contactPickerView getAllContacts] allKeys].count)
    {
        contactValidation = NO;
    }
    else
    {
        contactValidation = YES;
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
    [self contactFieldValidatior];
    [self messageFieldValidatior];
    [self.contactsTableView setHidden:YES];
    [self keyboardHidden:nil];
    NSString *completeContactString = [NSString string];
    MessageBean *object = [[MessageBean alloc] init];
    if(contactValidation && messageValidation)
    {
        if([Utils hasInternetConnection])
        {
            HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
            [self.navigationController.view addSubview:HUD];
            HUD.delegate = self;
            HUD.labelText = @"Please Wait!";
            [HUD show:YES];
            NSArray *selectedContacts1 = [[self.contactPickerView getAllContacts] allKeys];
            for(NSString *key in selectedContacts1)
            {
                NSString *stringWithoutHyphen = [key
                                                 stringByReplacingOccurrencesOfString:@"-" withString:@""];
                NSString *stringWithoutHypenCountryCode = [stringWithoutHyphen
                                                           stringByReplacingOccurrencesOfString:@"+91" withString:@""];
                NSString *stringWithoutSpaces = [stringWithoutHypenCountryCode
                                                 stringByReplacingOccurrencesOfString:@" " withString:@""];
                NSString * firstLetter = [stringWithoutSpaces substringToIndex:1];
                if ([firstLetter isEqualToString:@"0"]) {
                    stringWithoutSpaces = [stringWithoutSpaces substringFromIndex:1];
                }
                completeContactString = [Utils append:stringWithoutSpaces, @",", completeContactString,nil];
            }
            completeContactString = [completeContactString substringToIndex:[completeContactString length]-1];
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
            object.sentTo = completeContactString;
            object.password = [[userAccountRecord objectAtIndex:0] valueForKey:@"password"];
            object.gatewayUsed = [[userAccountRecord objectAtIndex:0] valueForKey:@"accounttype"];
            [[FreeSMSGlobals sharedFreeSMSGlobals].messageQueue addObject:object];
            MessageSending *obj = [[MessageSending alloc] init];
            obj.delegate = self;
            [obj processMessage:messageNumber];
            int lastRowNumber = [chatViewTable numberOfRowsInSection:0];
            NSIndexPath* ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
            NSArray* rowsToReload = [NSArray arrayWithObjects:ip, nil];
            [chatViewTable beginUpdates];
            [chatViewTable insertRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
            [chatViewTable endUpdates];
            NSIndexPath* ip1 = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
            [chatViewTable scrollToRowAtIndexPath:ip1 atScrollPosition:UITableViewScrollPositionTop animated:YES];
            message.text = @"";
            [message resignFirstResponder];
            messageNumber++;
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == contactsTableView)
    {
        if (filteredPeople.count==0) {
            self.contactsTableView.hidden = YES;
            bottomView.hidden = NO;
        }
        return filteredPeople.count;
    }
    else
    {
        return [[FreeSMSGlobals sharedFreeSMSGlobals].messageQueue count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellIdentifier1 = @"ContactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(tableView == contactsTableView)
    {
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier1];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        if (filteredPeople.count == indexPath.row)
        {
            cell.textLabel.text	= @"No Contacts Found!";
            cell.detailTextLabel.text = nil;
            cell.userInteractionEnabled = NO;
        }
        else
        {
            ABRecordID abRecordID = (ABRecordID)[[filteredPeople objectAtIndex:indexPath.row] intValue];
            ABRecordRef abPerson = ABAddressBookGetPersonWithRecordID([FreeSMSGlobals sharedFreeSMSGlobals].addressBook, abRecordID);
            cell.textLabel.text = (__bridge_transfer NSString *)ABRecordCopyCompositeName(abPerson);
            ABMultiValueRef phoneNumbers = ABRecordCopyValue(abPerson,kABPersonPhoneProperty);
            CFIndex temp = ABMultiValueGetIndexForIdentifier(phoneNumbers,0);
            NSString *phone = (__bridge_transfer NSString*) ABMultiValueCopyValueAtIndex(phoneNumbers, temp);
            cell.detailTextLabel.text = phone;
            CFRelease(phoneNumbers);
        }
        
    }
    else
    {
        MessageBean *bean = [[FreeSMSGlobals sharedFreeSMSGlobals].messageQueue objectAtIndex:indexPath.row];
        NSString *text = [bean message];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
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
                statusButton.tag = indexPath.row;
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
                reportButton.tag = indexPath.row;
                [reportButton addTarget:self action:@selector(infoIconTapped:) forControlEvents:UIControlEventTouchUpInside];
                [[cell contentView] addSubview:reportButton];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        backgroundImage.frame = CGRectMake(50, 5, 270, MAX(size.height+30, 5.0f));
        [messageLabel setFrame:CGRectMake(60, 7, 250, size.height+10)];
        if(![[bean messageStatus] isEqualToString:@"NO"])
        {
            _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(190,size.height+20, 120, 10)];
            NSDate *date = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"dd-MMM-yyyy hh:mm:ss a"];
            _dateLabel.text = [formatter stringFromDate:date];
            _dateLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
            [cell.contentView addSubview:_dateLabel];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == contactsTableView)
    {
        [contactsTableView setHidden:YES];
        if (indexPath.row == filteredPeople.count)
        {
            
        }
        else
        {
            NSNumber *personID = [filteredPeople objectAtIndex:indexPath.row];
            ABRecordID abRecordID = [personID intValue];
            ABRecordRef person = ABAddressBookGetPersonWithRecordID([FreeSMSGlobals sharedFreeSMSGlobals].addressBook, abRecordID);
            contactFirstName = (__bridge_transfer NSString *) ABRecordCopyValue(person,kABPersonFirstNameProperty);
            ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,kABPersonPhoneProperty);
            phoneNos = (__bridge NSArray *)(ABMultiValueCopyArrayOfAllValues(phoneNumbers));
            if(phoneNos == nil)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"No Phone Number Found!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                CFRelease(phoneNumbers);
            }
            else if(phoneNos.count > 1)
            {
                myActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select One" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
                myActionSheet.tag = 0;
                myActionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
                for(NSString *value1 in phoneNos)
                {
                    [myActionSheet addButtonWithTitle:value1];
                }
                [myActionSheet addButtonWithTitle:@"Cancel"];
                myActionSheet.cancelButtonIndex = myActionSheet.numberOfButtons-1;
                [myActionSheet showInView:self.view];
                CFRelease(phoneNumbers);
            }
            else
            {
                NSString *phoneNo = (__bridge_transfer NSString*) ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
                [self.contactPickerView addContact:phoneNo withName:contactFirstName];
                [self.selectedContacts setValue:contactFirstName forKey:phoneNo];
                CFRelease(phoneNumbers);
                bottomView.hidden = NO;
            }
        }
    }
    else
    {
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == chatViewTable)
    {
        MessageBean *tempobj = [[FreeSMSGlobals sharedFreeSMSGlobals].messageQueue objectAtIndex:indexPath.row];
        NSString *text = [tempobj message];
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        CGFloat height = MAX(size.height+20, 5.0f);
        return height + (CELL_CONTENT_MARGIN * 2);
    }
    return 45;
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 0)
    {
        if(buttonIndex != actionSheet.cancelButtonIndex)
        {
            [self.contactPickerView addContact:[phoneNos objectAtIndex:buttonIndex] withName:contactFirstName];
            [self.selectedContacts setValue:contactFirstName forKey:[phoneNos objectAtIndex:buttonIndex]];
//            [self.contactPickerView resignKeyboard];
            self.contactsTableView.hidden = YES;
        }
    }
    else if (actionSheet.tag == 1)
    {
        if (buttonIndex == 0)
        {
            [self resendMessage:messageNumberToBeReProcessed];
        }
    }
    bottomView.hidden = NO;
}
-(void)doneButtonPressed:(id)sender
{
    messageNumberToBeReProcessed = ((UIControl *) sender).tag;
    myActionSheet = [[UIActionSheet alloc] initWithTitle:@"What would you like to do?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Resend" otherButtonTitles:nil, nil];
    myActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    myActionSheet.tag = 1;
    [myActionSheet showInView:self.view];
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
-(BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == chatViewTable) {
        
        return YES;
    }
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (tableView == chatViewTable) {
        
        if (action == @selector(copy:))
        {
            return YES;
        }
        return NO;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (tableView == chatViewTable) {
        
        if(action == @selector(copy:))
        {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            MessageBean *tempobj = [[FreeSMSGlobals sharedFreeSMSGlobals].messageQueue objectAtIndex:indexPath.row];
            NSString *text = [tempobj message];
            [pasteboard setString:text];
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
        NSIndexPath *rowToReload = [NSIndexPath indexPathForRow:messageNumber inSection:0];
        NSArray *rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
        [self.chatViewTable reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
        [obj processMessage:messageNumber];
    }
    else
    {
        [Utils showAlert:@"Error!" :@"No Internet Connection Available"];
    }
}

#pragma MessageQueue Delegates Functions

-(void)messageSentSuccessfuly:(int)SMSCount
{
    //HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkblue.png"]];
	//HUD.mode = MBProgressHUDModeCustomView;
    //HUD.labelText = @"Sent";
    [HUD hide:YES];
    NSIndexPath *rowToReload = [NSIndexPath indexPathForRow:SMSCount inSection:0];
    NSArray *rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
    [self.chatViewTable reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
}

-(void)messageFailed:(int)SMSCount
{
    //HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"crossblue.png"]];
	//HUD.mode = MBProgressHUDModeCustomView;
    //HUD.labelText = @"Failed";
    [HUD hide:YES];
    NSIndexPath *rowToReload = [NSIndexPath indexPathForRow:SMSCount inSection:0];
    NSArray *rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
    [self.chatViewTable reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - THContactPickerTextViewDelegate

- (void)contactPickerTextViewDidChange:(NSString *)textViewText
{
    if (textViewText.length > 0)
    {
		[self.contactsTableView setHidden:NO];
		[self filterContentForSearchText:textViewText];
		[self.contactsTableView reloadData];
        [self.contactsTableView setContentOffset:CGPointMake(0,0) animated:NO];
	}
	else
    {
        bottomView.hidden = NO;
		[self.contactsTableView setHidden:YES];
	}
}

- (void)contactPickerDidResize:(THContactPickerView *)contactPickerView
{
    if(self.contactPickerView.frame.size.height == 76.000000)
    {
        self.chatViewTable.frame = CGRectMake(0, 77, 320, self.view.bounds.size.height - 80);
    }
    else
    {
        self.chatViewTable.frame = CGRectMake(0, 43, 320, self.view.bounds.size.height - 80);
    }
    [self adjustTableViewFrame];
    
}

- (void)contactPickerDidRemoveContact:(id)contact
{
    [self.selectedContacts removeObjectForKey:contact];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != alertView.cancelButtonIndex)
    {
        [self resendMessage:alertView.tag];
    }
}

@end