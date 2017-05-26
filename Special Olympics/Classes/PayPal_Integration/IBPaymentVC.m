//
//  IBPaymentVC.m
//  iBuddyClient
//
//  Created by Anubha on 10/05/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import "IBPaymentVC.h"
#define kDonationWithCodeAlertTag 5656

@interface IBPaymentVC ()
@property (weak, nonatomic) IBOutlet UIImageView *imgPaypal;
@property (weak, nonatomic) IBOutlet UIImageView *imgCreditCard;

@property (weak, nonatomic) IBOutlet UILabel *lblSubscribeAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblTaxAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblSubscription;

@property (weak, nonatomic) IBOutlet UITextField *txtRedemption;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UILabel *lblTop;
@property (weak, nonatomic) IBOutlet UIView *vwDynamic;
@property (weak, nonatomic) IBOutlet UILabel *lblDonation;
@property (weak, nonatomic) IBOutlet UIButton *btnDonationOn;
@property (weak, nonatomic) IBOutlet UIButton *btnDonationOff;
@property (weak, nonatomic) IBOutlet UILabel *lblOff;
@property (weak, nonatomic) IBOutlet UILabel *lblOn;
@property (weak, nonatomic) IBOutlet UIButton *btnRedemptionCode;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewRedemption;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@property (weak, nonatomic) IBOutlet UITextField *txtDonation;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UILabel *lblEnterCode;
@property (weak, nonatomic) IBOutlet UILabel *lblPendingPayment;
@property (weak, nonatomic) IBOutlet UILabel *lblChooseOneoption;
@property (weak, nonatomic) IBOutlet UILabel *lblChooseCredit;
@property (weak, nonatomic) IBOutlet UILabel *lblChoosePaypal;
@property (weak, nonatomic) IBOutlet UILabel *lblChooseCode;
@property (weak, nonatomic) IBOutlet UIImageView *imgDivider;
@property (weak, nonatomic) IBOutlet UILabel *lbl5dollar;

@property (weak, nonatomic) IBOutlet UILabel *lbl10dollar;
@property (weak, nonatomic) IBOutlet UILabel *lbl20dollar;
@property (weak, nonatomic) IBOutlet UIButton *btn5dollar;
@property (weak, nonatomic) IBOutlet UIButton *btn10dollar;
@property (weak, nonatomic) IBOutlet UILabel *lblOther;
@property (weak, nonatomic) IBOutlet UILabel *lblFundraiserText;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UIButton *btn20dollar;
@property (weak, nonatomic) IBOutlet UIScrollView *scrlView;
@property (weak, nonatomic) IBOutlet UILabel *lblCopyRight;

@end

@implementation IBPaymentVC
 @synthesize strClassTypeForPaymentScreen,donationAmount,lblCopyRight;
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
    
            if([strClassTypeForPaymentScreen isEqualToString:@"Dashboard"])
            {
            
                IBDashboardVC *objIBDashboardVC;
                if (kDevice==kIphone) {
                    objIBDashboardVC=[[IBDashboardVC alloc]initWithNibName:@"IBDashboardVC" bundle:nil];
                }
                else{
                    objIBDashboardVC=[[IBDashboardVC alloc]initWithNibName:@"IBDashboardVC_iPad" bundle:nil];
                }
                [self.navigationController pushViewController:objIBDashboardVC animated:NO];
                kAppDelegate.objSideBarVC.lastbtnClicked=kAppDelegate.objSideBarVC.btnProfile;
            }
            else
            {
                [self setLayoutForiOS7];
                isTextfieldSelected=NO;
                [self setInitialLabels];
                [self getSubscriptionAmounts];
                [self setBSKeyBoardControls];
            }

    
    
       // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
   
}
- (void)viewDidUnload {
    [self setScrlView:nil];
    [self setLblSubscribeAmount:nil];
    [self setLblTaxAmount:nil];
    [self setLblTotalAmount:nil];
    [self setTxtRedemption:nil];
    [self setVwDynamic:nil];
    [self setLblDonation:nil];
    [self setBtnDonationOn:nil];
    [self setBtnDonationOff:nil];
    [self setTxtDonation:nil];
    [self setLblOff:nil];
    [self setLblOn:nil];
    [self setBtnRedemptionCode:nil];
    [self setImgViewRedemption:nil];
    [self setLblEnterCode:nil];
    [self setBtnBack:nil];
    [self setLblPendingPayment:nil];
    [self setLblChooseOneoption:nil];
    [self setLblChooseCredit:nil];
    [self setLblChoosePaypal:nil];
    [self setLblChooseCode:nil];
    [self setImgDivider:nil];
    [self setLbl5dollar:nil];
    [self setLbl10dollar:nil];
    [self setLbl20dollar:nil];
    [self setBtn5dollar:nil];
    [self setBtn10dollar:nil];
    [self setBtn20dollar:nil];
    [self setLblOther:nil];
    [self setLblFundraiserText:nil];
    [self setLblSubscription:nil];
    [super viewDidUnload];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown
            ||interfaceOrientation == UIInterfaceOrientationPortrait);
    
}
#pragma mark - Set Initial Variables

/**
 Set initial labels
 */
