//
//  AddNewTemplateViewController.m
//  FreeSMS
//
//  Created by Rajan Balana on 11/10/12.
//  Copyright (c) 2012 Rajan Balana. All rights reserved.
//

#import "AddNewTemplateViewController.h"
#import "FreeSMSAppDelegate.h"
#import "Templates.h"

@interface AddNewTemplateViewController ()

@end

@implementation AddNewTemplateViewController
@synthesize templateTextView,characterCount,context;

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
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    label.text = NSLocalizedString(@"Add Template", @"");
    [label sizeToFit];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.0f/255.0f green:115.0f/255.0f blue:209.0f/255.0f alpha:0.0f]];
    UIBarButtonItem * addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveTemplateClicked)];
    [self.navigationItem setRightBarButtonItem:addButton];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)textViewDidChange:(UITextView *)textView
{
	int maxChars = 140;
	int charsLeft = maxChars - [textView.text length];
    NSString *temp = [textView text];
    if([textView.text length] == 0 )
    {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    else
    {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
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
-(void)saveTemplateClicked
{
    [templateTextView resignFirstResponder];
    context = [(FreeSMSAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSError *_savingError;
    Templates *Templates = [NSEntityDescription
                        insertNewObjectForEntityForName:@"Templates"
                        inManagedObjectContext:context];
    Templates.content = templateTextView.text;
    [context save:&_savingError];
    if(_savingError)
    {
        NSLog(@"Something went wrong while saving template to database");
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
