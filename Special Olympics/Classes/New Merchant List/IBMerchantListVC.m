//
//  IBMerchantListVC.m
//  iBuddyClient
//
//  Created by Anubha on 13/11/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import "IBMerchantListVC.h"
#import "SVPullToRefresh.h"
#import "UIImageView+WebCache.h"

#define kPlusFactorInMapView 30
#define kMap 101
#define kTrollies 102
#define kFeatured 103
#define kImgDividerHeight 5

#define kMerchantTableWidthIPhone 189
#define kMerchantTableWidthIPad 546
#define kIncrementFactorMerchant 5
#define kTableCellGapFromYMerchant 7

// Test hjdfgljgkdjfgjkld

@interface IBMerchantListVC () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tbl_MerchantList;
@property (weak, nonatomic) IBOutlet UILabel *lbl_ScreenTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnMap;
@property (weak, nonatomic) IBOutlet UIButton *btnTrolley;
@property (weak, nonatomic) IBOutlet UIButton *btnFeaturedOffers;
@property (weak, nonatomic) IBOutlet UIImageView *imgLowerDivider;
@property (weak, nonatomic) IBOutlet UIImageView *imgUpperDivider;

@end
@implementation IBMerchantListVC
@synthesize tblCustomCellMerchant;
@synthesize webServiceParams;
@synthesize offset,isInfiniteCalled;
@synthesize arrMerchants;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

#pragma mark -
#pragma mark - View lifecycle
- (void)viewDidLoad {
	[super viewDidLoad];
	//Added by Utkarsha so as to make iAds compatible to iOS 7 Layout
	[self setLayoutForiOS7];
    arrMerchants=[[NSMutableArray alloc]init];
	[self setInitialVariablesForViewDidLoad];
    
	// Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
	[self setInitialVariables];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:YES];
}

- (void)didReceiveMemoryWarning {
	//  [self setMapView:nil];
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
	//  [self setMapView:nil];
	[super viewDidUnload];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	// This is for a bug in MKMapView for iOS6
	[self purgeMapMemory];
}

// This is for a bug in MKMapView for iOS6
// Try to purge some of the memory being allocated by the map
- (void)purgeMapMemory {
	// Switching map types causes cache purging, so switch to a different map type
	mapView.mapType = MKMapTypeStandard;
	[mapView removeFromSuperview];
	mapView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown
	        || interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark-
#pragma mark - Private Methods

#pragma mark -
#pragma mark - Set Initial Variables
- (void)setInitialVariables {
	int height = 0;
	mapView = [[MKMapView alloc]init];
	mapView.delegate = self;
	if ([[webServiceParams valueForKey:@"isGru"] intValue] == 1) {
		self.lbl_ScreenTitle.text = @"MAP™";
		self.btnFeaturedOffers.hidden = FALSE;
		self.btnMap.hidden            = FALSE;
		self.btnTrolley.hidden        = FALSE;
		height = kPlusFactorInMapView;
	}
	if (kDevice == kIphone) {
		mapView.frame = CGRectMake(0, 48 + height, 320, 129);
	}
	else {
		mapView.frame = CGRectMake(0, 48 + height, 768, 384);
	}
	self.lbl_ScreenTitle.font = [UIFont fontWithName:kFont size:_lbl_ScreenTitle.font.pointSize];
	self.btnMap.titleLabel.font = [UIFont fontWithName:kFont size:self.btnMap.titleLabel.font.pointSize];
    
	self.btnTrolley.titleLabel.font = [UIFont fontWithName:kFont size:self.btnTrolley.titleLabel.font.pointSize];
	self.btnFeaturedOffers.titleLabel.font = [UIFont fontWithName:kFont size:self.btnFeaturedOffers.titleLabel.font.pointSize];
	[self.view addSubview:mapView];
	[self updateMemberPins:arrCombinedData];
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

- (void)getMerchantsList:(NSString *)type {
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	[kAppDelegate showProgressHUD];
	dict = webServiceParams;
    [dict setValue:[NSString stringWithFormat:@"%d",offset] forKey:@"offset"];
    [dict setValue:@"40" forKey:@"limit"];

	[AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary2:(NSMutableDictionary *)dict method:type] completeBlock: ^(NSData *data) {
	    id result = [NSJSONSerialization JSONObjectWithData:data
	                                                options:kNilOptions error:nil];
	    if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
	        if (self.dict_MerchantList) {
	            self.dict_MerchantList = nil;
			}
       //     NSLog(@"[[result valueForKey:@""]count]%d",[[result valueForKey:@"merchantsList"]count]);
	        self.tbl_MerchantList.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	        self.dict_MerchantList = [[NSMutableDictionary alloc]init];
	        self.dict_MerchantList = [result mutableCopy];
            NSArray *arrData=[self.dict_MerchantList valueForKey:@"merchantsList"];

            [arrMerchants addObjectsFromArray:arrData];
            [self.dict_MerchantList setObject:arrMerchants forKey:@"merchantsList"];
	        if (selectedTab == kMap) {
	            [self addingObjectsAndDroppingPins:result];
			}
	        [self.tbl_MerchantList reloadData];
		}
        
	    else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]) {
//	        if (self.dict_MerchantList) {
//	            self.dict_MerchantList = nil;
//			}
//	        self.dict_MerchantList = [[NSMutableDictionary alloc]init];
//	        self.dict_MerchantList = result;
//	        [self.tbl_MerchantList reloadData];
            isInfiniteCalled=true;
	      //  [CommonFunction fnAlert:@"" message:@"No more results."];
		}
	    else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]) {
	        [CommonFunction fnAlert:@"" message:@"Please try again"];
		}
	    else {
	        [CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
		}
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
	[self.tbl_MerchantList.pullToRefreshView stopAnimating];
}

