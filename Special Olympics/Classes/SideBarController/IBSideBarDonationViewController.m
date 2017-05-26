//
//  IBSideBarDonationViewController.m
//  iBuddyClient
//
//  Created by Nishu on 25/12/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import "IBSideBarDonationViewController.h"

@interface IBSideBarDonationViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblCopyRight;

@end

@implementation IBSideBarDonationViewController
@synthesize strPaymentToken;
@synthesize btnNoToDonation,btnYesToDonation,btn10dollar,btn15dollar,btn20dollar,btn5dollar,lbl10Dollar,lbl15Dollar,lbl20Dollar,lbl5Dollar,lblTop,txtOtherPrice,btn1500dollar,switchDonorOnOff,lblCopyRight;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark - View LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    //Added by Utkarsha so as to make iAds compatible to iOS 7 Layout
    [self setLayoutForiOS7];
    self.lblCopyRight.text = [CommonFunction getCopyRightText];
    // Do any additional setup after loading the view from its nib.
    self.lblTop.font=[UIFont fontWithName:kFont size:self.lblTop.font.pointSize];
    arrTextFields = [[NSMutableArray alloc] initWithObjects:self.txtOtherPrice,  nil];
    [self setUpCustomForm];
}

-(void)getPaymentToken
{
    
    [kAppDelegate showProgressHUD:self.view];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    /*commented in order to implement not to log out unpaid user*/
    [dict setValue:[[kAppDelegate dictUserInfo]valueForKey:@"userId"] forKey:@"userId"];
    [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dict method:kGetPaymnetToken] completeBlock:^(NSData *data) {
        id result = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions error:nil];
        if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
            
            strPaymentToken=[result valueForKey:@"paymentToken"];
        }
        else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]) {
            
            strPaymentToken=@"";

        }
        else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]){
            [CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
        }
        else {
            [CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
        }
        [kAppDelegate hideProgressHUD];
        
    } errorBlock:^(NSError *error) {
        if (error.code == NSURLErrorTimedOut) {
            [CommonFunction fnAlert:@"Alert!" message:kAlerTimedOut];
        }
        else{
            [CommonFunction fnAlert:@"Error" message:[error localizedDescription]];}
        [kAppDelegate hideProgressHUD];
        
    }];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self setInitialValues];
    [self getPaymentToken];
}
-(void)setInitialValues
{
    self.lblFundraiserName.text = [[kAppDelegate dictUserInfo] valueForKey:@"npoName"];
    [self.btnYesToDonation setImage:[UIImage imageNamed:@"checkbox_active.png"] forState:UIControlStateNormal] ;
    [self.btnNoToDonation setImage:[UIImage imageNamed:@"checkbox_inactive.png"] forState:UIControlStateNormal];
    [self.btn5dollar setImage:[UIImage imageNamed:@"radio_btn_active.png"] forState:UIControlStateNormal];
    self.lbl5Dollar.textColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    strDonationValue = @"5";
    self.txtOtherPrice.text = @"";
    [self.switchDonorOnOff setOn:NO];
    [CommonFunction setValueInUserDefault:kDonationType value:@"normal"];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Button Actions
- (IBAction)changeSwitch:(id)sender{
    
    if([sender isOn]){
        [CommonFunction setValueInUserDefault:@"anonymous_donation" value:@"1"];
    } else{
        [CommonFunction setValueInUserDefault:@"anonymous_donation" value:@"0"];
    }
}

- (IBAction)btnBackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnDoneClicked:(id)sender
{
    
    [txtOtherPrice resignFirstResponder];
    [_mScrollView setContentOffset:CGPointMake(0,0)];
    if (![strDonationValue isEqualToString:@"0"])
    {
        if ([self.txtOtherPrice.text length]>0)
        {
            
            float donation=[self.txtOtherPrice.text floatValue];
            [self resetTextColor];
            [self resetRadioButtons];
            strDonationValue = [NSString stringWithFormat:@"%.2f",donation];
            [CommonFunction setValueInUserDefault:kDonationType value:@"normal"];
        }
        strDonationValue = [NSString stringWithFormat:@"%.2f",[strDonationValue floatValue]];
        [self seletedDonation:strDonationValue];
    }
    else
    {
        [CommonFunction fnAlert:@"Alert" message:@"Please select any Donation amount to go next."];
    }
}

- (IBAction)btnYesToDonationClicked:(id)sender
{
    if (self.btnYesToDonation.imageView.image == [UIImage imageNamed:@"checkbox_inactive.png"])
    {
        [self.btnYesToDonation setImage:[UIImage imageNamed:@"checkbox_active.png"] forState:UIControlStateNormal] ;
    }
    else
    {
        [self.btnYesToDonation setImage:[UIImage imageNamed:@"checkbox_inactive.png"] forState:UIControlStateNormal];
    }
    [self.btnNoToDonation setImage:[UIImage imageNamed:@"checkbox_inactive.png"] forState:UIControlStateNormal];
    strDonationValue=@"0";
}

- (IBAction)btnNoToDonationClicked:(id)sender
{
    [kAppDelegate.objSideBarVC btnOffersClicked:nil];

//    if (self.btnNoToDonation.imageView.image == [UIImage imageNamed:@"checkbox_inactive.png"])
//    {
//        [self.btnNoToDonation setImage:[UIImage imageNamed:@"checkbox_active.png"] forState:UIControlStateNormal];
//        //[self seletedDonation:@"0"];
//        strDonationValue=@"0";
//    }
//    else
//    {
//        [self.btnNoToDonation setImage:[UIImage imageNamed:@"checkbox_inactive.png"] forState:UIControlStateNormal];
//    }
//    [self.btnYesToDonation setImage:[UIImage imageNamed:@"checkbox_inactive.png"] forState:UIControlStateNormal];
//    [self resetRadioButtons];
}
-(void)seletedDonation:(NSString*)donationAmount;
{
    {

			if ([strPaymentToken length] == 0) {
				IBCreditCardPaymentVC *objIBCreditCardPaymentVC;
				if (kDevice == kIphone) {
					objIBCreditCardPaymentVC = [[IBCreditCardPaymentVC alloc]initWithNibName:@"IBCreditCardPaymentVC" bundle:nil];
				}
				else {
					objIBCreditCardPaymentVC = [[IBCreditCardPaymentVC alloc]initWithNibName:@"IBCreditCardPayment_iPad" bundle:nil];
				}
				NSMutableDictionary *dictPayment = [[NSMutableDictionary alloc]init];
                float taxAmount = ([donationAmount intValue] * 2.9) / 100 + 0.30 + [donationAmount intValue];
                float finalTaxAmount =  (taxAmount * .029) - ([donationAmount intValue] * .029);
                taxAmount = taxAmount + finalTaxAmount;
                [dictPayment setObject:[NSString stringWithFormat:@"%.2f", taxAmount] forKey:@"amount"];
                [dictPayment setObject:[NSString stringWithFormat:@"%.2f has been dedcuted from your account.", taxAmount] forKey:@"AlertMsg"];
				[dictPayment setObject:kDonationUser forKey:@"paymentFor"];
				[dictPayment setObject:@"" forKey:@"storageToken"];
				[dictPayment setObject:KDonationThroughCreditCard forKey:@"paymentType"];
                [dictPayment setObject:donationAmount forKey:@"donation"];

				objIBCreditCardPaymentVC.dictDonationOrNormalInfo = dictPayment;
                objIBCreditCardPaymentVC.isExtraDonation=TRUE;
				[self.navigationController pushViewController:objIBCreditCardPaymentVC animated:YES];
			}
			else {
				NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
				[dict setValue:[[kAppDelegate dictUserInfo]valueForKey:@"userId"] forKey:@"userId"];
				[dict setValue:strPaymentToken forKey:@"paymentToken"];
				[dict setObject:kDonationUser forKey:@"paymentFor"];
				[dict setObject:@"" forKey:@"storageToken"];
				//[dict setObject:@"" forKey:@"amount"];
				[dict setValue:@"" forKey:@"firstName"];
				[dict setValue:@"" forKey:@"lastName"];
				[dict setValue:@"" forKey:@"cardNumber"];
				[dict setValue:@"" forKey:@"cardType"];
				[dict setValue:@"" forKey:@"expMonth"];
				[dict setValue:@"" forKey:@"expYear"];
                [dict setValue:@"1" forKey:@"forGratitude"];

                [dict setValue:donationAmount forKey:@"donation"];
                float taxAmount = ([donationAmount intValue] * 2.9) / 100 + 0.30 + [donationAmount intValue];
                float finalTaxAmount =  (taxAmount * .029) - ([donationAmount intValue] * .029);
                taxAmount = taxAmount + finalTaxAmount;
                [dict setObject:[NSString stringWithFormat:@"%.2f", taxAmount] forKey:@"amount"];
				[kAppDelegate showProgressHUD];
				[[SharedManager sharedManager]postCreditCardData:dict
				                                   completeBlock: ^(NSData *data)
                 {
                     id result = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions error:nil];
                     NSLog(@"%@",result);
                     UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:[NSString stringWithFormat:@"%.2f has been deducted from your account.",taxAmount] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     [alertView show];
                     [kAppDelegate.objSideBarVC btnOffersClicked:nil];

                 }
                errorBlock: ^(NSError *error) {
                 }];
			}
		
	}
}


