//
//  IBAddressVC.h
//  iBuddyClient
//
//  Created by Anubha on 04/12/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    /**  When user select setting from tab bar */
    editMode,
    /**  When user first time reset the new password */
    addMode,
}PageMode;
@interface IBAddressVC : CustomFormViewController<BSKeyboardControlsDelegate,ABPeoplePickerNavigationControllerDelegate>
- (IBAction)btnBackClicked:(id)sender;
- (IBAction)btnSaveClicked:(id)sender;
- (IBAction)btnDeleteClicked:(id)sender;
- (IBAction)btnContactListClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnContactList;
@property(nonatomic,strong) NSMutableArray  *arrRecords;
@property (nonatomic)PageMode pageModeType;
@property(nonatomic,strong) NSMutableDictionary  *dictAddressIndexInfo;
@end
