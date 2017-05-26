//
//  IBReferEmailVC.h
//  iBuddyClient
//
//  Created by Anubha on 11/12/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 @class IBReferEmailVC
 @inherits UIViewController
 @description Simple class to refer an iBC mobile application to someone, just tap on the Add button below and provide the required information. You can refer this App to up to 10 people at a time.
 */

@interface IBReferEmailVC : UIViewController{
 NSMutableArray *arrRecords;
 NSMutableArray *arrFundraisers;
 NSMutableDictionary *dictResult;
}

/**
 Property of NSString to show refer type
 */
@property(weak,nonatomic)NSString *strReferType;
/**
 Property of UITableViewCell custom cell
 */
@property (strong, nonatomic)IBOutlet UITableViewCell *tblCustomCellAddress;
/**
 @method btnAddClicked
 @description Calls to enter details of the person to whom you want to refer this app.
 @param param1 sender
 @returns IBAction
 */
- (IBAction)btnAddClicked:(id)sender;
/**
 @method btnSubmitClicked
 @description Calls to submit data on server and send reference
 @param param1 sender
 @returns IBAction
 */
- (IBAction)btnSubmitClicked:(id)sender;
/**
 @method btnBackClicked
 @description Calls to navigate to previous screen
 @param param1 sender
 @returns IBAction
 */
- (IBAction)btnBackClicked:(id)sender;
@end
