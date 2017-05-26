//
//  IBWithGratitudeVC.h
//  iBuddyClient
//
//  Created by Utkarsha on 08/04/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//


#import <UIKit/UIKit.h>
/**
   @class IBWithGratitudeVC
   @inherits UIViewController
   @description Simple class to represent Donations.
 */
@interface IBWithGratitudeVC : UIViewController
{
	NSMutableArray *arrayWithGratitude;
	NSInteger lastPageNumber;
	NSInteger pageSize;
	NSString *strDefaultNpoId;
	NSString *strSearchedNpoId;
	NSInteger totalDonors;
}

/**
   @property lblFundraiserName
   @description The name of the fundraiser
 */
@property (weak, nonatomic) IBOutlet UILabel *lblFundraiserName;

/**
   @property lblTop
   @description The title of navigation bar
 */
@property (weak, nonatomic) IBOutlet UILabel *lblTop;

/**
   @property tblCustomCellWithGratitude
   @description The tableview custom cell
 */

@property (weak, nonatomic) IBOutlet UITableViewCell *tblCustomCellWithGratitude;

/**
   @property tblWithGratitude
   @description The tableview object
 */

@property (strong, nonatomic) IBOutlet UITableView *tblWithGratitude;

/**
   @method btnSearchClicked
   @description Calls when Search button is clicked
   @param param1 sender
   @returns IBAction
 */

- (IBAction)btnSearchClicked:(id)sender;

/**
   @method callWithGratitudeService
   @description Calls when Search button is clicked
   @param param1 salepersonId param2 pageNumber param3 pageSize1
   @returns void
 */

- (void)callWithGratitudeService:(NSString *)salepersonId pageNo:(NSInteger)pageNumber pgSize:(NSInteger)pageSize1;
@end
