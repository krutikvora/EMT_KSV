//
//  IBWithGratitudeVC.m
//  iBuddyClient
//
//  Created by Utkarsha on 08/04/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import "IBWithGratitudeVC.h"
#import "IBSeachFundraiserVC.h"

@interface IBWithGratitudeVC ()
@property (weak, nonatomic) IBOutlet UILabel *lblCopyRight;

@end

@implementation IBWithGratitudeVC
@synthesize tblCustomCellWithGratitude, tblWithGratitude, lblTop, lblFundraiserName,lblCopyRight;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View Controller life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    //Added by Utkarsha so as to make iAds compatible to iOS 7 Layout
    [self setLayoutForiOS7];
    self.lblCopyRight.text = [CommonFunction getCopyRightText];
    // Do any additional setup after loading the view from its nib.
    lastPageNumber = 0;
    arrayWithGratitude = [[NSMutableArray alloc]init];
    self.lblTop.font = [UIFont fontWithName:kFont size:self.lblTop.font.pointSize];
    [kAppDelegate showProgressHUD:self.view];
    
    if ([[[kAppDelegate dictUserInfo]valueForKey:@"npoId"]intValue] != 1) {
        strSearchedNpoId = [[kAppDelegate dictUserInfo]valueForKey:@"npoId"];
    }
    else {
        strSearchedNpoId = @"";
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self callWithGratitudeService:strSearchedNpoId pageNo:0 pgSize:20];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    //arrayWithGratitude = NULL;
    // totalDonors = 0;
    //self.lblFundraiserName.text = @"";
    //[self.tblWithGratitude reloadData];
    if ([CommonFunction getValueFromUserDefault:@"SearchednpoID"]) {
        arrayWithGratitude = NULL;
        strDefaultNpoId = [CommonFunction getValueFromUserDefault:@"SearchednpoID"];
        self.lblFundraiserName.text = [CommonFunction getValueFromUserDefault:@"SearchedSalespersonName"];
        [CommonFunction deleteValueForKeyFromUserDefault:@"SearchednpoID"];
        [CommonFunction deleteValueForKeyFromUserDefault:@"SearchedSalespersonName"];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self callWithGratitudeService:strDefaultNpoId pageNo:0 pgSize:20];
        });
    }
}

- (void)viewDidUnload {
    self.lblFundraiserName = nil;
    self.lblTop = nil;
    self.tblCustomCellWithGratitude = nil;
    self.tblWithGratitude = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)showMenu:(id)sender {
    [kAppDelegate showMenu];
}

- (IBAction)btnSearchClicked:(id)sender {
    IBSeachFundraiserVC *objIBSeachFundraiserVC;
    if (kDevice == kIphone) {
        objIBSeachFundraiserVC = [[IBSeachFundraiserVC alloc]initWithNibName:@"IBSeachFundraiserVC" bundle:nil];
    }
    else {
        objIBSeachFundraiserVC = [[IBSeachFundraiserVC alloc]initWithNibName:@"IBSeachFundraiserVC_iPad" bundle:nil];
    }
    [self.navigationController pushViewController:objIBSeachFundraiserVC animated:YES];
}

#pragma mark - Load fundraisers
- (void)callWithGratitudeService:(NSString *)salepersonId pageNo:(NSInteger)pageNumber pgSize:(NSInteger)pageSize1 {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:salepersonId forKey:@"npoId"];
    [dict setValue:[NSString stringWithFormat:@"%d", pageNumber] forKey:@"pageNumber"];
    [dict setValue:[NSString stringWithFormat:@"%d", pageSize1] forKey:@"pageSize"];
    dispatch_sync(dispatch_get_main_queue(), ^{
        [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dict method:kNpoDonationbyId] completeBlock: ^(NSData *data) {
            id result = [NSJSONSerialization JSONObjectWithData:data
                                                        options:kNilOptions error:nil];
            if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]) {
                [CommonFunction fnAlert:@"No Records" message:@"No records found."];
                arrayWithGratitude = NULL;
                [self.tblWithGratitude reloadData];
            }
            else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]) {
                [CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
            }
            else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
                if ([arrayWithGratitude count] > 0) {
                    NSMutableArray *nextpageData = [[NSMutableArray alloc]init];
                    nextpageData = [result valueForKey:@"result"];
                    arrayWithGratitude = [NSMutableArray arrayWithArray:[arrayWithGratitude arrayByAddingObjectsFromArray:nextpageData]];
                }
                else {
                    arrayWithGratitude = [result valueForKey:@"result"];
                    totalDonors = [[result valueForKey:@"total_records"] integerValue];
                }
                if(![[[arrayWithGratitude valueForKey:@"npo_email"] objectAtIndex:0] isEqual:[NSNull null]])
                {
                    self.lblFundraiserName.text = [[arrayWithGratitude valueForKey:@"npo_title"] objectAtIndex:0];
                    
                }
                else
                {
                    self.lblFundraiserName.text = [[arrayWithGratitude valueForKey:@"s_name"] objectAtIndex:0];
                    
                }
                [self.tblWithGratitude reloadData];
            }
            else
                [CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
            [kAppDelegate hideProgressHUD];
        } errorBlock: ^(NSError *error) {
            if (error.code == NSURLErrorTimedOut) {
                [CommonFunction fnAlert:@"Alert!" message:kAlerTimedOut];
            }
            else {
                [CommonFunction fnAlert:@"Error" message:[error localizedDescription]];
            }
            [kAppDelegate hideProgressHUD];
        }];
    });
}

