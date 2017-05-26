//
//  IBOffersVC.h
//  iBuddyClient
//
//  Created by Anubha on 13/05/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "Annotation.h"
/**
 @class IBOffersVC
 @inherits UIViewController
 @description Simple class to view offers.
 */
@protocol IBOffersVCDelegate
@required
- (void)showAlert;
@end
typedef enum{
    /**  When user select setting from tab bar */
    viewForOffers,
    /**  When user first time reset the new password */
    viewForScannedoffers,
    
}OfferViewMode;
@interface IBOffersVC : UIViewController <IBOffersVCDelegate>{
   // NSMutableArray *arrCheckBoxes;
    IBOutlet UITableViewCell *tblCustomCellOffer;
    NSString *strMerchantAddress;
     MKMapView *mapView;
}
@property(nonatomic,strong)    NSMutableArray *arrOffers;

@property (nonatomic) int offset;
@property (nonatomic)BOOL isInfiniteCalled;

/**
 Property of UITableViewCell custom cell
 */
@property (strong, nonatomic)IBOutlet UITableViewCell *tblCustomCellOffer;
@property (nonatomic)OfferViewMode viewForOffer;
@property (nonatomic, retain)NSMutableDictionary *dict_OffersList;
@property (nonatomic, retain)NSMutableDictionary *dictMerchantInfo;

@property (nonatomic, assign)BOOL isSubscribed;
@property (strong, nonatomic) IBOutlet UIView *vwOffers;
@property (weak, nonatomic) IBOutlet UIScrollView *scrlView;
@property (weak, nonatomic) IBOutlet UILabel *lblMerchnatName;
@property (weak, nonatomic) IBOutlet UITextView *txtAddress;
@property (weak, nonatomic) IBOutlet UITextView *txtPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextView *txtUrl;

@property (weak, nonatomic) IBOutlet UIButton *btnWeb;
@property (weak, nonatomic) IBOutlet UIButton *btnPhone;

@end
