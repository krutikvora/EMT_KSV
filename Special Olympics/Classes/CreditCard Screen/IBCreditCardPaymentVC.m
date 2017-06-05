//
//  IBCreditCardPaymentVC.m
//  iBuddyClient
//
//  Created by Anubha on 15/05/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import "IBCreditCardPaymentVC.h"
#import "CustomPickerViewController.h"
#import "NSData-AES.h"
#import "IBTermsVC.h"
#import "OHAttributedLabel.h"
#import "NSAttributedString+Attributes.h"
#import "NSTextCheckingResult+ExtendedURL.h"
#import "CoreTextUtils.h"

#define kPaymentProgressAlertTag 1212
#define kPaymentDoneAlertTag 3131
#define kAlertMsgTag 2121

@interface IBCreditCardPaymentVC ()
@property (weak, nonatomic) IBOutlet UITextField *txtTypeOfCard;
@property (weak, nonatomic) IBOutlet UITextField *txtNameofCard;
@property (weak, nonatomic) IBOutlet UITextField *txtCardNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtExpiration;
@property (weak, nonatomic) IBOutlet UITextField *txtZipCodeField;
@property (weak, nonatomic) IBOutlet UITextField *txtAddressField;
@property (weak, nonatomic) IBOutlet UITextField *txtCVV2;
@property (weak, nonatomic) IBOutlet UILabel *lblTop;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UIScrollView *scrlView;
@property (weak, nonatomic) IBOutlet UITextField *txtYear;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckBox;
@property (weak, nonatomic) IBOutlet OHAttributedLabel *lblTerms;
@property (weak, nonatomic) IBOutlet UILabel *lblCopyRight;

@end

