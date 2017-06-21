//
//  IBCategoryVC.m
//  iBuddyClient
//
//  Created by Anubha on 12/11/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import "IBCategoryVC.h"
#import "SVPullToRefresh.h"
#import "UIImageView+WebCache.h"
#import "IBMerchantListVC.h"
#import "IBSubcategoryVC.h"

#define kCategoryTableWidthIPhone 180
#define kCategoryTableWidthIPad 495
#define kIncrementFactor 5
#define kTableCellGapFromY 5
#define kCategory 0
#define kDropdownTableHeight 60



@interface IBCategoryVC () <UITableViewDelegate, UITableViewDataSource>
{    NSArray *cityFilteredAray;
	 NSArray *arrDropdown; }
@property (weak, nonatomic) IBOutlet UITableView *tbl_MerchantList;
@property (weak, nonatomic) IBOutlet UILabel *lbl_ScreenTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblState;
@property (weak, nonatomic) IBOutlet UILabel *lblCity;
@property (weak, nonatomic) IBOutlet UILabel *lblEnterMiles;
@property (weak, nonatomic) IBOutlet UITextField *txtMiles;
@property (weak, nonatomic) IBOutlet UITextField *txtZipCode;
@property (weak, nonatomic) IBOutlet UILabel *lblZipCode;
@property (weak, nonatomic) IBOutlet UIButton *btnCurrentLocation;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL shouldFetchADs;
@property (weak, nonatomic) IBOutlet UILabel *lblCopyRight;
/**
 *  Keyboard controls.
 */
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@property (weak, nonatomic) IBOutlet UIButton *btnMiles;
@property (weak, nonatomic) IBOutlet UIButton *btnCitySerach;
@end

@implementation IBCategoryVC
@synthesize dict_MerchantList;
@synthesize userID;
@synthesize keyboardControls = _keyboardControls;
@synthesize tblCustomCellMerchant;
@synthesize dictParams,lblCopyRight;


#pragma mark - View LifeCycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

/*-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    NSMutableArray *arrViewControllers=[[NSMutableArray alloc]initWithArray:kAppDelegate.navController.viewControllers];
    NSLog(@"%d",[arrViewControllers count]);
    NSLog(@"%@",[arrViewControllers objectAtIndex:0]);


    if ([arrViewControllers count]==2&&[[arrViewControllers objectAtIndex:1]isKindOfClass:[IBOffersVC class]]) {
        [self setInitialVariables];
        checkMilesClick=FALSE;
        checkCityClick=FALSE;
        [self getCategoriesBasedOnZipCode];
        [self setBSKeyBoardControls];
    }
   }*/
- (void)viewDidLoad {
	[super viewDidLoad];
    if (kDevice == kIphone) {

    }
    else
    {
        UIButton *btnMenu=[UIButton buttonWithType:UIButtonTypeCustom];
        [btnMenu setImage:[UIImage imageNamed:@"ic_menu_icon"] forState:UIControlStateNormal];
        btnMenu.frame=CGRectMake(0, 0, 44, 44);
        [btnMenu addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnMenu];
    }
	//Added by Utkarsha so as to make iAds compatible to iOS 7 Layout
	[self setLayoutForiOS7];
	[self setInitialVariables];
	checkMilesClick = FALSE;
	checkCityClick = FALSE;
	[self getCategoriesBasedOnZipCode];
	[self setBSKeyBoardControls];
}

- (void)viewWillDisappear:(BOOL)animated {
	[CommonFunction setValueInUserDefault:kZipCodeRetained value:_txtZipCode.text];
	[super viewWillDisappear:YES];
}

