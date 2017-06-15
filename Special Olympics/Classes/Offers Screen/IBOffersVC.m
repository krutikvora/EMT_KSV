//
//  IBOffersVC.m
//  iBuddyClient
//
//  Created by Anubha on 13/05/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import "IBOffersVC.h"
#import "SVPullToRefresh.h"
#import "UIImageView+WebCache.h"
#import <AudioToolbox/AudioServices.h>
#import <AudioToolbox/AudioToolbox.h>
#define kOfferTableWidthIPhone 191
#define kOfferTableWidthIPad 553
#define kIncrementFactor 5
#define kAvailableCountHeighht 20
#define kTableCellGapFromY 7
#define kPurchaseAlertTag 9897
#define kDonationAlertTag 9696
#define kRedeemAlertTag 9595
@interface IBOffersVC () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tbl_OffersList;
@property (weak, nonatomic) IBOutlet UILabel *lbl_ScreenTitle;
@property int btnRedeemIndex;
- (IBAction)btnBackClicked:(id)sender;
- (IBAction)btnaddressClicked:(id)sender;
- (IBAction)btnphoneClicked:(id)sender;
- (IBAction)btnWebsiteClicked:(id)sender;
@end
@implementation IBOffersVC
@synthesize viewForOffer;
@synthesize dict_OffersList;
@synthesize isSubscribed;
@synthesize tblCustomCellOffer;
@synthesize dictMerchantInfo;
@synthesize offset,isInfiniteCalled;
@synthesize arrOffers;
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
    
	[self setInitialVariables];
    if ([[dictMerchantInfo valueForKey:@"IsEvent"] isEqualToString:@"1"])
    {
        self.lbl_ScreenTitle.text = @"EVENTS™";
		[self.tbl_OffersList addPullToRefreshWithActionHandler: ^{
		    [self getMerchantEvents];
		}];
	}
	else {
        arrOffers=[[NSMutableArray alloc]init];
        isInfiniteCalled=false;
        offset=0;
        self.lbl_ScreenTitle.text = @"OFFERS™";
        
		[self.tbl_OffersList addPullToRefreshWithActionHandler: ^{
		    [self getMerchantOffer];
		}];
        [self.tbl_OffersList addInfiniteScrollingWithActionHandler:^{
            if(isInfiniteCalled==false)
            {
            offset=offset+40;

            [self getMerchantOffer];
            
            [self.tbl_OffersList.infiniteScrollingView performSelector:@selector(stopAnimating) withObject:nil];
            }
        }];
	}

	// Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:YES];
    if ([[dictMerchantInfo valueForKey:@"IsEvent"] isEqualToString:@"1"]) {
		[self getMerchantEvents];
	}
	else {
        arrOffers=[[NSMutableArray alloc]init];
        [self getMerchantOffer];

//        [self.tbl_OffersList addInfiniteScrollingWithActionHandler:^{
//            if(isInfiniteCalled==false)
//            {
//                offset=offset+40;
//                
//
//                [self.tbl_OffersList.infiniteScrollingView performSelector:@selector(stopAnimating) withObject:nil];
//            }
//        }];
	}}

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

- (void)didReceiveMemoryWarning {
	// [self setMapView:nil];
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
	//  [self setMapView:nil];
	[self setVwOffers:nil];
	[self setLblMerchnatName:nil];
	[self setScrlView:nil];
	[self setTxtAddress:nil];
	[super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown
	        || interfaceOrientation == UIInterfaceOrientationPortrait);
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
- (void)getMerchantEvents {
	self.isSubscribed = FALSE;
	viewForOffer = viewForOffers;
	[kAppDelegate showProgressHUD:self.view];
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	[dict setValue:[dictMerchantInfo valueForKey:@"merchantId"] forKey:@"merchantId"];
    
	[AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dict method:kMerchantEventlistbymerchant] completeBlock: ^(NSData *data) {
	    id result = [NSJSONSerialization JSONObjectWithData:data
	                                                options:kNilOptions error:nil];
        NSLog(@"Event result :: %@",result);
	    if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
		}
	    else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]) {
	        [CommonFunction fnAlert:@"Alert!" message:@"No Event exist"];
		}
	    else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]) {
	        [CommonFunction fnAlert:@"Alert!" message:@"Please try again"];
		}
	    else {
	        [CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
		}
	    if (self.dict_OffersList) {
	        self.dict_OffersList = nil;
		}
	    self.dict_OffersList = [[NSMutableDictionary alloc]init];
	    self.dict_OffersList = result;
	    [self.tbl_OffersList reloadData];
	    [self setMerchantDetail];
	    // [self setMapView];
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
	[self.tbl_OffersList.pullToRefreshView stopAnimating];
}
- (void)getMerchantOffer {
	if ([[[kAppDelegate dictUserInfo]valueForKey:@"userId"] length] > 0) {
		viewForOffer = viewForScannedoffers;
		[kAppDelegate showProgressHUD:self.view];
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
		[dict setValue:[[kAppDelegate dictUserInfo]valueForKey:@"userId"] forKey:@"userId"];
		[dict setValue:[dictMerchantInfo valueForKey:@"merchantId"]  forKey:@"merchantId"];
		[dict setValue:[dictMerchantInfo valueForKey:@"categoryId"]  forKey:@"categoryId"];
        [dict setValue:@"40"  forKey:@"limit"];
        [dict setValue:@"1" forKey:@"callfromfirerescuefunding"];

        [dict setValue:[NSString stringWithFormat:@"%d",offset]  forKey:@"offset"];

		[AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:(NSMutableDictionary *)dict method:kOffersListUserID] completeBlock: ^(NSData *data) {
		    id result = [NSJSONSerialization JSONObjectWithData:data
		                                                options:kNilOptions error:nil];
		    NSLog(@"Result -- %@", result);
		    if ([[result valueForKey:@"isSubscribed"] isEqualToString:@"yes"] && [[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
		        self.isSubscribed = TRUE;
			}
		    else if ([[result valueForKey:@"isSubscribed"] isEqualToString:@"no"] && [[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
		        viewForOffer = viewForOffers;
		        self.isSubscribed = FALSE;
			}
		    else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]) {
                isInfiniteCalled=true;
		        [CommonFunction fnAlert:@"" message:@"No more results"];
			}
		    else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]) {
		        [CommonFunction fnAlert:@"" message:@"Please try again"];
			}
		    else {
		        [CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
			}
		    if (self.dict_OffersList) {
		        self.dict_OffersList = nil;
			}
		    self.tbl_OffersList.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
		    self.dict_OffersList = [[NSMutableDictionary alloc]init];
		    self.dict_OffersList = [result mutableCopy];
            
            NSArray *arrData=[self.dict_OffersList valueForKey:@"offersList"];
            
            [arrOffers addObjectsFromArray:arrData];
            [self.dict_OffersList setObject:arrOffers forKey:@"offersList"];

            
            
            
		    [self setMerchantDetail];
		    //[self setMapView];
            
		    [self.tbl_OffersList reloadData];
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
	}
	else {
		self.isSubscribed = FALSE;
		viewForOffer = viewForOffers;
		[kAppDelegate showProgressHUD:self.view];
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
		[dict setValue:[dictMerchantInfo valueForKey:@"merchantId"] forKey:@"merchantId"];
        [dict setValue:@"40"  forKey:@"limit"];
        [dict setValue:[NSString stringWithFormat:@"%d",offset]  forKey:@"offset"];

		[AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dict method:kOffersListMerchantID] completeBlock: ^(NSData *data) {
		    id result = [NSJSONSerialization JSONObjectWithData:data
		                                                options:kNilOptions error:nil];
		    if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
			}
		    else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]) {
                isInfiniteCalled=true;
                [CommonFunction fnAlert:@"" message:@"No more results"];
			}
		    else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]) {
		        [CommonFunction fnAlert:@"Alert!" message:@"Please try again"];
			}
		    else {
		        [CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
			}
		    if (self.dict_OffersList) {
		        self.dict_OffersList = nil;
			}
		    self.dict_OffersList = [[NSMutableDictionary alloc]init];
		    self.dict_OffersList = [result mutableCopy];
            NSArray *arrData=[self.dict_OffersList valueForKey:@"offersList"];
            
            [arrOffers addObjectsFromArray:arrData];
            [self.dict_OffersList setObject:arrOffers forKey:@"offersList"];

            
		    [self.tbl_OffersList reloadData];
		    [self setMerchantDetail];
		    // [self setMapView];
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
	}
	[self.tbl_OffersList.pullToRefreshView stopAnimating];
}

