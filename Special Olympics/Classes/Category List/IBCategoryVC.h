//
//  IBCategoryVC.h
//  iBuddyClient
//
//  Created by Anubha on 12/11/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BSKeyboardControls.h"
#import "IBMerchantByNameViewController.h"
/**
 @class IBCategoryVC
 @inherits UIViewController
 @description This class is the home screen of the application to view the offers of the merchants based on diffetent categories.
 */
@interface IBCategoryVC : UIViewController<BSKeyboardControlsDelegate,CLLocationManagerDelegate> {
    
    NSMutableDictionary *mDictStates;
    NSMutableArray *mDictCities;
    int mSelectedStateId;
    // int mSelectedCityID;
    BOOL checkShowHideTableView;
    NSString *tableType;
    NSString *strlatitude;
    NSString *strlongitude;
    BOOL checkMethodCalledTime;
    NSString *autorizationStatus;
    int selectedButton;
    BOOL checkCurrentLocation;
    BOOL checkMilesClick;
    BOOL checkCityClick;
    
    float tblViewStateX;
    float tblViewStateCityY;
    float tblViewStateCityWidth;
    float tblViewStateCityHeight;
    float tblViewCityX;
    NSString *striPhoneiPad;
    NSString *strSelectedCity;
    IBOutlet UITableViewCell *tblCustomCellMerchant;
    int IsEventOrCategory;
}
@property(nonatomic,strong)NSMutableDictionary *dictCount;
@property (nonatomic) int offset;
@property (nonatomic)BOOL isInfiniteCalled;
/**
 @property dictParams
 @description The dictionary to show parameters
 */
@property (strong, nonatomic)NSMutableDictionary *dictParams;
/**
 @property tblCustomCellMerchant
 @description TProperty of UITableViewCell custom cell
 */
@property (strong, nonatomic)IBOutlet UITableViewCell *tblCustomCellMerchant;
/**
 @property activityIndicator
 @description The UIActivityIndicatorView to improve
 */
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
/**
 @property btnCity
 @description The button to select city
 */
@property (weak, nonatomic) IBOutlet UIButton *btnCity;
/**
 @property btnState
 @description The button to select state
 */
@property (weak, nonatomic) IBOutlet UIButton *btnState;
/**
 @property tblViewStateCity
 @description The tableview to  view states and cities
 */
@property (weak, nonatomic) IBOutlet UITableView *tblViewStateCity;
/**
 @property dict_MerchantList
 @description The dictionary to show merchant list
 */
@property (nonatomic, retain)NSMutableDictionary *dict_MerchantList;
/**
 @property userID
 @description The string with user id
 */
@property (nonatomic, retain)NSString *userID;
/**
 @property txtCity
 @description The textfield to enter city
 */
@property (weak, nonatomic) IBOutlet UITextField *txtCity;
/**
 @property lblMerchantCity
 @description The name of the city to which merchant belong
 */
@property (weak, nonatomic) IBOutlet UILabel *lblMerchantCity;

- (IBAction)btnStateClicked:(id)sender;
- (IBAction)btnCityClicked:(id)sender;
- (IBAction)btnCurrentLocatiobClicked:(id)sender;
/**
 @method btnSearchMilesClicked
 @description Calls to search categories based on miles
 @param param1 sender
 @returns IBAction
 */
- (IBAction)btnSearchMilesClicked:(id)sender;
/**
 @method btnSearchCityClicked
 @description Calls to search categories based on city
 @param param1 sender
 @returns IBAction
 */
- (IBAction)btnSearchCityClicked:(id)sender;

/*Pooja*/
@property (weak, nonatomic) IBOutlet UIButton *btnDropDown;
@property (weak, nonatomic) IBOutlet UITableView *tblDropDown;
- (IBAction)btnDropDownClicked:(id)sender;
    
@end