- (IBAction)btn5DollarClicked:(id)sender
{
    [self resetTextColor];
    [self resetRadioButtons];
    [self.btn5dollar setImage:[UIImage imageNamed:@"radio_btn_active.png"] forState:UIControlStateNormal];
    self.lbl5Dollar.textColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    strDonationValue = @"5";
    [self.btnYesToDonation setImage:[UIImage imageNamed:@"checkbox_active.png"] forState:UIControlStateNormal] ;
    [self.btnNoToDonation setImage:[UIImage imageNamed:@"checkbox_inactive.png"] forState:UIControlStateNormal];

}
- (IBAction)btn10dollarClicked:(id)sender
{
    [self resetTextColor];
    [self resetRadioButtons];
    
    [self.btn10dollar setImage:[UIImage imageNamed:@"radio_btn_active.png"] forState:UIControlStateNormal];
    self.lbl10Dollar.textColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    [self.btnYesToDonation setImage:[UIImage imageNamed:@"checkbox_active.png"] forState:UIControlStateNormal] ;
    [self.btnNoToDonation setImage:[UIImage imageNamed:@"checkbox_inactive.png"] forState:UIControlStateNormal];

    [CommonFunction setValueInUserDefault:kDonationType value:@"normal"];
    strDonationValue = @"10";
}
- (IBAction)btn15dollarClicked:(id)sender
{
    [self resetTextColor];
    [self resetRadioButtons];
    [self.btn15dollar setImage:[UIImage imageNamed:@"radio_btn_active.png"] forState:UIControlStateNormal];
    self.lbl15Dollar.textColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    [CommonFunction setValueInUserDefault:kDonationType value:@"normal"];
    strDonationValue = @"15";
    [self.btnYesToDonation setImage:[UIImage imageNamed:@"checkbox_active.png"] forState:UIControlStateNormal] ;
    [self.btnNoToDonation setImage:[UIImage imageNamed:@"checkbox_inactive.png"] forState:UIControlStateNormal];

}

