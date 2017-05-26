//
//  IBSalepersonSearchVC.h
//  iBuddyClient
//
//  Created by Anubha on 18/11/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 @class IBSalepersonSearchVC
 @inherits UIViewController
 @description Simple class to search Saleperson.
 */
@interface IBSalepersonSearchVC : UIViewController
{

}
- (IBAction)btnSchoolClicked:(id)sender;

- (IBAction)btnStudentClicked:(id)sender;

/**
 @property tblCustomCellSalespersonCode
 @description The tableview custom cell
 */
@property (strong, nonatomic)IBOutlet UITableViewCell *tblCustomCellSalespersonCode;
/**
 @property dict_SalespersonCodesList
 @description The name of the dictionary to show salesperson code list
 */
@property (nonatomic, retain)NSMutableDictionary *dict_SalespersonCodesList;
/**
 @property lblCopyRight
 @description To show copyright disclaimer
 */
@property (weak, nonatomic) IBOutlet UILabel *lblCopyRight;
/**
 @method btnSalesClicked
 @description Calls when search is based on salesperson
 @param param1 sender
 @returns IBAction
 */
- (IBAction)btnSalesClicked:(id)sender;
/**
 @method btnFundriserClicked
 @description Calls when search is based on fundraisers
 @param param1 sender
 @returns IBAction
 */
- (IBAction)btnFundriserClicked:(id)sender;
/**
 @method btnCityClicked
 @description Calls when search is based on city
 @param param1 sender
 @returns IBAction
 */
- (IBAction)btnCityClicked:(id)sender;
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
/**
 @method btnCrossClicked
 @description Calls when cross button is clicked to close the popup
 @param param1 sender
 @returns IBAction
 */
- (IBAction)btnCrossClicked:(id)sender;

@end