- (void)setInitialVariables {
	self.lbl_ScreenTitle.font = [UIFont fontWithName:kFont size:_lbl_ScreenTitle.font.pointSize];
	_scrlView.contentSize = CGSizeMake(0, 420);
}

- (void)setMapView {
	_lblMerchnatName.text = [[self.dict_OffersList valueForKey:@"merchant"]valueForKey:@"merchantName"];
	_lblMerchnatName.font = [UIFont fontWithName:kFont size:_lblMerchnatName.font.pointSize];
	Annotation *annotation = [[Annotation alloc] initWithLatitude:[[[self.dict_OffersList valueForKey:@"merchant"]valueForKey:@"merchantLat"]floatValue] andLongitude:[[[self.dict_OffersList valueForKey:@"merchant"]valueForKey:@"merchantLong"]floatValue]];
	annotation.type  = @"Source";
    
	NSString *pinAddress;
	if ([[[self.dict_OffersList valueForKey:@"merchant"]valueForKey:@"merchantAddress"]length] > 0) {
		pinAddress = [[self.dict_OffersList valueForKey:@"merchant"]valueForKey:@"merchantName"];
		pinAddress = [pinAddress stringByAppendingString:@","];
		pinAddress = [pinAddress stringByAppendingString:[[self.dict_OffersList valueForKey:@"merchant"]valueForKey:@"merchantAddress"]];
	}
	else {
		pinAddress = [[self.dict_OffersList valueForKey:@"merchant"]valueForKey:@"merchantName"];
		pinAddress = [pinAddress stringByAppendingString:@","];
		pinAddress = [pinAddress stringByAppendingString:[[self.dict_OffersList valueForKey:@"merchant"]valueForKey:@"merchantCity"]];
		pinAddress = [pinAddress stringByAppendingString:@","];
		pinAddress = [pinAddress stringByAppendingString:[[self.dict_OffersList valueForKey:@"merchant"]valueForKey:@"merchantState"]];
	}
    
	annotation.title = pinAddress;
	[mapView addAnnotation:annotation];
	[mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake([[[self.dict_OffersList valueForKey:@"merchant"]valueForKey:@"merchantLat"]floatValue], [[[self.dict_OffersList valueForKey:@"merchant"]valueForKey:@"merchantLong"]floatValue]), MKCoordinateSpanMake(10, 10))];
	[self setCenterCoordinate:CLLocationCoordinate2DMake([[[self.dict_OffersList valueForKey:@"merchant"]valueForKey:@"merchantLat"]floatValue], [[[self.dict_OffersList valueForKey:@"merchant"]valueForKey:@"merchantLong"]floatValue]) zoomLevel:14 animated:YES];
}