-(void)setInitialLabels
{
    ambassdorClicked=FALSE;
    [CommonFunction setValueInUserDefault:@"isRemptionCode" value:@"no"];
    self.lblCopyRight.text = [CommonFunction getCopyRightText];
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
  //  [_scrlView addGestureRecognizer:singleTap];
    
    for (UIView *view in self.scrlView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)view;
            label.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
        }
    }
    for (UIView *view in self.scrlView.subviews) {
        if ([view isKindOfClass:[UITextView class]]) {
            UITextView *txtView = (UITextView *)view;
            txtView.font=[UIFont fontWithName:kFont size:txtView.font.pointSize];
        }
    }
    for (UIView *view in self.vwDynamic.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)view;
            label.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
        }
    }
    self.lblTop.font=[UIFont fontWithName:kFont size:_lblTop.font.pointSize];
    self.lblOff.font=[UIFont fontWithName:kFont size:_lblOff.font.pointSize];
    self.lblOn.font=[UIFont fontWithName:kFont size:_lblOn.font.pointSize];
    self.btnNext.titleLabel.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
    self.lblPendingPayment.font=[UIFont fontWithName:kFont size:self.lblPendingPayment.font.pointSize];
    self.lbl5dollar.font=[UIFont fontWithName:kFont size:16.0];
    self.lbl10dollar.font=[UIFont fontWithName:kFont size:14.0];
    self.lbl20dollar.font=[UIFont fontWithName:kFont size:14.0];
    self.lblOther.font=[UIFont fontWithName:kFont size:14.0];
    
    btnSelected=@"";
    if (kDevice==kIphone) {
        _scrlView.contentSize=CGSizeMake(0, 430);
        kDynamicViewPlusHeightTextField=90;
//        if(kAppDelegate.window.frame.size.height>480)
//        {
//            kDynamicViewPlusHeightControls=80;
//
//        }
//        else
//        {
            kDynamicViewPlusHeightControls=30;

//        }
        self.lblFundraiserText.font=[UIFont fontWithName:kFont size:10.0];
      
    }
    else
    {
        kDynamicViewPlusHeightTextField=30;
        kDynamicViewPlusHeightControls=50;
        _scrlView.contentSize=CGSizeMake(0, 500);
        self.lblFundraiserText.font=[UIFont fontWithName:kFont size:13.0];
         self.lbl5dollar.font=[UIFont fontWithName:kFont size:22.0];
    }
    
    if([[[kAppDelegate dictUserInfo]valueForKey:@"npoId"]intValue] != 1 && [self.donationAmount floatValue] >0)
    {
      /*********Commented by Utkarsha as extra donation has been changed*****/
        //self.txtDonation.hidden=FALSE;
        
        self.lblDonation.hidden=FALSE;
        self.lbl5dollar.hidden=FALSE;
        self.lbl5dollar.text = [NSString stringWithFormat:@"$%@",self.donationAmount];
//        self.lblOn.hidden=FALSE;
//        self.lblOff.hidden=FALSE;
//        self.btnDonationOff.hidden=FALSE;
//        self.btnDonationOn.hidden=FALSE;
        self.vwDynamic.frame=CGRectMake(self.vwDynamic.frame.origin.x, self.vwDynamic.frame.origin.y+kDynamicViewPlusHeightControls, self.vwDynamic.frame.size.width, self.vwDynamic.frame.size.height);
        _scrlView.contentSize=CGSizeMake(_scrlView.contentSize.width, _scrlView.contentSize.height+kDynamicViewPlusHeightControls);
        isDonation = YES;

    }
        if ([[[kAppDelegate dictUserInfo]valueForKey:@"npoId"]intValue] != 1)
        {
             _btnBack.hidden = NO;
        }
        else
        {
            _btnBack.hidden = YES;
        }
    
}
#pragma mark - Button Actions
- (IBAction)btnPaypalClicked:(id)sender {
    ambassdorClicked=FALSE;
    [CommonFunction setValueInUserDefault:@"isRemptionCode" value:@"no"];

    _txtRedemption.hidden=TRUE;
    _lblEnterCode.hidden=TRUE;
    
    if ([self.imgPaypal.image isEqual:[UIImage imageNamed:@"Settings_CheckBox1_1.png"]]) {
        btnSelected=@"Paypal";
        self.imgPaypal.image=[UIImage imageNamed:@"Settings_CheckBox2_2.png"];
        self.imgCreditCard.image=[UIImage imageNamed:@"Settings_CheckBox1_1.png"];
        self.imgViewRedemption.image=[UIImage imageNamed:@"Settings_CheckBox1_1.png"];
        
    }else{
        btnSelected=@"";
        self.imgPaypal.image=[UIImage imageNamed:@"Settings_CheckBox1_1.png"];
    }
    [self updateTotalAmountField:donationValue];
}

