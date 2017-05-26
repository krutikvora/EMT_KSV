//
//  IBMerchantsViewController.m
//  iBuddyClient
//
//  Created by Utkarsha on 08/05/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import "IBMerchantsViewController.h"
#import "UIImageView+WebCache.h"
#import "KSOffersViewController.h"


@interface IBMerchantsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tbl_MerchantList;
@property (weak, nonatomic) IBOutlet UIButton *btn_Back;
@property (weak, nonatomic) IBOutlet UILabel *lbl_ScreenTitle;

@end

@implementation IBMerchantsViewController
@synthesize dict_MerchantsList,tbl_MerchantList,btn_Back,lbl_ScreenTitle,tblCustomCell;

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
	// Do any additional setup after loading the view.
    //Added by Utkarsha so as to make iAds compatible to iOS 7 Layout
    [self setLayoutForiOS7];
    
	// Do any additional setup after loading the view.
    
    if(!iOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        tbl_MerchantList.frame=CGRectMake(tbl_MerchantList.frame.origin.x
                                         , tbl_MerchantList.frame.origin.y, tbl_MerchantList.frame.size.width, tbl_MerchantList.frame.size.height+40);
    }
    
    self.lbl_ScreenTitle.font=[UIFont fontWithName:kFont size:self.lbl_ScreenTitle.font.pointSize];
     [self getMerchants];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)getMerchants{
    [kAppDelegate showProgressHUD:self.view];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[CommonFunction getValueFromUserDefault:kMerchantId] forKey:@"merchantId"];
    
    [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dict method:kMerchantDetailByIdEmail] completeBlock:^(NSData *data) {
        id result = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions error:nil];
        if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
            if (self.dict_MerchantsList) {
                self.dict_MerchantsList=nil;
            }
            self.dict_MerchantsList=[[NSMutableDictionary alloc]init];
            self.dict_MerchantsList=[result valueForKey:@"merchantArr"];
            
            [self.tbl_MerchantList reloadData];
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
    NSMutableArray *arrData=[self.dict_MerchantsList valueForKey:@"offersList"];

    return [arrData count] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"customCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (tableView.tag!=1001) {
        if (kDevice==kIphone) {
            if (cell == nil){
                [[NSBundle mainBundle] loadNibNamed:@"IBMerchantCustomCell" owner:self options:nil];
                cell=tblCustomCell;
            }
        }
        else{
            if (cell == nil){
                [[NSBundle mainBundle] loadNibNamed:@"IBMerchantCustomCell" owner:self options:nil];
                cell=tblCustomCell;
                cell.backgroundColor = nil;
            }
        }
    }
    UIImageView *imgView=(UIImageView *)[cell viewWithTag:101];
    [imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kMerchantURL,[[self.dict_MerchantsList valueForKey:@"merchant_image"] objectAtIndex:indexPath.row]]]
            placeholderImage:[UIImage imageNamed:@""]];
    imgView.backgroundColor=[UIColor clearColor];
    [imgView setClipsToBounds:YES];
    UIImageView *imgSelected=[[UIImageView alloc]init];
    imgSelected.image=[UIImage imageNamed:@"RowHighlight@2x.png"];//OffersListBG_iPad@2x
    [cell setSelectedBackgroundView:imgSelected];
    cell.tag=indexPath.row;
    
    
    UILabel *lblOfferTitle=(UILabel *)[cell viewWithTag:102];
    lblOfferTitle.text=[[self.dict_MerchantsList valueForKey:@"merchant_name"] objectAtIndex:indexPath.row];
    lblOfferTitle.textColor=[UIColor whiteColor];
       /*font should always be set before size to fit property*/
    lblOfferTitle.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
    // [lblOfferTitle sizeToFit];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[CommonFunction getDeviceName:@"MainStoryboard_"] bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarCntrl"];
    kAppDelegate.window.rootViewController = viewController;
    [kAppDelegate.window makeKeyAndVisible];
}

@end
