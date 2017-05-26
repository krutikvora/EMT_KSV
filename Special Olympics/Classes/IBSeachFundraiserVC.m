//
//  IBSeachFundraiserVC.m
//  iBuddyClient
//
//  Created by Utkarsha on 08/04/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import "IBSeachFundraiserVC.h"

@interface IBSeachFundraiserVC ()

@property (weak, nonatomic) IBOutlet UILabel *lblScreenTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblCopyRight;

@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) NSString *strSelectionType;
@property (strong, nonatomic) IBOutlet UIView *vwPopUp;
@property (weak, nonatomic) IBOutlet UILabel *lblFundraiserTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblFundraiserDescription;
@property (weak, nonatomic) IBOutlet UIScrollView *scrlView;
@property (weak, nonatomic) IBOutlet UILabel *lblStaticText;
@end


@implementation IBSeachFundraiserVC
@synthesize tblCustomCellSalespersonCode,lblCopyRight;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	//Added by Utkarsha so as to make iAds compatible to iOS 7 Layout
	[self setLayoutForiOS7];

	[self setInitialVariables];
	// Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark Set Initial Labels
/**
   Set initial labels
 */
- (void)setInitialVariables {
     self.lblCopyRight.text = [CommonFunction getCopyRightText];
	self.lblScreenTitle.font = [UIFont fontWithName:kFont size:self.lblScreenTitle.font.pointSize];
	self.lblFundraiserTitle.font = [UIFont fontWithName:kFont size:self.lblFundraiserTitle.font.pointSize];
	self.lblFundraiserDescription.font = [UIFont fontWithName:_lblFundraiserDescription.font.fontName size:self.lblFundraiserDescription.font.pointSize];

	_strSelectionType = @"fundraiser";
	if (!iOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
		[[_searchBar.subviews objectAtIndex:0]removeFromSuperview];
	}
	_vwPopUp.frame = CGRectMake(_vwPopUp.frame.origin.x, _vwPopUp.frame.origin.y, _vwPopUp.frame.size.width, kAppDelegate.window.frame.size.height);
	_vwPopUp.alpha = 0;
	[kAppDelegate.window addSubview:_vwPopUp];
}

#pragma mark Button Actions

- (IBAction)btnSearchClicked:(id)sender {
	[_searchBar resignFirstResponder];
	[self getSalespersonList:_strSelectionType];
}

- (IBAction)btnBackClicked:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)btn_ViewClicked:(id)sender {
	[self getSalespersonDetail:[[[self.dict_SalespersonCodesList valueForKey:@"data"]objectAtIndex:[sender tag]]valueForKey:@"id"]];
}

#pragma mark-
#pragma mark - delegate Methods

