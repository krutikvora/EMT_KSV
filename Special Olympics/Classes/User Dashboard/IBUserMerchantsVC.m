//
//  IBUserMerchantsVC.m
//  iBuddyClient
//
//  Created by Anubha on 10/07/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import "IBUserMerchantsVC.h"
#import "UIImageView+WebCache.h"
#define kMerchantTableWidthIPhone 175
#define kMerchantTableWidthIPad 510
#define kIncrementFactorMerchant 5
#define kTableCellGapFromYMerchant 7
@interface IBUserMerchantsVC ()

@end

@implementation IBUserMerchantsVC
@synthesize dict_MerchantList;
@synthesize tblCustomCellMerchant;
#pragma mark lifeCycle
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
    //Added by Utkarsha so as to make iAds compatible to iOS 7 Layout
    [self setLayoutForiOS7];

    self.lblNoMerchants.font = [UIFont fontWithName:kFont size:self.lblNoMerchants.font.pointSize];
    NSString *userID=[[kAppDelegate dictUserInfo]valueForKey:@"userId"];
    NSString *userPayment=[[kAppDelegate dictUserInfo]valueForKey:@"userPayments"];
    if (![self.dict_MerchantList count]>0&&([userID length]>0&&[userPayment isEqualToString:@"active"])) {
        self.lblNoMerchants.hidden=FALSE;
        self.lblNoMerchants.text=@"No Offers have been redeemed.";
        _tblMerchants.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    else if(![self.dict_MerchantList count]>0>0&&([userID length]>0&&[userPayment isEqualToString:@"inactive"])) {
        self.lblNoMerchants.text=@"You have not paid yet. Please go to the Purchase App screen to make payment and redeem offers.";
        self.lblNoMerchants.hidden=FALSE;
        _tblMerchants.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    else{
        _tblMerchants.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        self.lblNoMerchants.hidden=TRUE;
        
    }
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTblMerchants:nil];
    [self setLblNoMerchants:nil];
    [super viewDidUnload];
}
#pragma mark -
#pragma mark - UITableView Deletgate & Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
    return [self.dict_MerchantList count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        
        static NSString *CellIdentifier = @"merchantCellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (kDevice==kIphone) {
            if (cell == nil){
                [[NSBundle mainBundle] loadNibNamed:@"IBMerchantTableCell_iPhone" owner:self options:nil];
                cell=tblCustomCellMerchant;
            }
        }
        else{
            if (cell == nil){
                [[NSBundle mainBundle] loadNibNamed:@"IBMerchantCustomCell_iPad" owner:self options:nil];
                cell=tblCustomCellMerchant;
            }
            cell.backgroundColor=nil;
        }
        UIImageView *imgView=(UIImageView *)[cell viewWithTag:101];
        [imgView setImageWithURL:[NSURL URLWithString:[[self.dict_MerchantList valueForKey:@"thumb"] objectAtIndex:indexPath.row]]
                placeholderImage:[UIImage imageNamed:@"dummy_image@2x.png"]];
        UILabel *lblMerchantTitle=(UILabel *)[cell viewWithTag:102];
        lblMerchantTitle.text=[[self.dict_MerchantList valueForKey:@"merchantName"] objectAtIndex:indexPath.row];
        lblMerchantTitle.textColor=[UIColor whiteColor];
        lblMerchantTitle.frame=CGRectMake(lblMerchantTitle.frame.origin.x, lblMerchantTitle.frame.origin.y, lblMerchantTitle.frame.size.width,[CommonFunction heightOfOfferCell:[[self.dict_MerchantList valueForKey:@"merchantName"] objectAtIndex:indexPath.row] andWidth:lblMerchantTitle.frame.size.width fontName:kFont fontSize:kAppDelegate.fontSize]);
        lblMerchantTitle.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
        
        UILabel *lblStateName=(UILabel *)[cell viewWithTag:103];
        
        NSString *strCityName=[[self.dict_MerchantList valueForKey:@"cityName"] objectAtIndex:indexPath.row];
        strCityName=[strCityName stringByAppendingString:@", "];
        strCityName=[strCityName stringByAppendingString:[[self.dict_MerchantList valueForKey:@"stateName"] objectAtIndex:indexPath.row]];
        lblStateName.frame=CGRectMake(lblStateName.frame.origin.x, lblMerchantTitle.frame.origin.y + lblMerchantTitle.frame.size.height , lblMerchantTitle.frame.size.width,[CommonFunction heightOfOfferCell:strCityName andWidth:lblStateName.frame.size.width fontName:kFont3 fontSize:kAppDelegate.fontSizeSmallest]);
        
        lblStateName.text=strCityName;
        lblStateName.textColor=[UIColor whiteColor];
        lblStateName.font=[UIFont fontWithName:kFont3 size:kAppDelegate.fontSizeSmallest];
    
        return cell;
        
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [CommonFunction callHideViewFromSideBar];
    
    
    IBUserOffersVC *objIBOffersVC;
    if (kDevice==kIphone) {
        objIBOffersVC   =[[IBUserOffersVC alloc]initWithNibName:@"IBUserOffersVC" bundle:nil];
    }
    else{
        objIBOffersVC   =[[IBUserOffersVC alloc]initWithNibName:@"IBUserOffers_iPad" bundle:nil];
    }
   objIBOffersVC.strMerchantID=[[self.dict_MerchantList valueForKey:@"merchantId"] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:objIBOffersVC animated:YES];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    float height=0;
    float width=0;
    if (kDevice==kIphone) {
        width=kMerchantTableWidthIPhone;
    }else{
        width=kMerchantTableWidthIPad;
    }
    
    NSString *strCityName=[[self.dict_MerchantList valueForKey:@"cityName"] objectAtIndex:indexPath.row];
    strCityName=[strCityName stringByAppendingString:@", "];
    strCityName=[strCityName stringByAppendingString:[[self.dict_MerchantList valueForKey:@"stateName"] objectAtIndex:indexPath.row]];
    
    height=[CommonFunction heightOfOfferCell:[[self.dict_MerchantList valueForKey:@"merchantName"] objectAtIndex:indexPath.row] andWidth:width fontName:kFont3 fontSize:kAppDelegate.fontSize] + [CommonFunction heightOfOfferCell:strCityName andWidth:width fontName:kFont3 fontSize:kAppDelegate.fontSizeSmallest] +  kTableCellGapFromYMerchant;
    
    
    if (height<50) {
        height=50+kTableCellGapFromYMerchant+kIncrementFactorMerchant;
    }
    else{
        height=height+kIncrementFactorMerchant;
    }
    return height;
}

@end