- (void)setMerchantDetail {
    
    NSString *strPhoneNumber=@"";
    NSString *strURL=@"";
    //Commented by Utkarsha on 3rd sep as client changed the links to icons
	float vwOffersY;
	float scrlViewHeight;
	if (kDevice == kIphone) {
		vwOffersY = 38;
		scrlViewHeight = 436;
	}
	else {
		vwOffersY = 45;
		scrlViewHeight = 980;
	}
    NSMutableArray *arrMerchantData=[self.dict_OffersList valueForKey:@"merchant"];
	if ([arrMerchantData count] > 0) {
		if ([[[self.dict_OffersList valueForKey:@"merchant"]valueForKey:@"merchantAddress"]length] > 0) {
			strMerchantAddress = [[self.dict_OffersList valueForKey:@"merchant"]valueForKey:@"merchantAddress"];
			strMerchantAddress = [strMerchantAddress stringByAppendingString:@", "];
			strMerchantAddress = [strMerchantAddress stringByAppendingString:[[self.dict_OffersList valueForKey:@"merchant"]valueForKey:@"merchantCity"]];
			strMerchantAddress = [strMerchantAddress stringByAppendingString:@", "];
			strMerchantAddress = [strMerchantAddress stringByAppendingString:[[self.dict_OffersList valueForKey:@"merchant"]valueForKey:@"merchantState"]];
			if ([[[self.dict_OffersList valueForKey:@"merchant"]valueForKey:@"merchantZipcode"]length] > 0) {
				strMerchantAddress = [strMerchantAddress stringByAppendingString:@", "];
				strMerchantAddress = [strMerchantAddress stringByAppendingString:[[self.dict_OffersList valueForKey:@"merchant"]valueForKey:@"merchantZipcode"]];
			}
            if ([[[self.dict_OffersList valueForKey:@"merchant"]valueForKey:@"merchantPhone"]length] > 0) {
				strPhoneNumber = [strPhoneNumber stringByAppendingString:[[self.dict_OffersList valueForKey:@"merchant"]valueForKey:@"merchantPhone"]];
			}
            else
            {
                _btnPhone.enabled=FALSE;
            }
			if ([[[self.dict_OffersList valueForKey:@"merchant"]valueForKey:@"merchantUrl"]length] > 0) {
				strURL = [strURL stringByAppendingString:[[self.dict_OffersList valueForKey:@"merchant"]valueForKey:@"merchantUrl"]];
			}
            else
            {
                _btnWeb.enabled=FALSE;
            }
		}
		else {
			strMerchantAddress = [[self.dict_OffersList valueForKey:@"merchant"]valueForKey:@"merchantCity"];
			strMerchantAddress = [strMerchantAddress stringByAppendingString:@", "];
			strMerchantAddress = [strMerchantAddress stringByAppendingString:[[self.dict_OffersList valueForKey:@"merchant"]valueForKey:@"merchantState"]];
			if ([[[self.dict_OffersList valueForKey:@"merchant"]valueForKey:@"merchantZipcode"]length] > 0) {
				strMerchantAddress = [strMerchantAddress stringByAppendingString:@", "];
				strMerchantAddress = [strMerchantAddress stringByAppendingString:[[self.dict_OffersList valueForKey:@"merchant"]valueForKey:@"merchantZipcode"]];
			}
            if ([[[self.dict_OffersList valueForKey:@"merchant"]valueForKey:@"merchantPhone"]length] > 0) {
				strPhoneNumber = [strPhoneNumber stringByAppendingString:[[self.dict_OffersList valueForKey:@"merchant"]valueForKey:@"merchantPhone"]];
			}
            else
            {
                _btnPhone.enabled=FALSE;
            }
			if ([[[self.dict_OffersList valueForKey:@"merchant"]valueForKey:@"merchantUrl"]length] > 0) {
				strURL = [strURL stringByAppendingString:[[self.dict_OffersList valueForKey:@"merchant"]valueForKey:@"merchantUrl"]];
			}
            else
            {
                _btnWeb.enabled=FALSE;
            }
		}
        _txtPhoneNumber.font = [UIFont fontWithName:@"Georgia-Italic" size:_txtPhoneNumber.font.pointSize];
        _txtUrl.font = [UIFont fontWithName:@"Georgia-Italic" size:_txtUrl.font.pointSize];
		_txtAddress.font = [UIFont fontWithName:@"Georgia-Italic" size:_txtAddress.font.pointSize];
		[UIView animateWithDuration:0.4 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations: ^{
            float totalHeight=0.0f;
            float phoneheight=0.0f;
            float URLHeight=0.0f;
		    self.txtAddress.hidden = FALSE;
            self.txtPhoneNumber.hidden=FALSE;
            self.txtUrl.hidden=FALSE;
		    _txtAddress.editable = NO;
            _txtPhoneNumber.editable=NO;
            _txtPhoneNumber.textColor=[UIColor darkGrayColor];
            _txtUrl.editable=NO;
            _txtUrl.textColor=[UIColor darkGrayColor];
		    _txtAddress.textColor =[UIColor darkGrayColor];
            /** Implemented by Nishu on 12th Sep */
            if (kDevice == kIphone) {
                float addressHeight=[CommonFunction heightOfLabel:strMerchantAddress andWidth:125 fontName:@"Georgia-Italic"  fontSize:_txtAddress.font.pointSize]+10;
                if([strPhoneNumber length]>0)
                {
                    phoneheight=[CommonFunction heightOfLabel:strPhoneNumber andWidth:self.txtPhoneNumber.frame.size.width fontName:@"Georgia-Italic"  fontSize:_txtPhoneNumber.font.pointSize]+10;
                }
                if([strURL length]>0)
                {
                    URLHeight=[CommonFunction heightOfLabel:strURL andWidth:165 fontName:@"Georgia-Italic"  fontSize:_txtUrl.font.pointSize]+10;
                }
                totalHeight=addressHeight+phoneheight;
                URLHeight=self.btnPhone.frame.size.height+URLHeight;

                self.txtAddress.frame = CGRectMake(self.txtAddress.frame.origin.x, self.txtAddress.frame.origin.y, 135, addressHeight);
                self.txtPhoneNumber.frame = CGRectMake(self.txtPhoneNumber.frame.origin.x, self.txtAddress.frame.origin.y + _txtAddress.frame.size.height-5, self.txtPhoneNumber.frame.size.width, [CommonFunction heightOfLabel:strPhoneNumber andWidth:self.txtPhoneNumber.frame.size.width fontName:@"Georgia-Italic"  fontSize:_txtPhoneNumber.font.pointSize] + 10);
                self.txtUrl.frame = CGRectMake(145, self.btnPhone.frame.origin.y+self.btnPhone.frame.size.height-5, 170, [CommonFunction heightOfLabel:strURL andWidth:170 fontName:@"Georgia-Italic"  fontSize:_txtUrl.font.pointSize] + 10);
                if([strURL length]>0)
                {
                    if(totalHeight>URLHeight)
                    {
                        self.vwOffers.frame = CGRectMake(self.vwOffers.frame.origin.x, vwOffersY + totalHeight, self.vwOffers.frame.size.width, self.vwOffers.frame.size.height);
                        _scrlView.contentSize = CGSizeMake(_scrlView.contentSize.width, scrlViewHeight + totalHeight);
                    }
                    else
                    {
                        self.vwOffers.frame = CGRectMake(self.vwOffers.frame.origin.x, vwOffersY + URLHeight, self.vwOffers.frame.size.width, self.vwOffers.frame.size.height);
                        _scrlView.contentSize = CGSizeMake(_scrlView.contentSize.width, scrlViewHeight + URLHeight);
                    }
                }
                else
                {
                    if(totalHeight<54)
                    {
                        totalHeight=54;
                    }
                    self.vwOffers.frame = CGRectMake(self.vwOffers.frame.origin.x, vwOffersY + totalHeight, self.vwOffers.frame.size.width, self.vwOffers.frame.size.height);
                    _scrlView.contentSize = CGSizeMake(_scrlView.contentSize.width, scrlViewHeight + totalHeight);
                }
            }
            else
            {
                float addressHeight=[CommonFunction heightOfLabel:strMerchantAddress andWidth:self.txtAddress.frame.size.width fontName:@"Georgia-Italic"  fontSize:_txtAddress.font.pointSize]+10;
                if([strPhoneNumber length]>0)
                {
                    phoneheight=[CommonFunction heightOfLabel:strPhoneNumber andWidth:self.txtPhoneNumber.frame.size.width fontName:@"Georgia-Italic"  fontSize:_txtPhoneNumber.font.pointSize]+10;
                }
                if([strURL length]>0)
                {
                    URLHeight=[CommonFunction heightOfLabel:strURL andWidth:450 fontName:@"Georgia-Italic"  fontSize:_txtUrl.font.pointSize]+10;
                }
                totalHeight=addressHeight+phoneheight;
                URLHeight=self.btnPhone.frame.size.height+URLHeight;

                self.txtAddress.frame = CGRectMake(self.txtAddress.frame.origin.x, self.txtAddress.frame.origin.y, self.txtAddress.frame.size.width, [CommonFunction heightOfLabel:strMerchantAddress andWidth:self.txtAddress.frame.size.width fontName:@"Georgia-Italic"  fontSize:_txtAddress.font.pointSize] + 10);
                self.txtPhoneNumber.frame = CGRectMake(self.txtPhoneNumber.frame.origin.x, self.txtAddress.frame.origin.y + _txtAddress.frame.size.height-5, self.txtPhoneNumber.frame.size.width, [CommonFunction heightOfLabel:strPhoneNumber andWidth:self.txtPhoneNumber.frame.size.width fontName:@"Georgia-Italic"  fontSize:_txtPhoneNumber.font.pointSize] + 10);
                if([strPhoneNumber length]>0)
                {
                    self.txtUrl.frame = CGRectMake(self.txtUrl.frame.origin.x, self.txtPhoneNumber.frame.origin.y + _txtPhoneNumber.frame.size.height-5, self.txtUrl.frame.size.width, [CommonFunction heightOfLabel:strURL andWidth:self.txtUrl.frame.size.width fontName:@"Georgia-Italic"  fontSize:_txtUrl.font.pointSize] + 10);
                }
                else
                {
                    self.txtUrl.frame = CGRectMake(self.txtUrl.frame.origin.x, self.txtAddress.frame.origin.y + _txtAddress.frame.size.height-5, self.txtUrl.frame.size.width, [CommonFunction heightOfLabel:strURL andWidth:self.txtUrl.frame.size.width fontName:@"Georgia-Italic"  fontSize:_txtUrl.font.pointSize] + 10);
                }
                if(totalHeight<90)
                {
                    totalHeight=90;
                }
                self.vwOffers.frame = CGRectMake(self.vwOffers.frame.origin.x, vwOffersY + totalHeight, self.vwOffers.frame.size.width, self.vwOffers.frame.size.height);
                _scrlView.contentSize = CGSizeMake(_scrlView.contentSize.width, scrlViewHeight + totalHeight);
            }
		} completion: ^(BOOL finished) {
		}];
        _txtAddress.text = strMerchantAddress;
        _txtPhoneNumber.text=strPhoneNumber;
        _txtUrl.text=strURL;
        mapView = [[MKMapView alloc]init];
        if (kDevice == kIphone) {
            mapView.frame = CGRectMake(0, 4, 320, 100);
        }
        else {
            mapView.frame = CGRectMake(0, 4, 768, 294);
        }
        [self.vwOffers addSubview:mapView];
        [self setMapView];
    }
}
- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel animated:(BOOL)animated {
	MKCoordinateSpan span = MKCoordinateSpanMake(0, 360 / pow(2, zoomLevel) * mapView.frame.size.width / 256);
	[mapView setRegion:MKCoordinateRegionMake(centerCoordinate, span) animated:animated];
}

