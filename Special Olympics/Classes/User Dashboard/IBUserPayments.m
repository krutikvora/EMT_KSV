//
//  IBUserPayments.m
//  iBuddyClient
//
//  Created by Anubha on 16/05/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import "IBUserPayments.h"

@interface IBUserPayments ()
{
    NSMutableDictionary *tempdict;
}
@end

@implementation IBUserPayments
@synthesize tblCustomCell;
@synthesize dictUserPayments;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark - View LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Added by Utkarsha so as to make iAds compatible to iOS 7 Layout
    [self setLayoutForiOS7];

    NSString *userID=[[kAppDelegate dictUserInfo]valueForKey:@"userId"];
    NSString *userPayment=[[kAppDelegate dictUserInfo]valueForKey:@"userPayments"];
    self.lblNoPayements.font = [UIFont fontWithName:kFont size:self.lblNoPayements.font.pointSize];
    
    tempdict=[self.dictUserPayments valueForKey:@"userPayments"];
    if (![tempdict count]>0&&([userID length]>0&&[userPayment isEqualToString:@"active"]))
    {
        NSMutableDictionary *dictUser=[self.dictUserPayments valueForKey:@"userDetail"];
        self.lblNoPayements.hidden=FALSE;
        
        if([[dictUser valueForKey:@"paymentType"] isEqualToString:@"GRU"])
        {
            self.lblNoPayements.text=@"You are registered as an educator.";
            
        }
        else
        {
            self.lblNoPayements.text=@"Payment has been made through Ambassador's code.";
            
        }
    }
    else if(![tempdict count]>0&&([userID length]>0&&[userPayment isEqualToString:@"inactive"])) {
        self.lblNoPayements.hidden=FALSE;
        self.lblNoPayements.text=@"You have not paid yet. Please go to the Purchase App screen to make payment.";
        
    }
    else{
        self.lblNoPayements.hidden=TRUE;
        
    }
    // Do any additional setup after loading the view from its nib.
}
- (void)viewDidUnload {
    [self setLblNoPayements:nil];
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown
            ||interfaceOrientation == UIInterfaceOrientationPortrait);
    
}
#pragma mark-TableView Delegate & Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 185;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [tempdict count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"CustomCell_Payment";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        if (kDevice==kIphone) {
            [[NSBundle mainBundle] loadNibNamed:@"CustomccellUserPayment" owner:self options:nil];
        }
        else{
            [[NSBundle mainBundle] loadNibNamed:@"CustomCellUserPayment_iPad" owner:self options:nil];
        }
            cell=tblCustomCell;
        cell.backgroundColor=nil;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    UILabel *lblTransactionID=(UILabel *)[cell viewWithTag:101];
    lblTransactionID.font = [UIFont fontWithName:kFont size:kAppDelegate.fontSizeSmall];
    UILabel *lblAmount=(UILabel *)[cell viewWithTag:102];
    lblAmount.font = [UIFont fontWithName:kFont size:kAppDelegate.fontSizeSmall];
    UILabel *lblDonation=(UILabel *)[cell viewWithTag:103];
    lblDonation.font = [UIFont fontWithName:kFont size:kAppDelegate.fontSizeSmall];
    UILabel *lblPaymentDate=(UILabel *)[cell viewWithTag:104];
    lblPaymentDate.font = [UIFont fontWithName:kFont size:kAppDelegate.fontSizeSmall];
    UILabel *LabelTransaction=(UILabel *)[cell viewWithTag:1001];
    LabelTransaction.font = [UIFont fontWithName:kFont size:kAppDelegate.fontSizeSmall];
    [LabelTransaction setText:[[tempdict valueForKey:@"transactionId"] objectAtIndex:indexPath.row]];
    
    UILabel *LabelAmount=(UILabel *)[cell viewWithTag:1002];
    LabelAmount.font = [UIFont fontWithName:kFont size:kAppDelegate.fontSizeSmall];
    [LabelAmount setText:[[tempdict valueForKey:@"amount"]  objectAtIndex:indexPath.row]];
    
    UILabel *LabelDonation=(UILabel *)[cell viewWithTag:1003];
    LabelDonation.font = [UIFont fontWithName:kFont size:kAppDelegate.fontSizeSmall];
    [LabelDonation setText:[[tempdict valueForKey:@"donation"]  objectAtIndex:indexPath.row]];
    
    UILabel *LabelDate=(UILabel *)[cell viewWithTag:1004];
    LabelDate.font = [UIFont fontWithName:kFont size:kAppDelegate.fontSizeSmall];
    [LabelDate setText:[[tempdict valueForKey:@"date_created"]  objectAtIndex:indexPath.row]];
    LabelDate.adjustsFontSizeToFitWidth=TRUE;
	return cell;
}


@end
