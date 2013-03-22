//
//  ConversationViewController.h
//  FreeSMS
//
//  Created by Rajan Balana on 27/10/12.
//  Copyright (c) 2012 Rajan Balana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageSending.h"
#import "MBProgressHUD.h"

@interface ConversationViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,ProgressDelegate,UIActionSheetDelegate,UIScrollViewDelegate,UITextViewDelegate,MBProgressHUDDelegate,UIAlertViewDelegate>
{
    UITextView *messageLabel;
    UIImageView *backgroundImage;
    IBOutlet UITableView *conversationTable;
    UILabel *_dateLabel;
    BOOL messageValidation;
    IBOutlet UILabel *characterCount;
    UIActivityIndicatorView *spinner;
    UIActionSheet *myActionSheet;
    IBOutlet UIView *bottomView;
    MBProgressHUD *HUD;
}
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSString *recipientNumber;
@property (nonatomic, strong) NSMutableArray *fetchedConversation;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UITextView *message;

-(IBAction)sendClicked;
@end