- (IBAction)btnCreditCardClicked:(id)sender {
    ambassdorClicked=FALSE;
    [CommonFunction setValueInUserDefault:@"isRemptionCode" value:@"no"];

    _txtRedemption.hidden=TRUE;
    _lblEnterCode.hidden=TRUE;
    
    if ([self.imgCreditCard.image isEqual:[UIImage imageNamed:@"Settings_CheckBox1_1.png"]]) {
        btnSelected=@"Credit Card";
        self.imgCreditCard.image=[UIImage imageNamed:@"Settings_CheckBox2_2.png"];
        self.imgPaypal.image=[UIImage imageNamed:@"Settings_CheckBox1_1.png"];
        self.imgViewRedemption.image=[UIImage imageNamed:@"Settings_CheckBox1_1.png"];
    if ([self.donationAmount intValue] >0 && isDonation == NO)
    {
            self.lblDonation.hidden=FALSE;
            self.lbl5dollar.hidden=FALSE;
                   self.vwDynamic.frame=CGRectMake(self.vwDynamic.frame.origin.x, self.vwDynamic.frame.origin.y+kDynamicViewPlusHeightControls, self.vwDynamic.frame.size.width, self.vwDynamic.frame.size.height);
                   _scrlView.contentSize=CGSizeMake(_scrlView.contentSize.width, _scrlView.contentSize.height+kDynamicViewPlusHeightControls);
        isDonation = NO;

    }

    }
    else
    {
        btnSelected=@"";
        isDonation=YES;
        self.imgCreditCard.image=[UIImage imageNamed:@"Settings_CheckBox1_1.png"];
        if ([self.donationAmount intValue] >0 && isDonation == NO)
        {
            self.lblDonation.hidden=FALSE;
            self.lbl5dollar.hidden=FALSE;
            self.vwDynamic.frame=CGRectMake(self.vwDynamic.frame.origin.x, self.vwDynamic.frame.origin.y-kDynamicViewPlusHeightControls, self.vwDynamic.frame.size.width, self.vwDynamic.frame.size.height);
            _scrlView.contentSize=CGSizeMake(_scrlView.contentSize.width, _scrlView.contentSize.height-kDynamicViewPlusHeightControls);
            isDonation = NO;
        }
    }
    [self updateTotalAmountField:donationValue];
    
}
- (IBAction)btnRedemptionCodeClicked:(id)sender
{
    if ([self.imgViewRedemption.image isEqual:[UIImage imageNamed:@"Settings_CheckBox1_1.png"]]) {
        _txtRedemption.hidden=FALSE;
        _lblEnterCode.hidden=FALSE;
        
        isDonation = NO;
//        if (kDevice==kIphone) {
//            _scrlView.contentOffset=CGPointMake(0, 350);
//        }
//        else{
//            _scrlView.contentOffset=CGPointMake(0, 250);
//        }
        ambassdorClicked=TRUE;
        btnSelected=@"Redemption";
        self.imgViewRedemption.image=[UIImage imageNamed:@"Settings_CheckBox2_2.png"];
        self.imgPaypal.image=[UIImage imageNamed:@"Settings_CheckBox1_1.png"];
        self.imgCreditCard.image=[UIImage imageNamed:@"Settings_CheckBox1_1.png"];
          if ([self.donationAmount intValue] >0)
          {
        self.vwDynamic.frame=CGRectMake(self.vwDynamic.frame.origin.x, self.vwDynamic.frame.origin.y-kDynamicViewPlusHeightControls, self.vwDynamic.frame.size.width, self.vwDynamic.frame.size.height);
        _scrlView.contentSize=CGSizeMake(_scrlView.contentSize.width, _scrlView.contentSize.height-kDynamicViewPlusHeightControls);
        self.lblDonation.hidden=TRUE;
        self.lbl5dollar.hidden=TRUE;
          }
        if (kDevice==kIphone) {
            if (_txtRedemption==self.txtRedemption) {
                _scrlView.contentOffset=CGPointMake(0, 100);
            }
            if (_txtRedemption==self.txtDonation) {
                _scrlView.contentOffset=CGPointMake(0, 100);
            }
        }
         [_txtRedemption becomeFirstResponder];
        if ([self.keyboardControls.textFields containsObject:_txtRedemption])
            self.keyboardControls.activeTextField = _txtRedemption;
        [CommonFunction callHideViewFromSideBar];


    }else{
        ambassdorClicked=FALSE;
        
        [_txtRedemption resignFirstResponder];
        _txtRedemption.hidden=TRUE;
        _lblEnterCode.hidden=TRUE;
        isDonation = YES;
        btnSelected=@"";
        self.imgViewRedemption.image=[UIImage imageNamed:@"Settings_CheckBox1_1.png"];
                if ([self.donationAmount intValue] >0) {
            self.lblDonation.hidden=FALSE;
            self.lbl5dollar.hidden=FALSE;
                    self.vwDynamic.frame=CGRectMake(self.vwDynamic.frame.origin.x, self.vwDynamic.frame.origin.y+kDynamicViewPlusHeightControls, self.vwDynamic.frame.size.width, self.vwDynamic.frame.size.height);
                    _scrlView.contentSize=CGSizeMake(_scrlView.contentSize.width, _scrlView.contentSize.height+kDynamicViewPlusHeightControls);

        }
    }
    [self updateTotalAmountField:donationValue];
    
}


- (IBAction)btnNextClicked:(id)sender {
    if ([btnSelected isEqualToString:@"Credit Card"]) {
        IBCreditCardPaymentVC *objIBCreditCardPaymentVC;
        
        if (kDevice==kIphone) {
            objIBCreditCardPaymentVC=[[IBCreditCardPaymentVC alloc]initWithNibName:@"IBCreditCardPaymentVC" bundle:nil];
        }
        else{
            objIBCreditCardPaymentVC=[[IBCreditCardPaymentVC alloc]initWithNibName:@"IBCreditCardPayment_iPad" bundle:nil];
        }
        [self.navigationController pushViewController:objIBCreditCardPaymentVC animated:YES];
    }
    
    else if([btnSelected isEqualToString:@"Redemption"]&&[donationValue floatValue]>0){
        
        [self donationPay];
    }
    else if([btnSelected isEqualToString:@"Redemption"]){
        
        [self goToCodeRedemption];
    }
    else{
        [CommonFunction fnAlert:@"Alert" message:@"Please select an option to go next."];
    }
}


- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnDonationONClicked:(id)sender {
    [self.btnDonationOn setImage:[UIImage imageNamed:@"radio-btn_selected.png"] forState:UIControlStateNormal];
    [self.btnDonationOff setImage:[UIImage imageNamed:@"radio-btn.png"] forState:UIControlStateNormal];
    
    self.btnDonationOn.userInteractionEnabled=NO;
    self.btnDonationOff.userInteractionEnabled=YES;
    self.txtDonation.hidden=FALSE;
    self.lbl5dollar.hidden=FALSE;
    self.lbl10dollar.hidden=FALSE;
    self.lbl20dollar.hidden=FALSE;
    self.btn5dollar.hidden=FALSE;
    self.btn10dollar.hidden=FALSE;
    self.btn20dollar.hidden=FALSE;
    self.lblOther.hidden=FALSE;
    self.lblFundraiserText.hidden=FALSE;
    
    self.vwDynamic.frame=CGRectMake(self.vwDynamic.frame.origin.x, self.vwDynamic.frame.origin.y+kDynamicViewPlusHeightTextField, self.vwDynamic.frame.size.width, self.vwDynamic.frame.size.height);
    _scrlView.contentSize=CGSizeMake(_scrlView.contentSize.width, _scrlView.contentSize.height+kDynamicViewPlusHeightTextField);
}
- (IBAction)btnDonationOFFClicked:(id)sender {
    
    donationValue=@"0";
    [self.btn10dollar setImage:[UIImage imageNamed:@"radio-btn.png"] forState:UIControlStateNormal];
    [self.btn20dollar setImage:[UIImage imageNamed:@"radio-btn.png"] forState:UIControlStateNormal];
    [self.btn5dollar setImage:[UIImage imageNamed:@"radio-btn.png"] forState:UIControlStateNormal];
    if (ambassdorClicked==TRUE) {
        self.lblTotalAmount.text=@"$0.00";
        self.lblTaxAmount.text=@"$0.00";
        self.lblSubscribeAmount.text=@"$0.00";
    }
    else{
        NSString *strActualAmount=@"$";
        strActualAmount=[strActualAmount stringByAppendingString:[CommonFunction getValueFromUserDefault:kTotalPayment]];
        NSString *strTaxPayment=@"$";
        strTaxPayment=[strTaxPayment stringByAppendingString:[CommonFunction getValueFromUserDefault:kTax]];
        
        NSString *strSubscriptionPayment=@"$";
        strSubscriptionPayment=[strSubscriptionPayment stringByAppendingString:[CommonFunction getValueFromUserDefault:KSubscriptionPayment]];
        
        [CommonFunction setValueInUserDefault:kTotalPaymentUpdated value:[CommonFunction getValueFromUserDefault:kTotalPayment]];
        self.lblTotalAmount.text=strActualAmount;
        self.lblTaxAmount.text=strTaxPayment;
        self.lblSubscribeAmount.text=strSubscriptionPayment;
    }
    
    [self.btnDonationOn setImage:[UIImage imageNamed:@"radio-btn.png"] forState:UIControlStateNormal];
    [self.btnDonationOff setImage:[UIImage imageNamed:@"radio-btn_selected.png"] forState:UIControlStateNormal];
    self.btnDonationOn.userInteractionEnabled=YES;
    self.btnDonationOff.userInteractionEnabled=NO;
    self.txtDonation.hidden=TRUE;
    self.lbl5dollar.hidden=TRUE;
    self.lbl10dollar.hidden=TRUE;
    self.lbl20dollar.hidden=TRUE;
    self.btn5dollar.hidden=TRUE;
    self.btn10dollar.hidden=TRUE;
    self.btn20dollar.hidden=TRUE;
    self.lblOther.hidden=TRUE;
    self.lblFundraiserText.hidden=TRUE;
    
    self.vwDynamic.frame=CGRectMake(self.vwDynamic.frame.origin.x, self.vwDynamic.frame.origin.y-kDynamicViewPlusHeightTextField, self.vwDynamic.frame.size.width, self.vwDynamic.frame.size.height);
    _scrlView.contentSize=CGSizeMake(_scrlView.contentSize.width, _scrlView.contentSize.height-kDynamicViewPlusHeightTextField);
}
- (IBAction)btn5Dollarclicked:(id)sender {
    [self.btn5dollar setImage:[UIImage imageNamed:@"radio-btn_selected.png"] forState:UIControlStateNormal];
    [self.btn10dollar setImage:[UIImage imageNamed:@"radio-btn.png"] forState:UIControlStateNormal];
    [self.btn20dollar setImage:[UIImage imageNamed:@"radio-btn.png"] forState:UIControlStateNormal];
    [self updateTotalAmountField:@"5"];
    
}
- (IBAction)btn10dollarclicked:(id)sender {
    [self.btn5dollar setImage:[UIImage imageNamed:@"radio-btn.png"] forState:UIControlStateNormal];
    [self.btn10dollar setImage:[UIImage imageNamed:@"radio-btn_selected"] forState:UIControlStateNormal];
    [self.btn20dollar setImage:[UIImage imageNamed:@"radio-btn.png"] forState:UIControlStateNormal];
    [self updateTotalAmountField:@"10"];
}

