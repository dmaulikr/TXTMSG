//
//  SentSMSCell.m
//  FreeSMS
//
//  Created by Rajan Balana on 06/10/12.
//  Copyright (c) 2012 Rajan Balana. All rights reserved.
//

#import "SentSMSCell.h"

@implementation SentSMSCell
@synthesize sentdate,sentfromlabel,messagesent;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
