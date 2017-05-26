//
//  KSOffersViewController.h
//  iBuddyClub
//
//  Created by Karamjeet Singh on 12/03/13.
//  Copyright (c) 2013 Netsmartz Info Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    /**  When user select setting from tab bar */
    viewForOffersMerchant,
    
    /**  When user first time reset the new password */
    viewForScannedoffersMerchant,
    
    
}OfferViewModeMerchant;
@interface KSOffersViewController : UIViewController
@property (nonatomic)OfferViewModeMerchant viewForOffer;
@property (nonatomic, retain)NSMutableDictionary *dict_OffersList;
@property (nonatomic, retain)NSString *userID;
@property (nonatomic, assign)BOOL isSubscribed;
@property (strong, nonatomic)IBOutlet UITableViewCell *tblCustomCellOffer;

@end
