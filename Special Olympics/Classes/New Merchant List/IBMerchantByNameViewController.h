//
//  IBMerchantByNameViewController.h
//  iBuddyClient
//
//  Created by Neelesh Rai on 12/22/15.
//  Copyright (c) 2015 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface IBMerchantByNameViewController : UIViewController
{
    
}
@property(nonatomic,strong)    NSMutableArray *arrMerchants;
@property(nonatomic,strong) NSMutableDictionary *dictData;

@property(nonatomic,strong) IBOutlet UITableView *tblMerchants;
@property (nonatomic, retain)NSMutableDictionary *webServiceParams;
@property (nonatomic, retain)IBOutlet UITextField *txtSearch;
@property (strong, nonatomic)IBOutlet UITableViewCell *tblCustomCellMerchant;


/**
 @method btnBackClicked
 @description Calls to navigate to previous screen
 @param param1 sender
 @returns IBAction
 */
- (IBAction)btnBackClicked:(id)sender;

@end