#pragma mark -
#pragma mark - UITableView Deletgate & Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	//#warning Potentially incomplete method implementation.
	// Return the number of sections.
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int rowCount;
	if ([[dictMerchantInfo valueForKey:@"IsEvent"] isEqualToString:@"1"]) {
        NSMutableArray *arrMerchantData=[self.dict_OffersList valueForKey:@"merchantEventList"];

		rowCount = [arrMerchantData count];
	}
	else {
        
        NSMutableArray *arrMerchantData=[self.dict_OffersList valueForKey:@"offersList"];

        rowCount =[arrMerchantData count];
	}
	return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"customCellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSLog(@"%@",self.dict_OffersList);
    
    NSLog(@"%@",[[[self.dict_OffersList valueForKey:@"offersList"]valueForKey:@"offerThumbImage"] objectAtIndex:indexPath.row]);
	if (tableView.tag != 1001) {
		if (kDevice == kIphone) {
			if (cell == nil) {
				[[NSBundle mainBundle] loadNibNamed:@"IBOfferTableCell" owner:self options:nil];
				cell = tblCustomCellOffer;
			}
		}
		else {
			[[NSBundle mainBundle] loadNibNamed:@"IBOfferTableCell_iPad" owner:self options:nil];
			cell = tblCustomCellOffer;
		}
		cell.backgroundColor = nil;
	}
    
    
    if ([[dictMerchantInfo valueForKey:@"IsEvent"] isEqualToString:@"1"])
    {
        UIImageView *imgView = (UIImageView *)[cell viewWithTag:101];
        [imgView setImageWithURL:[NSURL URLWithString:[[[self.dict_OffersList valueForKey:@"merchantEventList"]valueForKey:@"event_logo"] objectAtIndex:indexPath.row]]
                placeholderImage:[UIImage imageNamed:@"default_offers_img.png"]];
        imgView.backgroundColor = [UIColor clearColor];
        imgView.layer.borderColor = [[UIColor grayColor]CGColor];
        
        UILabel *lblOfferTitle = (UILabel *)[cell viewWithTag:102];
        lblOfferTitle.text = [[[self.dict_OffersList valueForKey:@"merchantEventList"]objectAtIndex:indexPath.row] valueForKey:@"title"];
		lblOfferTitle.textColor = [UIColor blackColor];
		lblOfferTitle.frame = CGRectMake(lblOfferTitle.frame.origin.x, lblOfferTitle.frame.origin.y, lblOfferTitle.frame.size.width, [CommonFunction heightOfOfferCell:[[[self.dict_OffersList valueForKey:@"merchantEventList"]objectAtIndex:indexPath.row] valueForKey:@"title"] andWidth:lblOfferTitle.frame.size.width fontName:kFont fontSize:kAppDelegate.fontSize]);
        cell.tag = indexPath.row;
        
    }
    else
    {

	UIImageView *imgView = (UIImageView *)[cell viewWithTag:101];
	[imgView setImageWithURL:[NSURL URLWithString:[[[self.dict_OffersList valueForKey:@"offersList"]valueForKey:@"offerThumbImage"] objectAtIndex:indexPath.row]]
	        placeholderImage:[UIImage imageNamed:@"default_offers_img.png"]];
	imgView.backgroundColor = [UIColor clearColor];
	imgView.layer.borderColor = [[UIColor grayColor]CGColor];
	UILabel *lblAvailablecount = (UILabel *)[cell viewWithTag:103];
	UIImageView *imgSelected = [[UIImageView alloc]init];
	imgSelected.image = [UIImage imageNamed:@"RowHighlight@2x.png"]; //OffersListBG_iPad@2x
	[cell setSelectedBackgroundView:imgSelected];
	cell.tag = indexPath.row;
    
	UILabel *lblOfferTitle = (UILabel *)[cell viewWithTag:102];
	if (viewForOffer == viewForOffers) {
		lblOfferTitle.text = [[[self.dict_OffersList valueForKey:@"offersList"]objectAtIndex:indexPath.row] valueForKey:@"offerTitle"];
		lblOfferTitle.textColor = [UIColor blackColor];
		lblOfferTitle.frame = CGRectMake(lblOfferTitle.frame.origin.x, lblOfferTitle.frame.origin.y, lblOfferTitle.frame.size.width, [CommonFunction heightOfOfferCell:[[[self.dict_OffersList valueForKey:@"offersList"]objectAtIndex:indexPath.row] valueForKey:@"offerTitle"] andWidth:lblOfferTitle.frame.size.width fontName:kFont fontSize:kAppDelegate.fontSize]);
	}
	else if (viewForOffer == viewForScannedoffers) {
		lblOfferTitle.text = [[[self.dict_OffersList valueForKey:@"offersList"]objectAtIndex:indexPath.row] valueForKey:@"offerTitle"];
		lblOfferTitle.frame = CGRectMake(lblOfferTitle.frame.origin.x, lblOfferTitle.frame.origin.y, lblOfferTitle.frame.size.width, [CommonFunction heightOfOfferCell:[[[self.dict_OffersList valueForKey:@"offersList"]objectAtIndex:indexPath.row] valueForKey:@"offerTitle"] andWidth:lblOfferTitle.frame.size.width fontName:kFont fontSize:kAppDelegate.fontSize]);
        
		if ((![[[[self.dict_OffersList valueForKey:@"offersList"]valueForKey:@"availableCount"] objectAtIndex:indexPath.row]isEqualToString:@"0"])) {
			lblOfferTitle.textColor = [UIColor blackColor];
			lblOfferTitle.highlightedTextColor = [UIColor blackColor];
			lblAvailablecount.textColor = [UIColor blackColor];
			lblAvailablecount.highlightedTextColor = [UIColor darkGrayColor];
			if ([[[[self.dict_OffersList valueForKey:@"offersList"]valueForKey:@"isAvailable"] objectAtIndex:indexPath.row]isEqual:[NSNumber numberWithChar:0]]) {
				lblAvailablecount.text = @"No redemptions available.";
			}
			else {
				lblAvailablecount.text = @"Redemptions available.";
			}
		}
		else {
			lblOfferTitle.textColor = [UIColor colorWithRed:150.0 / 255.0 green:31.0 / 255.0 blue:28.0 / 255.0 alpha:1.0];
			lblOfferTitle.highlightedTextColor = [UIColor colorWithRed:100.0 / 255.0 green:31.0 / 255.0 blue:28.0 / 255.0 alpha:1.0];
			lblAvailablecount.textColor = [UIColor colorWithRed:150.0 / 255.0 green:31.0 / 255.0 blue:28.0 / 255.0 alpha:1.0];
			lblAvailablecount.highlightedTextColor = [UIColor colorWithRed:100.0 / 255.0 green:31.0 / 255.0 blue:28.0 / 255.0 alpha:1.0];
			lblAvailablecount.text = [NSString stringWithFormat:@"Can be redeemed %@", [[[self.dict_OffersList valueForKey:@"offersList"]valueForKey:@"alert"] objectAtIndex:indexPath.row]];
		}
		lblAvailablecount.frame = CGRectMake(lblAvailablecount.frame.origin.x, (lblOfferTitle.frame.origin.y + lblOfferTitle.frame.size.height), lblAvailablecount.frame.size.width, lblAvailablecount.frame.size.height);
	}
	lblOfferTitle.font = [UIFont fontWithName:kFont size:kAppDelegate.fontSize];
	lblAvailablecount.adjustsFontSizeToFitWidth = YES;
	lblAvailablecount.font = [UIFont italicSystemFontOfSize:kAppDelegate.fontSizeSmallest];
	NSString *strType;
	if (kDevice == kIphone) {
		strType = @"@2x.png";
	}
	else {
		strType = @"@2x~ipad.png";
	}
	if ([[cell.contentView.subviews lastObject]isKindOfClass:[UIButton class]]) {
		NSString *userCompleteIncomplete = [[kAppDelegate dictUserInfo]valueForKey:@"profileComplete"];
		UIButton *btn = (UIButton *)[cell.contentView.subviews lastObject];
		if (self.isSubscribed == TRUE && [userCompleteIncomplete isEqualToString:@"1"]) {
			[btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"RedeemIcon%@", strType]] forState:UIControlStateNormal];
		}
		else {
			[btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"RedeemIconlocked%@", strType]] forState:UIControlStateNormal];
		}
		btn.tag = indexPath.row;
	}
	else {
		UIButton *btn_Redeem = [UIButton buttonWithType:UIButtonTypeCustom];
		btn_Redeem.tag = indexPath.row;
		if (kDevice == kIphone) {
			btn_Redeem.frame = CGRectMake(260, 10, 40, 49);
		}
		else {
			btn_Redeem.frame = CGRectMake(660, 1, 45, 55);
		}
		NSString *userCompleteIncomplete = [[kAppDelegate dictUserInfo]valueForKey:@"profileComplete"];
		if (self.isSubscribed == TRUE && [userCompleteIncomplete isEqualToString:@"1"]) {
			[btn_Redeem setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"RedeemIcon%@", strType]] forState:UIControlStateNormal];
		}
		else {
			[btn_Redeem setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"RedeemIconlocked%@", strType]] forState:UIControlStateNormal];
		}
		[btn_Redeem addTarget:self action:@selector(btnRedeemClicked:) forControlEvents:UIControlEventTouchUpInside];
		[cell.contentView addSubview:btn_Redeem];
	}
    }
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

    if (self.isSubscribed == TRUE && [[[kAppDelegate dictUserInfo]valueForKey:@"profileComplete"] isEqualToString:@"1"]) {
        if ([[dictMerchantInfo valueForKey:@"IsEvent"] isEqualToString:@"1"])
        {
            IBEventDetailVC *objIBEventDetailVC;
            if (kDevice == kIphone) {
                objIBEventDetailVC   = [[IBEventDetailVC alloc]initWithNibName:@"IBEventDetailVC" bundle:nil];
            }
            else {
                objIBEventDetailVC   = [[IBEventDetailVC alloc]initWithNibName:@"IBEventDetailVC_iPad" bundle:nil];
            }
            objIBEventDetailVC.eventID = [[[[self.dict_OffersList valueForKey:@"merchantEventList"] objectAtIndex:indexPath.row]valueForKey:@"id"] intValue];
            objIBEventDetailVC.strMethod = @"1";
            [self.navigationController pushViewController:objIBEventDetailVC animated:YES];
        }
        else
        {
            IBOffersDescriptionVC *objIBOffersDescriptionVC;
            if (kDevice == kIphone) {
                objIBOffersDescriptionVC   =   [[IBOffersDescriptionVC alloc]initWithNibName:@"IBOffersDescriptionVC" bundle:nil];
            }
            else {
                objIBOffersDescriptionVC   =   [[IBOffersDescriptionVC alloc]initWithNibName:@"IBOfferDescriptionVC_iPad" bundle:nil];
            }
            objIBOffersDescriptionVC.delegate = self;
            objIBOffersDescriptionVC.dict_OfferDetail = [self setDictMerchantAndOffers:indexPath.row];
            [self.navigationController pushViewController:objIBOffersDescriptionVC animated:YES];
        }
    }
    else {
        UIAlertView *alertPurchase = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Purchase now to unlock the details." delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        alertPurchase.tag = kPurchaseAlertTag;
        [alertPurchase show];
    }

    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	float height = 0;
	float width = 0;
	if (kDevice == kIphone) {
		width = kOfferTableWidthIPhone;
	}
	else {
		width = kOfferTableWidthIPad;
	}
	if (self.isSubscribed == TRUE) {
		height = [CommonFunction heightOfOfferCell:[[[self.dict_OffersList valueForKey:@"offersList"]objectAtIndex:indexPath.row] valueForKey:@"offerTitle"] andWidth:width fontName:kFont fontSize:kAppDelegate.fontSize] + kTableCellGapFromY;
		if (height < 50) {
			height = 50 + kTableCellGapFromY + kIncrementFactor;
		}
		else {
			height = height + kIncrementFactor + kAvailableCountHeighht;
		}
	}
	else {
		height = [CommonFunction heightOfOfferCell:[[[self.dict_OffersList valueForKey:@"offersList"]objectAtIndex:indexPath.row] valueForKey:@"offerTitle"] andWidth:width fontName:kFont fontSize:kAppDelegate.fontSize] + kTableCellGapFromY;
		if (height < 50) {
			height = 50 + kTableCellGapFromY + kIncrementFactor;
		}
		else {
			height = height + kIncrementFactor;
		}
	}
	return height;
}

