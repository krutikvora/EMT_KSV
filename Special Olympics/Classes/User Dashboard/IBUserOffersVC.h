//
//  IBUserOffersVC.h
//  iBuddyClient
//
//  Created by Anubha on 17/05/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IBUserOfferSecription.h"
@interface IBUserOffersVC : UIViewController{
  NSMutableDictionary *dict_OffersList;
  IBOutlet UITableViewCell *tblCustomCellOffer;
}/**
 Property of UITableViewCell custom cell
 */
@property (strong, nonatomic)IBOutlet UITableViewCell *tblCustomCellOffer;
@property (strong, nonatomic)NSMutableDictionary *dict_OffersList;
@property (nonatomic, retain)NSString *strMerchantID;
@property (weak, nonatomic) IBOutlet UITableView *tblOffers;
- (IBAction)btnBackAction:(id)sender;
@end