@implementation IBCreditCardPaymentVC
@synthesize dictDonationOrNormalInfo,lblCopyRight,isExtraDonation,btnCancelRegistration;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark View LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Added by Utkarsha so as to make iAds compatible to iOS 7 Layout
    [self setLayoutForiOS7];

    [self setInitialVaribles];
    arrTypeOfCards=[[NSMutableArray alloc]initWithObjects:@"Visa",@"Master Card",@"American Express", nil];
    arrTypeOfCards=[[arrTypeOfCards sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] mutableCopy];
    arrTextFields = [[NSMutableArray alloc] initWithObjects:_txtTypeOfCard,_txtNameofCard,_txtCardNumber,_txtExpiration,_txtYear,_txtCVV2,self.txtAddressField,self.txtZipCodeField,  nil];
    for (UITextField *obj in arrTextFields)
    {
        UIView *leftPAdding = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, obj.frame.size.height)];
        obj.leftView = leftPAdding;
        obj.leftViewMode = UITextFieldViewModeAlways;
        obj.layer.borderColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.0].CGColor;
        obj.layer.borderWidth = 1;
        [obj setValue:[UIColor lightGrayColor]
           forKeyPath:@"_placeholderLabel.textColor"];
    }
    
    UIImageView *leftPAdding = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 30, 30)];
    leftPAdding.image= [UIImage imageNamed:@"dropdown"];
    leftPAdding.contentMode=UIViewContentModeScaleAspectFit;
    _txtTypeOfCard.rightView = leftPAdding;
    _txtTypeOfCard.rightViewMode = UITextFieldViewModeAlways;
    
    UIImageView *leftPAdding1 = [[UIImageView alloc]initWithFrame:CGRectMake(0,  5, 30, 30)];
    leftPAdding1.image= [UIImage imageNamed:@"dropdown"];
    leftPAdding1.contentMode=UIViewContentModeScaleAspectFit;
    _txtExpiration.rightView = leftPAdding1;
    _txtExpiration.rightViewMode = UITextFieldViewModeAlways;
    
    UIImageView *leftPAdding2 = [[UIImageView alloc]initWithFrame:CGRectMake(0,  5, 30, 30)];
    leftPAdding2.image= [UIImage imageNamed:@"dropdown"];
    leftPAdding2.contentMode=UIViewContentModeScaleAspectFit;
    _txtYear.rightView = leftPAdding2;
    _txtYear.rightViewMode = UITextFieldViewModeAlways;

    
    NSMutableArray *arrYears= [self getYearsArray];
    [self createPickerForFields:[NSArray arrayWithObjects:_txtTypeOfCard,_txtExpiration,_txtYear, nil] withPickerDataInArrayFormat:@[arrTypeOfCards,    @[@"Month",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"],arrYears]];
    [self setUpCustomForm];
    [self.scrlView setContentSize:CGSizeMake(255, 390)];
    if(isExtraDonation==TRUE)
    {
        btnCancelRegistration.hidden=YES;
        if (kDevice == kIphone) {
            self.btnSubmit.frame=CGRectMake(105, self.btnSubmit.frame.origin.y, self.btnSubmit.frame.size.width, self.btnSubmit.frame.size.height);
        }
        else
        {
            self.btnSubmit.frame=CGRectMake(270, self.btnSubmit.frame.origin.y, self.btnSubmit.frame.size.width, self.btnSubmit.frame.size.height);

        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown
            ||interfaceOrientation == UIInterfaceOrientationPortrait);
    
}

#pragma mark Button Actions
- (IBAction)btnCancelregistrationAction:(id)sender
{
    
    
        [kAppDelegate showProgressHUD:self.view];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:[[kAppDelegate dictUserInfo]valueForKey:@"userId"] forKey:@"userId"];
    
        [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dict method:kCancelRegistration] completeBlock:^(NSData *data) {
            id result = [NSJSONSerialization JSONObjectWithData:data
                                                        options:kNilOptions error:nil];
            if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]])
            {
                [kAppDelegate setDictUserInfo:nil];

                [CommonFunction setValueInUserDefault:kZipCode value:@""];
                [CommonFunction setValueInUserDefault:kZipCodeHighlighted value:@""];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kdictUserInfo];
                [[NSUserDefaults standardUserDefaults] synchronize];

                
                IBLoginVC *objIBLoginVC;
                if (kDevice == kIphone) {
                    objIBLoginVC = [[IBLoginVC alloc]initWithNibName:@"IBLoginVC" bundle:nil];
                }
                else {
                    objIBLoginVC = [[IBLoginVC alloc]initWithNibName:@"IBLoginVC_iPad" bundle:nil];
                }
                //objIBLoginVC.classType = kOffers;
                [self.navigationController pushViewController:objIBLoginVC animated:YES];

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
- (IBAction)btnSubmitClicked:(id)sender
{
   
    if ([self.txtTypeOfCard.text isEqualToString:@""]) {
        [CommonFunction fnAlert:@"Alert" message:@"Please select type of card."];
    }
    else if ([self.txtNameofCard.text isEqualToString:@""]) {
        [CommonFunction fnAlert:@"Alert" message:@"Please fill your name on card."];
    }
    else if ([self.txtCardNumber.text isEqualToString:@""] )
    {
        [CommonFunction fnAlert:@"Alert" message:@"Please fill your card number."];
    }
    else if ([self.txtExpiration.text isEqualToString:@"Select"]||[self.txtExpiration.text isEqualToString:@"Month"] ) {
        [CommonFunction fnAlert:@"Alert" message:@"Please select the month"];
    }
       else if ([self.txtYear.text isEqualToString:@""] ||[self.txtYear.text isEqualToString:@"Year"]) {
        [CommonFunction fnAlert:@"Alert" message:@"Please select the year"];
    }
       else if ([self.txtCVV2.text isEqualToString:@""] ) {
           [CommonFunction fnAlert:@"Alert" message:@"Please fill your CVV2#."];
       }

    else if([CommonFunction validateStringCardNumber:[self.txtCardNumber.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]==NO){
        [CommonFunction fnAlert:@"Alert" message:[NSString stringWithFormat:@"Card Number you entered isn't valid"]];
    }
    else if ([self.txtAddressField.text isEqualToString:@""]) {
        [CommonFunction fnAlert:@"Alert" message:@"Please enter your address."];
    }
    else if ([self.txtZipCodeField.text isEqualToString:@""] )
    {
        [CommonFunction fnAlert:@"Alert" message:@"Please enter your zipcode."];
    }
    else if (![self isZipCodeValid:self.txtZipCodeField.text]) {
        [CommonFunction fnAlert:@"Alert" message:@"Please enter valid ZipCode."];
    }
    else if([_btnCheckBox.imageView.image isEqual:[UIImage imageNamed:@"Settings_CheckBox1_1.png"]])   {
        [CommonFunction fnAlert:@"Alert" message:@"Please agree to the Terms & Conditions first."];
        //return;
    }
    else {

        [self postCreditCardData];
        //Method to call  service
    }
}

- (IBAction)btnBackAction:(id)sender {
    if(isExtraDonation==TRUE)
    {
        [kAppDelegate.objSideBarVC btnOffersClicked:nil];

    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];

    }
}

- (IBAction)btnAgreeClicked:(id)sender {
  
}

- (IBAction)btnCheckBoxClicked:(id)sender {
    if ([_btnCheckBox.imageView.image isEqual:[UIImage imageNamed:@"Settings_CheckBox1_1.png"]]) {
        [_btnCheckBox setImage:[UIImage imageNamed:@"Settings_CheckBox2_2.png"] forState:UIControlStateNormal];
    }else{
        [_btnCheckBox setImage:[UIImage imageNamed:@"Settings_CheckBox1_1.png"] forState:UIControlStateNormal];
    }
}

//Jasmeet changes

/**
 Check whether the Zip code entered is valid or not
  */
-(BOOL)isZipCodeValid:(NSString *)str
{
    BOOL val;
    NSString *cityPath = [[NSBundle mainBundle] pathForResource:@"cities" ofType:@"plist"];
    NSString *statePath = [[NSBundle mainBundle] pathForResource:@"states1" ofType:@"plist"];
    NSMutableArray *arrCity = [[NSMutableArray alloc] initWithContentsOfFile:cityPath];
    NSMutableArray *arrState = [[NSMutableArray alloc] initWithContentsOfFile:statePath];
    NSString *city = nil;
    NSString *state = nil;
    NSString *stateId = nil;
    NSString *cityId = nil;
    for (int cityCounter = 0; cityCounter < [arrCity count]; cityCounter++) {
        if ([[[arrCity objectAtIndex:cityCounter] valueForKey:@"ZipCode"] isEqualToString:str]) {
            city =[[arrCity objectAtIndex:cityCounter] valueForKey:@"City_Alias"];
            stateId = [[arrCity objectAtIndex:cityCounter] valueForKey:@"StateID"];
            cityId = [[arrCity objectAtIndex:cityCounter] valueForKey:@"CityID"];
            break;
        }
    }
    
    for (int stateCounter = 0; stateCounter < [arrState count]; stateCounter++) {
        if ([[[arrState objectAtIndex:stateCounter] valueForKey:@"StateID"] isEqualToString:stateId]) {
            state =[[arrState objectAtIndex:stateCounter] valueForKey:@"Name"];
            break;
        }
    }
    
    if (city.length==0) {
        val = NO;
    }
    else {
        [CommonFunction setValueInUserDefault:@"SelectedState" value:state];
        [CommonFunction setValueInUserDefault:@"SelectedCity" value:city];
        [CommonFunction setValueInUserDefault:@"SelectedStateID" value:stateId];
        [CommonFunction setValueInUserDefault:@"SelectedCityID" value:cityId];
        val = YES;
    }
    return val;
}

/**
 Method to post credit card information
 */

-(void)postCreditCardData
{
    if ([self checkValidMonthOrYear]==NO) {
        [CommonFunction fnAlert:@"Alert!" message:@"Please choose the correct month of expiration date."];
        return;
    }
    [self setCardType];
    if ([[dictDonationOrNormalInfo valueForKey:@"paymentType" ] isEqualToString:KDonationThroughCreditCard]) {
        [kAppDelegate showProgressHUD:self.view];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        /*commented in order to implement not to log out unpaid user*/
        //[dict setValue:[CommonFunction getValueFromUserDefault:kUserId] forKey:@"userId"];
        [dict setValue:[[kAppDelegate dictUserInfo]valueForKey:@"userId"] forKey:@"userId"];
        [dict setValue:@"" forKey:@"firstName"];
        [dict setValue:@"" forKey:@"lastName"];
        [dict setValue:[self encryptstring:self.txtCardNumber.text] forKey:@"cardNumber"];
        [dict setValue:[self encryptstring:strCardType] forKey:@"cardType"];
        [dict setValue:self.txtExpiration.text forKey:@"expMonth"];
        [dict setValue:self.txtYear.text forKey:@"expYear"];
        [dict setValue:@"" forKey:@"paymentToken"];
        [dict setValue:self.txtAddressField.text forKey:@"billing_address"];
        [dict setValue:self.txtZipCodeField.text forKey:@"billing_zip"];
        [dict setValue:[dictDonationOrNormalInfo valueForKey:@"amount"] forKey:@"amount"];
        [dict setValue:[dictDonationOrNormalInfo valueForKey:@"paymentFor"] forKey:@"paymentFor"];
        [dict setValue:[dictDonationOrNormalInfo valueForKey:@"storageToken"] forKey:@"storageToken"];
        if(isExtraDonation==TRUE)
        {
            [dict setValue:@"1" forKey:@"forGratitude"];
            [dict setValue:[dictDonationOrNormalInfo valueForKey:@"donation"] forKey:@"donation"];
            

        }
        else
        {
            [dict setValue:@"" forKey:@"forGratitude"];

        }
        NSLog(@"%@",dict);
        [[SharedManager sharedManager]postCreditCardData:dict
                                                    completeBlock:^(NSData *data) {
        if ([[dictDonationOrNormalInfo valueForKey:@"paymentFor"]isEqualToString:@"DONATION"]) {
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:[dictDonationOrNormalInfo valueForKey:@"AlertMsg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            alertView.tag=kPaymentDoneAlertTag;
            [alertView show];
        }else{
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:[dictDonationOrNormalInfo valueForKey:@"AlertMsg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            alertView.tag=kAlertMsgTag;
            [alertView show];
        }
       
        } errorBlock:^(NSError *error) {
        }];
    }
    else{
    [kAppDelegate showProgressHUD:self.view];
        strIsAnonymouDonation = [CommonFunction getValueFromUserDefault:@"anonymous_donation"];
        [CommonFunction deleteValueForKeyFromUserDefault:@"anonymous_donation"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    /*commented in order to implement not to log out unpaid user*/
    //[dict setValue:[CommonFunction getValueFromUserDefault:kUserId] forKey:@"userId"];
    [dict setValue:[[kAppDelegate dictUserInfo]valueForKey:@"userId"] forKey:@"userId"];
    [dict setValue:[CommonFunction getValueFromUserDefault:kTotalPaymentUpdated] forKey:@"amount"];
        /* Added by Utkarsha to Show donation type*/
    [dict setValue:[CommonFunction getValueFromUserDefault:kDonationType] forKey:@"donationType"];
        /****/
    [dict setValue:[CommonFunction getValueFromUserDefault:kDonation] forKey:@"donation"];
    [dict setValue:[self encryptstring:self.txtNameofCard.text] forKey:@"cardName"];
    [dict setValue:[self encryptstring:self.txtCardNumber.text] forKey:@"cardNumber"];
    [dict setValue:[self encryptstring:strCardType] forKey:@"cardType"];
    [dict setValue:[self encryptstring:self.txtCVV2.text] forKey:@"cvv"];
    [dict setValue:self.txtExpiration.text forKey:@"expMonth"];
    [dict setValue:self.txtYear.text forKey:@"expYear"];
    [dict setValue:@"1" forKey:@"dontSendPush"];
    [dict setValue:self.txtAddressField.text forKey:@"billing_address"];
    [dict setValue:self.txtZipCodeField.text forKey:@"billing_zip"];
    [dict setValue:strIsAnonymouDonation forKey:@"anonymous_donation"];
        NSLog(@"%@",dict);
    [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dict method:kCreditCardService] completeBlock:^(NSData *data) {  
        id result = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions error:nil];
        if (dictInfo)
        {
            dictInfo=nil;
        }
        dictInfo=[[NSMutableDictionary alloc]init];
        dictInfo=result;
        if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]])
        {
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Your payment is completed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            /*Added by Utkarsha so as to show the payment has been completed*/
            [[kAppDelegate dictUserInfo]setValue:@"active" forKey:@"userPayments"];
            alertView.tag=kPaymentProgressAlertTag;
            [alertView show];
        }
        else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]){
              [CommonFunction fnAlert:@"Error while processing the payment!" message:[result valueForKey:@"error"]];
        }
        else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]){
            //[CommonFunction fnAlert:@"Alert!" message:@"Please enter correct information of your credit card."];
            [CommonFunction fnAlert:@"Alert!" message:@"Already paid."];
        }
        else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:2]]){
            [CommonFunction fnAlert:@"Alert!" message:@"Server error"];
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
            if (error.code == NSURLErrorTimedOut) {
                [CommonFunction fnAlert:@"Alert!" message:kAlerTimedOut];
            }
            else{
        [CommonFunction fnAlert:@"Error" message:[error localizedDescription]];
            }
        }
        [kAppDelegate hideProgressHUD];
    }];
    }
}
-(NSString *)encryptstring:(NSString *)textToConvert{
    NSString *password = @"29xdVi33L5W32SL2";
        
    NSData *data = [textToConvert dataUsingEncoding: NSASCIIStringEncoding];
    NSData *encryptedData = [data AESEncryptWithPassphrase:password];
    
    // 2) Encode Base 64
    // If you need to send over internet, encode NSData -&gt; Base64 encoded string
    [Base64 initialize];
    NSString *b64EncStr = [Base64 encode:encryptedData];
    return b64EncStr;
}


