//
//  FirstViewController.h
//  iBuddyClient
//
//  Created by Meet Patel on 10/05/17.
//  Copyright © 2017 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UITextField *txtName;
    IBOutlet UITextField *txtEmailID;
    IBOutlet UITextField *txtConfirmEmailID;
    IBOutlet UITextField *txtPhoneNumber;
}
@end