- (IBAction)btn20dollarClicked:(id)sender
{
    [self resetTextColor];
    [self resetRadioButtons];
    [self.btn20dollar setImage:[UIImage imageNamed:@"radio_btn_active.png"] forState:UIControlStateNormal];
    self.lbl20Dollar.textColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    [CommonFunction setValueInUserDefault:kDonationType value:@"normal"];
    strDonationValue = @"20";
    [self.btnYesToDonation setImage:[UIImage imageNamed:@"checkbox_active.png"] forState:UIControlStateNormal] ;
    [self.btnNoToDonation setImage:[UIImage imageNamed:@"checkbox_inactive.png"] forState:UIControlStateNormal];

}
/*****Bronze Donation*****/
- (IBAction)btn50dollarClicked:(id)sender
{
    [self resetTextColor];
    [self resetRadioButtons];
    [self.btn50dollar setImage:[UIImage imageNamed:@"radio_btn_active.png"] forState:UIControlStateNormal];
    [CommonFunction setValueInUserDefault:kDonationType value:@"bronze"];
    strDonationValue = @"50";
    [self.btnYesToDonation setImage:[UIImage imageNamed:@"checkbox_active.png"] forState:UIControlStateNormal] ;
    [self.btnNoToDonation setImage:[UIImage imageNamed:@"checkbox_inactive.png"] forState:UIControlStateNormal];

}
- (IBAction)btn100dollarClicked:(id)sender
{
    [self resetTextColor];
    [self resetRadioButtons];
    [self.btn100dollar setImage:[UIImage imageNamed:@"radio_btn_active.png"] forState:UIControlStateNormal];
    [CommonFunction setValueInUserDefault:kDonationType value:@"bronze"];
    strDonationValue = @"100";
    [self.btnYesToDonation setImage:[UIImage imageNamed:@"checkbox_active.png"] forState:UIControlStateNormal] ;
    [self.btnNoToDonation setImage:[UIImage imageNamed:@"checkbox_inactive.png"] forState:UIControlStateNormal];

}
- (IBAction)btn150dollarClicked:(id)sender
{
    [self resetTextColor];
    [self resetRadioButtons];
    [self.btn150dollar setImage:[UIImage imageNamed:@"radio_btn_active.png"] forState:UIControlStateNormal];
    [CommonFunction setValueInUserDefault:kDonationType value:@"bronze"];
    strDonationValue = @"150";
    [self.btnYesToDonation setImage:[UIImage imageNamed:@"checkbox_active.png"] forState:UIControlStateNormal] ;
    [self.btnNoToDonation setImage:[UIImage imageNamed:@"checkbox_inactive.png"] forState:UIControlStateNormal];

}