#pragma mark- Initial Settings
-(void)setInitialVaribles
{
     self.lblCopyRight.text = [CommonFunction getCopyRightText];
    isCardLength = NO;
    isCardNumeric = NO;
    //Added by Utkarsha to fix (*) color issue on 30 Jul
    for (UIView *view in self.scrlView.subviews) {
		if ([view isKindOfClass:[UILabel class]]) {
			UILabel *label = (UILabel *)view;
			if (label.tag != 123) {
				label.font = [UIFont fontWithName:kFont size:kAppDelegate.fontSizeSmall];
				[label highlightTextInLabel:@"*"];
			}
		}
	}
    self.lblTop.font=[UIFont fontWithName:kFont size:self.lblTop.font.pointSize];
    self.btnSubmit.titleLabel.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSizeSmall];
    self.btnCancelRegistration.titleLabel.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSizeSmall];

    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:@"I agree to the iBuddyClub Terms of Service and Privacy Policy"];
    self.lblTerms.attributedText = attrStr;

    [attrStr setTextColor:[UIColor blackColor]];
    // Change the color for three links
    [attrStr setTextColor:[UIColor blueColor] range:NSMakeRange(26,16)];
    [attrStr setTextColor:[UIColor blueColor] range:NSMakeRange(47,14)];
    // Add a link to a given portion of the string
    [self.lblTerms addCustomLink:[NSURL URLWithString:@"Terms of Service"] inRange:NSMakeRange(26,16)];
    [self.lblTerms addCustomLink:[NSURL URLWithString:@"Privacy Policy"] inRange:NSMakeRange(47,14)];
    [self.lblTerms setLinkColor:[UIColor blueColor]];
    self.lblTerms.font=[UIFont fontWithName:kFont size:self.lblTerms.font.pointSize];
    
    //Jasmeet changes
}
/**
 Method to get years list
 */
