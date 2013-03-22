//
//  SendSMSViewController.h
//  FreeSMS
//
//  Created by Rajan Balana on 13/09/12.
//  Copyright (c) 2012 Rajan Balana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "MenuViewController.h"
#import "MessageSending.h"
#import "THContactPickerView.h"
#import "MBProgressHUD.h"

@class MenuViewController;

@interface SendSMSViewController : UIViewController <ABPeoplePickerNavigationControllerDelegate,UITextViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,ProgressDelegate,UIActionSheetDelegate,THContactPickerDelegate,UIScrollViewDelegate,MBProgressHUDDelegate,UIAlertViewDelegate>
{
    MenuViewController *menuView;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UITableView *chatViewTable;
    NSMutableArray *userAccounts;
    UIBarButtonItem *doneButton;
    IBOutlet UIButton *accountButton;
    UISegmentedControl *closeButton;
    UIActionSheet *myActionSheet;
    NSString *selectedAccountUsername;
    UITextView *messageLabel;
    UIImageView *backgroundImage;
    UIActivityIndicatorView *spinner;
    NSInteger buttonID;
    UILabel *_dateLabel;
    UIImageView *backgroundTextBox;
    IBOutlet UIView *bottomView;
    IBOutlet UIView *topView;
    IBOutlet UILabel *contactsLabel;
    UIButton *contactButton;
    MBProgressHUD *HUD;
    UIButton *keyboardHideButton;
}

@property (nonatomic, strong) THContactPickerView *contactPickerView;
@property (nonatomic, retain) NSMutableArray *people;
@property (nonatomic, retain) NSMutableArray *peopleFiltered;
@property (nonatomic, retain) NSString *contactsReceived;
@property (nonatomic, retain) NSString *messageReceived;
@property (nonatomic, assign) BOOL messageStatus;
@property (nonatomic, assign) BOOL contactValidation;
@property (nonatomic, assign) BOOL messageValidation;
@property (assign, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSString *value;
@property (nonatomic, retain) IBOutlet UITextField *contacts;
@property (nonatomic, retain) IBOutlet UITextView *message;
@property (nonatomic, retain) IBOutlet UILabel *characterCount;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UITableView *chatViewTable;
@property (nonatomic, retain) UILabel *dateLabel;
@property (nonatomic, retain) UITableView *contactsTableView;
@property (nonatomic, strong) NSMutableArray *filteredPeople;
@property (nonatomic, strong) NSMutableDictionary *selectedContacts;
@property (nonatomic, strong) IBOutlet UILabel *contactsLabel;

-(IBAction)hiiClicked;
-(IBAction)sendClicked;
-(void)messageFieldValidatior;
-(void)contactFieldValidatior;
-(void)showTopView;
@end