//
//  IBMerchantListVC.h
//  iBuddyClient
//
//  Created by Anubha on 13/11/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>
/***
 @class IBMerchantListVC
 @inherits UIViewController
 @description Simple class to represent merchant list based on categories.
 */
@interface IBMerchantListVC : UIViewController<MKMapViewDelegate>
{
    IBOutlet UITableViewCell *tblCustomCellMerchant;
    MKMapView *mapView;
    NSMutableArray *arrCombinedData;
    int selectedTab;
}
@property(nonatomic,strong)    NSMutableArray *arrMerchants;
@property (nonatomic) int offset;
@property (nonatomic)BOOL isInfiniteCalled;

/***
 Property of UITableViewCell custom cell
 */
@property (strong, nonatomic)IBOutlet UITableViewCell *tblCustomCellMerchant;
/***
 @property dict_MerchantList
 @description The name of the dictionary to show Merchant list
 */
@property (nonatomic, retain)NSMutableDictionary *dict_MerchantList;
/***
 @property webServiceParams
 @description The name of the dictionary to show parameters required in the web service
 */
@property (nonatomic, retain)NSMutableDictionary *webServiceParams;


- (IBAction)btnMapClicked:(id)sender;
/**
 @method btnBackClicked
 @description Calls to navigate to previous screen
 @param param1 sender
 @returns IBAction
 */
- (IBAction)btnBackClicked:(id)sender;

- (IBAction)btnTrolleyClicked:(id)sender;

- (IBAction)btnFeaturedClicked:(id)sender;
@end