/*****Silver Donation*****/
- (IBAction)btn200dollarClicked:(id)sender
{
    [self resetTextColor];
    [self resetRadioButtons];
    [self.btn200dollar setImage:[UIImage imageNamed:@"radio_btn_active.png"] forState:UIControlStateNormal];
    [CommonFunction setValueInUserDefault:kDonationType value:@"silver"];
    strDonationValue = @"200";
    
}
- (IBAction)btn250dollarClicked:(id)sender
{
    [self resetTextColor];
    [self resetRadioButtons];
    [self.btn250dollar setImage:[UIImage imageNamed:@"radio_btn_active.png"] forState:UIControlStateNormal];
    [CommonFunction setValueInUserDefault:kDonationType value:@"silver"];
    strDonationValue = @"250";
    [self.btnYesToDonation setImage:[UIImage imageNamed:@"checkbox_active.png"] forState:UIControlStateNormal] ;
    [self.btnNoToDonation setImage:[UIImage imageNamed:@"checkbox_inactive.png"] forState:UIControlStateNormal];

}
- (IBAction)btn300dollarClicked:(id)sender
{
    [self resetTextColor];
    [self resetRadioButtons];
    [self.btn300dollar setImage:[UIImage imageNamed:@"radio_btn_active.png"] forState:UIControlStateNormal];
    [CommonFunction setValueInUserDefault:kDonationType value:@"silver"];
    strDonationValue = @"300";
    [self.btnYesToDonation setImage:[UIImage imageNamed:@"checkbox_active.png"] forState:UIControlStateNormal] ;
    [self.btnNoToDonation setImage:[UIImage imageNamed:@"checkbox_inactive.png"] forState:UIControlStateNormal];

}