-(NSMutableArray *)getYearsArray
{
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDate *today = [NSDate date];
    
    NSDateComponents *components = [currentCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:today];
    NSInteger year = [components year];
    
    NSMutableArray  *arrYears=[[NSMutableArray alloc]init];
    [arrYears addObject:@"Year"];
    
    [arrYears addObject:[NSString stringWithFormat:@"%d",year]];
    for (int i=0; i<19; i++) {
        year=year+1;
        [arrYears addObject:[NSString stringWithFormat:@"%d",year]];
    }
    return arrYears;
}
-(BOOL)checkValidMonthOrYear
{
    BOOL value=YES;
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDate *today = [NSDate date];
    
    NSDateComponents *components = [currentCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:today];
    NSInteger year = [components year];
    NSInteger month=[components month];
    
    if ([self.txtYear.text isEqualToString:[NSString stringWithFormat:@"%d",year]]) {
        if ([self.txtExpiration.text intValue]<month) {
            value =NO;
        }
     }
    return value;
}


/*
 Method to set card type
 */
-(void)setCardType
{
    if ([self.txtTypeOfCard.text isEqualToString:@"Visa"]) {
        strCardType=@"Visa";
    }
    else if([self.txtTypeOfCard.text isEqualToString:@"American Express"])
    {
        strCardType=@"AmEx";
    }
    else if([self.txtTypeOfCard.text isEqualToString:@"Master Card"] )
    {
        strCardType=@"Mastercard";
    }
}
#pragma mark - UITextView delegates