#pragma mark -
#pragma mark - UITableView Deletgate & Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	//#warning Potentially incomplete method implementation.
	// Return the number of sections.
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	//#warning Incomplete method implementation.
	// Return the number of rows in the section.
    NSMutableArray *arrSalePersonData=[self.dict_SalespersonCodesList valueForKey:@"data"];
	return [arrSalePersonData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"salespersonCellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (kDevice == kIphone) {
		if (cell == nil) {
			[[NSBundle mainBundle] loadNibNamed:@"IBSalesPersonTableCell_iPhone" owner:self options:nil];
			cell = tblCustomCellSalespersonCode;
		}
	}
	else {
		if (cell == nil) {
			[[NSBundle mainBundle] loadNibNamed:@"IBSalesPersonTableCell_iPad" owner:self options:nil];
			cell = tblCustomCellSalespersonCode;
		}
	}
	cell.backgroundColor = nil;
	UILabel *lblName = (UILabel *)[cell viewWithTag:101];
	lblName.textColor = [UIColor whiteColor];
	lblName.adjustsFontSizeToFitWidth = TRUE;
	lblName.font = [UIFont fontWithName:kFont size:kAppDelegate.fontSize];

	UILabel *lblSalespersonCode = (UILabel *)[cell viewWithTag:102];
	lblSalespersonCode.text = [[[self.dict_SalespersonCodesList valueForKey:@"data"]objectAtIndex:indexPath.row]valueForKey:@"code"];
	lblSalespersonCode.textColor = [UIColor whiteColor];
	lblSalespersonCode.adjustsFontSizeToFitWidth = TRUE;
	lblSalespersonCode.font = [UIFont italicSystemFontOfSize:lblSalespersonCode.font.pointSize];

	UILabel *lblFundraiser = (UILabel *)[cell viewWithTag:103];
	lblFundraiser.textColor = [UIColor whiteColor];
	lblFundraiser.adjustsFontSizeToFitWidth = TRUE;
	lblFundraiser.font = [UIFont fontWithName:kFont size:lblFundraiser.font.pointSize];
	if ([_strSelectionType isEqualToString:@"salesperson"]) {
		lblName.text = [[[self.dict_SalespersonCodesList valueForKey:@"data"]objectAtIndex:indexPath.row]valueForKey:@"name"];
		lblFundraiser.text = [[[self.dict_SalespersonCodesList valueForKey:@"data"]objectAtIndex:indexPath.row]valueForKey:@"fundraiser"];
	}
	else {
		lblName.text = [[[self.dict_SalespersonCodesList valueForKey:@"data"]objectAtIndex:indexPath.row]valueForKey:@"fundraiser"];
		lblFundraiser.text = [[[self.dict_SalespersonCodesList valueForKey:@"data"]objectAtIndex:indexPath.row]valueForKey:@"name"];
	}
	if ([[cell.contentView.subviews lastObject]isKindOfClass:[UIButton class]]) {
		UIButton *btn = (UIButton *)[cell.contentView.subviews lastObject];
		if (kDevice == kIphone) {
			[btn setBackgroundImage:[UIImage imageNamed:@"icon_view-detail@2x.png"] forState:UIControlStateNormal];
		}
		else {
			[btn setBackgroundImage:[UIImage imageNamed:@"icon_view-detai~ipad"] forState:UIControlStateNormal];
		}
		btn.tag = indexPath.row;
	}
	else {
		UIButton *btn_View = [UIButton buttonWithType:UIButtonTypeCustom];
		btn_View.tag = indexPath.row;
		if (kDevice == kIphone) {
			btn_View.frame = CGRectMake(215, 20, 40, 40);
			[btn_View setBackgroundImage:[UIImage imageNamed:@"icon_view-detail@2x.png"] forState:UIControlStateNormal];
		}
		else {
			btn_View.frame = CGRectMake(520, 28, 48, 48);
			[btn_View setBackgroundImage:[UIImage imageNamed:@"icon_view-detai~ipad"] forState:UIControlStateNormal];
		}
		[btn_View addTarget:self action:@selector(btn_ViewClicked:) forControlEvents:UIControlEventTouchUpInside];
		[cell.contentView addSubview:btn_View];
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//[CommonFunction setValueInUserDefault:@"SearchedSalesperson" value:[[[self.dict_SalespersonCodesList valueForKey:@"data"]objectAtIndex:indexPath.row]valueForKey:@"code"]];
	[CommonFunction setValueInUserDefault:@"SearchednpoID" value:[[[self.dict_SalespersonCodesList valueForKey:@"data"]objectAtIndex:indexPath.row]valueForKey:@"npoId"]];
	[CommonFunction setValueInUserDefault:@"SearchedSalespersonName" value:[[[self.dict_SalespersonCodesList valueForKey:@"data"]objectAtIndex:indexPath.row]valueForKey:@"fundraiser"]];

	[self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	float height = 0;
	if (kDevice == kIphone) {
		height = 72;
	}
	else {
		height = 90;
	}
	return height;
}

- (void)reloadTable {
	[kAppDelegate showProgressHUD];
	self.dict_SalespersonCodesList = nil;
	[_tblView reloadData];
	_searchBar.text = @"";
	[kAppDelegate hideProgressHUD];
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

- (void)getSalespersonList:(NSString *)paramType {
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	[dict setValue:_searchBar.text forKey:paramType];
	[kAppDelegate showProgressHUD:self.view];
	[AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:(NSMutableDictionary *)dict method:kGetSalesperson] completeBlock: ^(NSData *data) {
	    id result = [NSJSONSerialization JSONObjectWithData:data
	                                                options:kNilOptions error:nil];
	    if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
	        if (self.dict_SalespersonCodesList) {
	            self.dict_SalespersonCodesList = nil;
			}
	        self.tblView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	        self.dict_SalespersonCodesList = [[NSMutableDictionary alloc]init];
	        self.dict_SalespersonCodesList = result;
	        [self.tblView reloadData];
		}
	    else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]) {
	        if (self.dict_SalespersonCodesList) {
	            self.dict_SalespersonCodesList = nil;
			}
	        self.dict_SalespersonCodesList = [[NSMutableDictionary alloc]init];
	        self.dict_SalespersonCodesList = result;
	        [self.tblView reloadData];
	        [CommonFunction fnAlert:@"" message:@"No Fundraiser exist."];
		}
	    else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]) {
	        [CommonFunction fnAlert:@"" message:@"Please try again"];
		}
	    else {
	        [CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
		}
	    [kAppDelegate hideProgressHUD];
	} errorBlock: ^(NSError *error)
	{
	    if (error.code == NSURLErrorTimedOut) {
	        [CommonFunction fnAlert:@"Alert!" message:kAlerTimedOut];
		}
	    else {
	        [CommonFunction fnAlert:@"Error" message:[error localizedDescription]];
		}
	    [kAppDelegate hideProgressHUD];
	}];
}

