       //
//  IBUserOffersVC.m
//  iBuddyClient
//
//  Created by Anubha on 17/05/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//
#import "IBUserOffersVC.h"
#import "UIImageView+WebCache.h"
#define kOfferTableWidthIPhone 166
#define kOfferTableWidthIPad 455

#define kIncrementFactorOffer 5
#define kTableCellGapFromYOffer 7
@interface IBUserOffersVC ()

@end

@implementation IBUserOffersVC
@synthesize strMerchantID;
@synthesize tblCustomCellOffer;
@synthesize dict_OffersList;
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

    [self getRedeemedOffers];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidUnload {
    [self setTblOffers:nil];
    [super viewDidUnload];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown
            ||interfaceOrientation == UIInterfaceOrientationPortrait);
    
}
#pragma mark Get Data
-(void)getRedeemedOffers
{
        
        [kAppDelegate showProgressHUD:self.view];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:[[kAppDelegate dictUserInfo]valueForKey:@"userId"] forKey:@"userId"];
        [dict setValue:strMerchantID  forKey:@"merchantId"];
        [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:(NSMutableDictionary *) dict method:kredeemedoffersbyuser] completeBlock:^(NSData *data) {
            
            id result = [NSJSONSerialization JSONObjectWithData:data
                                                        options:kNilOptions error:nil];
            if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
                self.tblOffers.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
                if (self.dict_OffersList) {
                    self.dict_OffersList=nil;
                }
                self.dict_OffersList=[[NSMutableDictionary alloc]init];
                self.dict_OffersList=[result valueForKey:@"offersList"];
                [self.tblOffers reloadData];
            }
            
            else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]){
                
                [CommonFunction fnAlert:@"" message:@"No offers exist"];
            }
            else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]){
                [CommonFunction fnAlert:@"" message:@"Please try again"];
            }
            else {
                [CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
                
            }
           
            [kAppDelegate hideProgressHUD];
            
        } errorBlock:^(NSError *error) {
            if (error.code == NSURLErrorTimedOut) {
                [CommonFunction fnAlert:@"Alert!" message:kAlerTimedOut];
            }
            else{
            [CommonFunction fnAlert:@"Error" message:[error localizedDescription]];
            }
            [kAppDelegate hideProgressHUD];
        }];
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
    return [self.dict_OffersList count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"customCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
        if (kDevice==kIphone) {
            if (cell == nil){
                [[NSBundle mainBundle] loadNibNamed:@"IBUserOffersTableCell" owner:self options:nil];
                cell=tblCustomCellOffer;
            }
        }
        else{
            if (cell == nil){
                [[NSBundle mainBundle] loadNibNamed:@"IBUserOfferTableCell_iPad" owner:self options:nil];
                cell=tblCustomCellOffer;
            }
            cell.backgroundColor=nil;
        }
    
    UIImageView *imgView=(UIImageView *)[cell viewWithTag:101];
    [imgView setImageWithURL:[NSURL URLWithString:[[self.dict_OffersList  valueForKey:@"offerThumbImage"] objectAtIndex:indexPath.row]]
            placeholderImage:[UIImage imageNamed:@"dummy_image@2x.png"]];
    
    UILabel *lblOfferTitle=(UILabel *)[cell viewWithTag:102];
    lblOfferTitle.text=[[self.dict_OffersList  valueForKey:@"offerTitle"] objectAtIndex:indexPath.row];
    lblOfferTitle.textColor=[UIColor whiteColor];
    lblOfferTitle.frame=CGRectMake(lblOfferTitle.frame.origin.x, lblOfferTitle.frame.origin.y ,lblOfferTitle.frame.size.width,[CommonFunction heightOfOfferCell:[[self.dict_OffersList  valueForKey:@"offerTitle"] objectAtIndex:indexPath.row] andWidth:lblOfferTitle.frame.size.width fontName:kFont fontSize:kAppDelegate.fontSize]);
    lblOfferTitle.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
    
    UILabel *lblOfferDate=(UILabel *)[cell viewWithTag:103];
    lblOfferDate.text=[NSString stringWithFormat:@"Date: %@",[[self.dict_OffersList  valueForKey:@"redemptionDate"] objectAtIndex:indexPath.row]];
    lblOfferDate.frame=CGRectMake(lblOfferDate.frame.origin.x, lblOfferTitle.frame.origin.y + lblOfferTitle.frame.size.height, lblOfferDate.frame.size.width,[CommonFunction heightOfOfferCell:[NSString stringWithFormat:@"Date: %@",[[self.dict_OffersList  valueForKey:@"redemptionDate"] objectAtIndex:indexPath.row]] andWidth:lblOfferDate.frame.size.width fontName:kFont3 fontSize:kAppDelegate.fontSizeSmall]);
    lblOfferDate.font = [UIFont fontWithName:kFont3 size:kAppDelegate.fontSizeSmall];
    
    UILabel *lblOfferTime=(UILabel *)[cell viewWithTag:104];
    lblOfferTime.text=[NSString stringWithFormat:@"Time: %@",[[self.dict_OffersList  valueForKey:@"redemptionTime"] objectAtIndex:indexPath.row]];
    lblOfferTime.frame=CGRectMake(lblOfferTime.frame.origin.x, lblOfferDate.frame.origin.y + lblOfferDate.frame.size.height, lblOfferTime.frame.size.width,[CommonFunction heightOfOfferCell:[NSString stringWithFormat:@"Time: %@",[[self.dict_OffersList  valueForKey:@"redemptionTime"] objectAtIndex:indexPath.row]] andWidth:lblOfferTime.frame.size.width fontName:kFont3 fontSize:kAppDelegate.fontSizeSmall]);
    lblOfferTime.font = [UIFont fontWithName:kFont3 size:kAppDelegate.fontSizeSmall];
       
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
       [CommonFunction callHideViewFromSideBar];
     IBUserOfferSecription *objIBOffersDescriptionVC;
     if (kDevice==kIphone) {
       objIBOffersDescriptionVC  =[[IBUserOfferSecription alloc]initWithNibName:@"IBUserOfferSecription" bundle:nil];

    }
    else{
        objIBOffersDescriptionVC  =[[IBUserOfferSecription alloc]initWithNibName:@"IBUserOfferSecription_iPad" bundle:nil];
 
    }
    NSArray *arrDict_OfferDetail = (NSArray *)self.dict_OffersList;
    objIBOffersDescriptionVC.dict_OfferDetail=[arrDict_OfferDetail objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:objIBOffersDescriptionVC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height=0;
    float width=0;
    if (kDevice==kIphone) {
        width=kOfferTableWidthIPhone;
    }else{
        width=kOfferTableWidthIPad;
    }
    
    height=[CommonFunction heightOfOfferCell:[NSString stringWithFormat:@"Date: %@",[[self.dict_OffersList  valueForKey:@"redemptionDate"] objectAtIndex:indexPath.row]] andWidth:width fontName:kFont3 fontSize:kAppDelegate.fontSizeSmall] + [CommonFunction heightOfOfferCell:[NSString stringWithFormat:@"Time: %@",[[self.dict_OffersList  valueForKey:@"redemptionTime"] objectAtIndex:indexPath.row]] andWidth:width fontName:kFont3 fontSize:kAppDelegate.fontSizeSmall] + [CommonFunction heightOfOfferCell:[[self.dict_OffersList  valueForKey:@"offerTitle"] objectAtIndex:indexPath.row] andWidth:width fontName:kFont fontSize:kAppDelegate.fontSize]+ kTableCellGapFromYOffer;
   
    if (height<50) {
        height=50+kTableCellGapFromYOffer+kIncrementFactorOffer;
    }
    else{
        height=height+kIncrementFactorOffer;
    }
    return height;
}
#pragma mark -
#pragma mark - Buttons Action
/*
 Action back button
 */
- (IBAction)btnBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
