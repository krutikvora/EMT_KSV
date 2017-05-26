//
//  IBUserMerchantsVC.h
//  iBuddyClient
//
//  Created by Anubha on 10/07/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IBUserMerchantsVC : UIViewController{
    NSMutableDictionary *dict_MerchantList;
    IBOutlet UITableViewCell *tblCustomCellMerchant;
    
}
/**
 Property of UITableViewCell custom cell
 */
@property (strong, nonatomic)IBOutlet UITableViewCell *tblCustomCellMerchant;
@property (weak, nonatomic) IBOutlet UITableView *tblMerchants;
@property (weak, nonatomic) IBOutlet UILabel *lblNoMerchants;
@property (strong, nonatomic)NSMutableDictionary *dict_MerchantList;
@end
