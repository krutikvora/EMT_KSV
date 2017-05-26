//
//  IBSeachFundraiserVC.h
//  iBuddyClient
//
//  Created by Utkarsha on 08/04/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
   @class IBSeachFundraiserVC
   @inherits UIViewController
   @description Simple class to search fundraisers and view their donations.
 */

@interface IBSeachFundraiserVC : UIViewController
/**
   @property tblCustomCellSalespersonCode
   @description The tableview custom cell
 */
@property (strong, nonatomic) IBOutlet UITableViewCell *tblCustomCellSalespersonCode;
/**
   @property dict_SalespersonCodesList
   @description The name of the dictionary to show salesperson code list
 */
@property (nonatomic, retain) NSMutableDictionary *dict_SalespersonCodesList;

/**
   @method btnCrossClicked
   @description Calls when cross button is clicked to close the popup
   @param param1 sender
   @returns IBAction
 */
- (IBAction)btnCrossClicked:(id)sender;
/**
   @method btnSearchClicked
   @description Calls when Search button is clicked to search fundraisers
   @param param1 sender
   @returns IBAction
 */
- (IBAction)btnSearchClicked:(id)sender;
/**
   @method btnBackClicked
   @description Calls to navigate to previous screen
   @param param1 sender
   @returns IBAction
 */
- (IBAction)btnBackClicked:(id)sender;

@end
