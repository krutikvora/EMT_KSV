//
//  PaymentProgramVC.h
//  iBuddyClient
//
//  Created by Anubha on 10/05/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentProgramVC : UIViewController
{
    IBOutlet UIButton *btnArrowDown;
    IBOutlet UIButton *btnArrowUp;
    NSDictionary *dictProfileData;

}
- (IBAction)btnPaymentProgClicked:(id)sender;
- (IBAction)btnOkClicked:(id)sender;
- (IBAction)btnSearchClicked:(id)sender;
@property(strong,nonatomic)NSString *strSearchedSalesperson;
@property (strong, nonatomic) NSDictionary *dictProfileData;
@property (weak, nonatomic) IBOutlet UIImageView *imgLogo;
@property (weak, nonatomic) IBOutlet UILabel *lblUniversalCode;

@property (weak, nonatomic) IBOutlet UILabel *lblTitleText;
@property (weak, nonatomic) IBOutlet UILabel *lblSearchFundlizer;

@end
