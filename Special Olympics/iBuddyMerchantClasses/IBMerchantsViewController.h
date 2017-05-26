//
//  IBMerchantsViewController.h
//  iBuddyClient
//
//  Created by Utkarsha on 08/05/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IBMerchantsViewController : UIViewController
@property (nonatomic, strong)NSMutableDictionary *dict_MerchantsList;
@property (strong, nonatomic)IBOutlet UITableViewCell *tblCustomCell;

@end
