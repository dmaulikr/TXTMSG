//
//  SMSGatewaysViewController.m
//  FreeSMS
//
//  Created by Rajan Balana on 16/10/12.
//  Copyright (c) 2012 Rajan Balana. All rights reserved.
//

#import "SMSGatewaysViewController.h"
#import "AddGatewayViewController.h"
#import "TSMiniWebBrowser.h"

@interface SMSGatewaysViewController ()

@end

@implementation SMSGatewaysViewController
@synthesize SMSGatewaysTable;

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
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    label.text = NSLocalizedString(@"SMS Gateways", @"");
    [label sizeToFit];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.0f/255.0f green:115.0f/255.0f blue:209.0f/255.0f alpha:0.0f]];
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grey.png"]];
    [tempImageView setFrame:self.SMSGatewaysTable.frame];
    self.SMSGatewaysTable.backgroundView = tempImageView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 4;
    }
    else if (section == 1)
    {
        return 0;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell== nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if(indexPath.row == 0)
    {
        cell.textLabel.text = @"Way2SMS";
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"register.gif"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = indexPath.row;
        button.frame = CGRectMake(self.view.bounds.size.width - 205, 5, 100, 30);
        [cell.contentView addSubview:button];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if(indexPath.row == 1)
    {
        cell.textLabel.text = @"160by2";
        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button1 setBackgroundImage:[UIImage imageNamed:@"register.gif"] forState:UIControlStateNormal];
        [button1 addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        button1.frame = CGRectMake(self.view.bounds.size.width - 205, 5, 100, 30);
                button1.tag = indexPath.row;
        [cell.contentView addSubview:button1];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if(indexPath.row == 2)
    {
        cell.textLabel.text = @"FullOnSMS";
        UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button2 setBackgroundImage:[UIImage imageNamed:@"register.gif"] forState:UIControlStateNormal];
        [button2 addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        button2.frame = CGRectMake(self.view.bounds.size.width - 205, 5, 100, 30);
                button2.tag = indexPath.row;
        [cell.contentView addSubview:button2];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if(indexPath.row == 3)
    {
        cell.textLabel.text = @"Site2SMS";
        UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button2 setBackgroundImage:[UIImage imageNamed:@"register.gif"] forState:UIControlStateNormal];
        [button2 addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        button2.frame = CGRectMake(self.view.bounds.size.width - 205, 5, 100, 30);
        button2.tag = indexPath.row;
        [cell.contentView addSubview:button2];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return @"Indian SMS Gateways";
    }
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        AddGatewayViewController *addGatewayView;
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            addGatewayView = [[AddGatewayViewController alloc] initWithNibName:@"AddGatewayViewController" bundle:nil];
        }
        else
        {
            addGatewayView = [[AddGatewayViewController alloc] initWithNibName:@"AddGatewayViewController~iPad" bundle:nil];
        }
        if (indexPath.row == 0)
        {
            addGatewayView.gateway = @"Way2SMS";
        }
        else if(indexPath.row == 1)
        {
            addGatewayView.gateway = @"160by2";
        }
        else if (indexPath.row == 2)
        {
            addGatewayView.gateway = @"FullOnSMS";
        }
        else if (indexPath.row == 3)
        {
            addGatewayView.gateway = @"Site2SMS";
        }
        [self.navigationController pushViewController:addGatewayView animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}
-(void)buttonTapped:(UIButton *)sender
{
    TSMiniWebBrowser *webBrowser;
    if(sender.tag == 0)
    {
        webBrowser = [[TSMiniWebBrowser alloc]initWithUrl:[NSURL URLWithString:@"http://www.way2sms.com"]];
        
    }
    else if (sender.tag == 1)
    {
        webBrowser = [[TSMiniWebBrowser alloc]initWithUrl:[NSURL URLWithString:@"http://www.160by2.com"]];
    }
    else if (sender.tag == 2)
    {
        webBrowser = [[TSMiniWebBrowser alloc]initWithUrl:[NSURL URLWithString:@"http://www.fullonsms.com"]];
    }
    else if (sender.tag == 3)
    {
        webBrowser = [[TSMiniWebBrowser alloc]initWithUrl:[NSURL URLWithString:@"http://www.site2sms.com"]];
    }
    webBrowser.showURLStringOnActionSheetTitle = NO;
    webBrowser.showPageTitleOnTitleBar = YES;
    webBrowser.showActionButton = YES;
    webBrowser.showReloadButton = YES;
    webBrowser.mode = TSMiniWebBrowserModeNavigation;
    webBrowser.barStyle = UIBarStyleBlack;
    
    [self.navigationController pushViewController:webBrowser animated:YES];
}
@end