#pragma mark -
#pragma mark - Set Map View
- (void)addingObjectsAndDroppingPins:(NSDictionary *)result {
	[arrCombinedData addObjectsFromArray:[result valueForKey:@"merchantsList"]];
	[arrCombinedData addObjectsFromArray:[result valueForKey:@"trollies"]];
	[self updateMemberPins:arrCombinedData];
}

- (void)setInitialVariablesForViewDidLoad {
	_lbl_ScreenTitle.text = [[[webServiceParams valueForKey:@"CategoryTitle"] uppercaseString] stringByAppendingString:@"™"];
	selectedTab = kMap;
	arrCombinedData = [[NSMutableArray alloc] init];
	[self getMerchantsList:kGetMerchantList];
	if ([[webServiceParams valueForKey:@"isGru"] intValue] == 1) {
		self.tbl_MerchantList.frame = CGRectMake(self.tbl_MerchantList.frame.origin.x, self.tbl_MerchantList.frame.origin.y + kPlusFactorInMapView, self.tbl_MerchantList.frame.size.width, self.tbl_MerchantList.frame.size.height - kPlusFactorInMapView);
		self.imgLowerDivider.frame = CGRectMake(self.imgLowerDivider.frame.origin.x, self.tbl_MerchantList.frame.origin.y - kImgDividerHeight, self.imgLowerDivider.frame.size.width, self.imgLowerDivider.frame.size.height);
		self.imgUpperDivider.frame = CGRectMake(self.imgUpperDivider.frame.origin.x, self.btnMap.frame.origin.y + self.btnMap.frame.size.height, self.imgUpperDivider.frame.size.width, self.imgUpperDivider.frame.size.height);
	}
	else {
        self.offset=0;
        isInfiniteCalled=false;
//		[self.tbl_MerchantList addPullToRefreshWithActionHandler: ^{
//         //   isInfiniteCalled=false;
//		    [self getMerchantsList:kGetMerchantList];
//		}];
        [self.tbl_MerchantList addInfiniteScrollingWithActionHandler:^{
            offset=offset+40;
            if(isInfiniteCalled==false)
            {
                [self getMerchantsList:kGetMerchantList];
                [self.tbl_MerchantList.infiniteScrollingView performSelector:@selector(stopAnimating) withObject:nil];
                //    [self.tbl_MerchantList.infiniteScrollingView performSelector:@selector(stopAnimating) withObject:nil afterDelay:1];
            }
        }];
	}
}

