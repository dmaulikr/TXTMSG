//
//  AddNewTemplateViewController.h
//  FreeSMS
//
//  Created by Rajan Balana on 11/10/12.
//  Copyright (c) 2012 Rajan Balana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplatesViewController.h"
@class TemplatesViewController;

@interface AddNewTemplateViewController : UIViewController<UITextViewDelegate>
{
     TemplatesViewController *templatesView;
}
@property (nonatomic, retain) IBOutlet UITextView *templateTextView;
@property (nonatomic, retain) IBOutlet UILabel *characterCount;
@property (nonatomic, retain) NSManagedObjectContext *context;

@end
