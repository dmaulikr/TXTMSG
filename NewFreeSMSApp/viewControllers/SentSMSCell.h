//
//  SentSMSCell.h
//  FreeSMS
//
//  Created by Rajan Balana on 06/10/12.
//  Copyright (c) 2012 Rajan Balana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SentSMSCell : UITableViewCell
{
    IBOutlet UILabel *sentfromlabel;
    IBOutlet UILabel *sentdate;
    IBOutlet UILabel *messagesent;
}
@property (nonatomic, retain) IBOutlet UILabel *sentfromlabel;
@property (nonatomic, retain) IBOutlet UILabel *sentdate;
@property (nonatomic, retain) IBOutlet UILabel *messagesent;
@end
