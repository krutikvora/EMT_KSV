//
//  KSOffersViewController.m
//  iBuddyClub
//
//  Created by Karamjeet Singh on 12/03/13.
//  Copyright (c) 2013 Netsmartz Info Tech. All rights reserved.
//

#import "KSOffersViewController.h"
#import "KSOfferDetailsViewController.h"
#import "UIImageView+WebCache.h"
#define kOfferTableMerchantWidthIPhone 209
#define kOfferTableMerchantWidthIPad 493
#define kIncrementFactorMerchant 5
#define kTableCellGapFromYMerchant 7
@interface KSOffersViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tbl_OffersList;
@property (weak, nonatomic) IBOutlet UIButton *btn_Back;
@property (weak, nonatomic) IBOutlet UILabel *lbl_ScreenTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;


@end

@implementation KSOffersViewController
@synthesize viewForOffer;
@synthesize dict_OffersList;
@synthesize userID;
@synthesize isSubscribed;
@synthesize tblCustomCellOffer;

#pragma mark -
#pragma mark - View Life Cycle
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

	// Do any additional setup after loading the view.
    
    if(!iOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        _tbl_OffersList.frame=CGRectMake(_tbl_OffersList.frame.origin.x
                                         , _tbl_OffersList.frame.origin.y, _tbl_OffersList.frame.size.width, _tbl_OffersList.frame.size.height+40);
        _imgBackground.frame=CGRectMake(_imgBackground.frame.origin.x
                                        , _imgBackground.frame.origin.y, _imgBackground.frame.size.width, _imgBackground.frame.size.height+40);
    }
    
    self.lbl_ScreenTitle.font=[UIFont fontWithName:kFont size:self.lbl_ScreenTitle.font.pointSize];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    if (viewForOffer==viewForOffersMerchant) {
        self.btn_Back.hidden=TRUE;
        [self getMerchantOffer];
    }else if (viewForOffer==viewForScannedoffersMerchant){
        self.btn_Back.hidden=FALSE;
        [self getScannedOffer];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidUnload {
    [self setTbl_OffersList:nil];
    [self setBtn_Back:nil];
    [super viewDidUnload];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown
            ||interfaceOrientation == UIInterfaceOrientationPortrait);
    
}
#pragma mark-
#pragma mark - Private Methods


#pragma mark -
#pragma mark - Button Action
/*
 Action Back button
 */

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 
#pragma mark - WebService
/**
 @Method   -  getMerchantOffer - -> get merchant offer list
 @param    -  merchantId
 @Responce -  status = 1 -> success - return offersList
              status = 0 -> no records
              status = -1 -> error
 */

-(void)getMerchantOffer{
    [kAppDelegate showProgressHUD:self.view];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[CommonFunction getValueFromUserDefault:kMerchantId] forKey:@"merchantId"];
    
    [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dict method:koffersbymerchant] completeBlock:^(NSData *data) {
        id result = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions error:nil];
        if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
            if (self.dict_OffersList) {
                self.dict_OffersList=nil;
            }
            self.dict_OffersList=[[NSMutableDictionary alloc]init];
            self.dict_OffersList=result;
            [self.tbl_OffersList reloadData];
        }else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]){
            [CommonFunction fnAlert:@"" message:@"No records exist"];
        }else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]){
            [CommonFunction fnAlert:@"" message:@"Please try again"];
        }
        else {
            [CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];

                    }
        [kAppDelegate hideProgressHUD];
        
    } errorBlock:^(NSError *error) {
        [CommonFunction fnAlert:@"Error" message:[error localizedDescription]];
        [kAppDelegate hideProgressHUD];
    }];
}
/**
 @Method   -  getScanedOffer - -> get merchant offer list by scaning QR code
 @param    -  merchantId, userId (from scaned QR code)
 @Responce -  status = 1 -> success - return offersList
 status = 0 -> no records
 status = -1 -> error
 */