- (void)updateMemberPins:(NSMutableArray *)arrResponse {
	for (int i = 0; i < [arrResponse count]; i++) {
		Annotation *annotation = [[Annotation alloc] initWithLatitude:[[[arrResponse valueForKey:@"merchantLat"]objectAtIndex:i]floatValue] andLongitude:[[[arrResponse valueForKey:@"merchantLong"]objectAtIndex:i]floatValue]];
		annotation.type  = @"Source";
		//To set value of bit to check if it is trolly or merchant, so that the image of pin can be set accordingly.
		if ([[[arrResponse objectAtIndex:i] valueForKey:@"isTrolley"] intValue] == 1) {
			annotation.isTrolley = 1;
		}
		NSString *pinAddress;
		if ([[[arrResponse valueForKey:@"merchantAddress"]objectAtIndex:i] length] > 0) {
			pinAddress = [NSString stringWithFormat:@"%@%@", VALID_STRING([[arrResponse objectAtIndex:i]valueForKey:@"merchantName"]), VALID_STRING([[arrResponse objectAtIndex:i]valueForKey:@"title"])];
			pinAddress = [pinAddress stringByAppendingString:@","];
			pinAddress = [pinAddress stringByAppendingString:[[arrResponse valueForKey:@"merchantAddress"]objectAtIndex:i]];
		}
		else {
			pinAddress = [NSString stringWithFormat:@"%@%@", VALID_STRING([[arrResponse objectAtIndex:i]valueForKey:@"merchantName"]), VALID_STRING([[arrResponse objectAtIndex:i]valueForKey:@"title"])];
			pinAddress = [pinAddress stringByAppendingString:@","];
			pinAddress = [pinAddress stringByAppendingString:[[arrResponse valueForKey:@"merchantCity"]objectAtIndex:i]];
			pinAddress = [pinAddress stringByAppendingString:@","];
			pinAddress = [pinAddress stringByAppendingString:[[arrResponse valueForKey:@"merchantState"]objectAtIndex:i]];
		}
		annotation.title = pinAddress;
        
        if([[[arrResponse objectAtIndex:i] valueForKey:@"global_merchant"] isEqualToString:@"1"])
        {
            
        }
        else
        {
            [mapView addAnnotation:annotation];
            
        }
	}
	[self zoomToFitMapAnnotations:mapView];
}

- (void)zoomToFitMapAnnotations:(MKMapView *)MapView {
	if ([MapView.annotations count] == 0)
		return;
	CLLocationCoordinate2D topLeftCoord;
	topLeftCoord.latitude = -90;
	topLeftCoord.longitude = 180;
	CLLocationCoordinate2D bottomRightCoord;
	bottomRightCoord.latitude = 90;
	bottomRightCoord.longitude = -180;
	for (Annotation *annotation in MapView.annotations) {
		topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
		topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        
		bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
		bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
	}
	MKCoordinateRegion region;
	region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
	region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
	region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 2.0;  // Add a little extra space on the sides
	region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 2.0;  // Add a little extra space on the sides
    
	region = [MapView regionThatFits:region];
	if (region.center.longitude == -180.00000000) {
		NSLog(@"Invalid region!");
	}
	else {
		[MapView setRegion:region animated:YES];
	}
}

