//
//  IBMultipleAddressVC.h
//  iBuddyClient
//
//  Created by Anubha on 03/12/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 @class IBMultipleAddressVC
 @inherits UIViewController
 @description Simple class to gift APP to Multiple Addresses.
 */
@interface IBMultipleAddressVC : UIViewController{
    NSMutableArray *arrRecords;
    NSMutableArray *arrFundraisers;
    NSMutableDictionary *dictResult;
    NSString *strTotalAmount;
}
/**
 Property of UITableViewCell custom cell
 */
@property (strong, nonatomic)IBOutlet UITableViewCell *tblCustomCellAddress;
/**
 @property strGiftType
 @description The string to show gift type
 */
@property(weak,nonatomic)NSString *strGiftType;
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

- (IBAction)btnBackClicked:(id)sender;
@end