/*****Gold Donation*****/
- (IBAction)btn500dollarClicked:(id)sender
{
    [self resetTextColor];
    [self resetRadioButtons];
    [self.btn500dollar setImage:[UIImage imageNamed:@"radio_btn_active.png"] forState:UIControlStateNormal];
    [CommonFunction setValueInUserDefault:kDonationType value:@"gold"];
    strDonationValue = @"500";
    [self.btnYesToDonation setImage:[UIImage imageNamed:@"checkbox_active.png"] forState:UIControlStateNormal] ;
    [self.btnNoToDonation setImage:[UIImage imageNamed:@"checkbox_inactive.png"] forState:UIControlStateNormal];

}
- (IBAction)btn1000dollarClicked:(id)sender
{
    [self resetTextColor];
    [self resetRadioButtons];
    [self.btn1000dollar setImage:[UIImage imageNamed:@"radio_btn_active.png"] forState:UIControlStateNormal];
    [CommonFunction setValueInUserDefault:kDonationType value:@"gold"];
    strDonationValue = @"1000";
    [self.btnYesToDonation setImage:[UIImage imageNamed:@"checkbox_active.png"] forState:UIControlStateNormal] ;
    [self.btnNoToDonation setImage:[UIImage imageNamed:@"checkbox_inactive.png"] forState:UIControlStateNormal];

}
- (IBAction)btn1500dollarClicked:(id)sender
{
    [self resetTextColor];
    [self resetRadioButtons];
    [self.btn1500dollar setImage:[UIImage imageNamed:@"radio_btn_active.png"] forState:UIControlStateNormal];
    [CommonFunction setValueInUserDefault:kDonationType value:@"gold"];
    strDonationValue = @"1500";
    [self.btnYesToDonation setImage:[UIImage imageNamed:@"checkbox_active.png"] forState:UIControlStateNormal] ;
    [self.btnNoToDonation setImage:[UIImage imageNamed:@"checkbox_inactive.png"] forState:UIControlStateNormal];

}
-(void)resetTextColor
{
    self.lbl5Dollar.textColor = [UIColor colorWithRed:0.0f/255.0f green:117.0f/255.0f blue:116.0f/255.0f alpha:1.0f];
    self.lbl10Dollar.textColor = [UIColor colorWithRed:0.0f/255.0f green:117.0f/255.0f blue:116.0f/255.0f alpha:1.0f];
    self.lbl15Dollar.textColor = [UIColor colorWithRed:0.0f/255.0f green:117.0f/255.0f blue:116.0f/255.0f alpha:1.0f];
    self.lbl20Dollar.textColor = [UIColor colorWithRed:0.0f/255.0f green:117.0f/255.0f blue:116.0f/255.0f alpha:1.0f];
}
-(void)resetRadioButtons
{
    strDonationValue=@"";
    self.txtOtherPrice.text = @"";
    [self.btn5dollar setImage:[UIImage imageNamed:@"radio_btn_inactive.png"] forState:UIControlStateNormal];
    [self.btn10dollar setImage:[UIImage imageNamed:@"radio_btn_inactive.png"] forState:UIControlStateNormal];
    [self.btn15dollar setImage:[UIImage imageNamed:@"radio_btn_inactive.png"] forState:UIControlStateNormal];
    [self.btn20dollar setImage:[UIImage imageNamed:@"radio_btn_inactive.png"] forState:UIControlStateNormal];
    [self.btn50dollar setImage:[UIImage imageNamed:@"radio_btn_inactive.png"] forState:UIControlStateNormal];
    [self.btn100dollar setImage:[UIImage imageNamed:@"radio_btn_inactive.png"] forState:UIControlStateNormal];
    [self.btn150dollar setImage:[UIImage imageNamed:@"radio_btn_inactive.png"] forState:UIControlStateNormal];
    [self.btn200dollar setImage:[UIImage imageNamed:@"radio_btn_inactive.png"] forState:UIControlStateNormal];
    [self.btn250dollar setImage:[UIImage imageNamed:@"radio_btn_inactive.png"] forState:UIControlStateNormal];
    [self.btn300dollar setImage:[UIImage imageNamed:@"radio_btn_inactive.png"] forState:UIControlStateNormal];
    [self.btn500dollar setImage:[UIImage imageNamed:@"radio_btn_inactive.png"] forState:UIControlStateNormal];
    [self.btn1000dollar setImage:[UIImage imageNamed:@"radio_btn_inactive.png"] forState:UIControlStateNormal];
    [self.btn1500dollar setImage:[UIImage imageNamed:@"radio_btn_inactive.png"] forState:UIControlStateNormal];
    
}
#pragma mark - Delegate Methods


#pragma mark -

#pragma mark CUSTOM TEXTFIELD DELEGATES
-(BOOL)customTextFieldShouldBeginEditing:(UITextField *)textField
{
    [CommonFunction callHideViewFromSideBar];
    if (textField == self.txtOtherPrice)
    {
        [self resetTextColor];
        [self resetRadioButtons];
    }
    return YES;
}
-(BOOL)customTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)textEntered
{
    
    if (textField == self.txtOtherPrice)
    {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:textEntered];
        
        NSString *expression = @"^([0-9]*)(\\.([0-9]+)?)?$";
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString
                                                            options:0
                                                              range:NSMakeRange(0, [newString length])];
        if (numberOfMatches == 0)
        {
            [CommonFunction fnAlert:@"Please enter numbers only." message:@""];
            return NO;
        }
    }
    return YES;
    
}


-(BOOL)customTextFieldShouldEndEditing:(UITextField *)textField
{
    //    float donation=[textField.text floatValue];
    //    if (textField == self.txtOtherPrice)
    //    {
    //            [self resetTextColor];
    //            [self resetRadioButtons];
    //            strDonationValue = [NSString stringWithFormat:@"%f",donation];
    //            [CommonFunction setValueInUserDefault:kDonationType value:@"normal"];
    //    }
    return YES;
}

@end
