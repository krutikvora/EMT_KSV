//
//  IBOffersDescriptionVC.h
//  iBuddyClient
//
//  Created by Anubha on 13/05/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 @class IBOffersDescriptionVC
 @inherits UIViewController
 @description Simple class to represent offer description.
 */
@interface IBOffersDescriptionVC : UIViewController
@property id <IBOffersVCDelegate> delegate;
/**
 @property dict_OfferDetail
 @description The dictionary of offer details
 */
@property (nonatomic, retain)NSMutableDictionary *dict_OfferDetail;
/**
 @property dict_MerchantList
 @description The dictionary of merchant list
 */
@property (nonatomic, retain)NSMutableDictionary *dict_MerchantList;
/**
 @property dictAddressIndexInfo
 @description The activity indicator to improve user interaction with the application
 */
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end