#pragma mark-
#pragma mark - Button Actions

- (IBAction)btnBackClicked:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)btnRedeemClicked:(id)sender {
	if (self.isSubscribed == TRUE && [[[kAppDelegate dictUserInfo]valueForKey:@"profileComplete"] isEqualToString:@"1"]) {
		_btnRedeemIndex = [sender tag];
		UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Are you at the merchant location and sure you want to redeem this offer?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
		alertView.tag = kRedeemAlertTag;
		[alertView show];
	}
	else {
		if ([[[kAppDelegate dictUserInfo]valueForKey:@"userId"]length] > 0 && [[[kAppDelegate dictUserInfo] valueForKey:@"isUserGruEdu"] intValue] == 1) {
			UIAlertView *alertPurchase = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Purchase now for reduced price of $3.99/month to unlock all deals." delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
			alertPurchase.tag = kPurchaseAlertTag;
			[alertPurchase show];
		}
		else {
			UIAlertView *alertPurchase = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Purchase now to unlock all deals." delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
			alertPurchase.tag = kPurchaseAlertTag;
			[alertPurchase show];
		}
	}
}

- (void)showAlert {
    
    //[[[self.dict_OffersList valueForKey:@"donation_criteria"]valueForKey:@"is_donation_on"]isEqualToString:@"<null>"]
    NSLog(@"%@",dict_OffersList);
    if (![[[self.dict_OffersList valueForKey:@"donation_criteria"]valueForKey:@"is_donation_on"]isEqual:[NSNull null]]  )
    {
        if ([[[self.dict_OffersList valueForKey:@"donation_criteria"]valueForKey:@"is_donation_on"]isEqualToString:@"1"]) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            NSURL *fileURL = [NSURL URLWithString:@"/System/Library/Audio/UISounds/sms-received1.caf"];
            //  NSURL *fileURL = [NSURL URLWithString:@"/System/Library/Audio/UISounds/ReceivedMessage.caf"];
            // see list below
            SystemSoundID soundID;
            AudioServicesCreateSystemSoundID((__bridge_retained CFURLRef)fileURL,&soundID);
            AudioServicesPlaySystemSound(soundID);
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            [kAppDelegate fnAlert:@"" tag:kDonationAlertTag dict:self.dict_OffersList];
        }
        
    }
    else{
        [kAppDelegate fnAlert:@"" tag:kDonationAlertTag dict:self.dict_OffersList];
    }
}