- (MKAnnotationView *)mapView:(MKMapView *)MapView viewForAnnotation:(id <MKAnnotation> )annotation {
	static NSString *parkingAnnotationIdentifier = @"ParkingAnnotationIdentifier";
    
	if ([annotation isKindOfClass:[Annotation class]]) {
		//Try to get an unused annotation, similar to uitableviewcells
		MKAnnotationView *annotationView = [MapView dequeueReusableAnnotationViewWithIdentifier:parkingAnnotationIdentifier];
		//If one isn't available, create a new one
		if (!annotationView) {
			annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:parkingAnnotationIdentifier];
			if (((Annotation *)annotation).isTrolley == 1) {
				annotationView.image = [UIImage imageNamed:@"map_pin_trolley.png"];
			}
			else {
				annotationView.image = [UIImage imageNamed:@"map_pin_purple.png"];
			}
		}
		annotationView.canShowCallout = YES;
		return annotationView;
	}
	return nil;
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
	if (selectedTab == kMap) {
        NSMutableArray *arrData=[self.dict_MerchantList valueForKey:@"merchantsList"];
		return [arrData count];
	}
	else if (selectedTab == kTrollies) {
        NSMutableArray *arrData=[self.dict_MerchantList valueForKey:@"trolliesList"];
        return [arrData count];

	}
	else if (selectedTab == kFeatured) {
        
        NSMutableArray *arrData=[self.dict_MerchantList valueForKey:@"featuredOffersList"];
        return [arrData count];

        
	}
	return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	//        static NSString *CellIdentifier = @"merchantCellIdentifier";
	UITableViewCell *cell = nil;    //[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (kDevice == kIphone) {
		if (cell == nil) {
			[[NSBundle mainBundle] loadNibNamed:@"IBMerchantTableCell_iPhone" owner:self options:nil];
			cell = tblCustomCellMerchant;
		}
	}
	else {
		if (cell == nil) {
			[[NSBundle mainBundle] loadNibNamed:@"IBMerchantCustomCell_iPad" owner:self options:nil];
			cell = tblCustomCellMerchant;
		}
		cell.backgroundColor = nil;
	}
	if (selectedTab == kMap) {
		[self fillMerchantRows:indexPath cell:cell];
	}
	else if (selectedTab == kTrollies) {
		[self fillTrolleyRows:indexPath cell:cell];
	}
	else if (selectedTab == kFeatured) {
		[self fillFeaturedOfferRows:indexPath cell:cell];
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[CommonFunction callHideViewFromSideBar];
	if (selectedTab == kMap) {
		IBOffersVC *objIBOffersVC;
		if (kDevice == kIphone) {
			objIBOffersVC = [[IBOffersVC alloc]initWithNibName:@"IBOffersVC" bundle:nil];
		}
		else {
			objIBOffersVC = [[IBOffersVC alloc]initWithNibName:@"IBOfffersVC_iPad" bundle:nil];
		}
		NSMutableDictionary *dictMerchantInfo = [[NSMutableDictionary alloc]init];
		[dictMerchantInfo setValue:[[[self.dict_MerchantList valueForKey:@"merchantsList"]valueForKey:@"merchantId"] objectAtIndex:indexPath.row] forKey:@"merchantId"];
		[dictMerchantInfo setValue:[webServiceParams valueForKey:@"categoryId"] forKey:@"categoryId"];
        [dictMerchantInfo setValue:[webServiceParams valueForKey:@"IsEvent"] forKey:@"IsEvent"];
        
		objIBOffersVC.dictMerchantInfo = dictMerchantInfo;
		[self.navigationController pushViewController:objIBOffersVC animated:YES];
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	float height = 0;
	float width = 0;
	if (kDevice == kIphone) {
		width = kMerchantTableWidthIPhone;
	}
	else {
		width = kMerchantTableWidthIPad;
	}
	if (selectedTab == kMap) {
		NSString *strStateCityName = [[[self.dict_MerchantList valueForKey:@"merchantsList"]valueForKey:@"cityName"] objectAtIndex:indexPath.row];
		strStateCityName = [strStateCityName stringByAppendingString:@", "];
		strStateCityName = [strStateCityName stringByAppendingString:[[[self.dict_MerchantList valueForKey:@"merchantsList"]valueForKey:@"stateName"] objectAtIndex:indexPath.row]];
        
		height = [CommonFunction heightOfOfferCell:[[[self.dict_MerchantList valueForKey:@"merchantsList"]valueForKey:@"merchantName"] objectAtIndex:indexPath.row] andWidth:width fontName:kFont fontSize:kAppDelegate.fontSize] + [CommonFunction heightOfOfferCell:strStateCityName andWidth:width fontName:kFont fontSize:kAppDelegate.fontSize] + kTableCellGapFromYMerchant;
	}
	else if (selectedTab == kTrollies) {
		NSString *strStateCityName = [[[self.dict_MerchantList valueForKey:@"trolliesList"]valueForKey:@"location"] objectAtIndex:indexPath.row];
		strStateCityName = [strStateCityName stringByAppendingString:@", "];
		strStateCityName = [strStateCityName stringByAppendingString:[[[self.dict_MerchantList valueForKey:@"trolliesList"]valueForKey:@"city"] objectAtIndex:indexPath.row]];
		strStateCityName = [strStateCityName stringByAppendingString:@", "];
		strStateCityName = [strStateCityName stringByAppendingString:[[[self.dict_MerchantList valueForKey:@"trolliesList"]valueForKey:@"state"] objectAtIndex:indexPath.row]];
        
		height = [CommonFunction heightOfOfferCell:[[[self.dict_MerchantList valueForKey:@"trolliesList"]objectAtIndex:indexPath.row] valueForKey:@"title"] andWidth:width fontName:kFont fontSize:kAppDelegate.fontSize] + [CommonFunction heightOfOfferCell:strStateCityName andWidth:width fontName:kFont3 fontSize:kAppDelegate.fontSize] + kTableCellGapFromYMerchant;
	}
	else if (selectedTab == kFeatured) {
		height = [CommonFunction heightOfOfferCell:[[[self.dict_MerchantList valueForKey:@"featuredOffersList"]valueForKey:@"title"] objectAtIndex:indexPath.row] andWidth:width fontName:kFont fontSize:kAppDelegate.fontSize] + kTableCellGapFromYMerchant;
	}
    
	if (height < 50) {
		height = 50 + kTableCellGapFromYMerchant + kIncrementFactorMerchant;
	}
	else {
		height = height + kIncrementFactorMerchant;
	}
	return height;
}

- (void)fillMerchantRows:(NSIndexPath *)indexPath cell:(UITableViewCell *)cell {
	UIImageView *imgView = (UIImageView *)[cell viewWithTag:101];
    NSLog(@"%@",[[[self.dict_MerchantList valueForKey:@"merchantsList"]objectAtIndex:indexPath.row] valueForKey:@"thumb"]);
	[imgView setImageWithURL:[NSURL URLWithString:[[[self.dict_MerchantList valueForKey:@"merchantsList"]objectAtIndex:indexPath.row] valueForKey:@"thumb"] ]
	        placeholderImage:[UIImage imageNamed:@"default_offers_img.png"]];
    
	//Added by UTKARSHA GUPTA to show featured merchants on the top of the list on 26th jun 14
	UIImageView *imgViewFeatured = (UIImageView *)[cell viewWithTag:106];
	
    if ([[[[self.dict_MerchantList valueForKey:@"merchantsList"] objectAtIndex:indexPath.row]valueForKey:@"is_golden_egg_merchant"] isEqualToString:@"1"] ||[[[[self.dict_MerchantList valueForKey:@"merchantsList"]objectAtIndex:indexPath.row] valueForKey:@"isFeatured"] isEqualToString:@"1"])
        
    {
		[imgViewFeatured setImage:[UIImage imageNamed:@"featured_badge.png"]];
	}
	else {
		[imgViewFeatured setImage:NULL];
	}
    
	UILabel *lblMerchantTitle = (UILabel *)[cell viewWithTag:102];
	lblMerchantTitle.text = [[[self.dict_MerchantList valueForKey:@"merchantsList"]valueForKey:@"merchantName"] objectAtIndex:indexPath.row];
	lblMerchantTitle.textColor = [UIColor blackColor];
	// lblMerchantTitle.adjustsFontSizeToFitWidth=TRUE;
	lblMerchantTitle.font = [UIFont fontWithName:kFont size:kAppDelegate.fontSize];
	lblMerchantTitle.frame = CGRectMake(lblMerchantTitle.frame.origin.x, lblMerchantTitle.frame.origin.y, lblMerchantTitle.frame.size.width, [CommonFunction heightOfOfferCell:[[[self.dict_MerchantList valueForKey:@"merchantsList"] objectAtIndex:indexPath.row] valueForKey:@"merchantName"] andWidth:lblMerchantTitle.frame.size.width fontName:kFont fontSize:kAppDelegate.fontSize]);
    
	UILabel *lblStateCityName = (UILabel *)[cell viewWithTag:103];
	NSString *strStateCityName = [[[self.dict_MerchantList valueForKey:@"merchantsList"] objectAtIndex:indexPath.row]valueForKey:@"cityName"];
	strStateCityName = [strStateCityName stringByAppendingString:@", "];
	strStateCityName = [strStateCityName stringByAppendingString:[[[self.dict_MerchantList valueForKey:@"merchantsList"] objectAtIndex:indexPath.row]valueForKey:@"stateName"]];
	lblStateCityName.text = strStateCityName;
	lblStateCityName.textColor = [UIColor blackColor];
	lblStateCityName.adjustsFontSizeToFitWidth = TRUE;
	lblStateCityName.frame = CGRectMake(lblStateCityName.frame.origin.x, lblMerchantTitle.frame.origin.y + lblMerchantTitle.frame.size.height, lblStateCityName.frame.size.width, [CommonFunction heightOfOfferCell:strStateCityName andWidth:lblStateCityName.frame.size.width fontName:kFont fontSize:kAppDelegate.fontSize]);
	lblStateCityName.font = [UIFont italicSystemFontOfSize:lblStateCityName.font.pointSize];
    
    
	UILabel *lblMiles = (UILabel *)[cell viewWithTag:105];
    NSLog(@"%@",[[[self.dict_MerchantList valueForKey:@"merchantsList"] objectAtIndex:indexPath.row]valueForKey:@"global_merchant"]);
    if([[[[self.dict_MerchantList valueForKey:@"merchantsList"] objectAtIndex:indexPath.row]valueForKey:@"global_merchant"] isEqualToString:@"1"])
    {
        lblMiles.text = @"Nationwide";
        
    }
    else
    {
        lblMiles.text = [[[self.dict_MerchantList valueForKey:@"merchantsList"] objectAtIndex:indexPath.row]valueForKey:@"distance"];
        
    }
	lblMiles.textColor = [UIColor blackColor];
	lblMiles.adjustsFontSizeToFitWidth = TRUE;
}

//Fill rows for trollies
- (void)fillTrolleyRows:(NSIndexPath *)indexPath cell:(UITableViewCell *)cell {
	UIImageView *imgView = (UIImageView *)[cell viewWithTag:101];
	[imgView setImageWithURL:[NSURL URLWithString:[[[self.dict_MerchantList valueForKey:@"trolliesList"]valueForKey:@"thumb"] objectAtIndex:indexPath.row]]
	        placeholderImage:[UIImage imageNamed:@"default_offers_img.png"]];
    
	UILabel *lblTrollyTitle = (UILabel *)[cell viewWithTag:102];
	lblTrollyTitle.text = [[[self.dict_MerchantList valueForKey:@"trolliesList"]valueForKey:@"title"] objectAtIndex:indexPath.row];
	lblTrollyTitle.textColor = [UIColor blackColor];
	// lblMerchantTitle.adjustsFontSizeToFitWidth=TRUE;
	lblTrollyTitle.font = [UIFont fontWithName:kFont size:kAppDelegate.fontSize];
	lblTrollyTitle.frame = CGRectMake(lblTrollyTitle.frame.origin.x, lblTrollyTitle.frame.origin.y, lblTrollyTitle.frame.size.width, [CommonFunction heightOfOfferCell:[[[self.dict_MerchantList valueForKey:@"trolliesList"]valueForKey:@"title"] objectAtIndex:indexPath.row] andWidth:lblTrollyTitle.frame.size.width fontName:kFont fontSize:kAppDelegate.fontSize]);
	UILabel *lblStateCityName = (UILabel *)[cell viewWithTag:103];
	NSString *strStateCityName = [[[self.dict_MerchantList valueForKey:@"trolliesList"]valueForKey:@"location"] objectAtIndex:indexPath.row];
	strStateCityName = [strStateCityName stringByAppendingString:@", "];
	strStateCityName = [strStateCityName stringByAppendingString:[[[self.dict_MerchantList valueForKey:@"trolliesList"]valueForKey:@"city"] objectAtIndex:indexPath.row]];
	strStateCityName = [strStateCityName stringByAppendingString:@", "];
	strStateCityName = [strStateCityName stringByAppendingString:[[[self.dict_MerchantList valueForKey:@"trolliesList"]valueForKey:@"state"] objectAtIndex:indexPath.row]];
	lblStateCityName.text = strStateCityName;
	lblStateCityName.textColor = [UIColor blackColor];
	lblStateCityName.adjustsFontSizeToFitWidth = TRUE;
	lblStateCityName.frame = CGRectMake(lblStateCityName.frame.origin.x, lblTrollyTitle.frame.origin.y + lblTrollyTitle.frame.size.height, lblStateCityName.frame.size.width, [CommonFunction heightOfOfferCell:strStateCityName andWidth:lblStateCityName.frame.size.width fontName:kFont3 fontSize:kAppDelegate.fontSize]);
	lblStateCityName.font = [UIFont fontWithName:kFont3 size:kAppDelegate.fontSize];
}

//Fill rows for featured offers
- (void)fillFeaturedOfferRows:(NSIndexPath *)indexPath cell:(UITableViewCell *)cell {
	UILabel *lblDate = (UILabel *)[cell viewWithTag:103];
	lblDate.text = @"";
    
	UILabel *lblDistance = (UILabel *)[cell viewWithTag:105];
	lblDistance.text = @"";
    
	UIImageView *imgView = (UIImageView *)[cell viewWithTag:101];
	[imgView setImage:[UIImage imageNamed:@"default_offers_img.png"]];
    
	UILabel *lblFeaturedTitle = (UILabel *)[cell viewWithTag:102];
	lblFeaturedTitle.text = [[[self.dict_MerchantList valueForKey:@"featuredOffersList"]valueForKey:@"title"] objectAtIndex:indexPath.row];
	lblFeaturedTitle.textColor = [UIColor blackColor];
	// lblMerchantTitle.adjustsFontSizeToFitWidth=TRUE;
	lblFeaturedTitle.font = [UIFont fontWithName:kFont size:kAppDelegate.fontSize];
	lblFeaturedTitle.frame = CGRectMake(lblFeaturedTitle.frame.origin.x, lblFeaturedTitle.frame.origin.y, lblFeaturedTitle.frame.size.width, [CommonFunction heightOfOfferCell:[[[self.dict_MerchantList valueForKey:@"featuredOffersList"]valueForKey:@"title"] objectAtIndex:indexPath.row] andWidth:lblFeaturedTitle.frame.size.width fontName:kFont fontSize:kAppDelegate.fontSize]);
}

#pragma mark-
#pragma mark - Button Actions

- (IBAction)btnMapClicked:(id)sender {
	self.lbl_ScreenTitle.text = @"MAP™";
	selectedTab = kMap;
	self.imgLowerDivider.hidden = FALSE;
	self.imgUpperDivider.hidden = FALSE;
	[self setButtonImages:self.btnMap];
	[self getMerchantsList:kGetMerchantList];
	if (mapView.hidden) {
		mapView.hidden = FALSE;
		self.tbl_MerchantList.frame = CGRectMake(0, self.tbl_MerchantList.frame.origin.y + mapView.frame.size.height, self.tbl_MerchantList.frame.size.width, self.tbl_MerchantList.frame.size.height - mapView.frame.size.height);
	}
}

- (IBAction)btnBackClicked:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnTrolleyClicked:(id)sender {
	self.lbl_ScreenTitle.text = @"TROLLEY SCHEDULE™";
    
	self.imgLowerDivider.hidden = TRUE;
	self.imgUpperDivider.hidden = TRUE;
	selectedTab = kTrollies;
	[self setButtonImages:self.btnTrolley];
	[self getMerchantsList:kgettrollieslist];
    
	if (!mapView.hidden) {
		mapView.hidden = TRUE;
		self.tbl_MerchantList.frame = CGRectMake(0, self.tbl_MerchantList.frame.origin.y - mapView.frame.size.height, self.tbl_MerchantList.frame.size.width, self.tbl_MerchantList.frame.size.height + mapView.frame.size.height);
	}
}

- (IBAction)btnFeaturedClicked:(id)sender {
	self.lbl_ScreenTitle.text = @"FEATURED OFFERS™";
    
	self.imgLowerDivider.hidden = TRUE;
	self.imgUpperDivider.hidden = TRUE;
	selectedTab = kFeatured;
	[self setButtonImages:self.btnFeaturedOffers];
	[self getMerchantsList:kgetfeaturedofferslist];
	if (!mapView.hidden) {
		mapView.hidden = TRUE;
		self.tbl_MerchantList.frame = CGRectMake(0, self.tbl_MerchantList.frame.origin.y - mapView.frame.size.height, self.tbl_MerchantList.frame.size.width, self.tbl_MerchantList.frame.size.height + mapView.frame.size.height);
	}
}

- (void)setButtonImages:(UIButton *)button {
	if (button == self.btnMap) {
		button.userInteractionEnabled = NO;
		self.btnTrolley.userInteractionEnabled = YES;
		self.btnFeaturedOffers.userInteractionEnabled = YES;
        
		[button setBackgroundImage:[UIImage imageNamed:@"Map_Tab_hover.png"] forState:UIControlStateNormal];
		[self.btnTrolley setBackgroundImage:[UIImage imageNamed:@"Trolley_Tab.png"] forState:UIControlStateNormal];
		[self.btnFeaturedOffers setBackgroundImage:[UIImage imageNamed:@"Featured_Tab.png"] forState:UIControlStateNormal];
	}
	else if (button == self.btnTrolley) {
		button.userInteractionEnabled = NO;
		self.btnMap.userInteractionEnabled = YES;
		self.btnFeaturedOffers.userInteractionEnabled = YES;
		[button setBackgroundImage:[UIImage imageNamed:@"Trolley_Tab_hover.png"] forState:UIControlStateNormal];
		[self.btnMap setBackgroundImage:[UIImage imageNamed:@"Map_Tab.png"] forState:UIControlStateNormal];
		[self.btnFeaturedOffers setBackgroundImage:[UIImage imageNamed:@"Featured_Tab.png"] forState:UIControlStateNormal];
	}
	else if (button == self.btnFeaturedOffers) {
		button.userInteractionEnabled = NO;
		self.btnMap.userInteractionEnabled = YES;
		self.btnTrolley.userInteractionEnabled = YES;
		[button setBackgroundImage:[UIImage imageNamed:@"Featured_Tab_hover.png"] forState:UIControlStateNormal];
		[self.btnTrolley setBackgroundImage:[UIImage imageNamed:@"Trolley_Tab.png"] forState:UIControlStateNormal];
		[self.btnMap setBackgroundImage:[UIImage imageNamed:@"Map_Tab.png"] forState:UIControlStateNormal];
	}
}

@end
