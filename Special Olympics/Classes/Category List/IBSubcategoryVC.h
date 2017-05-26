//
//  IBSubcategoryVC.h
//  iBuddyClient
//
//  Created by Utkarsha on 11/08/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IBSubcategoryVC : UIViewController
{
	NSMutableArray *arraySubCategory;
}

/**
 @property dictParams
 @description The dictionary to show parameters
 */
@property (strong, nonatomic)NSMutableDictionary *dictParameters;
@property (weak, nonatomic) IBOutlet UILabel *lblTop;
@property (weak, nonatomic) IBOutlet UITableViewCell *tblCustomCellSubCategory;
@property (strong, nonatomic) IBOutlet UITableView *tblSubCategory;
@property (strong, nonatomic) NSMutableArray *arraySubCategory;
@property (weak, nonatomic) IBOutlet UILabel *lblCopyRight;
@end