- (IBAction)btnaddressClicked:(id)sender
{
    NSString *strTempAddress=@"";
    if ([[[self.dict_OffersList valueForKey:@"merchant"]valueForKey:@"merchantAddress"]length] > 0) {
        strTempAddress = [[self.dict_OffersList valueForKey:@"merchant"]valueForKey:@"merchantAddress"];
        strTempAddress = [strTempAddress stringByAppendingString:@", "];
        strTempAddress = [strTempAddress stringByAppendingString:[[self.dict_OffersList valueForKey:@"merchant"]valueForKey:@"merchantCity"]];
        strTempAddress = [strTempAddress stringByAppendingString:@", "];
        strTempAddress = [strTempAddress stringByAppendingString:[[self.dict_OffersList valueForKey:@"merchant"]valueForKey:@"merchantState"]];
        
        if ([[[self.dict_OffersList valueForKey:@"merchant"]valueForKey:@"merchantZipcode"]length] > 0) {
            strTempAddress = [strTempAddress stringByAppendingString:@", "];
            strTempAddress = [strTempAddress stringByAppendingString:[[self.dict_OffersList valueForKey:@"merchant"]valueForKey:@"merchantZipcode"]];
        }
        
    }
    else {
        strTempAddress = [[self.dict_OffersList valueForKey:@"merchant"]valueForKey:@"merchantCity"];
        strTempAddress = [strTempAddress stringByAppendingString:@", "];
        strTempAddress = [strTempAddress stringByAppendingString:[[self.dict_OffersList valueForKey:@"merchant"]valueForKey:@"merchantState"]];
        if ([[[self.dict_OffersList valueForKey:@"merchant"]valueForKey:@"merchantZipcode"]length] > 0) {
            strTempAddress = [strTempAddress stringByAppendingString:@", "];
            strTempAddress = [strTempAddress stringByAppendingString:[[self.dict_OffersList valueForKey:@"merchant"]valueForKey:@"merchantZipcode"]];
        }
        
    }
    NSLog(@"%@",strTempAddress);
    
    
    NSString* url = [NSString stringWithFormat: @"http://maps.google.com/maps?q=%@",
                     [strTempAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
	
}

- (IBAction)btnphoneClicked:(id)sender {
	NSString *phoneNoStr;
	if ([[[self.dict_OffersList valueForKey:@"merchant"]valueForKey:@"merchantPhone"]length] > 0) {
		phoneNoStr = [[self.dict_OffersList valueForKey:@"merchant"]valueForKey:@"merchantPhone"];
		NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@", phoneNoStr]];
        
		if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
			[[UIApplication sharedApplication] openURL:phoneUrl];
		}
		else {
            [CommonFunction fnAlert:@"" message:@"Call facility is not available!"];
		}
	}
	else {
	}
}

- (IBAction)btnWebsiteClicked:(id)sender
{
    NSString *strWebsite = [[self.dict_OffersList valueForKey:@"merchant"]valueForKey:@"merchantUrl"];
    if ([[[self.dict_OffersList valueForKey:@"merchant"]valueForKey:@"merchantUrl"]length] > 0)
    {
        if (![strWebsite hasPrefix:@"http://"] && ![strWebsite hasPrefix:@"https://"]) {
            strWebsite = [NSString stringWithFormat:@"http://%@",strWebsite];
        }
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strWebsite]];
    }
}

