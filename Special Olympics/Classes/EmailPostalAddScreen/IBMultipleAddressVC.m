//
//  IBMultipleAddressVC.m
//  iBuddyClient
//
//  Created by Anubha on 03/12/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import "IBMultipleAddressVC.h"
#import "IBAddressVC.h"
#define kPlusFactor 5
#define  kCellWidthiPhone 145
#define kCellWidthiPad 445
#define kGiftSuccessAlertTag 8989
#define kGiftPaymentSuccessAlertTag 3434

@interface IBMultipleAddressVC ()
@property (weak, nonatomic) IBOutlet UITableView *tblRecords;
@property (weak, nonatomic) IBOutlet UILabel *lblCopyRight;
@end

@implementation IBMultipleAddressVC
@synthesize tblCustomCellAddress;
@synthesize strGiftType,lblCopyRight;
#pragma mark -
#pragma mark LifeCycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Added by Utkarsha so as to make iAds compatible to iOS 7 Layout
    [self setLayoutForiOS7];

    [self setInitialVariables];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [_tblRecords reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Set Initial Variables

-(void)setInitialVariables{
     self.lblCopyRight.text = [CommonFunction getCopyRightText];
     arrRecords=[[NSMutableArray alloc]init];
       for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *textField = (UILabel *)view;
            textField.font=[UIFont fontWithName:kFont size:textField.font.pointSize];
        }

       }
  /*  [self getAllFundraisers];*/
}
#pragma mark - Get Webservice Data

-(void)postRecords
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:arrRecords forKey:@"data"];
    [dict setValue:[[kAppDelegate dictUserInfo]valueForKey:@"userId"] forKey:@"userId"];
    [dict setValue:strGiftType forKey:@"giftType"];
    
    [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:(NSMutableDictionary *) dict method:kStoreGifteeInfo] completeBlock:^(NSData *data) {
        id result = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions error:nil];
        if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
            UIAlertView *alert;
            if ([strGiftType isEqualToString:@"Email"]) {
                 alert=[[UIAlertView alloc]initWithTitle:@"Success!" message:@"Your gift entry has been received.  An ambassador code will be emailed to all recipients after the payment has been processed.  Do you want to continue?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
            }
            else{
                 alert=[[UIAlertView alloc]initWithTitle:@"Success!" message:@"Your gift entry has been received.  A postal mail letter with an ambassador code will be sent to all recipients after the payment has been processed.  Do you want to continue?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
            }
            alert.tag=kGiftSuccessAlertTag;
            [alert show];
            dictResult=result;
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
-(void)getSubScriptionAmountForGiftee{
    [kAppDelegate showProgressHUD:self.view];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    /*commented in order to implement not to log out unpaid user*/
    [dict setValue:[[kAppDelegate dictUserInfo]valueForKey:@"userId"] forKey:@"userId"];
    [dict setValue:[NSNumber numberWithInt:[arrRecords count]] forKey:@"numberOfGiftee"];
    [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dict method:kGetGiftAmount] completeBlock:^(NSData *data) {
        id result = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions error:nil];
        if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
            strTotalAmount=[result valueForKey:@"totalAmount"];
            [self postRecords];
        }
        else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]){
            [CommonFunction fnAlert:@"Server Error!" message:@"Unable to get payment from server."];
        }
        else {
            [CommonFunction fnAlert:@"Server Error!" message:@"Unable to get payment from server."];
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
#pragma mark - Button Actions

- (IBAction)btnAddClicked:(id)sender {
    if ([arrRecords count]<10) {
        IBAddressVC *objIBAddressVC;
        if (kDevice==kIphone) {
            objIBAddressVC=[[IBAddressVC alloc]initWithNibName:@"IBAddressVC" bundle:nil];
        }
        else{
            objIBAddressVC=[[IBAddressVC alloc]initWithNibName:@"IBAddressVc_iPad" bundle:nil];
        }
        objIBAddressVC.arrRecords =arrRecords;
        objIBAddressVC.pageModeType=addMode;
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        [dict setObject:strGiftType forKey:@"strgiftType"];
        objIBAddressVC.dictAddressIndexInfo = dict;
        [self.navigationController pushViewController:objIBAddressVC animated:YES];
    }
    else{
        [CommonFunction fnAlert:@"Alert" message:@"Not more than 10 addresses are allowed."];
    }
}

- (IBAction)btnSubmitClicked:(id)sender {
    if ([arrRecords count]==0) {
        if ([strGiftType isEqualToString:@"Address"]) {
            [CommonFunction fnAlert:@"Alert" message:@"At least fill one address to post."];
        }
        else{
            [CommonFunction fnAlert:@"Alert" message:@"At least fill one email to post."];
        }
    }
    else{
        [self getSubScriptionAmountForGiftee];
    }
}
-(void)btn_EditClicked:(id)sender
{
    IBAddressVC *objIBAddressVC;
    if (kDevice==kIphone) {
        objIBAddressVC=[[IBAddressVC alloc]initWithNibName:@"IBAddressVC" bundle:nil];
    }
    else{
        objIBAddressVC=[[IBAddressVC alloc]initWithNibName:@"IBAddressVc_iPad" bundle:nil];
    }
    objIBAddressVC.arrRecords =arrRecords;
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:[NSNumber numberWithInt:[sender tag]] forKey:@"selectedArrayIndex"];
    [dict setObject:strGiftType forKey:@"strgiftType"];
   // [dict setObject:arrFundraisers forKey:@"fundraisersList"];
    objIBAddressVC.dictAddressIndexInfo = dict;
    objIBAddressVC.pageModeType=editMode;
    [self.navigationController pushViewController:objIBAddressVC animated:YES];
}

- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark-
#pragma mark - delegate Methods

#pragma mark -
#pragma mark - UITableView Deletgate & Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [arrRecords count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"IBAddress";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (kDevice==kIphone) {
        if (cell == nil){
            [[NSBundle mainBundle] loadNibNamed:@"IBAddressCustomCell_iPhone" owner:self options:nil];
            cell=tblCustomCellAddress;
        }
    }
    else{
        if (cell == nil){
            [[NSBundle mainBundle] loadNibNamed:@"IBAddressCustomCell_iPad" owner:self options:nil];
            cell=tblCustomCellAddress;
        }
    }
     cell.backgroundColor=nil;
     UILabel *lblGifterName=(UILabel *)[cell viewWithTag:1001];
     UILabel *lblGifteeName=(UILabel *)[cell viewWithTag:1002];
     UILabel *lblNPOName=(UILabel *)[cell viewWithTag:1003];
    
    UILabel *txtGifterName=(UILabel *)[cell viewWithTag:101];
    txtGifterName.text=[[arrRecords objectAtIndex:indexPath.row]valueForKey:@"Gifter Name"];

    UILabel *txtGifteeName=(UILabel *)[cell viewWithTag:102];
    txtGifteeName.text=[[arrRecords objectAtIndex:indexPath.row]valueForKey:@"Giftee Name"];
    
    UILabel *txtNPOName=(UILabel *)[cell viewWithTag:103];
    txtNPOName.text=[[arrRecords objectAtIndex:indexPath.row]valueForKey:@"NPO Name"];
    
    UILabel *txtEmail=(UILabel *)[cell viewWithTag:104];
    UILabel *lblEmail=(UILabel *)[cell viewWithTag:1004];
    if ([strGiftType isEqualToString:@"Address"]) {
        lblEmail.text=@"Giftee's Address";
        txtEmail.text=[[arrRecords objectAtIndex:indexPath.row]valueForKey:@"Address"];

    }
    else{
        lblEmail.text=@"Giftee's Email";
        txtEmail.text=[[arrRecords objectAtIndex:indexPath.row]valueForKey:@"Email"];

    }
    NSArray *arrLabels=[[NSMutableArray alloc]initWithObjects:lblGifterName,txtGifterName,lblGifteeName,txtGifteeName,lblNPOName,txtNPOName,lblEmail,txtEmail, nil];
    
    NSArray *arrLabelValues=[[NSMutableArray alloc]initWithObjects:@"Gifter Name",[[arrRecords objectAtIndex:indexPath.row]valueForKey:@"Gifter Name"],@"Giftee Name",[[arrRecords objectAtIndex:indexPath.row]valueForKey:@"Giftee Name"],@"Fundraiser Name",[[arrRecords objectAtIndex:indexPath.row]valueForKey:@"NPO Name"],lblEmail.text,txtEmail.text, nil];
    
    NSArray *kFonts=[[NSMutableArray alloc]initWithObjects:@"Helvetica Neue",kFont2,@"Helvetica Neue",kFont2,@"Helvetica Neue",kFont2,@"Helvetica Neue",kFont2, nil];
    
    NSArray *incrementParameter=[[NSMutableArray alloc]initWithObjects:@"X",@"X",@"Y",@"X",@"Y",@"X",@"Y",@"X", nil];
    
    [[SharedManager sharedManager] setFrames:arrLabels labelValues:arrLabelValues incrementType:incrementParameter kFonts:kFonts plusfactor:5 initialYValue:0];
    
    UIImageView *imgDivider=(UIImageView *)[cell viewWithTag:105];
    imgDivider.frame=CGRectMake(imgDivider.frame.origin.x, txtEmail.frame.origin.y+txtEmail.frame.size.height+8, imgDivider.frame.size.width, imgDivider.frame.size.height);
    if ([[cell.contentView.subviews lastObject]isKindOfClass:[UIButton class]]) {
        UIButton *btn=(UIButton *)[cell.contentView.subviews lastObject];
        if (kDevice==kIphone) {
            [btn setBackgroundImage:[UIImage imageNamed:@"icon_edit@2x.png"] forState:UIControlStateNormal];
        }
        else{
            [btn setBackgroundImage:[UIImage imageNamed:@"icon_edit~ipad.png"] forState:UIControlStateNormal];
        }
        btn.tag= indexPath.row;
    }
    else{
        UIButton  *btn_Edit=[UIButton buttonWithType:UIButtonTypeCustom];
        btn_Edit.tag= indexPath.row;
        if (kDevice==kIphone) {
            btn_Edit.frame=CGRectMake(260,28,40,40);
            [btn_Edit setBackgroundImage:[UIImage imageNamed:@"icon_edit@2x.png"] forState:UIControlStateNormal];
        }
        else{
            btn_Edit.frame=CGRectMake(660,30 ,47,47);
            [btn_Edit setBackgroundImage:[UIImage imageNamed:@"icon_edit~ipad"] forState:UIControlStateNormal];
        }
        [btn_Edit addTarget:self action:@selector(btn_EditClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn_Edit];
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    IBAddressVC *objIBAddressVC;
    if (kDevice==kIphone) {
        objIBAddressVC=[[IBAddressVC alloc]initWithNibName:@"IBAddressVC" bundle:nil];
    }
    else{
        objIBAddressVC=[[IBAddressVC alloc]initWithNibName:@"IBAddressVc_iPad" bundle:nil];
    }
    objIBAddressVC.arrRecords =arrRecords;
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:[NSNumber numberWithInt:indexPath.row] forKey:@"selectedArrayIndex"];
    [dict setObject:strGiftType forKey:@"strgiftType"];
    objIBAddressVC.dictAddressIndexInfo = dict;
    objIBAddressVC.pageModeType=editMode;
    [self.navigationController pushViewController:objIBAddressVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height=0;
    NSString *strAddress;
    if ([strGiftType isEqualToString:@"Address"]) {
        strAddress=[[arrRecords objectAtIndex:indexPath.row]valueForKey:@"Address"];
    }
    else{
        strAddress=[[arrRecords objectAtIndex:indexPath.row]valueForKey:@"Email"];
    }
    
    if (kDevice==kIphone) {
         height=[CommonFunction heightOfLabel:[[arrRecords objectAtIndex:indexPath.row]valueForKey:@"Gifter Name"] andWidth:kCellWidthiPhone fontName:kFont2 fontSize:13]+[CommonFunction heightOfLabel:[[arrRecords objectAtIndex:indexPath.row]valueForKey:@"Giftee Name"] andWidth:kCellWidthiPhone fontName:kFont2 fontSize:13]+[CommonFunction heightOfLabel:[[arrRecords objectAtIndex:indexPath.row]valueForKey:@"NPO Name"] andWidth:kCellWidthiPhone fontName:kFont2 fontSize:13]+[CommonFunction heightOfLabel:strAddress andWidth:kCellWidthiPhone fontName:kFont2 fontSize:13]+(kPlusFactor*4)+10;
    }
    else{
         height=[CommonFunction heightOfLabel:[[arrRecords objectAtIndex:indexPath.row]valueForKey:@"Gifter Name"] andWidth:kCellWidthiPad fontName:kFont2 fontSize:15]+[CommonFunction heightOfLabel:[[arrRecords objectAtIndex:indexPath.row]valueForKey:@"Giftee Name"] andWidth:kCellWidthiPad fontName:kFont2 fontSize:15]+[CommonFunction heightOfLabel:[[arrRecords objectAtIndex:indexPath.row]valueForKey:@"NPO Name"] andWidth:kCellWidthiPad fontName:kFont2 fontSize:15]+[CommonFunction heightOfLabel:strAddress andWidth:kCellWidthiPad fontName:kFont2 fontSize:15]+(kPlusFactor*4)+10;
    }
    
       return height;
}
#pragma mark - Alert View Delegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView tag]==kGiftSuccessAlertTag && buttonIndex==0) {
        if ([[dictResult valueForKey:@"permanent_payment_token"]length]==0){
            IBCreditCardPaymentVC *objIBCreditCardPaymentVC;
            if (kDevice==kIphone) {
                objIBCreditCardPaymentVC=[[IBCreditCardPaymentVC alloc]initWithNibName:@"IBCreditCardPaymentVC" bundle:nil];
            }
            else{
                objIBCreditCardPaymentVC=[[IBCreditCardPaymentVC alloc]initWithNibName:@"IBCreditCardPayment_iPad" bundle:nil];
            }
            NSMutableDictionary *dictPayment=[[NSMutableDictionary alloc]init];
            NSString *strAmount= [strTotalAmount stringByReplacingOccurrencesOfString:@"$" withString:@""];

            [dictPayment setObject:strAmount forKey:@"amount"];
            
            [dictPayment setObject:kGiftUser forKey:@"paymentFor"];
            [dictPayment setObject:[dictResult valueForKey:@"gifteeStorageToken"] forKey:@"storageToken"];
            [dictPayment setObject:KDonationThroughCreditCard forKey:@"paymentType"];
            [dictPayment setObject:@"Your application has been successfully gifted to user." forKey:@"AlertMsg"];
            objIBCreditCardPaymentVC.dictDonationOrNormalInfo=dictPayment;
            [self.navigationController pushViewController:objIBCreditCardPaymentVC animated:YES];
        }
        else{
            [kAppDelegate showProgressHUD:self.view];
             NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:[[kAppDelegate dictUserInfo]valueForKey:@"userId"] forKey:@"userId"];
            [dict setValue:[dictResult valueForKey:@"permanent_payment_token"] forKey:@"paymentToken"];
            [dict setObject:[dictResult valueForKey:@"gifteeStorageToken"] forKey:@"storageToken"];
            [dict setObject:kGiftUser forKey:@"paymentFor"];
            NSString *strAmount= [strTotalAmount stringByReplacingOccurrencesOfString:@"$" withString:@""];

            [dict setObject:strAmount forKey:@"amount"];
            [dict setValue:@"" forKey:@"firstName"];
            [dict setValue:@"" forKey:@"lastName"];
            [dict setValue:@"" forKey:@"cardNumber"];
            [dict setValue:@"" forKey:@"cardType"];
            [dict setValue:@"" forKey:@"expMonth"];
            [dict setValue:@"" forKey:@"expYear"];
            [[SharedManager sharedManager]postCreditCardData:dict
             completeBlock:^(NSData *data) {
               UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Your application has been successfully gifted to user." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
               alertView.tag=kGiftPaymentSuccessAlertTag;
               [alertView show];
           } errorBlock:^(NSError *error) {
           }];
        }
    }
    if ([alertView tag]==kGiftPaymentSuccessAlertTag && buttonIndex==0){
        [self btnBackClicked:nil];
    }
}
@end