- (void)viewDidUnload {
	[self setBtnMiles:nil];
	[self setBtnCitySerach:nil];
	[self setTxtZipCode:nil];
	[self setLblZipCode:nil];
	[self setTxtCity:nil];
	[self setLblMerchantCity:nil];
	[super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown
	        || interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Set Initial Methods

- (void)setInitialVariables {
    
      self.lblCopyRight.text = [CommonFunction getCopyRightText];
	if (kDevice == kIphone) {
		tblViewStateX = 30;
		tblViewStateCityY = 82;
		tblViewStateCityWidth = 118;
		tblViewStateCityHeight = 339;
		tblViewCityX = 185;
		striPhoneiPad = @"@2x.png";
	}
	else {
		tblViewStateX = 140;
		tblViewStateCityY = 92;
		tblViewStateCityWidth = 200;
		tblViewStateCityHeight = 700;
		tblViewCityX = 403;
		striPhoneiPad = @"~ipad.png";
	}
	arrDropdown = [[NSArray alloc]initWithObjects:@"Categories", @"Events", nil];
	self.lbl_ScreenTitle.font = [UIFont fontWithName:kFont size:_lbl_ScreenTitle.font.pointSize];
	self.lblEnterMiles.font = [UIFont fontWithName:kFont size:self.lblEnterMiles.font.pointSize];
	self.lblZipCode.font = [UIFont fontWithName:kFont size:self.lblZipCode.font.pointSize];
	self.lblMerchantCity.font = [UIFont fontWithName:kFont size:self.lblZipCode.font.pointSize];
	self.btnMiles.titleLabel.font = [UIFont fontWithName:kFont size:self.btnMiles.titleLabel.font.pointSize];
	self.btnCitySerach.titleLabel.font = [UIFont fontWithName:kFont size:self.btnCitySerach.titleLabel.font.pointSize];
	self.btnDropDown.titleLabel.font = [UIFont fontWithName:kFont3 size:self.btnDropDown.titleLabel.font.pointSize];
	mDictStates = [[NSMutableDictionary alloc]init];
	mDictCities = [[NSMutableArray alloc]init];
	self.lblCity.adjustsFontSizeToFitWidth = TRUE;
	self.lblState.adjustsFontSizeToFitWidth = TRUE;
	self.activityIndicator.alpha = 0.0;
	self.txtMiles.text = [CommonFunction getValueFromUserDefault:@"Miles"];
	self.txtZipCode.text = [CommonFunction getValueFromUserDefault:kZipCode];
	IsEventOrCategory = kCategory; //By pooja
	self.tblDropDown.layer.cornerRadius = 5.0;
	self.tblDropDown.layer.borderWidth  = 1.0;
	self.tblDropDown.layer.borderColor  = [[UIColor grayColor]CGColor];
	strSelectedCity = @"";

	[self fetchStatePlistData];
	NSLog(@"setInitialVariables called");
}

- (void)getCategoriesBasedOnZipCode {
	if (([[[kAppDelegate dictUserInfo]valueForKey:@"userId"] length] > 0 || [[CommonFunction getValueFromUserDefault:kZipCode] length] > 0) && [[CommonFunction getValueFromUserDefault:kZipCodeHighlighted]isEqualToString:@"False"]) {
        if (kDevice == kIphone) {

            [self.btnCurrentLocation setImage:[UIImage imageNamed:@"OffersCrntLocation@2x.png"] forState:UIControlStateNormal];

        }
        else
        {
            [self.btnCurrentLocation setImage:[UIImage imageNamed:@"OffersCrntLocation~ipad.png"] forState:UIControlStateNormal];
        }
		[self getCurrentLocation];
		/*commented [self getMerchants]; */
		[self getCategories:IsEventOrCategory];
		NSLog(@"getCurrentLocation called");
	}

	else {
		[self btnCurrentLocatiobClicked:nil];
		NSLog(@"btnCurrentLocatiobClicked called");
	}
}

- (void)getCategories:(int)eventOrCategory {
	//[kAppDelegate callAdsWebService:@"34.3230497" longitude:@"-80.8765205"];
	if (checkCityClick == TRUE) {
		if (![strSelectedCity length] > 0) {
			self.dict_MerchantList = nil;
			[_tbl_MerchantList reloadData];
            if([self.lblState.text isEqualToString:@"State"])
            {
                [CommonFunction fnAlert:@"Alert" message:@"Please select any state first"];
            }
            else
            {
                [CommonFunction fnAlert:@"Alert" message:@"Please select any city first"];
            }
			return;
		}
		[kAppDelegate showProgressHUD];
         [[kAppDelegate HUD] setLabelText:@"Please be patient, there are lots of great deals coming your way!"];
        [[kAppDelegate HUD] setLabelFont:[UIFont systemFontOfSize:14]];

		dictParams = [[NSMutableDictionary alloc] init];
		[dictParams setValue:strSelectedCity forKey:@"cityName"];
		//[dictParams setValue:strSelectedCity forKey:@"City_Alias"];

		[dictParams setValue:[NSString stringWithFormat:@"%d", mSelectedStateId] forKey:@"stateId"];
		[dictParams setValue:[NSNumber numberWithInt:IsEventOrCategory] forKey:@"IsEvent"];
        
        [AsyncURLConnection request:[[AsyncURLConnection sharedManager] createJSONRequestForDictionary:(NSMutableDictionary *)dictParams method:kGetFeaturedData] completeBlock:^(NSData *webdata) {
            id Featuredresult = [NSJSONSerialization JSONObjectWithData:webdata
                                                        options:kNilOptions error:nil];
            NSMutableArray *arrFeaturedData=[[NSMutableArray alloc]init];
            if ([[Featuredresult valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
                
                NSArray *arrFeaturedSorted = [Featuredresult valueForKey:@"categoriesList"];
                [arrFeaturedData addObjectsFromArray:arrFeaturedSorted];
            }
            [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:(NSMutableDictionary *)dictParams method:kGetCategories] completeBlock: ^(NSData *data) {
                id result = [NSJSONSerialization JSONObjectWithData:data
                                                            options:kNilOptions error:nil];
                if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
                    
                    NSArray *arrSorted = [result valueForKey:@"categoriesList"];

                    [arrFeaturedData addObjectsFromArray:arrSorted];
                }
                
                else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]) {
                    /*** by pooja***/
                    if (IsEventOrCategory == kCategory) {
                        [CommonFunction fnAlert:@"" message:@"No categories exist for this city.  Please select another city."];
                    }
                    else {
                        [CommonFunction fnAlert:@"" message:@"No events exist for this city.  Please select another city."];
                    }
                }
                else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]) {
                    [CommonFunction fnAlert:@"" message:@"Please try again"];
                }
                else {
                    [CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
                }
                NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
                [dict setObject:arrFeaturedData forKey:@"categoriesList"];
                [self reloadTable:dict];
                [kAppDelegate hideProgressHUD];
            } errorBlock: ^(NSError *error) {
                if (error.code == NSURLErrorTimedOut) {
                    [CommonFunction fnAlert:@"Alert!" message:kAlerTimedOut];
                }
                else {
                    [CommonFunction fnAlert:@"Error" message:[error localizedDescription]];
                }
                [self reloadTable:nil];
                
                [kAppDelegate hideProgressHUD];
            }];


           

        } errorBlock:^(NSError *error) {
            if (error.code == NSURLErrorTimedOut) {
              //  [CommonFunction fnAlert:@"Alert!" message:kAlerTimedOut];
            }
            else {
               // [CommonFunction fnAlert:@"Error" message:[error localizedDescription]];
            }
           // [self reloadTable:nil];
            
            [kAppDelegate hideProgressHUD];
        }];
	}
	else {
		if (![self.txtZipCode.text length] > 0) {
			self.dict_MerchantList = nil;
			[_tbl_MerchantList reloadData];
			[CommonFunction fnAlert:@"Alert" message:@"Unable to find your current location, please try again later and check your location settings"];
           

			return;
		}
		else {
			[kAppDelegate showProgressHUD];
 [[kAppDelegate HUD] setLabelText:@"Please be patient, there are lots of great deals coming your way!"];
            [[kAppDelegate HUD] setLabelFont:[UIFont systemFontOfSize:14]];

			if ([[CommonFunction getValueFromUserDefault:kZipCode]isEqualToString:[CommonFunction getValueFromUserDefault:kZipCodeRetained]]) {
				NSLog(@"Equal string %@%@", [CommonFunction getValueFromUserDefault:kZipCode], [CommonFunction getValueFromUserDefault:kZipCodeRetained]);

				NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
				NSData *data = [defaults objectForKey:kArrCoordinates];
				if ([data length] > 0) {
					NSArray *arrCoordinates = [NSKeyedUnarchiver unarchiveObjectWithData:data];
					dictParams = [[NSMutableDictionary alloc] init];
					[dictParams setValue:[arrCoordinates objectAtIndex:0] forKey:@"lat"];
					[dictParams setValue:[arrCoordinates objectAtIndex:1] forKey:@"long"];
					[dictParams setValue:self.txtMiles.text forKey:@"miles"];
					[dictParams setValue:[NSNumber numberWithInt:IsEventOrCategory] forKey:@"IsEvent"];
                    
                    
                    [AsyncURLConnection request:[[AsyncURLConnection sharedManager] createJSONRequestForDictionary:(NSMutableDictionary *)self.dictParams method:kGetFeaturedData] completeBlock:^(NSData *data) {
                        id Featuredresult = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:kNilOptions error:nil];
                        NSMutableArray *arrFeaturedData=[[NSMutableArray alloc]init];
                        if ([[Featuredresult valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
                            
                            NSArray *arrFeaturedSorted = [Featuredresult valueForKey:@"categoriesList"];
                            [arrFeaturedData addObjectsFromArray:arrFeaturedSorted];
                        }
                        
                        [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:(NSMutableDictionary *)self.dictParams method:kGetCategories] completeBlock: ^(NSData *data) {
                            id result = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:kNilOptions error:nil];
                            if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
                                
                                NSArray *arrSorted = [result valueForKey:@"categoriesList"];
                                [arrFeaturedData addObjectsFromArray:arrSorted];

                            }
                            else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]) {
                                if (IsEventOrCategory == kCategory) {
                                    [CommonFunction fnAlert:@"" message:@"No categories exist for this city.  Please select another city."];
                                }
                                else {
                                    [CommonFunction fnAlert:@"" message:@"No events exist for this city.  Please select another city."];
                                }
                            }
                            else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]) {
                                [CommonFunction fnAlert:@"" message:@"Please try again"];
                            }
                            else {
                                [CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
                            }
                            NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
                            [dict setObject:arrFeaturedData forKey:@"categoriesList"];
                            [self reloadTable:dict];
                            [kAppDelegate hideProgressHUD];
                        } errorBlock: ^(NSError *error) {
                            if (error.code == NSURLErrorTimedOut) {
                                [CommonFunction fnAlert:@"Alert!" message:kAlerTimedOut];
                            }
                            else {
                                [CommonFunction fnAlert:@"Error" message:[error localizedDescription]];
                            }
                            [self reloadTable:nil];
                            [kAppDelegate hideProgressHUD];
                        }];

      
                        
                        
                        
                        
                    } errorBlock:^(NSError *error) {
                        if (error.code == NSURLErrorTimedOut) {
                            //  [CommonFunction fnAlert:@"Alert!" message:kAlerTimedOut];
                        }
                        else {
                            // [CommonFunction fnAlert:@"Error" message:[error localizedDescription]];
                        }
                        // [self reloadTable:nil];
                        
                        [kAppDelegate hideProgressHUD];
                    }];
                    
                    
                    
                    
				}
				else {
					//[CommonFunction fnAlert:@"Alert" message:@"Unable to get your location from this zip code, please try with another zip code."];
                    
					[self reloadTable:nil];
					[kAppDelegate hideProgressHUD];
				}
			}

			else {
				NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", [self.txtZipCode.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

				NSLog(@"Not equal string %@%@", [CommonFunction getValueFromUserDefault:kZipCode], [CommonFunction getValueFromUserDefault:kZipCodeRetained]);


				[AsyncURLConnection request:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] completeBlock: ^(NSData *data) {
				    NSString *locationString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
				    if ([locationString length] > 0) {
				        NSError *err = nil;
				        NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:[locationString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
				        if ([[[dictResponse valueForKey:@"status"] lowercaseString] isEqualToString:[[NSString stringWithFormat:@"OK"] lowercaseString]]) {
				            NSMutableArray *arrCoordinates = [[NSMutableArray alloc]init];
				            [arrCoordinates addObject:[[[[[dictResponse valueForKey:@"results"] valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lat"] objectAtIndex:0]];
				            [arrCoordinates addObject:[[[[[dictResponse valueForKey:@"results"] valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lng"] objectAtIndex:0]];

				            /*For saving of latitude and longitude */
				            NSData *newdata = [NSKeyedArchiver archivedDataWithRootObject:arrCoordinates];
				            [[NSUserDefaults standardUserDefaults] setObject:newdata forKey:kArrCoordinates];
				            [[NSUserDefaults standardUserDefaults] synchronize];

				            if ([arrCoordinates count] > 0) {
				                dictParams = [[NSMutableDictionary alloc] init];
				                [dictParams setValue:[arrCoordinates objectAtIndex:0] forKey:@"lat"];
				                [dictParams setValue:[arrCoordinates objectAtIndex:1] forKey:@"long"];
				                [dictParams setValue:self.txtMiles.text forKey:@"miles"];
				                [dictParams setValue:[NSNumber numberWithInt:IsEventOrCategory] forKey:@"IsEvent"];
                                
                                [AsyncURLConnection request:[[AsyncURLConnection sharedManager] createJSONRequestForDictionary:(NSMutableDictionary *)dictParams method:kGetFeaturedData] completeBlock:^(NSData *webdata) {
                                    id Featuredresult = [NSJSONSerialization JSONObjectWithData:webdata
                                                                                        options:kNilOptions error:nil];
                                    NSMutableArray *arrFeaturedData=[[NSMutableArray alloc]init];
                                    if ([[Featuredresult valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
                                        
                                        NSArray *arrFeaturedSorted = [Featuredresult valueForKey:@"categoriesList"];
                                        [arrFeaturedData addObjectsFromArray:arrFeaturedSorted];
                                    }
                                    
                                    [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:(NSMutableDictionary *)self.dictParams method:kGetCategories] completeBlock: ^(NSData *data) {
                                        id result = [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:kNilOptions error:nil];
                                        if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
                                            NSArray *arrSorted = [result valueForKey:@"categoriesList"];
                                            [arrFeaturedData addObjectsFromArray:arrSorted];

                                        }
                                        else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]) {
                                            if (IsEventOrCategory == kCategory) {
                                                [CommonFunction fnAlert:@"" message:@"No categories exist for this Zip Code.  Please select another one."];
                                            }
                                            else {
                                                [CommonFunction fnAlert:@"" message:@"No events exist for this Zip Code.  Please select another one."];
                                            }
                                        }
                                        else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]) {
                                            [CommonFunction fnAlert:@"" message:@"Please try again"];
                                        }
                                        else {
                                            [CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
                                        }
                                        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
                                        [dict setObject:arrFeaturedData forKey:@"categoriesList"];
                                        [self reloadTable:dict];
                                        [kAppDelegate hideProgressHUD];
                                    } errorBlock: ^(NSError *error) {
                                        if (error.code == NSURLErrorTimedOut) {
                                            [CommonFunction fnAlert:@"Alert!" message:kAlerTimedOut];
                                        }
                                        else {
                                            [CommonFunction fnAlert:@"Error" message:[error localizedDescription]];
                                        }
                                        [self reloadTable:nil];
                                        [kAppDelegate hideProgressHUD];
                                    }];
                                    
                                    
                                    
                                    
                                    
                                    
                                } errorBlock:^(NSError *error) {
                                    if (error.code == NSURLErrorTimedOut) {
                                        //  [CommonFunction fnAlert:@"Alert!" message:kAlerTimedOut];
                                    }
                                    else {
                                        // [CommonFunction fnAlert:@"Error" message:[error localizedDescription]];
                                    }
                                    // [self reloadTable:nil];
                                    
                                    [kAppDelegate hideProgressHUD];
                                }];
                                
                                
				                
							}
				            else {
				                //[CommonFunction fnAlert:@"Alert" message:@"Unable to get your location from this zip code, please try with another zip code."];
				                [self reloadTable:nil];
				                [kAppDelegate hideProgressHUD];
							}
						}
				        else if ([[[dictResponse valueForKey:@"status"] lowercaseString] isEqualToString:[[NSString stringWithFormat:@"ZERO_RESULTS"] lowercaseString]]) {
				            [CommonFunction fnAlert:@"Alert" message:@"Unable to fetch the details for the respective zip code due to :- Zero results found."];
						}
				        else if ([[[dictResponse valueForKey:@"status"] lowercaseString] isEqualToString:[[NSString stringWithFormat:@"OVER_QUERY_LIMIT"] lowercaseString]]) {
				            [CommonFunction fnAlert:@"Alert" message:@"Unable to fetch the details for the respective zip code due to :- Over query limit"];
						}
				        else if ([[[dictResponse valueForKey:@"status"] lowercaseString] isEqualToString:[[NSString stringWithFormat:@"REQUEST_DENIED"] lowercaseString]]) {
				            [CommonFunction fnAlert:@"Alert" message:@"Unable to fetch the details for the respective zip code due to :- Request denied."];
						}
				        else if ([[[dictResponse valueForKey:@"status"] lowercaseString] isEqualToString:[[NSString stringWithFormat:@"INVALID_REQUEST"] lowercaseString]]) {
				            [CommonFunction fnAlert:@"Alert" message:@"Unable to fetch the details for the respective zip code due to :- Invalid request."];
						}
				        else if ([[[dictResponse valueForKey:@"status"] lowercaseString] isEqualToString:[[NSString stringWithFormat:@"UNKNOWN_ERROR"] lowercaseString]]) {
				            [CommonFunction fnAlert:@"Alert" message:@"Unable to fetch the details for the respective zip code due to :- Unknown error."];
						}

				        else {
				           // [CommonFunction fnAlert:@"Alert" message:@"Unable to get your location from this zip code, please try with another zip code."];
				            [self reloadTable:nil];
						}
				        [kAppDelegate hideProgressHUD];
					}
				} errorBlock: ^(NSError *error) {
				    if (error.code == NSURLErrorTimedOut) {
				        [CommonFunction fnAlert:@"Alert!" message:kAlerTimedOut];
					}
				    else {
				        [CommonFunction fnAlert:@"Error" message:[error localizedDescription]];
					}
				    [self reloadTable:nil];
				    [kAppDelegate hideProgressHUD];
				}];
			}
		}
	}
}

- (void)getCategoriesOnDonePressed {
	if ([self.txtMiles.text length] > 0 && ![self.txtZipCode.text length] > 0) {
		[CommonFunction fnAlert:@"Alert" message:@"Please enter zip code."];
	}
	if (![self.txtMiles.text length] > 0 && ![self.txtZipCode.text length] > 0) {
		[CommonFunction fnAlert:@"Alert" message:@"Please enter miles and zip code."];
	}
    if ([self.txtMiles.text isEqualToString:@"0"]) {
        [CommonFunction fnAlert:@"Alert" message:@"Entered miles should be greater than 0."];
        return;
    }

	if (![self.txtMiles.text length] > 0 && [self.txtZipCode.text length] > 0) {
		if (![self.txtZipCode.text isEqualToString:[CommonFunction getValueFromUserDefault:kZipCode]]) {
            if (kDevice == kIphone) {
                
                [self.btnCurrentLocation setImage:[UIImage imageNamed:@"OffersCrntLocation@2x.png"] forState:UIControlStateNormal];

            }
            else
            {
			[self.btnCurrentLocation setImage:[UIImage imageNamed:@"OffersCrntLocation~ipad.png"] forState:UIControlStateNormal];
            }
			[CommonFunction setValueInUserDefault:kZipCodeHighlighted value:@"False"];
		}
            		[CommonFunction fnAlert:@"Alert" message:@"Please enter miles."];
	}

	if ([self.txtMiles.text length] > 0 && [self.txtZipCode.text length] > 0) {
		if (![self.txtZipCode.text isEqualToString:[CommonFunction getValueFromUserDefault:kZipCode]]) {
            if (kDevice == kIphone) {
                
                [self.btnCurrentLocation setImage:[UIImage imageNamed:@"OffersCrntLocation@2x.png"] forState:UIControlStateNormal];

            }
            else
            {
			[self.btnCurrentLocation setImage:[UIImage imageNamed:@"OffersCrntLocation~ipad.png"] forState:UIControlStateNormal];
            }
			[CommonFunction setValueInUserDefault:kZipCodeHighlighted value:@"False"];
		}
		[CommonFunction setValueInUserDefault:kMiles value:self.txtMiles.text];
		[CommonFunction setValueInUserDefault:kZipCodeRetained value:[CommonFunction getValueFromUserDefault:kZipCode]];

		[CommonFunction setValueInUserDefault:kZipCode value:self.txtZipCode.text];
		[self getCategories:IsEventOrCategory];
	}
}

#pragma mark - Button Actions
- (IBAction)btnSearchByNameAction:(id)sender
{
    if (checkCityClick == TRUE) {
        if (![strSelectedCity length] > 0) {
            self.dict_MerchantList = nil;
            [_tbl_MerchantList reloadData];
            if([self.lblState.text isEqualToString:@"State"])
            {
                [CommonFunction fnAlert:@"Alert" message:@"Please select any state first"];
            }
            else
            {
                [CommonFunction fnAlert:@"Alert" message:@"Please select any city first"];
            }
            return;
        }
        [kAppDelegate showProgressHUD:self.view];
        dictParams = [[NSMutableDictionary alloc] init];
        [dictParams setValue:strSelectedCity forKey:@"cityName"];
        
        [dictParams setValue:[NSString stringWithFormat:@"%d", mSelectedStateId] forKey:@"stateId"];
    }
    else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [defaults objectForKey:kArrCoordinates];
        if ([data length] > 0) {
            NSArray *arrCoordinates = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            dictParams = [[NSMutableDictionary alloc] init];
            [dictParams setValue:[arrCoordinates objectAtIndex:0] forKey:@"lat"];
            [dictParams setValue:[arrCoordinates objectAtIndex:1] forKey:@"long"];
            [dictParams setValue:self.txtMiles.text forKey:@"miles"];
            
        }
    }
    
    IBMerchantByNameViewController *objIBSubcategoryVC;
    if (kDevice == kIphone) {
        objIBSubcategoryVC   = [[IBMerchantByNameViewController alloc]initWithNibName:@"IBMerchantByNameViewController" bundle:nil];
    }
    else {
        objIBSubcategoryVC   = [[IBMerchantByNameViewController alloc]initWithNibName:@"IBMerchantByNameViewController_iPad" bundle:nil];
    }
    objIBSubcategoryVC.dictData=dictParams;
    [self.navigationController pushViewController:objIBSubcategoryVC animated:YES];
    
}
- (IBAction)btnStateClicked:(id)sender {
	[self hideDropdownTable];
	[_txtCity resignFirstResponder];
	dispatch_async(dispatch_get_main_queue(), ^{
	    self.activityIndicator.alpha = 0.0;
	    [self.activityIndicator stopAnimating];
	});
	tableType = @"State";
	if (checkShowHideTableView == FALSE) {
		_tblViewStateCity.frame = CGRectMake(tblViewStateX, tblViewStateCityY, tblViewStateCityWidth, 0);
		[self showTableView];
		[_tblViewStateCity reloadData];
	}

	else if (checkShowHideTableView == TRUE && selectedButton != [sender tag]) {
		[self hideTableView];
		_tblViewStateCity.frame = CGRectMake(tblViewStateX, tblViewStateCityY, tblViewStateCityWidth, 0);
		[self showTableView];
		[_tblViewStateCity reloadData];
	}
	else {
		[self hideTableView];
	}
	selectedButton = [sender tag];
}

- (IBAction)btnCityClicked:(id)sender {
	//[self.tblDropDown setHidden:TRUE];
	[self hideDropdownTable];
	tableType = @"City";
	if ([self.lblState.text isEqualToString:@"No state"]) {
		[CommonFunction fnAlert:@"Alert" message:@"No city exists corresponding to this state"];
	}
	else if ([self.lblState.text isEqualToString:@"State"] || ![self.lblState.text length] > 0) {
		[CommonFunction fnAlert:@"Alert" message:@"Please select state first"];
	}
	else {
		if (checkShowHideTableView == FALSE) {
			_tblViewStateCity.frame = CGRectMake(tblViewCityX, tblViewStateCityY, tblViewStateCityWidth, 0);
			[self showTableView];
			[_tblViewStateCity reloadData];
		}
		else if (checkShowHideTableView == TRUE && selectedButton == [sender tag]) {
			_tblViewStateCity.frame = CGRectMake(tblViewCityX, tblViewStateCityY, tblViewStateCityWidth, 0);
			[self showTableView];
			[_tblViewStateCity reloadData];
		}

		else if (checkShowHideTableView == TRUE && selectedButton != [sender tag]) {
			[self hideTableView];
			_tblViewStateCity.frame = CGRectMake(tblViewCityX, tblViewStateCityY, tblViewStateCityWidth, 0);
			[self showTableView];
			[_tblViewStateCity reloadData];
		}
		else {
			[self hideTableView];
			self.activityIndicator.alpha = 0.0;
			self.activityIndicator.alpha = 0.0;
			[self.activityIndicator stopAnimating];
		}
	}
	selectedButton = [sender tag];
}

- (IBAction)btnCurrentLocatiobClicked:(id)sender {
	self.shouldFetchADs = NO;
	checkMethodCalledTime = FALSE;
	kAppDelegate.checkToStopMethodCall = FALSE;

	if (_locationManager == nil) {
		self.locationManager = [[CLLocationManager alloc] init];
		[self.locationManager setDelegate:self];
	}
    if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.locationManager requestWhenInUseAuthorization];
        
    }
	[self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
	[self.locationManager setDistanceFilter:kCLDistanceFilterNone];
	[self.locationManager startUpdatingLocation];
}

- (IBAction)btnSearchMilesClicked:(id)sender {
	[_txtCity resignFirstResponder];
	if (checkMilesClick == FALSE) {
		strlatitude = @"";
		strlongitude = @"";
        if(kDevice==kIphone)
        {
            [self.btnMiles setBackgroundImage:[UIImage imageNamed:@"ButtonLeftActive@2x.png"] forState:UIControlStateNormal];
            [self.btnCitySerach setBackgroundImage:[UIImage imageNamed:@"ButtonRight@2x.png"] forState:UIControlStateNormal];

        }
        else
        {
            
            [self.btnMiles setBackgroundImage:[UIImage imageNamed:@"ButtonLeftActive~ipad.png"] forState:UIControlStateNormal];
            [self.btnCitySerach setBackgroundImage:[UIImage imageNamed:@"ButtonRight~ipad.png"] forState:UIControlStateNormal];

        }
		self.btnState.hidden = TRUE;
		self.lblMerchantCity.hidden = TRUE;
		//self.btnCity.hidden=TRUE;
		self.txtCity.hidden = TRUE;
		self.lblCity.hidden = TRUE;
		self.lblState.hidden = TRUE;
		self.txtMiles.hidden = FALSE;
		self.txtZipCode.hidden = FALSE;
		self.btnCurrentLocation.hidden = FALSE;
		self.lblEnterMiles.hidden = FALSE;
		self.lblZipCode.hidden = FALSE;
		checkMilesClick = TRUE;
		checkCityClick = FALSE;
		[self getCategoriesBasedOnZipCode];
	}
}

- (IBAction)btnSearchCityClicked:(id)sender {
	[self.txtMiles resignFirstResponder];
	[self.txtZipCode resignFirstResponder];
    self.txtCity.placeholder= @"City";

	if (checkCityClick == FALSE) {
		strlatitude = @"";
		strlongitude = @"";
        
        if(kDevice==kIphone)
        {
            [self.btnMiles setBackgroundImage:[UIImage imageNamed:@"ButtonLeft@2x.png"] forState:UIControlStateNormal];
            [self.btnCitySerach setBackgroundImage:[UIImage imageNamed:@"ButtonRightActive@2x.png"] forState:UIControlStateNormal];
            
        }
        else
        {
            
            [self.btnMiles setBackgroundImage:[UIImage imageNamed:@"ButtonLeft~ipad.png"] forState:UIControlStateNormal];
            [self.btnCitySerach setBackgroundImage:[UIImage imageNamed:@"ButtonRightActive~ipad.png"] forState:UIControlStateNormal];
            
        }
        
        
		self.btnState.hidden = FALSE;
		// self.btnCity.hidden=FALSE;
		//self.lblCity.hidden=FALSE;
		self.lblState.hidden = FALSE;
		self.lblMerchantCity.hidden = FALSE;
		_txtCity.hidden = FALSE;
		self.btnCurrentLocation.hidden = TRUE;
		self.txtMiles.hidden = TRUE;
		self.lblEnterMiles.hidden = TRUE;
		self.txtZipCode.hidden = TRUE;
		self.lblZipCode.hidden = TRUE;
		//checkCurrentLocation=FALSE;
		checkCityClick = TRUE;
		checkMilesClick = FALSE;
		/*commented  [self getMerchants]; */
		[self getCategories:IsEventOrCategory];
	}
}

- (IBAction)btnDropDownClicked:(id)sender {
	if (checkShowHideTableView == TRUE) {
		[self hideTableView];
	}
	if (self.tblDropDown.hidden) {
		[self showDropDownTable];
	}
	else {
		[self hideDropdownTable];
	}
}

- (void)showDropDownTable {
	[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationCurveEaseOut animations: ^{
	    _tblDropDown.frame = CGRectMake(self.tblDropDown.frame.origin.x, self.tblDropDown.frame.origin.y, self.tblDropDown.frame.size.width, kDropdownTableHeight);
	    self.tblDropDown.hidden = FALSE;
	} completion: ^(BOOL finished) {
	}];
}

- (void)hideDropdownTable {
	[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationCurveEaseOut animations: ^{
	    _tblDropDown.frame = CGRectMake(self.tblDropDown.frame.origin.x, self.tblDropDown.frame.origin.y, self.tblDropDown.frame.size.width, 0);
	} completion: ^(BOOL finished) {
	    self.tblDropDown.hidden = TRUE;
	}];
}

- (IBAction)showMenu:(id)sender {
    [kAppDelegate showMenu];
}

#pragma mark Location Manager Delegates
- (void)getCurrentLocation {
	self.shouldFetchADs = YES;
	kAppDelegate.checkToStopMethodCall = FALSE;
	if (_locationManager == nil) {
		self.locationManager = [[CLLocationManager alloc] init];
		[self.locationManager setDelegate:self];
	}
    if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.locationManager requestWhenInUseAuthorization];

    }
	[self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
	[self.locationManager setDistanceFilter:kCLDistanceFilterNone];
	[self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
	if (self.shouldFetchADs) {
		//Added by Utkarsha so as to get Ads in between
		[kAppDelegate fetchAdslocation:newLocation error:nil];
	}
	else {
		[CommonFunction setValueInUserDefault:kZipCodeHighlighted value:@"True"];
        if (kDevice == kIphone) {

            [self.btnCurrentLocation setImage:[UIImage imageNamed:@"OffersCrntLocation_Active.png"] forState:UIControlStateNormal];

        }
        else
        {
		[self.btnCurrentLocation setImage:[UIImage imageNamed:@"OffersCrntLocation_Active~ipad.png"] forState:UIControlStateNormal];
        }
		float latitude = newLocation.coordinate.latitude;
		float longitude = newLocation.coordinate.longitude;
		[self getZipCode:latitude longitude:longitude];

		/* Added by Utkarsha to test app if adds are available
		   CLLocation *loc = [[CLLocation alloc]initWithLatitude:35.018217 longitude:-80.9318332];
		   [kAppDelegate fetchAdslocation:loc error:nil];

		   [self getZipCode:35.018217 longitude:-80.9318332];
		 */

		[kAppDelegate fetchAdslocation:newLocation error:nil];
	}
	[self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	if (self.shouldFetchADs) {
		//Dont show any error.
		//Added by Utkarsha so as to get Ads in between
		[kAppDelegate fetchAdslocation:nil error:error];
	}
	else {
		if ((error.domain == kCLErrorDomain) &&
		    (error.code == kCLErrorDenied)) {
			[CommonFunction setValueInUserDefault:kZipCodeHighlighted value:@"False"];
            if (kDevice == kIphone) {

                [self.btnCurrentLocation setImage:[UIImage imageNamed:@"OffersCrntLocation@2x.png"] forState:UIControlStateNormal];

            }
            else
            {
			[self.btnCurrentLocation setImage:[UIImage imageNamed:@"OffersCrntLocation~ipad.png"] forState:UIControlStateNormal];
            }
			self.dict_MerchantList = nil;
			[_tbl_MerchantList reloadData];
			[CommonFunction fnAlert:@"Alert" message:@"You have denied the authorization to fetch current location.  Please on from the settings"];
		}
	}
	[self.locationManager stopUpdatingLocation];
}

#pragma mark - Get state City Plist
//Fetch the States data from the Plist
- (void)fetchStatePlistData {
	//Adding values form State plist into State array
	NSString *statePath = [[NSBundle mainBundle] pathForResource:@"states1" ofType:@"plist"];
	NSMutableArray *arrState = [[NSMutableArray alloc] initWithContentsOfFile:statePath];
	NSMutableArray *arrNames = [[NSMutableArray alloc] init];
	NSMutableArray *arrStateIds = [[NSMutableArray alloc] init];
	//Fetching states corresponding to the country
	for (int stateCounter = 0; stateCounter < [arrState count]; stateCounter++) {
		[arrNames addObject:[[arrState objectAtIndex:stateCounter] valueForKey:@"Name"]];
		[mDictStates setObject:arrNames forKey:@"Name"];

		[arrStateIds addObject:[[arrState objectAtIndex:stateCounter] valueForKey:@"StateID"]];
		[mDictStates setObject:arrStateIds forKey:@"StateID"];
	}
}

//Fetching State's data from Plist
- (void)fetchCityPlistData {
	//Adding values form State plist into State array
	[mDictCities removeAllObjects];

	NSString *cityPath = [[NSBundle mainBundle] pathForResource:@"cities" ofType:@"plist"];
	NSMutableArray *arrCity = [[NSMutableArray alloc] initWithContentsOfFile:cityPath];
	NSMutableArray *arrUnsortedArray = [[NSMutableArray alloc] init];
	for (int stateCounter = 0; stateCounter < [arrCity count]; stateCounter++) {
		if ([[[arrCity objectAtIndex:stateCounter] valueForKey:@"StateID"] isEqualToString:[NSString stringWithFormat:@"%d", mSelectedStateId]]) {
			[arrUnsortedArray addObject:[arrCity objectAtIndex:stateCounter]];
		}
	}
	NSSortDescriptor *brandDescriptor = [[NSSortDescriptor alloc] initWithKey:@"City_Alias" ascending:YES];
	NSArray *sortDescriptors  = [NSArray arrayWithObject:brandDescriptor];
	[mDictCities addObjectsFromArray:[arrUnsortedArray sortedArrayUsingDescriptors:sortDescriptors]];
	dispatch_async(dispatch_get_main_queue(), ^{
	    [kAppDelegate hideProgressHUD];
	    self.txtCity.text = [[mDictCities valueForKey:@"City_Alias"] objectAtIndex:0];
	    strSelectedCity = [[mDictCities valueForKey:@"City_Alias"] objectAtIndex:0];
	    /*commented  [self getMerchants];*/
	    [self getCategories:IsEventOrCategory];
	});
}

- (void)filterCityArrayForText:(NSString *)textEntered {
	NSString *stringToSearch = @"";
	if (_txtCity.text.length > 0) {
		stringToSearch = [stringToSearch stringByAppendingString:_txtCity.text];
	}
	if (textEntered.length > 0) {
		stringToSearch = [stringToSearch stringByAppendingString:textEntered];
	}
	else
		stringToSearch = [stringToSearch substringToIndex:stringToSearch.length - 1];

	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"City_Alias BEGINSWITH[cd] %@", stringToSearch];
	NSArray *arrayFileterd = [mDictCities filteredArrayUsingPredicate:predicate];
	NSUInteger count11 = arrayFileterd.count;
	if (count11 > 1000) count11 = 1000;
	cityFilteredAray = [arrayFileterd objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, count11)]];
	[self btnCityClicked:_btnCity];
}

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
	NSInteger count = 0;
	if (tableView.tag == 1001 && [tableType isEqualToString:@"State"]) {
        NSMutableArray *arrSalePersonData=[mDictStates valueForKey:@"Name"];

		count = [arrSalePersonData count];
	}
	else if (tableView.tag == 1001 && [tableType isEqualToString:@"City"]) {
		count = cityFilteredAray.count;
		[self setCityTableHeight:cityFilteredAray.count];
	}
	else if (tableView == self.tbl_MerchantList) {
        NSMutableArray *arrSalePersonData=[self.dict_MerchantList valueForKey:@"categoriesList"];

		count = [arrSalePersonData count];
	}
	else if (tableView == self.tblDropDown)  {
		count = [arrDropdown count];
	}
	return count;
}