-(void)getScannedOffer{
    [kAppDelegate showProgressHUD:self.view];
    //  NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    int intUserID=[self.userID intValue];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [CommonFunction getValueFromUserDefault:kMerchantId], @"merchantId",
                          [NSString stringWithFormat:@"%d",intUserID], @"userId",
                          nil];
     
    [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:(NSMutableDictionary *) dict method:kuseravailableoffers] completeBlock:^(NSData *data) {
        
        id result = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions error:nil];
        
        if ([[result valueForKey:@"isSubscribed"] isEqualToString:@"yes"]&&[[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
            self.isSubscribed=TRUE;
            if (self.dict_OffersList) {
                self.dict_OffersList=nil;
            }
            
            self.dict_OffersList=[[NSMutableDictionary alloc]init];
            self.dict_OffersList=result;
            [self.tbl_OffersList reloadData];
        }
        else if([[result valueForKey:@"isSubscribed"] isEqualToString:@"no"]&&[[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]])
        {
            self.isSubscribed=FALSE;
            [CommonFunction fnAlert:@"" message:@"Your iBuddyClub account is not active, please subscribe or renew."];
        }
        
        else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]){
            [CommonFunction fnAlert:@"" message:@"Your iBuddyClub account is not active, please subscribe or renew."];}
        else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]){
            [CommonFunction fnAlert:@"" message:@"Please try again"];
            
           
        }
        else {
            [CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];

            
        }
        [kAppDelegate hideProgressHUD];
        
    } errorBlock:^(NSError *error) {
        [CommonFunction fnAlert:@"Error" message:[error localizedDescription]];
        [kAppDelegate hideProgressHUD];
    }];
}
#pragma mark-
#pragma mark - delegate Methods

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
    NSMutableArray *arrData=[self.dict_OffersList valueForKey:@"offersList"];

    return [arrData count] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{  
    static NSString *CellIdentifier = @"customCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (tableView.tag!=1001) {
        if (kDevice==kIphone) {
            if (cell == nil){
                [[NSBundle mainBundle] loadNibNamed:@"IBOfferTableCell_Merchant" owner:self options:nil];
                cell=tblCustomCellOffer;
            }
        }
        else{
            if (cell == nil){
                [[NSBundle mainBundle] loadNibNamed:@"IBOfferTableCell_iPad_Merchant" owner:self options:nil];
                cell=tblCustomCellOffer;
                cell.backgroundColor = nil;
            }
        }
    }
    UIImageView *imgView=(UIImageView *)[cell viewWithTag:101];
    [imgView setImageWithURL:[NSURL URLWithString:[[[self.dict_OffersList valueForKey:@"offersList"]valueForKey:@"offerThumbImage"] objectAtIndex:indexPath.row]]
            placeholderImage:[UIImage imageNamed:@""]];
    imgView.backgroundColor=[UIColor clearColor];
    [imgView setClipsToBounds:YES];
    UIImageView *imgSelected=[[UIImageView alloc]init];
    imgSelected.image=[UIImage imageNamed:@"RowHighlight@2x.png"];//OffersListBG_iPad@2x
    [cell setSelectedBackgroundView:imgSelected];
    cell.tag=indexPath.row;
    
    
    UILabel *lblOfferTitle=(UILabel *)[cell viewWithTag:102];
    
    if (viewForOffer==viewForOffersMerchant) {
        lblOfferTitle.text=[[[self.dict_OffersList valueForKey:@"offersList"]valueForKey:@"offerTitle"] objectAtIndex:indexPath.row];
       lblOfferTitle.textColor=[UIColor whiteColor];
        
    }else if (viewForOffer==viewForScannedoffersMerchant){
       lblOfferTitle.text=[[[self.dict_OffersList valueForKey:@"offersList"]valueForKey:@"offerTitle"] objectAtIndex:indexPath.row];
        
        if (![[[[self.dict_OffersList valueForKey:@"offersList"]valueForKey:@"availableCount"] objectAtIndex:indexPath.row]isEqualToString:@"0"]) {
            lblOfferTitle.textColor=[UIColor whiteColor];
            lblOfferTitle.highlightedTextColor=[UIColor whiteColor];
        }else{
            lblOfferTitle.textColor=[UIColor redColor];
            lblOfferTitle.highlightedTextColor=[UIColor redColor];
        }
    }
     lblOfferTitle.frame=CGRectMake(lblOfferTitle.frame.origin.x, lblOfferTitle.frame.origin.y, lblOfferTitle.frame.size.width,[CommonFunction heightOfOfferCell:[[[self.dict_OffersList valueForKey:@"offersList"]valueForKey:@"offerTitle"] objectAtIndex:indexPath.row] andWidth:lblOfferTitle.frame.size.width fontName:kFont fontSize:kAppDelegate.fontSize]);
    /*font should always be set before size to fit property*/
    lblOfferTitle.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
   // [lblOfferTitle sizeToFit];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[CommonFunction getDeviceName:@"MainStoryboard_"] bundle:nil];
    KSOfferDetailsViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"offerDetails"];
    viewController.dict_OfferDetail=[[self.dict_OffersList valueForKey:@"offersList"] objectAtIndex:indexPath.row];
    viewController.userID=userID;
    viewController.isSubscribed=self.isSubscribed;
    [self.navigationController pushViewController:viewController animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    float height=0;
//    if (kDevice==kIphone) {
//        height=[CommonFunction heightOfOfferCell:[[[self.dict_OffersList valueForKey:@"offersList"]objectAtIndex:indexPath.row] valueForKey:@"offerTitle"] andWidth:209 fontName:kFontMerchant fontSize:kFontSize1];
//        if (height<50) {
//            height=65;
//        }
//        else{
//            height=height+15;
//        }
//    }
//    else{
//        height=[CommonFunction heightOfOfferCell:[[[self.dict_OffersList valueForKey:@"offersList"]objectAtIndex:indexPath.row] valueForKey:@"offerTitle"] andWidth:493 fontName:kFontMerchant fontSize:kFontSize1];
//        if (height<50) {
//            height=65;
//        }
//        else{
//            height=height+15;
//        }
//    }
    float height=0;
    float width=0;
    if (kDevice==kIphone) {
        width=kOfferTableMerchantWidthIPhone;
    }else{
        width=kOfferTableMerchantWidthIPad;
    }
    height=[CommonFunction heightOfOfferCell:[[[self.dict_OffersList valueForKey:@"offersList"]objectAtIndex:indexPath.row] valueForKey:@"offerTitle"] andWidth:width fontName:kFont fontSize:kAppDelegate.fontSize]+kTableCellGapFromYMerchant;
    if (height<50) {
        height=50+kTableCellGapFromYMerchant+kIncrementFactorMerchant;
    }
    else{
        height=height+kIncrementFactorMerchant;
    }
    return height;
}
@end