#pragma mark -
#pragma mark - UITableView Deletgate & Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // #warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    int count;
    count = [arrayWithGratitude count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIImageView *imgView;
    UILabel *lblWithGratitudeTitle;
    
    static NSString *CellIdentifier = @"withGratitudeCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (kDevice == kIphone) {
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"IBWithGratitudeCell" owner:self options:nil];
            cell = tblCustomCellWithGratitude;
        }
    }
    else {
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"IBWithGratitudeCell_iPad" owner:self options:nil];
            cell = tblCustomCellWithGratitude;
        }
    }
    cell.backgroundColor = nil;
    //Set Donation Type image
    imgView = (UIImageView *)[cell viewWithTag:101];
    NSString *donationType = [[arrayWithGratitude valueForKey:@"donation_type"] objectAtIndex:indexPath.row];
    if ([donationType isEqualToString:@"normal"]) {
        [imgView setImage:[UIImage imageNamed:@"regular_icon"]];
    }
    else if ([donationType isEqualToString:@"bronze"]) {
        [imgView setImage:[UIImage imageNamed:@"Bronze_icon"]];
    }
    else if ([donationType isEqualToString:@"silver"]) {
        [imgView setImage:[UIImage imageNamed:@"silver_icon"]];
    }
    else if ([donationType isEqualToString:@"gold"]) {
        [imgView setImage:[UIImage imageNamed:@"gold_icon"]];
    }
    
    // Set Title
    lblWithGratitudeTitle = (UILabel *)[cell viewWithTag:102];
    lblWithGratitudeTitle.textColor = [UIColor whiteColor];
    
    NSString *anonymousDonation = [[arrayWithGratitude valueForKey:@"anonymous_donation"] objectAtIndex:indexPath.row];
    if (anonymousDonation == nil || anonymousDonation == (id)[NSNull null]) {
        anonymousDonation = @"1";
    }
    else {
        anonymousDonation = anonymousDonation;
    }
    NSString *strNpoName=@"";
    if(![[[arrayWithGratitude valueForKey:@"npo_email"] objectAtIndex:indexPath.row] isEqual:[NSNull null]])
    {
        strNpoName = [[arrayWithGratitude valueForKey:@"npo_title"] objectAtIndex:indexPath.row];
        
    }
    else
    {
        strNpoName = [[arrayWithGratitude valueForKey:@"s_name"] objectAtIndex:indexPath.row];
        
    }
    
    
    if ([anonymousDonation isEqualToString:@"1"]) {
        lblWithGratitudeTitle.text = [NSString stringWithFormat:@"Anonymous donor has donated $%@ to %@", [[arrayWithGratitude valueForKey:@"donation_amount"] objectAtIndex:indexPath.row], strNpoName];
    }
    else {
        lblWithGratitudeTitle.text = [NSString stringWithFormat:@"%@ has donated $%@ to %@", [[arrayWithGratitude valueForKey:@"first_name"] objectAtIndex:indexPath.row], [[arrayWithGratitude valueForKey:@"donation_amount"] objectAtIndex:indexPath.row], strNpoName];
    }
    
    //Set Donation Date
    UILabel *lblWithGratitudeDate = (UILabel *)[cell viewWithTag:103];
    lblWithGratitudeDate.textColor = [UIColor whiteColor];
    if (kDevice == kIphone) {
        lblWithGratitudeDate.font = [UIFont fontWithName:kFont size:10];
        lblWithGratitudeTitle.font = [UIFont fontWithName:kFont size:12];
    }
    else {
        lblWithGratitudeDate.font = [UIFont fontWithName:kFont size:12];
        lblWithGratitudeTitle.font = [UIFont fontWithName:kFont size:16];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *orignalDate   =  [dateFormatter dateFromString:[[arrayWithGratitude valueForKey:@"date_created"] objectAtIndex:indexPath.row]];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSString *finalString = [dateFormatter stringFromDate:orignalDate];
    lblWithGratitudeDate.text = [NSString stringWithFormat:@"%@", finalString];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    /*** end ***/
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (endScrolling >= scrollView.contentSize.height) {
        NSString *strSalespersonId;
        if (strDefaultNpoId) {
            strSalespersonId = strDefaultNpoId;
        }
        else {
            strSalespersonId = strSearchedNpoId;
        }
        if ([arrayWithGratitude count] < totalDonors) {
            lastPageNumber = lastPageNumber + 1;
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [self callWithGratitudeService:strSalespersonId pageNo:lastPageNumber pgSize:20];
            });
        }
    }
}

@end
