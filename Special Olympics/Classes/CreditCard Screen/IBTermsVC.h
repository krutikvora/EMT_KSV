//
//  IBTermsVC.h
//  iBuddyClient
//
//  Created by Anubha on 03/01/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 @class IBTermsVC
 @inherits UIViewController
 @description Simple class to represent terms and conditions.
 */
@interface IBTermsVC : UIViewController{
    IBOutlet UIButton *btnArrowDown;
    IBOutlet UIButton *btnArrowUp;
   
}
/**
 @property strTermsOrPrivacy
 @description To show terms and privac policies
 */
@property(nonatomic,strong)NSString *strTermsOrPrivacy;
/**
 @property lbl_Top
 @description The title of navigation bar
 */
@property (weak, nonatomic) IBOutlet UILabel *lbl_Top;
/**
 @property txtViewTerms
 @description The textview to view terms
 */
@property (weak, nonatomic) IBOutlet UITextView *txtViewTerms;
/**
 @property txtViewPolicy
 @description The textview to view policies
 */
@property (weak, nonatomic) IBOutlet UITextView *txtViewPolicy;

/**
 @method btnBackClicked
 @description Calls to navigate to previous screen
 @param param1 sender
 @returns IBAction
 */

- (IBAction)btnBackClicked:(id)sender;
@end