#pragma mark - UIAlertView Delegate
- (void)willPresentAlertView:(UIAlertView *)alertView {
	if (alertView.tag == kDonationAlertTag) {
		if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7) {
			if (!kIphone) {
				[alertView setFrame:CGRectMake(17, 30, 286, 390)];
				alertView.center = CGPointMake(self.view.center.x, self.view.center.y);
				NSArray *subviewArray = [alertView subviews];
				NSLog(@"%@", subviewArray);
				UITextView *message = (UITextView *)[subviewArray objectAtIndex:8];
				[message setFrame:CGRectMake(12, 60, 260, 55)];
				UILabel *messagelbl = (UILabel *)[subviewArray objectAtIndex:2];
				[messagelbl setFrame:CGRectMake(10, 40, 260, 70)];
                
				UIButton *plus1button = (UIButton *)[subviewArray objectAtIndex:3];
				[plus1button setFrame:CGRectMake(10, 125, 260, 40)];
				UIButton *plus2button = (UIButton *)[subviewArray objectAtIndex:4];
				[plus2button setFrame:CGRectMake(10, 175, 260, 40)];
				UIButton *plus3button = (UIButton *)[subviewArray objectAtIndex:5];
				[plus3button setFrame:CGRectMake(10, 225, 260, 40)];
				UIButton *plus4button = (UIButton *)[subviewArray objectAtIndex:6];
				[plus4button setFrame:CGRectMake(10, 275, 260, 40)];
				UIButton *cancelbutton = (UIButton *)[subviewArray objectAtIndex:7];
				[cancelbutton setFrame:CGRectMake(10, 325, 260, 40)];
			}
		}
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if ([alertView tag] == kRedeemAlertTag && buttonIndex == 0) {
		if (![[[[self.dict_OffersList valueForKey:@"offersList"]valueForKey:@"availableCount"] objectAtIndex:_btnRedeemIndex]isEqualToString:@"0"]) {
			[kAppDelegate showProgressHUD];
			NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
			[dict setValue:[[kAppDelegate dictUserInfo]valueForKey:@"userId"] forKey:@"userId"];
			[dict setValue:[[[self.dict_OffersList valueForKey:@"offersList"]valueForKey:@"offerId"] objectAtIndex:_btnRedeemIndex] forKey:@"offerId"];
			[AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dict method:kRedeemoffer] completeBlock: ^(NSData *data) {
			    id result = [NSJSONSerialization JSONObjectWithData:data
			                                                options:kNilOptions error:nil];
			    if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
			        IBRedeemOffer *objIBRedeemOffer;
			        if (kDevice == kIphone) {
			            objIBRedeemOffer = [[IBRedeemOffer alloc]initWithNibName:@"IBRedeemOffer" bundle:nil];
					}
			        else {
			            objIBRedeemOffer = [[IBRedeemOffer alloc]initWithNibName:@"IBRedeemOffer_iPad" bundle:nil];
					}
			        objIBRedeemOffer.delegate = self;
			        objIBRedeemOffer.dict_MerchantInfo = [self setDictMerchantAndOffers:_btnRedeemIndex];
			        [self.navigationController pushViewController:objIBRedeemOffer animated:YES];
				}
			    else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]) {
			        [CommonFunction fnAlert:@"" message:[NSString stringWithFormat:@"%@%@", @"It can be used again ", [[[self.dict_OffersList valueForKey:@"offersList"] valueForKey:@"alert"]objectAtIndex:_btnRedeemIndex]]];
				}
			    else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]) {
			        [CommonFunction fnAlert:@"" message:@"Please try again"];
				}
			    else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:2]]) {
			        [CommonFunction fnAlert:@"" message:@"Your subscription Expired.  Please renew your subscription."];
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
		}
		else {
			[CommonFunction fnAlert:@"Alert" message:@"This offer is expired"];
		}
	}
	if ([alertView tag] == kDonationAlertTag) {
		if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
		}
		else {
			if ([[[self.dict_OffersList valueForKey:@"donation_criteria"]valueForKey:@"permanent_payment_token"]length] == 0) {
				IBCreditCardPaymentVC *objIBCreditCardPaymentVC;
				if (kDevice == kIphone) {
					objIBCreditCardPaymentVC = [[IBCreditCardPaymentVC alloc]initWithNibName:@"IBCreditCardPaymentVC" bundle:nil];
				}
				else {
					objIBCreditCardPaymentVC = [[IBCreditCardPaymentVC alloc]initWithNibName:@"IBCreditCardPayment_iPad" bundle:nil];
				}
				NSMutableDictionary *dictPayment = [[NSMutableDictionary alloc]init];
				if (buttonIndex == 1) {
					float taxAmount = (1 * 2.9) / 100 + 0.30 + 1.0;
					float finalTaxAmount =  (taxAmount * .029) - (1 * .029);
					taxAmount = taxAmount + finalTaxAmount;
					[dictPayment setObject:[NSString stringWithFormat:@"%f", taxAmount] forKey:@"amount"];
					[dictPayment setObject:@"$1.34 has been deducted from your account." forKey:@"AlertMsg"];
				}
				else if (buttonIndex == 2) {
					float taxAmount = (2 * 2.9) / 100 + 0.30 + 2.0;
					float finalTaxAmount =  (taxAmount * .029) - (2 * .029);
					taxAmount = taxAmount + finalTaxAmount;
                    
					[dictPayment setObject:[NSString stringWithFormat:@"%f", taxAmount] forKey:@"amount"];
					[dictPayment setObject:[NSString stringWithFormat:@"$%.2f has been deducted from your account.", taxAmount] forKey:@"AlertMsg"];
				}
				else if (buttonIndex == 3) {
					float taxAmount = (3 * 2.9) / 100 + 0.30 + 3.0;
					float finalTaxAmount =  (taxAmount * .029) - (3 * .029);
					taxAmount = taxAmount + finalTaxAmount;
                    
					[dictPayment setObject:[NSString stringWithFormat:@"%f", taxAmount] forKey:@"amount"];
					[dictPayment setObject:[NSString stringWithFormat:@"$%.2f has been deducted from your account.", taxAmount] forKey:@"AlertMsg"];
				}
				else if (buttonIndex == 4) {
					float taxAmount = (5 * 2.9) / 100 + 0.30 + 5.0;
					float finalTaxAmount =  (taxAmount * .029) - (5 * .029);
					taxAmount = taxAmount + finalTaxAmount;
					[dictPayment setObject:[NSString stringWithFormat:@"%f", taxAmount] forKey:@"amount"];
					[dictPayment setObject:[NSString stringWithFormat:@"$%.2f has been deducted from your account.", taxAmount] forKey:@"AlertMsg"];
				}
                
				[dictPayment setObject:kDonationUser forKey:@"paymentFor"];
				[dictPayment setObject:@"" forKey:@"storageToken"];
				[dictPayment setObject:KDonationThroughCreditCard forKey:@"paymentType"];
                
				objIBCreditCardPaymentVC.dictDonationOrNormalInfo = dictPayment;
				[self.navigationController pushViewController:objIBCreditCardPaymentVC animated:YES];
			}
			else {
				NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
				[dict setValue:[[kAppDelegate dictUserInfo]valueForKey:@"userId"] forKey:@"userId"];
				[dict setValue:[[self.dict_OffersList valueForKey:@"donation_criteria"]valueForKey:@"permanent_payment_token"] forKey:@"paymentToken"];
				[dict setObject:kDonationUser forKey:@"paymentFor"];
				[dict setObject:@"" forKey:@"storageToken"];
				//[dict setObject:@"" forKey:@"amount"];
				[dict setValue:@"" forKey:@"firstName"];
				[dict setValue:@"" forKey:@"lastName"];
				[dict setValue:@"" forKey:@"cardNumber"];
				[dict setValue:@"" forKey:@"cardType"];
				[dict setValue:@"" forKey:@"expMonth"];
				[dict setValue:@"" forKey:@"expYear"];
				if (buttonIndex == 1) {
					float taxAmount = (1 * 2.9) / 100 + 0.30 + 1.0;
					float finalTaxAmount =  (taxAmount * .029) - (1 * .029);
					taxAmount = taxAmount + finalTaxAmount;
					[dict setObject:[NSString stringWithFormat:@"%.2f", taxAmount] forKey:@"amount"];
				}
				else if (buttonIndex == 2) {
					float taxAmount = (2 * 2.9) / 100 + 0.30 + 2.0;
					float finalTaxAmount =  (taxAmount * .029) - (2 * .029);
					taxAmount = taxAmount + finalTaxAmount;
					[dict setObject:[NSString stringWithFormat:@"%.2f", taxAmount] forKey:@"amount"];
				}
				else if (buttonIndex == 3) {
					float taxAmount = (3 * 2.9) / 100 + 0.30 + 3.0;
					float finalTaxAmount =  (taxAmount * .029) - (3 * .029);
					taxAmount = taxAmount + finalTaxAmount;
					[dict setObject:[NSString stringWithFormat:@"%.2f", taxAmount] forKey:@"amount"];
				}
				else if (buttonIndex == 4) {
					float taxAmount = (5 * 2.9) / 100 + 0.30 + 5.0;
					float finalTaxAmount =  (taxAmount * .029) - (5 * .029);
					taxAmount = taxAmount + finalTaxAmount;
					[dict setObject:[NSString stringWithFormat:@"%.2f", taxAmount] forKey:@"amount"];
				}
				else {
					return;
				}
				[kAppDelegate showProgressHUD];
				[[SharedManager sharedManager]postCreditCardData:dict
				                                   completeBlock: ^(NSData *data)
                 {
                     UIAlertView *alertView;
                     if (buttonIndex == 1) {
                         alertView = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"$1.34 has been deducted from your account." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     }
                     else if (buttonIndex == 2) {
                         float taxAmount = (2 * 2.9) / 100 + 0.30 + 2.0;
                         float finalTaxAmount =  (taxAmount * .029) - (2 * .029);
                         taxAmount = taxAmount + finalTaxAmount;
                         alertView = [[UIAlertView alloc]initWithTitle:@"Alert" message:[NSString stringWithFormat:@"$%.2f has been deducted from your account.", taxAmount] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     }
                     else if (buttonIndex == 3) {
                         float taxAmount = (3 * 2.9) / 100 + 0.30 + 3.0;
                         float finalTaxAmount =  (taxAmount * .029) - (3 * .029);
                         taxAmount = taxAmount + finalTaxAmount;
                         alertView = [[UIAlertView alloc]initWithTitle:@"Alert" message:[NSString stringWithFormat:@"$%.2f has been deducted from your account.", taxAmount] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     }
                     else if (buttonIndex == 4) {
                         float taxAmount = (5 * 2.9) / 100 + 0.30 + 5.0;
                         float finalTaxAmount =  (taxAmount * .029) - (5 * .029);
                         taxAmount = taxAmount + finalTaxAmount;
                         alertView = [[UIAlertView alloc]initWithTitle:@"Alert" message:[NSString stringWithFormat:@"$%.2f has been deducted from your account.", taxAmount] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     }
                     
                     [alertView show];
                 }
                                                      errorBlock: ^(NSError *error) {
                 }];
			}
		}
	}
	else if (alertView.tag == kPurchaseAlertTag) {
        if(buttonIndex==0)
        {
		NSString *userPayment = [[kAppDelegate dictUserInfo]valueForKey:@"userPayments"];
        
		if ([[[kAppDelegate dictUserInfo]valueForKey:@"userId"]length] > 0 && [[[kAppDelegate dictUserInfo]valueForKey:@"profileComplete"]isEqualToString:@"0"] && [userPayment isEqualToString:@"active"]) {
			/**** Added by Utkarsha to enable complete registration*****/
			IBRegisterVC *objIBRegisterVC;
			if (kDevice == kIphone) {
				objIBRegisterVC = [[IBRegisterVC alloc]initWithNibName:@"IBRegisterVC" bundle:nil];
			}
			else {
				objIBRegisterVC = [[IBRegisterVC alloc]initWithNibName:@"IBRegisterVC_iPad" bundle:nil];
			}
			objIBRegisterVC.strEditProfile = @"Edit";
			objIBRegisterVC.strController = @"My Profile";
			objIBRegisterVC.strDetailRegistration = @"DetailRegistration";
			objIBRegisterVC.dictProfileData = [[kAppDelegate dictUserInfo] valueForKey:@"userDetail"];
			[kAppDelegate.navController pushViewController:objIBRegisterVC animated:NO];
			/******/
		}
		else if ([[[kAppDelegate dictUserInfo]valueForKey:@"userId"]length] > 0 && [[[kAppDelegate dictUserInfo]valueForKey:@"profileComplete"]isEqualToString:@"0"] && [userPayment isEqualToString:@"inactive"]) {
//			if ([[[kAppDelegate dictUserInfo]valueForKey:@"npoId"]intValue] != 1 && [[[kAppDelegate dictUserInfo] valueForKey:@"isUserGruEdu"] intValue] == 0) {
//				IBExtraDonationVC *objIBExtraDonationVC;
//                
//				if (kDevice == kIphone) {
//					objIBExtraDonationVC = [[IBExtraDonationVC alloc]initWithNibName:@"IBExtraDonationVC" bundle:nil];
//				}
//				else {
//					objIBExtraDonationVC = [[IBExtraDonationVC alloc]initWithNibName:@"IBExtraDonationVC_iPad" bundle:nil];
//				}
//				//objIBExtraDonationVC.strClassTypeForPaymentScreen=@"Dashboard";//bit for not to hide back button on payment screen.
//				[self.navigationController pushViewController:objIBExtraDonationVC animated:YES];
//			}
//			else {
				IBPaymentVC *objIBPaymentVC;
                
				if (kDevice == kIphone) {
					objIBPaymentVC = [[IBPaymentVC alloc]initWithNibName:@"IBPaymentVC" bundle:nil];
				}
				else {
					objIBPaymentVC = [[IBPaymentVC alloc]initWithNibName:@"IBPaymentVC_iPad" bundle:nil];
				}
				objIBPaymentVC.strClassTypeForPaymentScreen = @"Dashboard"; //bit for not to hide back button on payment screen.
				[self.navigationController pushViewController:objIBPaymentVC animated:YES];
			//}
		}
		else {
			IBLoginVC *objIBLoginVC;
			if (kDevice == kIphone) {
				objIBLoginVC = [[IBLoginVC alloc]initWithNibName:@"IBLoginVC" bundle:nil];
			}
			else {
				objIBLoginVC = [[IBLoginVC alloc]initWithNibName:@"IBLoginVC_iPad" bundle:nil];
			}
			objIBLoginVC.classType = kOffers;
			[self.navigationController pushViewController:objIBLoginVC animated:YES];
		}
	}
    }
}

- (NSMutableDictionary *)setDictMerchantAndOffers:(NSInteger)indexPath {
	NSMutableDictionary *dictInfo = [[NSMutableDictionary alloc]init];
	[dictInfo setValue:[self.dict_OffersList valueForKey:@"merchant"] forKey:@"merchant"];
	[dictInfo setValue:[[self.dict_OffersList valueForKey:@"offersList"] objectAtIndex:indexPath] forKey:@"offersList"];
	[dictInfo setValue:[[self.dict_OffersList valueForKey:@"donation_criteria"]valueForKey:@"is_donation_on"] forKey:@"is_donation_on"];
	[dictInfo setValue:[[self.dict_OffersList valueForKey:@"donation_criteria"]valueForKey:@"npo_title"] forKey:@"npo_title"];
	[dictInfo setValue:[[self.dict_OffersList valueForKey:@"donation_criteria"]valueForKey:@"permanent_payment_token"] forKey:@"permanent_payment_token"];
	[dictInfo setValue:[[[self.dict_OffersList valueForKey:@"offersList"]valueForKey:@"offerTitle"]objectAtIndex:indexPath] forKey:@"offerTitle"];
	[dictInfo setValue:[NSNumber numberWithBool:self.isSubscribed] forKey:@"isSubscribed"];
	return dictInfo;
}

@end
