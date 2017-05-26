//
//  IBAddReferEmailVC.h
//  iBuddyClient
//
//  Created by Anubha on 11/12/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<AddressBook/AddressBook.h>
#import<AddressBookUI/AddressBookUI.h>
/**
 @class IBAddReferEmailVC
 @inherits CustomFormViewController
 @description Simple class to provide the required information to refer an iBC mobile application to someone.
 */
@interface IBAddReferEmailVC : CustomFormViewController<ABPeoplePickerNavigationControllerDelegate,BSKeyboardControlsDelegate>
{

}
/**
 @property arrRecords
 @description The array Of Records
 */
@property(nonatomic,strong) NSMutableArray  *arrRecords;
/**
 @property dictAddressIndexInfo
 @description The dictionary of Address Index Information
 */
@property(nonatomic,strong) NSMutableDictionary  *dictAddressIndexInfo;


/**
 @method btnBackClicked
 @description Calls to navigate to previous screen
 @param param1 sender
 @returns IBAction
 */
- (IBAction)btnBackClicked:(id)sender;
/**
 @method btnSaveClicked
 @description Calls to save the record
 @param param1 sender
 @returns IBAction
 */
- (IBAction)btnSaveClicked:(id)sender;
/**
 @method btnDeleteClicked
 @description Calls to delete the record
 @param param1 sender
 @returns IBAction
 */
- (IBAction)btnDeleteClicked:(id)sender;
/**
 @method btnContactListClicked
 @description Calls to get list of contacts
 @param param1 sender
 @returns IBAction
 */
- (IBAction)btnContactListClicked:(id)sender;
@end