//-(void)customTextViewDidBeginEditing:(UITextView *)textView
//{
//    if ([textView.text isEqualToString:@"i.e. 123 Main St."]) {
//        textView.text = @"";
//        textView.textColor = [UIColor blackColor]; //optional
//    }
//    [textView becomeFirstResponder];
//}
//
//- (void)customTextViewDidEndEditing:(UITextView *)textView
//{
//    if ([textView.text isEqualToString:@""]) {
//        textView.text = @"i.e. 123 Main St.";
//        textView.textColor = [UIColor lightGrayColor]; //optional
//    }
//    [textView resignFirstResponder];
//}

#pragma mark - Alert View delegates
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==kPaymentDoneAlertTag) {
        [self btnBackAction:nil];
    }
    else if (alertView.tag==kPaymentProgressAlertTag)
    {
        /**** Commented and added by Utkarsha to enable complete registration*****/
//        IBDashboardVC *objIBDashboardVC;
//        if (kDevice==kIphone) {
//            objIBDashboardVC=[[IBDashboardVC alloc]initWithNibName:@"IBDashboardVC" bundle:nil];
//        }
//        else{
//            objIBDashboardVC=[[IBDashboardVC alloc]initWithNibName:@"IBDashboardVC_iPad" bundle:nil];
//        }
//        [self.navigationController pushViewController:objIBDashboardVC animated:YES];
//        kAppDelegate.objSideBarVC.lastbtnClicked=kAppDelegate.objSideBarVC.btnProfile;
        
        IBRegisterVC *objIBRegisterVC;
        if (kDevice==kIphone) {
            objIBRegisterVC=[[IBRegisterVC alloc]initWithNibName:@"IBRegisterVC" bundle:nil];
        }
        else{
            objIBRegisterVC=[[IBRegisterVC alloc]initWithNibName:@"IBRegisterVC_iPad" bundle:nil];
        }
        objIBRegisterVC.strEditProfile=@"Edit";
        objIBRegisterVC.strDetailRegistration=@"DetailRegistration";
        if ([[CommonFunction getValueFromUserDefault:@"isGiftVC"] isEqualToString:@"1"])
        {
             objIBRegisterVC.strController = @"Gift";
            [CommonFunction deleteValueForKeyFromUserDefault:@"isGiftVC"];
        }
        else
        {
        objIBRegisterVC.strController = @"My Profile";
        }
        objIBRegisterVC.dictProfileData=[dictInfo valueForKey:@"userDetail"];
        [CommonFunction setValueInUserDefault:@"userName" value:[[dictInfo valueForKey:@"userDetail"] valueForKey:@"name"]];
        NSLog(@"get value %@",[CommonFunction getValueFromUserDefault:@"address"]);
        [CommonFunction setValueInUserDefault:@"address" value:self.txtAddressField.text];
        NSLog(@"get value %@",[CommonFunction getValueFromUserDefault:@"address"]);

        [CommonFunction setValueInUserDefault:@"zipCode" value:self.txtZipCodeField.text];
         //kAppDelegate.dictUserInfo = [NSMutableDictionary dictionaryWithDictionary:dictInfo];
        NSLog(@"%@",kAppDelegate.dictUserInfo);
        //objIBRegisterVC.dictProfileData=[dictInfo valueForKey:@"userDetail"];
        // [kAppDelegate.navController presentModalViewController:objIBRegisterVC animated:YES];
        
        [kAppDelegate.navController pushViewController:objIBRegisterVC animated:NO];
        /******/
    }
    else if (alertView.tag==kAlertMsgTag){
    NSMutableArray *arrViewControllers=[[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    if ([arrViewControllers count]>0) {
        [self.navigationController popToViewController:[arrViewControllers objectAtIndex:0] animated:YES];
    }
    }
}
#pragma mark - CUSTOM TEXTFIELD DELEGATES
-(BOOL)customTextFieldShouldBeginEditing:(UITextField *)textField
{
    [CommonFunction callHideViewFromSideBar];
    if (textField==_txtTypeOfCard) {
        if(kDevice!=kIphone){
            [self dismissKeypad];
            CustomPickerViewController *customPicker = [CustomPickerViewController sharedManager];
            if (popView)
            {
                popView = nil;
            }
            popView = [[UIPopoverController alloc] initWithContentViewController:customPicker] ;
            [popView setDelegate:self];
            popView.popoverContentSize = CGSizeMake(customPicker.picker.frame.size.width, customPicker.picker.frame.size.height+customPicker.toolBar.frame.size.height) ;
            [popView presentPopoverFromRect:CGRectMake(textField.frame.origin.x,textField.frame.origin.y+textField.frame.size.height-10,10,10)
                                     inView:self.scrlView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
            customPicker.arrPicker = arrTypeOfCards;
            
            [customPicker showPickerOnCompletion:^(NSString *text, int row) {
                textField.text = text;
            } OnHiding:^(int direction) {
                [popView dismissPopoverAnimated:YES];
                if (direction==DirectionNext) {
                    
                    [_txtNameofCard becomeFirstResponder];
                }
               
                if (direction==DirectionDone) {
                    [self removeScrollAnimation:_txtTypeOfCard.frame];
                }
            } selectedText:textField.text showSegment:YES multiSelection:NO fontSize:18];
            return NO;
        }
        
    }
    
    if (textField==_txtExpiration) {
        
        if(kDevice!=kIphone){
            [self dismissKeypad];
            
            CustomPickerViewController *customPicker = [CustomPickerViewController sharedManager];
            
            if (popView)
            {
                popView = nil;
            }
            popView = [[UIPopoverController alloc] initWithContentViewController:customPicker] ;
            [popView setDelegate:self];
            popView.popoverContentSize =  popView.popoverContentSize = CGSizeMake(customPicker.picker.frame.size.width, customPicker.picker.frame.size.height+customPicker.toolBar.frame.size.height) ;
            [popView presentPopoverFromRect:CGRectMake(textField.frame.origin.x+textField.frame.size.width-20,textField.frame.origin.y+textField.frame.size.height-10,10,10)
                                     inView:self.scrlView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
            customPicker.arrPicker = [[NSMutableArray alloc]initWithObjects:@"Month",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",nil];
            [customPicker showPickerOnCompletion:^(NSString *text, int row) {
                textField.text = text;
            } OnHiding:^(int direction) {
                [popView dismissPopoverAnimated:YES];
                if (direction==DirectionNext) {
                    [_txtYear becomeFirstResponder];
                }
                if (direction==DirectionPrevious) {
                    [_txtCardNumber becomeFirstResponder];
                }
                if (direction==DirectionDone) {
                    [self removeScrollAnimation:_txtExpiration.frame];
                }
                
            } selectedText:textField.text showSegment:YES multiSelection:NO fontSize:18];
            return NO;
        }
    }
    
   if (textField==_txtYear) {
    
    if(kDevice!=kIphone) {
        [self dismissKeypad];
        
        CustomPickerViewController *customPicker = [CustomPickerViewController sharedManager];
        if (popView)
        {
            popView = nil;
        }
        popView = [[UIPopoverController alloc] initWithContentViewController:customPicker] ;
        [popView setDelegate:self];
        popView.popoverContentSize =  popView.popoverContentSize = CGSizeMake(customPicker.picker.frame.size.width, customPicker.picker.frame.size.height+customPicker.toolBar.frame.size.height) ;
        [popView presentPopoverFromRect:CGRectMake(textField.frame.origin.x+textField.frame.size.width-20,textField.frame.origin.y+textField.frame.size.height-10,10,10)
                                 inView:self.scrlView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        customPicker.arrPicker = [self getYearsArray];
        
        [customPicker showPickerOnCompletion:^(NSString *text, int row) {
            textField.text = text;
        } OnHiding:^(int direction) {
            [popView dismissPopoverAnimated:YES];
            if (direction==DirectionNext) {
                [_txtCVV2 becomeFirstResponder];
            }
            if (direction==DirectionPrevious) {
                [_txtExpiration becomeFirstResponder];
            }
            if (direction==DirectionDone) {
                [self removeScrollAnimation:_txtYear.frame];
            }
            
        } selectedText:textField.text showSegment:YES multiSelection:NO fontSize:18];
        return NO;
    }
   }
    return YES;
}
-(BOOL)customTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)textEntered
{
   /*******Added by Utkarsha Gupta to limit char in card name*/
//    if (textField == self.txtCardNumber ) {
//        if([textEntered length]){
//            if ([textField.text length]>15)
//            {
//                if (!isCardLength)
//                {
//                [CommonFunction fnAlert:@"" message:@"Card Number can't be greater than 16 Characters."];
//                    isCardLength = YES;
//                }
//
//                return NO;
//            }
//            else{
//                return YES;
//            }
//        }
//    }
   /********/
    if (textField == self.txtCardNumber||textField== self.txtCVV2)
    {
        NSCharacterSet *NUMBERS	= [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        for (int i = 0; i < [textEntered length]; i++)
        {
            unichar d = [textEntered characterAtIndex:i];
            if (![NUMBERS characterIsMember:d])
            {
                if (!isCardNumeric)
                {
                [CommonFunction fnAlert:@"Please enter numbers only." message:@""];
                    isCardNumeric =YES;
                }
                return NO;
            }
        }
        if([textEntered length]){
            if ([textField.text length]>15)
            {
                if (!isCardLength)
                {
                    [CommonFunction fnAlert:@"" message:@"Card Number can't be greater than 16 Characters."];
                    isCardLength = YES;
                }
                
                return NO;
            }
        }
    }
    if (textField==self.txtCVV2) {
        if([textEntered length]){
            //Changes suggested by client 3/3/14
           // if ([self.txtCVV2.text length]>2) {

            if ([self.txtCVV2.text length]>3) {
                return NO;
            }
            else{
                return YES;
            }
        }
    }
    if (textField == self.txtAddressField) {
        if (self.txtAddressField.text.length) {
            if ([textField.text length]>29) {
                [CommonFunction fnAlert:@"" message:@"Address can't be greater than 30 Characters."];
                return NO;
            }
            else {
                return YES;
            }
        }
    }

    return YES;
    
}
#pragma mark Attributed Label delegate
-(BOOL)attributedLabel:(OHAttributedLabel*)attributedLabel shouldFollowLink:(NSTextCheckingResult*)linkInfo
{
   
    if(linkInfo.range.location==26){
        IBTermsVC *objTerms;
        if (kDevice==kIphone) {
            objTerms=[[IBTermsVC alloc]initWithNibName:@"IBTermsVC" bundle:nil];
        }
        else{
            objTerms =[[IBTermsVC alloc]initWithNibName:@"IBTermsVC_iPad" bundle:nil];
        }
        objTerms.strTermsOrPrivacy=kTerms;
        [self.navigationController pushViewController:objTerms animated:YES];
    }
    else if(linkInfo.range.location==47){
        IBTermsVC *objTerms;
        if (kDevice==kIphone) {
            objTerms=[[IBTermsVC alloc]initWithNibName:@"IBTermsVC" bundle:nil];
        }
        else{
            objTerms =[[IBTermsVC alloc]initWithNibName:@"IBTermsVC_iPad" bundle:nil];
        }
        objTerms.strTermsOrPrivacy=kPrivacy;

        [self.navigationController pushViewController:objTerms animated:YES];
    }
    return YES;
}
@end