- (void)getSalespersonDetail:(NSString *)salespersonID {
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	[dict setValue:salespersonID forKey:@"salespersonId"];
	[kAppDelegate showProgressHUD:self.view];
	[AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:(NSMutableDictionary *)dict method:kgetsalespersondetail] completeBlock: ^(NSData *data) {
	    id result = [NSJSONSerialization JSONObjectWithData:data
	                                                options:kNilOptions error:nil];
	    if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
	        [kAppDelegate hideProgressHUD];
	        [self setPopUp:[NSMutableDictionary dictionaryWithDictionary:result]];
		}

	    else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]) {
	        [CommonFunction fnAlert:@"" message:@"No Details exist."];
	        [kAppDelegate hideProgressHUD];
		}
	    else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]) {
	        [CommonFunction fnAlert:@"" message:@"Please try again"];
	        [kAppDelegate hideProgressHUD];
		}
	    else {
	        [CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
	        [kAppDelegate hideProgressHUD];
		}
	} errorBlock: ^(NSError *error) {
	    if (error.code == NSURLErrorTimedOut) {
	        [CommonFunction fnAlert:@"Alert!" message:kAlerTimedOut];
		}
	    else {
	        [CommonFunction fnAlert:@"Error" message:[error localizedDescription]];
		}
	    [kAppDelegate hideProgressHUD];
	}];
}

#pragma mark - Set Pop Up Methods

- (void)setPopUp:(NSDictionary *)dict {
	NSArray *arrLabels = [[NSMutableArray alloc]initWithObjects:_lblFundraiserTitle, _lblFundraiserDescription, nil];
	NSArray *arrLabelValues = [[NSMutableArray alloc]initWithObjects:[[dict valueForKey:@"data"]valueForKey:@"title"], [[dict valueForKey:@"data"]valueForKey:@"description"], nil];
	NSArray *kFonts = [[NSMutableArray alloc]initWithObjects:kFont, @"Georgia", nil];
	NSArray *incrementParameter = [[NSMutableArray alloc]initWithObjects:@"X", @"Y", nil];
	[[SharedManager sharedManager] setFrames:arrLabels labelValues:arrLabelValues incrementType:incrementParameter kFonts:kFonts plusfactor:5 initialYValue:5];
	self.scrlView.contentSize = CGSizeMake(0, self.lblFundraiserDescription.frame.origin.y + self.lblFundraiserDescription.frame.size.height + 5);
	[[SharedManager sharedManager] subViewAnimation:_vwPopUp];
}

- (IBAction)btnCrossClicked:(id)sender {
	[[SharedManager sharedManager] removeAnimation:_vwPopUp];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[searchBar resignFirstResponder];
	[self getSalespersonList:_strSelectionType];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
	return YES;
}

@end