- (IBAction)btn20dollarClicked:(id)sender {
    [self.btn5dollar setImage:[UIImage imageNamed:@"radio-btn.png"] forState:UIControlStateNormal];
    [self.btn10dollar setImage:[UIImage imageNamed:@"radio-btn.png"] forState:UIControlStateNormal];
    [self.btn20dollar setImage:[UIImage imageNamed:@"radio-btn_selected.png"] forState:UIControlStateNormal];
    [self updateTotalAmountField:@"20"];
    
}

-(void)pushToDashBoard: (NSDictionary*)result
{
    // code changed for dashboard
//    if([strClassTypeForPaymentScreen isEqualToString:@"Dashboard"])
//    {
//            IBDashboardVC *objIBDashboardVC;
//            if (kDevice==kIphone) {
//                objIBDashboardVC=[[IBDashboardVC alloc]initWithNibName:@"IBDashboardVC" bundle:nil];
//            }
//            else{
//                objIBDashboardVC=[[IBDashboardVC alloc]initWithNibName:@"IBDashboardVC_iPad" bundle:nil];
//            }
//            [self.navigationController pushViewController:objIBDashboardVC animated:YES];
//            kAppDelegate.objSideBarVC.lastbtnClicked=kAppDelegate.objSideBarVC.btnProfile;
//    }
//    else
//    {
        IBRegisterVC *objIBRegisterVC;
        if (kDevice==kIphone) {
            objIBRegisterVC=[[IBRegisterVC alloc]initWithNibName:@"IBRegisterVC" bundle:nil];
        }
        else{
            objIBRegisterVC=[[IBRegisterVC alloc]initWithNibName:@"IBRegisterVC_iPad" bundle:nil];
        }
        objIBRegisterVC.strEditProfile=@"Edit";
        objIBRegisterVC.strDetailRegistration=@"DetailRegistration";
        objIBRegisterVC.strController = @"My Profile";
        objIBRegisterVC.dictProfileData=[result valueForKey:@"userDetail"];
        //[[kAppDelegate dictUserInfo]setObject:[dictInfo valueForKey:@"userDetail"] forKey:@"userDetail"];
        //objIBRegisterVC.dictProfileData=[dictInfo valueForKey:@"userDetail"];
        // [kAppDelegate.navController presentModalViewController:objIBRegisterVC animated:YES];
        
        [kAppDelegate.navController pushViewController:objIBRegisterVC animated:NO];
 //   }
//    IBDashboardVC *objIBDashboardVC;
//    if (kDevice==kIphone) {
//        objIBDashboardVC=[[IBDashboardVC alloc]initWithNibName:@"IBDashboardVC" bundle:nil];
//    }
//    else{
//        objIBDashboardVC=[[IBDashboardVC alloc]initWithNibName:@"IBDashboardVC_iPad" bundle:nil];
//    }
//    [self.navigationController pushViewController:objIBDashboardVC animated:YES];
//    kAppDelegate.objSideBarVC.lastbtnClicked=kAppDelegate.objSideBarVC.btnProfile;
    
    

}
-(void)checkPendingPayment
{
   // if ([[kAppDelegate.dictUserPaymentInfo valueForKey:@"isPending"]isEqualToString:@"yes"]) {
        if ([[kAppDelegate.dictUserInfo valueForKey:@"isPending"]isEqualToString:@"yes"]) {
        _lblPendingPayment.hidden=NO;
        for (UIView *view in self.vwDynamic.subviews) {
            if ([view isKindOfClass:[UIImageView class]]) {
                UIImageView *imgView = (UIImageView *)view;
                imgView.hidden=YES;
            }
        }
        for (UIView *view in self.vwDynamic.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)view;
                btn.hidden=YES;
            }
        }
        if([[[kAppDelegate dictUserInfo]valueForKey:@"npoId"]intValue] != 1 &&[[[kAppDelegate dictUserInfo] valueForKey:@"isUserGruEdu"] intValue] ==0)
        {
            self.vwDynamic.frame=CGRectMake(self.vwDynamic.frame.origin.x, self.vwDynamic.frame.origin.y-kDynamicViewPlusHeightControls, self.vwDynamic.frame.size.width, self.vwDynamic.frame.size.height);
            _scrlView.contentSize=CGSizeMake(_scrlView.contentSize.width, _scrlView.contentSize.height-kDynamicViewPlusHeightControls);
        }
        _lblDonation.hidden=YES;
        _lblOn.hidden=YES;
        _lblOff.hidden=YES;
        _txtDonation.hidden=YES;
        _btnDonationOff.hidden=YES;
        _btnDonationOn.hidden=YES;
        _btnNext.hidden=YES;
        _lblChooseCode.hidden=YES;
        _lblChooseCredit.hidden=YES;
        _lblChoosePaypal.hidden=YES;
        _lblChooseOneoption.text=@"Payment Status";
        _imgDivider.hidden=NO;
        _scrlView.contentSize=CGSizeMake(0, 450);
    }
}
#pragma mark -
#pragma mark - UITextField Delegate & Validation Check

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self setDollarButtonImages];
    
    if ([self.keyboardControls.textFields containsObject:textField])
        self.keyboardControls.activeTextField = textField;
    [CommonFunction callHideViewFromSideBar];
    
    if (kDevice==kIphone) {
        if (textField==self.txtRedemption) {
            _scrlView.contentOffset=CGPointMake(0, 100);
        }
        if (textField==self.txtDonation) {
            _scrlView.contentOffset=CGPointMake(0, 100);
        }
    }
    isTextfieldSelected=YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    isTextfieldSelected=NO;
    if (textField==self.txtDonation) {
        [self.txtDonation resignFirstResponder];
        [self setDollarButtonImages];
        [self updateTotalAmountField:self.txtDonation.text];
    }
    _scrlView.contentOffset=CGPointMake(0, 0);
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    if (textField==self.txtDonation) {
        [self.txtDonation resignFirstResponder];
        [self setDollarButtonImages];
        
        [self updateTotalAmountField:self.txtDonation.text];
    }
    _scrlView.contentOffset=CGPointMake(0, 0);
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)textEntered{
    if (textField == self.txtDonation)
    {
        NSCharacterSet *NUMBERS	= [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
        for (int i = 0; i < [textEntered length]; i++)
        {
            unichar d = [textEntered characterAtIndex:i];
            if (![NUMBERS characterIsMember:d])
            {
                UIAlertView *alertIntCheck=[[UIAlertView alloc]initWithTitle:@"Please enter numbers only." message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertIntCheck show];
                return NO;
            }
        }
    }
    return YES;
}
-(void)updateTotalAmountField:(NSString *)txtFieeldValue
{
    [CommonFunction setValueInUserDefault:kDonation value:txtFieeldValue];
    
    if (ambassdorClicked==TRUE) {
        donationValue=txtFieeldValue ;
        
        float donation=[txtFieeldValue floatValue];
        if (donation>0)
        {
            _lblSubscription.text=@"Donation";
            NSString *strsubscriptionAmount=@"$";
            strsubscriptionAmount=[strsubscriptionAmount stringByAppendingString:[NSString stringWithFormat:@"%.02f",donation]];
            //1.0 extra is demanded by client 27/2/14
            //removed extra 1 by utkarsha as requested by client on 15 May 14
            float taxAmount=(donation*2.9)/100+0.30;
            NSString *strTaxAmount=@"$";
            strTaxAmount=[strTaxAmount stringByAppendingString:[NSString stringWithFormat:@"%.02f",taxAmount]];
            
            float totalAmount=donation+[[NSString stringWithFormat:@"%.02f",taxAmount] floatValue];
            NSString *strActualAmount=@"$";
            strActualAmount=[strActualAmount stringByAppendingString:[NSString stringWithFormat:@"%.02f",totalAmount]];
            [CommonFunction setValueInUserDefault:kTotalPaymentUpdated value:[NSString stringWithFormat:@"%.02f",totalAmount]];
            _lblSubscribeAmount.text=strsubscriptionAmount ;
            _lblTaxAmount.text=strTaxAmount;
            
            self.lblTotalAmount.text=strActualAmount;
        }
        else
        {
            _lblSubscription.text=@"Subscription Amount";

            NSString *strsubscriptionAmount=@"$";
            strsubscriptionAmount=[strsubscriptionAmount stringByAppendingString:[NSString stringWithFormat:@"%.02f",donation]];
            _lblSubscribeAmount.text=strsubscriptionAmount ;
            _lblTaxAmount.text=strsubscriptionAmount;
           
            self.lblTotalAmount.text=strsubscriptionAmount;
        }
    }
    else{
        _lblSubscription.text=@"Subscription Amount";
        NSString *strsubscriptionAmount=@"$";
        float taxAmount=0.0;
        NSString *strTaxAmount=@"";
        float totalAmount=0.0;
        NSString *strActualAmount=@"$";
        donationValue=txtFieeldValue ;
        NSString *strSuscriptionAmount=[CommonFunction getValueFromUserDefault:KSubscriptionPayment];
        float subscriptionAmount=[strSuscriptionAmount floatValue];
        float amountWithDonation=subscriptionAmount+[txtFieeldValue floatValue];
       
        
        if([[kAppDelegate.dictUserInfo valueForKey:@"isUserGruEdu"] intValue] == 1)
        {
            strsubscriptionAmount=[[strsubscriptionAmount stringByAppendingString:[NSString stringWithFormat:@"%.02f",subscriptionAmount]]stringByAppendingString:@"/Month"];
            taxAmount=0.0;
            strTaxAmount=@"Free";
            totalAmount=amountWithDonation+[[NSString stringWithFormat:@"%.02f",taxAmount] floatValue];
            strActualAmount=[[strActualAmount stringByAppendingString:[NSString stringWithFormat:@"%.02f",totalAmount]]stringByAppendingString:@"/Month"];
        }
        else{
            
            strsubscriptionAmount=[strsubscriptionAmount stringByAppendingString:[NSString stringWithFormat:@"%.02f",subscriptionAmount]];
            //1.0 extra is demanded by client 27/2/14
            //removed extra 1 by utkarsha as requested by client on 15 May 14
            if (subscriptionAmount < 39.99)
            {
                taxAmount=(amountWithDonation*2.9)/100+0.30 + 1.0;

            }
            else
            {
            taxAmount=(amountWithDonation*2.9)/100+0.30;
            }
            strTaxAmount=@"$";
            strTaxAmount=[strTaxAmount stringByAppendingString:[NSString stringWithFormat:@"%.02f",taxAmount]];
            totalAmount=amountWithDonation+[[NSString stringWithFormat:@"%.02f",taxAmount] floatValue];
            strActualAmount=[strActualAmount stringByAppendingString:[NSString stringWithFormat:@"%.02f",totalAmount]];
        }
        [CommonFunction setValueInUserDefault:kTotalPaymentUpdated value:[NSString stringWithFormat:@"%.02f",totalAmount]];
        _lblSubscribeAmount.text=strsubscriptionAmount ;
        _lblTaxAmount.text=strTaxAmount;
        self.lblTotalAmount.text=strActualAmount;
}
}

#pragma mark -
#pragma mark BSKeyboardControls Delegate

-(void)setBSKeyBoardControls
{
    self.keyboardControls = [[BSKeyboardControls alloc] init];
    
    // Set the delegate of the keyboard controls
    self.keyboardControls.delegate = self;
    
    // Add all text fields you want to be able to skip between to the keyboard controls
    // The order of thise text fields are important. The order is used when pressing "Previous" or "Next"
    self.keyboardControls.textFields = [NSArray arrayWithObjects:self.txtDonation,nil];
    [self.keyboardControls reloadTextFields];
    self.keyboardControls.showSegment=NO;
}

/*
 * The "Done" button was pressed
 * We want to close the keyboard
 */
- (void)keyboardControlsDonePressed:(BSKeyboardControls *)controls
{
    [self.txtDonation resignFirstResponder];
    [self updateTotalAmountField:self.txtDonation.text];
}
- (void)keyboardControlsPreviousNextPressed:(BSKeyboardControls *)controls withDirection:(KeyboardControlsDirection)direction andActiveTextField:(id)textField
{
    
}


-(void)setDollarButtonImages
{
    [self.btn5dollar setImage:[UIImage imageNamed:@"radio-btn.png"] forState:UIControlStateNormal];
    [self.btn10dollar setImage:[UIImage imageNamed:@"radio-btn.png"] forState:UIControlStateNormal];
    [self.btn20dollar setImage:[UIImage imageNamed:@"radio-btn.png"] forState:UIControlStateNormal];
}

#pragma mark - Alert View Delegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView tag]==kDonationWithCodeAlertTag && buttonIndex==1)
    {
        IBCreditCardPaymentVC *objIBCreditCardPaymentVC;
        if (kDevice==kIphone)
        {
            objIBCreditCardPaymentVC=[[IBCreditCardPaymentVC alloc]initWithNibName:@"IBCreditCardPaymentVC" bundle:nil];
        }
        else{
            objIBCreditCardPaymentVC=[[IBCreditCardPaymentVC alloc]initWithNibName:@"IBCreditCardPayment_iPad" bundle:nil];
        }
        [self.navigationController pushViewController:objIBCreditCardPaymentVC animated:YES];
    }
}
#pragma mark Webservice Methods
-(void)setAmounts:(NSMutableDictionary *)result{
    if([[kAppDelegate.dictUserInfo valueForKey:@"isUserGruEdu"] intValue] == 1){
        _lblSubscribeAmount.text=[[result valueForKey:@"subscriptionAmount"]stringByAppendingString:@"/Month"];
        _lblTaxAmount.text=[result valueForKey:@"tax"];
        _lblTotalAmount.text=[[result valueForKey:@"total"]stringByAppendingString:@"/Month"];
        _lblPrice.text=@"GRU Price";
        if (kDevice==kIphone) {
            _lblSubscribeAmount.frame=CGRectMake(_lblSubscribeAmount.frame.origin.x, _lblSubscribeAmount.frame.origin.y, _lblSubscribeAmount.frame.size.width, _lblSubscribeAmount.frame.size.height+16);
            _lblTotalAmount.frame=CGRectMake(_lblTotalAmount.frame.origin.x, _lblTotalAmount.frame.origin.y-10, _lblTotalAmount.frame.size.width, _lblTotalAmount.frame.size.height+16);
        }
    }
    else
    {
        _lblSubscribeAmount.text=[result valueForKey:@"subscriptionAmount"];
        _lblTaxAmount.text=[result valueForKey:@"tax"];
        _lblTotalAmount.text=[result valueForKey:@"total"];
    }
  //  [kAppDelegate.dictUserPaymentInfo setValue:[result valueForKey:@"isPending"] forKey:@"isPending"];
    [kAppDelegate.dictUserInfo setValue:[result valueForKey:@"isPending"] forKey:@"isPending"];
    NSString   *strPayment=[result valueForKey:@"total"];
    strPayment=[strPayment stringByReplacingOccurrencesOfString:@"$" withString:@""];
    [CommonFunction setValueInUserDefault:kTotalPayment value:strPayment];
    [CommonFunction setValueInUserDefault:kTax value:[[result valueForKey:@"tax"] stringByReplacingOccurrencesOfString:@"$" withString:@""]];
    [CommonFunction setValueInUserDefault:KSubscriptionPayment value:[[result valueForKey:@"subscriptionAmount"] stringByReplacingOccurrencesOfString:@"$" withString:@""]];
    [CommonFunction setValueInUserDefault:kTotalPaymentUpdated value:strPayment];
    [self checkPendingPayment];
}
- (void)goToCodeRedemption
{
    [_txtRedemption resignFirstResponder];
    if ([_txtRedemption.text length]>0) {
        [kAppDelegate showProgressHUD:self.view];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:self.txtRedemption.text forKey:@"redemptionCode"];
        [dict setValue:[[kAppDelegate dictUserInfo]valueForKey:@"userId"] forKey:@"userId"];
        [dict setValue:donationValue forKey:@"donation"];
        
        [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dict method:kRedemptionCode] completeBlock:^(NSData *data) {
            id result = [NSJSONSerialization JSONObjectWithData:data
                                                        options:kNilOptions error:nil];
            if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]])
            {
                [CommonFunction fnAlert:@"Success" message:@"Your payment is completed."];
                [CommonFunction setValueInUserDefault:@"isRemptionCode" value:@"yes"];
                [[kAppDelegate dictUserInfo]setValue:@"active" forKey:@"userPayments"];
                //                [[kAppDelegate dictUserInfo]setValue:[CommonFunction getValueFromUserDefault:@"userId"] forKey:@"userId"];
                [self pushToDashBoard:result];
            }
            else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]){
                [CommonFunction fnAlert:@"Failure" message:@"Invalid code."];
            }
            else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]){
                [CommonFunction fnAlert:@"" message:@"Please try again"];
            }
            else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:2]]){
                [CommonFunction fnAlert:@"" message:@"Code is expired"];
            }
            else  {
                [CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
            }
            [kAppDelegate hideProgressHUD];
            
        } errorBlock:^(NSError *error) {
            if (error.code == NSURLErrorTimedOut) {
                [CommonFunction fnAlert:@"Alert!" message:kAlerTimedOut];
            }
            else{
                [CommonFunction fnAlert:@"Error" message:[error localizedDescription]];
            }
            [kAppDelegate hideProgressHUD];
        }];
    }
    else{
        [CommonFunction fnAlert:@"" message:@"Please enter redemption code"];
    }
}
- (void)donationPay {
    [_txtRedemption resignFirstResponder];
    if ([_txtRedemption.text length]>0) {
        
        [kAppDelegate showProgressHUD:self.view];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:self.txtRedemption.text forKey:@"redemptionCode"];
        /*commented in order to implement not to log out unpaid user*/
        //[dict setValue:[CommonFunction getValueFromUserDefault:kUserId] forKey:@"userId"];
        [dict setValue:[[kAppDelegate dictUserInfo]valueForKey:@"userId"] forKey:@"userId"];
        [dict setValue:donationValue forKey:@"donation"];
        
        [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dict method:kRedemptionCode] completeBlock:^(NSData *data) {
            id result = [NSJSONSerialization JSONObjectWithData:data
                                                        options:kNilOptions error:nil];
            if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
//                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"You want to make the donation?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Credit Card", nil];
//                alert.tag=kDonationWithCodeAlertTag;
//                [alert show];
                IBCreditCardPaymentVC *objIBCreditCardPaymentVC;
                if (kDevice==kIphone)
                {
                    objIBCreditCardPaymentVC=[[IBCreditCardPaymentVC alloc]initWithNibName:@"IBCreditCardPaymentVC" bundle:nil];
                }
                else{
                    objIBCreditCardPaymentVC=[[IBCreditCardPaymentVC alloc]initWithNibName:@"IBCreditCardPayment_iPad" bundle:nil];
                }
                [self.navigationController pushViewController:objIBCreditCardPaymentVC animated:YES];
            }
            else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]){
                [CommonFunction fnAlert:@"Failure" message:@"Invalid code."];
            }
            else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]){
                [CommonFunction fnAlert:@"" message:@"Please try again"];
            }
            else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:2]]){
                [CommonFunction fnAlert:@"" message:@"Code is expired"];
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
                [CommonFunction fnAlert:@"Error" message:[error localizedDescription]];
            }
            [kAppDelegate hideProgressHUD];
        }];
    }
    else{
        [CommonFunction fnAlert:@"" message:@"Please enter promotion code"];
    }
}
-(void)getSubscriptionAmounts
{
    [kAppDelegate showProgressHUD:self.view];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    /*commented in order to implement not to log out unpaid user*/
    //  [dict setValue:[CommonFunction getValueFromUserDefault:kUserId] forKey:@"userId"];
    [dict setValue:[[kAppDelegate dictUserInfo]valueForKey:@"userId"] forKey:@"userId"];
    [dict setValue:[kAppDelegate.dictUserInfo valueForKey:@"isUserGruEdu"] forKey:@"isGru"];
    
    [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dict method:kGetAmounts] completeBlock:^(NSData *data) {
        id result = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions error:nil];
        // code changed if condition added
        
//        if([strClassTypeForPaymentScreen isEqualToString:@"Dashboard"])
//        {
//            IBDashboardVC *objIBDashboardVC;
//            if (kDevice==kIphone) {
//                objIBDashboardVC=[[IBDashboardVC alloc]initWithNibName:@"IBDashboardVC" bundle:nil];
//            }
//            else{
//                objIBDashboardVC=[[IBDashboardVC alloc]initWithNibName:@"IBDashboardVC_iPad" bundle:nil];
//            }
//            [self.navigationController pushViewController:objIBDashboardVC animated:YES];
//            kAppDelegate.objSideBarVC.lastbtnClicked=kAppDelegate.objSideBarVC.btnProfile;
//        }
//        else
//        {
//
        [self setAmounts:result];
        [self updateTotalAmountField:donationAmount];
      //  }
        [kAppDelegate hideProgressHUD];
        
    } errorBlock:^(NSError *error) {
        [kAppDelegate hideProgressHUD];
    }];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (isTextfieldSelected)
    {
        [_txtRedemption resignFirstResponder];
        isTextfieldSelected=NO;
    }
}
//- (void)handleTap:(UITapGestureRecognizer *)sender {
//    // report click to UI changer
//    [_txtRedemption resignFirstResponder];
//}
@end