/**
   Method to set city table height*/

- (void)setCityTableHeight:(int)count {
	if (kDevice == kIphone) {
		if (count < 7) {
			_tblViewStateCity.frame = CGRectMake(_tblViewStateCity.frame.origin.x, _tblViewStateCity.frame.origin.y, _tblViewStateCity.frame.size.width, count * 50);
		}
		else {
			_tblViewStateCity.frame = CGRectMake(_tblViewStateCity.frame.origin.x, _tblViewStateCity.frame.origin.y, _tblViewStateCity.frame.size.width, tblViewStateCityHeight);
		}
	}
	else {
		if (count < 14) {
			_tblViewStateCity.frame = CGRectMake(_tblViewStateCity.frame.origin.x, _tblViewStateCity.frame.origin.y, _tblViewStateCity.frame.size.width, count * 50);
		}
		else {
			_tblViewStateCity.frame = CGRectMake(_tblViewStateCity.frame.origin.x, _tblViewStateCity.frame.origin.y, _tblViewStateCity.frame.size.width, tblViewStateCityHeight);
		}
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (tableView == self.tbl_MerchantList) {
		static NSString *CellIdentifier = @"categoryCellIdentifier";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (kDevice == kIphone) {
			if (cell == nil) {
				[[NSBundle mainBundle] loadNibNamed:@"IBCategoryTableCell_iPhone" owner:self options:nil];
				cell = tblCustomCellMerchant;
			}
		}
		else {
			if (cell == nil) {
				[[NSBundle mainBundle] loadNibNamed:@"IBCategoryTableCell_iPad" owner:self options:nil];
				cell = tblCustomCellMerchant;
                
			}
		}
		cell.backgroundColor = nil;
		UIImageView *imgView = (UIImageView *)[cell viewWithTag:101];
		[imgView setImageWithURL:[NSURL URLWithString:[[[self.dict_MerchantList valueForKey:@"categoriesList"]objectAtIndex:indexPath.row]valueForKey:@"thumb"] ]
		        placeholderImage:[UIImage imageNamed:@"Pic.png"]];

		//Added by UTKARSHA GUPTA to show featured merchants on the top of the list on 26th jun 14
		UIImageView *imgViewFeatured = (UIImageView *)[cell viewWithTag:106];

		UILabel *lblMerchantCount = (UILabel *)[cell viewWithTag:107];

		lblMerchantCount.textColor = [UIColor whiteColor];
		lblMerchantCount.font = [UIFont fontWithName:kFont size:13];
		//new change added by Utkarsha on 1 aug on featured merchants
        NSLog(@"is_featured = %@ is_golden_egg %@ is_event_category %@",[[[self.dict_MerchantList valueForKey:@"categoriesList"]valueForKey:@"is_featured"] objectAtIndex:indexPath.row],[[[self.dict_MerchantList valueForKey:@"categoriesList"]valueForKey:@"is_golden_egg"] objectAtIndex:indexPath.row],[[[self.dict_MerchantList valueForKey:@"categoriesList"]valueForKey:@"is_event_category"] objectAtIndex:indexPath.row]);
        NSLog(@"%@",[[self.dict_MerchantList valueForKey:@"categoriesList"] objectAtIndex:indexPath.row]);
		if ([[[[self.dict_MerchantList valueForKey:@"categoriesList"] objectAtIndex:indexPath.row]valueForKey:@"is_golden_egg"] isEqualToString:@"1"] || [[[[self.dict_MerchantList valueForKey:@"categoriesList"] objectAtIndex:indexPath.row] valueForKey:@"is_featured"]isEqualToString:@"1"] || [[[[self.dict_MerchantList valueForKey:@"categoriesList"]objectAtIndex:indexPath.row] valueForKey:@"is_event_category"] isEqualToString:@"1"]) {
            
            [imgViewFeatured setImage:[UIImage imageNamed:@"featured_count.png"]];
            lblMerchantCount.text = [[[[self.dict_MerchantList valueForKey:@"categoriesList"] objectAtIndex:indexPath.row]valueForKey:@"count"]stringValue];

            
//            if ([[[[self.dict_MerchantList valueForKey:@"categoriesList"] objectAtIndex:indexPath.row]valueForKey:@"is_event_category"] isEqualToString:@"1"])
//            {
//                [imgViewFeatured setImage:[UIImage imageNamed:@"featured_count.png"]];
//				lblMerchantCount.text = [[[[self.dict_MerchantList valueForKey:@"categoriesList"] objectAtIndex:indexPath.row]valueForKey:@"count"]stringValue];
//			}
//            if ([[[[self.dict_MerchantList valueForKey:@"categoriesList"]valueForKey:@"is_golden_egg"] objectAtIndex:indexPath.row] isEqualToString:@"1"])
//            {
//                [imgViewFeatured setImage:[UIImage imageNamed:@"featured_count.png"]];
//                lblMerchantCount.text = [[[[self.dict_MerchantList valueForKey:@"categoriesList"] objectAtIndex:indexPath.row]valueForKey:@"count"]stringValue];
//            }
//            if ([[[[self.dict_MerchantList valueForKey:@"categoriesList"]valueForKey:@"is_featured"] objectAtIndex:indexPath.row] isEqualToString:@"1"])
//            {
//                [imgViewFeatured setImage:[UIImage imageNamed:@"featured_count.png"]];
//                lblMerchantCount.text = [[[[self.dict_MerchantList valueForKey:@"categoriesList"] objectAtIndex:indexPath.row]valueForKey:@"count"]stringValue];
//            }
//			else if ([[[[self.dict_MerchantList valueForKey:@"categoriesList"]valueForKey:@"featured_merchants"] objectAtIndex:indexPath.row] isEqualToString:@"0"]) {
//				[imgViewFeatured setImage:NULL];
//				lblMerchantCount.text = @"";
//			}
//			else {
//				[imgViewFeatured setImage:[UIImage imageNamed:@"featured_count.png"]];
//				lblMerchantCount.text = [[[self.dict_MerchantList valueForKey:@"categoriesList"]valueForKey:@"featured_merchants"] objectAtIndex:indexPath.row];
//			}
		}
		else {
			[imgViewFeatured setImage:NULL];
			lblMerchantCount.text = @"";
		}

//        if ([[[[self.dict_MerchantList valueForKey:@"categoriesList"]valueForKey:@"featured_merchants"] objectAtIndex:indexPath.row] isEqualToString:@"0"]) {
//			[imgViewFeatured setImage:NULL];
//			lblMerchantCount.text = @"";
//		}
//		else {
//			[imgViewFeatured setImage:[UIImage imageNamed:@"featured_count.png"]];
//			lblMerchantCount.text = [[[self.dict_MerchantList valueForKey:@"categoriesList"]valueForKey:@"featured_merchants"] objectAtIndex:indexPath.row];
//		}
//


		//////

		UILabel *lblCategoryTitle = (UILabel *)[cell viewWithTag:102];
		lblCategoryTitle.text = [[[self.dict_MerchantList valueForKey:@"categoriesList"]valueForKey:@"categoryName"] objectAtIndex:indexPath.row];

		lblCategoryTitle.frame = CGRectMake(lblCategoryTitle.frame.origin.x, lblCategoryTitle.frame.origin.y, lblCategoryTitle.frame.size.width, [CommonFunction heightOfOfferCell:[[[self.dict_MerchantList valueForKey:@"categoriesList"]valueForKey:@"categoryName"] objectAtIndex:indexPath.row] andWidth:lblCategoryTitle.frame.size.width fontName:kFont fontSize:kAppDelegate.fontSize]);
		lblCategoryTitle.textColor = [UIColor whiteColor];
		lblCategoryTitle.font = [UIFont fontWithName:kFont size:kAppDelegate.fontSize];
		return cell;
	}

	else if (tableView.tag == 1001 && [tableType isEqualToString:@"State"]) {
		static NSString *CellIdentifier = @"Country_List";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
			UILabel *lblCountryName = [[UILabel alloc]init];
			lblCountryName.frame = CGRectMake(2, 3, tblViewStateCityWidth, 30);
			lblCountryName.tag = 101;
			lblCountryName.adjustsFontSizeToFitWidth = TRUE;
			lblCountryName.text = [[mDictStates valueForKey:@"Name"] objectAtIndex:indexPath.row];
			lblCountryName.font = [UIFont fontWithName:kFont size:kFontText];
			[cell.contentView addSubview:lblCountryName];
		}
		else {
			UILabel *lblCountryName = (UILabel *)[cell viewWithTag:101];
			lblCountryName.text = [[mDictStates valueForKey:@"Name"] objectAtIndex:indexPath.row];
			lblCountryName.textColor = [UIColor blackColor];
			lblCountryName.font = [UIFont fontWithName:kFont size:kFontText];
		}
		return cell;
	}
	else if (tableView.tag == 1001 && [tableType isEqualToString:@"City"]) {
		static NSString *CellIdentifier = @"City_List";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
			UILabel *lblCityName = [[UILabel alloc]init];
			lblCityName.frame = CGRectMake(2, 3, tblViewStateCityWidth, 30);
			lblCityName.tag = 101;
			lblCityName.text = [[cityFilteredAray valueForKey:@"City_Alias"] objectAtIndex:indexPath.row];
			lblCityName.font = [UIFont fontWithName:kFont size:kFontText];

			lblCityName.adjustsFontSizeToFitWidth = TRUE;

			[cell.contentView addSubview:lblCityName];

			UILabel *lblZipCode = [[UILabel alloc]init];
			lblZipCode.frame = CGRectMake(2, 20, tblViewStateCityWidth, 30);
			lblZipCode.backgroundColor = [UIColor clearColor];
			lblZipCode.textColor = [UIColor blackColor];

			lblZipCode.tag = 102;
			lblZipCode.adjustsFontSizeToFitWidth = TRUE;
			lblZipCode.text = [NSString stringWithFormat:@"Zip Code:- %@", [[cityFilteredAray valueForKey:@"ZipCode"] objectAtIndex:indexPath.row]];
			lblZipCode.font = [UIFont fontWithName:kFont size:kFontText];

			[cell.contentView addSubview:lblZipCode];
		}
		else {
			UILabel *lblCityName = (UILabel *)[cell viewWithTag:101];
			lblCityName.text = [[cityFilteredAray valueForKey:@"City_Alias"] objectAtIndex:indexPath.row];
			lblCityName.textColor = [UIColor blackColor];
			lblCityName.font = [UIFont fontWithName:kFont size:kFontText];

			UILabel *lblZipCode = (UILabel *)[cell viewWithTag:102];
			lblZipCode.text = [NSString stringWithFormat:@"Zip Code:- %@", [[cityFilteredAray valueForKey:@"ZipCode"] objectAtIndex:indexPath.row]];
			lblZipCode.textColor = [UIColor blackColor];
			lblZipCode.font = [UIFont fontWithName:kFont size:kFontText];
		}

		return cell;
	}
	else if (tableView == self.tblDropDown) {
		static NSString *CellIdentifier = @"City_List";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
			cell.textLabel.text = [arrDropdown objectAtIndex:indexPath.row];
			cell.textLabel.font = [UIFont fontWithName:kFont size:kFontText];
		}
		return cell;
	}
	return NO;
	/*** end ***/
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[CommonFunction callHideViewFromSideBar];
	if (tableView.tag == 1001 && [tableType isEqualToString:@"State"]) {
		[self hideTableView];
		mSelectedStateId = [[[mDictStates valueForKey:@"StateID"] objectAtIndex:indexPath.row]intValue];
		self.lblState.text = [[mDictStates valueForKey:@"Name"] objectAtIndex:indexPath.row];
		[kAppDelegate showProgressHUD:self.view];
		dispatch_async(dispatch_get_global_queue(0, 0), ^{
		    [self fetchCityPlistData];
		});
		self.txtCity.text = @"";
	}
	else if (tableView.tag == 1001 && [tableType isEqualToString:@"City"]) {
		[self hideTableView];
		self.txtCity.text = [[cityFilteredAray valueForKey:@"City_Alias"] objectAtIndex:indexPath.row];
		strSelectedCity = [[cityFilteredAray valueForKey:@"City_Alias"] objectAtIndex:indexPath.row];
		[_txtCity resignFirstResponder];
		// mSelectedCityID = [[[mDictCities valueForKey:@"CityID"] objectAtIndex:indexPath.row]intValue];
		/*commented  [self getMerchants]; */
		[self getCategories:IsEventOrCategory];
	}
	else if (tableView == self.tbl_MerchantList)
    {
        NSMutableArray *arrSubctagoryData=[[[self.dict_MerchantList valueForKey:@"categoriesList"]valueForKey:@"subcategories"] objectAtIndex:indexPath.row];
        
        if ([arrSubctagoryData count]>0) {
            IBSubcategoryVC *objIBSubcategoryVC;
			if (kDevice == kIphone) {
				objIBSubcategoryVC   = [[IBSubcategoryVC alloc]initWithNibName:@"IBSubcategoryVC" bundle:nil];
			}
			else {
				objIBSubcategoryVC   = [[IBSubcategoryVC alloc]initWithNibName:@"IBSubcategoryVC_iPad" bundle:nil];
			}
			objIBSubcategoryVC.dictParameters = dictParams;
            NSLog(@"%@",[[[self.dict_MerchantList valueForKey:@"categoriesList"]valueForKey:@"subcategories"] objectAtIndex:indexPath.row]);
            objIBSubcategoryVC.arraySubCategory = [[[self.dict_MerchantList valueForKey:@"categoriesList"]valueForKey:@"subcategories"] objectAtIndex:indexPath.row];
			[self.navigationController pushViewController:objIBSubcategoryVC animated:YES];

        }
        else
        {
		[dictParams setObject:[[[self.dict_MerchantList valueForKey:@"categoriesList"]valueForKey:@"categoryId"] objectAtIndex:indexPath.row] forKey:@"categoryId"];
		[dictParams setObject:[[[self.dict_MerchantList valueForKey:@"categoriesList"]valueForKey:@"isGru"] objectAtIndex:indexPath.row] forKey:@"isGru"];

		[dictParams setObject:[[[self.dict_MerchantList valueForKey:@"categoriesList"]valueForKey:@"categoryName"] objectAtIndex:indexPath.row] forKey:@"CategoryTitle"];
            [dictParams setObject:[[[self.dict_MerchantList valueForKey:@"categoriesList"]valueForKey:@"is_event_category"] objectAtIndex:indexPath.row] forKey:@"IsEvent"];


		if (IsEventOrCategory == kCategory) {
			IBMerchantListVC *objIBOffersVC;
			if (kDevice == kIphone) {
				objIBOffersVC   = [[IBMerchantListVC alloc]initWithNibName:@"IBMerchantListVC" bundle:nil];
			}
			else {
				objIBOffersVC   = [[IBMerchantListVC alloc]initWithNibName:@"IBMerchantListVC_iPad" bundle:nil];
			}
			objIBOffersVC.webServiceParams = dictParams;
			[self.navigationController pushViewController:objIBOffersVC animated:YES];
		}
		else {
			/*** By Pooja ****/
			IBEventDetailVC *objIBEventDetailVC;
			if (kDevice == kIphone) {
				objIBEventDetailVC   = [[IBEventDetailVC alloc]initWithNibName:@"IBEventDetailVC" bundle:nil];
			}
			else {
				objIBEventDetailVC   = [[IBEventDetailVC alloc]initWithNibName:@"IBEventDetailVC_iPad" bundle:nil];
			}
			objIBEventDetailVC.eventID = [[[[self.dict_MerchantList valueForKey:@"categoriesList"] objectAtIndex:indexPath.row]valueForKey:@"categoryId"] intValue];
			[self.navigationController pushViewController:objIBEventDetailVC animated:YES];
			/*****/
		}
	}
    }
	else {
		//By pooja
		[self.btnDropDown setTitle:[NSString stringWithFormat:@"  %@", [arrDropdown objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
		[self hideDropdownTable];
		IsEventOrCategory = indexPath.row;
		[self getCategories:IsEventOrCategory];
		[self.tbl_MerchantList reloadData];
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	float height;
	float width = 0;
	if (kDevice == kIphone) {
		width = kCategoryTableWidthIPhone;
	}
	else {
		width = kCategoryTableWidthIPad;
	}
	if (tableView == self.tbl_MerchantList) {
		height = [CommonFunction heightOfOfferCell:[[[self.dict_MerchantList valueForKey:@"categoriesList"]valueForKey:@"categoryName"] objectAtIndex:indexPath.row] andWidth:width fontName:kFont fontSize:kAppDelegate.fontSize] + kTableCellGapFromY;
		if (height < 50) {
			height = 50 + kTableCellGapFromY + kIncrementFactor;
		}
		else {
			height = height + kIncrementFactor;
		}
	}
	else if (tableView.tag == 1001 && [tableType isEqualToString:@"City"]) {
		height = 50;
	}
	else {
		height = 30;
	}
	return height;
}

- (void)reloadTable:(NSMutableDictionary *)result {
	if (self.dict_MerchantList) {
		self.dict_MerchantList = nil;
	}
	self.tbl_MerchantList.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	self.dict_MerchantList = [[NSMutableDictionary alloc]init];
	// Commented by Utkarsha to remove sorting on the basis of position

//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
//                                        initWithKey: @"position" ascending: YES];
	NSArray *arrSorted = [result valueForKey:@"categoriesList"];

	if ([[[kAppDelegate dictUserInfo]valueForKey:@"userId"]length] > 0 && [[[kAppDelegate dictUserInfo] valueForKey:@"isUserGruEdu"] intValue] == 1) {
		if ([arrSorted count] > 0) {
			[self.dict_MerchantList setObject:arrSorted forKey:@"categoriesList"];
		}
	}
	else {
		// Commented by Utkarsha to remove sorting on the basis of GRU

		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isGru == %d", 0];
		arrSorted = [arrSorted filteredArrayUsingPredicate:predicate];
		if ([arrSorted count] > 0) {
			[self.dict_MerchantList setObject:arrSorted forKey:@"categoriesList"];
		}
	}

	[self.tbl_MerchantList reloadData];
}

#pragma mark Table View Show Or Hode
- (void)showTableView {
	if ([tableType isEqualToString:@"State"]) {
		[UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationCurveEaseOut animations: ^{
		    _tblViewStateCity.frame = CGRectMake(tblViewStateX, tblViewStateCityY, tblViewStateCityWidth, tblViewStateCityHeight);
		} completion: ^(BOOL finished) {
		    checkShowHideTableView = TRUE;
		    _tblViewStateCity.hidden = NO;
		}];
	}
	else {
		[UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationCurveEaseOut animations: ^{
		    _tblViewStateCity.frame = CGRectMake(tblViewCityX, tblViewStateCityY, tblViewStateCityWidth, tblViewStateCityHeight);
		} completion: ^(BOOL finished) {
		    _tblViewStateCity.hidden = NO;
		    checkShowHideTableView = TRUE;
		}];
	}
}

- (void)hideTableView {
	if ([tableType isEqualToString:@"State"]) {
		[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationCurveEaseOut animations: ^{
		    _tblViewStateCity.frame = CGRectMake(tblViewStateX, tblViewStateCityY, tblViewStateCityWidth, 0);
		} completion: ^(BOOL finished) {
		    checkShowHideTableView = FALSE;
		}];
	}
	else {
		[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationCurveEaseOut animations: ^{
		    _tblViewStateCity.frame = CGRectMake(tblViewCityX, tblViewStateCityY, tblViewStateCityWidth, 0);
		} completion: ^(BOOL finished) {
		    checkShowHideTableView = FALSE;
		}];
	}
}

#pragma mark - fetch Zip Code

- (void)getZipCode:(float)latitude longitude:(float)longitude {
	if (checkMethodCalledTime == FALSE) {
		[kAppDelegate showProgressHUD];
         [[kAppDelegate HUD] setLabelText:@"Please be patient, there are lots of great deals coming your way!"];
        [[kAppDelegate HUD] setLabelFont:[UIFont systemFontOfSize:14]];

		checkMethodCalledTime = TRUE;
		CLLocationCoordinate2D coordinate;
		coordinate.latitude = latitude;
		coordinate.longitude = longitude;
		CLLocation *Location = [[CLLocation alloc]initWithCoordinate:coordinate altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:[NSDate date]];
		CLGeocoder *reverseGeo = [[CLGeocoder alloc] init];
		[reverseGeo reverseGeocodeLocation:Location completionHandler:
		 ^(NSArray *placemarks, NSError *error) {
		    [kAppDelegate hideProgressHUD];
		    if (error == nil && [placemarks count] > 0) {
		        CLPlacemark *topResult = [placemarks objectAtIndex:0];
		        self.txtZipCode.text = [topResult postalCode];
		        [CommonFunction setValueInUserDefault:kZipCodeRetained value:[CommonFunction getValueFromUserDefault:kZipCode]];
		        [CommonFunction setValueInUserDefault:kZipCode value:self.txtZipCode.text];
		        [CommonFunction setValueInUserDefault:kZipCodeHighlighted value:@"True"];
		        [self getCategories:IsEventOrCategory];
			}
		    else
				[CommonFunction fnAlert:@"Alert" message:@"Unable to find your current location."];
             

		}];
	}
}

#pragma mark -
#pragma mark BSKeyboardControls Delegate

- (void)setBSKeyBoardControls {
	self.keyboardControls = [[BSKeyboardControls alloc] init];
	// Set the delegate of the keyboard controls
	self.keyboardControls.delegate = self;
	// Add all text fields you want to be able to skip between to the keyboard controls
	// The order of thise text fields are important. The order is used when pressing "Previous" or "Next"
	self.keyboardControls.textFields = [NSArray arrayWithObjects:self.txtMiles, self.txtZipCode, nil];
	[self.keyboardControls reloadTextFields];
	self.keyboardControls.showSegment = NO;
}

/*
 * The "Done" button was pressed
 * We want to close the keyboard
 */
- (void)keyboardControlsDonePressed:(BSKeyboardControls *)controls {
	[self.txtMiles resignFirstResponder];
	[self.txtZipCode resignFirstResponder];
	[self getCategoriesOnDonePressed];
}

#pragma mark UITextField Delegate

/* Editing began */
- (void)textFieldDidBeginEditing:(UITextField *)textField {
	// [self.tblDropDown setHidden:TRUE];
	[self hideDropdownTable];
	if ([self.keyboardControls.textFields containsObject:textField])
		self.keyboardControls.activeTextField = textField;

	if (textField == _txtCity) {
		_txtCity.text = @"";
		[self hideTableView];
		if ([self.lblState.text isEqualToString:@"State"] || ![self.lblState.text length] > 0) {
			[CommonFunction fnAlert:@"Alert" message:@"Please select state first"];
			[textField resignFirstResponder];
		}
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	if (textField == _txtZipCode || textField == _txtMiles) {
		[self getCategoriesOnDonePressed];
	}
	else {
		if (![[mDictCities valueForKey:@"City_Alias"]containsObject:_txtCity.text]) {
			[CommonFunction fnAlert:@"Alert!" message:@"Please select valid city"];
			[self reloadTable:nil];
		}
		else {
			strSelectedCity = _txtCity.text;
			[self getCategories:IsEventOrCategory];
		}
	}
	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	if (textField == _txtCity) {
		if ((textField.text.length == 0 && string.length > 0) || textField.text.length) {
			_tblViewStateCity.frame = CGRectMake(tblViewCityX, tblViewStateCityY, tblViewStateCityWidth, 0);

			self.tblViewStateCity.hidden = NO;
			[self filterCityArrayForText:string];
		}
		else
			self.tblViewStateCity.hidden = YES;

		if (textField.text.length == 1 && string.length <= 0)
			self.tblViewStateCity.hidden = YES;
	}
	return YES;
}

@end
