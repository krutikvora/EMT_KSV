//
//  IBAboutUsVC.h
//  iBuddyClient
//
//  Created by Anubha on 28/06/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 @class IBAboutUsVC
 @inherits UIViewController
 @description Simple class to view about iBuddyclub.
 */
@interface IBAboutUsVC : UIViewController{
    IBOutlet UIButton *btnArrowDown;
    IBOutlet UIButton *btnArrowUp;
}
/**
 @property lblTop
 @description The title of navigation bar
 */

@property (weak, nonatomic) IBOutlet UILabel *lbl_Top;
/**
 @property txtViewAboutUs
 @description The UITextView to show about ibuddy
 */

@property (weak, nonatomic) IBOutlet UITextView *txtViewAboutUs;

/**
 @property lblWebsiteText
 @description The label to show website details
 */
@property (weak, nonatomic) IBOutlet UILabel *lblWebsiteText;
@end
