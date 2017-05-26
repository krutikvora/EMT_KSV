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
}
- (IBAction)btnPaymentProgClicked:(id)sender;
- (IBAction)btnOkClicked:(id)sender;
- (IBAction)btnSearchClicked:(id)sender;
@property(strong,nonatomic)NSString *strSearchedSalesperson;

@property (weak, nonatomic) IBOutlet UILabel *lblTitleText;
@property (weak, nonatomic) IBOutlet UILabel *lblSearchFundlizer;

@end
