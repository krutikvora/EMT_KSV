//
//  KSSplashVC.h
//  iBuddyClient
//
//  Created by krutik on 19/05/17.
//  Copyright © 2017 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSSplashVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblErrorMsg;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnSignup;
- (IBAction)btnSignupClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnRetry;
- (IBAction)btnRetryClick:(id)sender;

- (IBAction)btnLoginClick:(id)sender;
@end
