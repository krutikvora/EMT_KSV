//
//  IBReferFriendVC.m
//  iBuddyClient
//
//  Created by Anubha on 17/12/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import "IBReferFriendVC.h"
#import <Accounts/AccountsDefines.h>
#import <Accounts/ACAccountType.h>
#import <Accounts/ACAccountStore.h>
#import <Accounts/Accounts.h>
#define kFundraiserListHeightiPhone 145
#define kFundraiserListHeightiPad 130
@interface IBReferFriendVC ()
{
    NSMutableArray *arrFundraisers;
    NSArray *fundraisersFilteredArray;
    BOOL bitGetFundraisers;
    NSString *strBtnType;
}


@property (strong, nonatomic) IBOutlet UIView *vwPopUp;
@property (weak, nonatomic) IBOutlet UITextField *txtNPOName;
@property (weak, nonatomic) IBOutlet UITextField *txtNPOCode;
@property (weak, nonatomic) IBOutlet UITableView *tblFundraiserList;
@property (weak, nonatomic) IBOutlet UILabel *lblStaticText;
@property (weak, nonatomic) IBOutlet UILabel *lblCopyRight;
@end

@implementation IBReferFriendVC
@synthesize arrayOfAccounts,lblCopyRight;

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
 self.lblCopyRight.text = [CommonFunction getCopyRightText];
    [self setInitialVariables];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setInitialVariables{
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            btn.titleLabel.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
        }
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)view;
            label.font=[UIFont fontWithName:kFont size:label.font.pointSize];
        }
    }
    _vwPopUp.frame=CGRectMake(_vwPopUp.frame.origin.x, _vwPopUp.frame.origin.y, _vwPopUp.frame.size.width, kAppDelegate.window.frame.size.height);
    _vwPopUp.alpha=0;
    [kAppDelegate.window addSubview:_vwPopUp];
}

#pragma mark - Private Methods

- (IBAction)showMenu:(id)sender {
    [kAppDelegate showMenu];
}

#pragma mark - Message Share
-(IBAction)btnMessageClicked:(id)sender{
    
    if(![MFMessageComposeViewController canSendText]) {
        IBReferEmailVC *objIBReferEmailVC;
        if (kDevice==kIphone) {
            objIBReferEmailVC=[[IBReferEmailVC alloc]initWithNibName:@"IBReferEmailVC" bundle:nil];
        }
        else{
            objIBReferEmailVC=[[IBReferEmailVC alloc]initWithNibName:@"IBReferEmailVC_iPad" bundle:nil];
        }
        objIBReferEmailVC.strReferType=kReferSMS;
        [self.navigationController pushViewController:objIBReferEmailVC animated:YES];
    }
    else{
         _lblStaticText.text=@"Please select any fundraiser to post text through SMS.";
        [self getAllFundraisers];
        strBtnType=@"SMS";
    }
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
        case MessageComposeResultSent:{
            break;
        }
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Email Share
-(IBAction)btnEmailClicked:(id)sender
{
    IBReferEmailVC *objIBReferEmailVC;
    if (kDevice==kIphone) {
        objIBReferEmailVC=[[IBReferEmailVC alloc]initWithNibName:@"IBReferEmailVC" bundle:nil];
    }
    else{
        objIBReferEmailVC=[[IBReferEmailVC alloc]initWithNibName:@"IBReferEmailVC_iPad" bundle:nil];
    }
    objIBReferEmailVC.strReferType=kReferEmail;
    [self.navigationController pushViewController:objIBReferEmailVC animated:YES];
}

- (IBAction)btnCancelClicked:(id)sender {
    [_txtNPOName resignFirstResponder];
    [[SharedManager sharedManager]removeAnimation:_vwPopUp];
}

- (IBAction)btnDoneClicked:(id)sender {
    [_txtNPOName resignFirstResponder];
     if ([self.txtNPOName.text isEqualToString:@""]||[self.txtNPOName.text length]==0)
     {
          //**** Changed by Utkarsha on 13 July 14 --NPO name to fundraiser name on client request***/
        [CommonFunction fnAlert:@"Alert" message:@"Please enter Fundraiser Name."];
    }
    else if ([self.txtNPOCode.text isEqualToString:@""]||[self.txtNPOCode.text length]==0) {
        [CommonFunction fnAlert:@"Alert" message:@"Please select correct Fundraiser Name."];
    }
    else{
    
    if ([strBtnType isEqualToString:@"SMS"]) {
        NSString *strMessage=[NSString stringWithFormat:@"Please support %@ and enjoy numerous discounts at local participating businesses!",_txtNPOName.text];
        strMessage=[strMessage stringByAppendingString:@"\n"];
        strMessage=[strMessage stringByAppendingString:[NSString stringWithFormat:@"Use fundraising code: %@ ",_txtNPOCode.text]];
        strMessage=[strMessage stringByAppendingString:@"\n"];
        strMessage=[strMessage stringByAppendingString:[NSString stringWithFormat:@"Link: %@ ",kAppLink]];
        NSString *message = strMessage;
        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
        messageController.messageComposeDelegate = self;
        [messageController setBody:message];
        [self presentViewController:messageController animated:YES completion:nil];
    }
    else{
        
            
            [self postStatusUpdateClick];
        }
        

    }
    [[SharedManager sharedManager]removeAnimation:_vwPopUp];
    
}
#pragma mark - Twitter Share
-(IBAction)btnTwitterClicked:(id)sender{
    
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            
            [self postToTwitter];

            
        }
        else
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Please go to device settings and add your twitter account information." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
    
//    ACAccountStore *account = [[ACAccountStore alloc] init];
//    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
//    [account requestAccessToAccountsWithType:accountType options:Nil completion:^(BOOL granted, NSError *error) {
//        if (granted == YES)
//        {
//            self.arrayOfAccounts = [account accountsWithAccountType:accountType];
//            if ([self.arrayOfAccounts count] > 0)
//            {
//                [self performSelectorOnMainThread:@selector(delayTwitterClickAfterAuthorize) withObject:nil waitUntilDone:YES];
//            }
//            else
//            {
//                [self performSelectorOnMainThread:@selector(delayTwitterClickAfterUnauthorize) withObject:nil waitUntilDone:YES];
//            }
//        }
//        else
//        {
//            if (error.code == 6)
//                [self performSelectorOnMainThread:@selector(delayTwitterClickAfterUnauthorize) withObject:nil waitUntilDone:YES];
//            else
//                [self performSelectorOnMainThread:@selector(delayTwitterClickDontAllow) withObject:nil waitUntilDone:YES];
//        }
//    }];
//    [account requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
//        if (granted == YES)
//        {
//            self.arrayOfAccounts = [account accountsWithAccountType:accountType];
//            if ([self.arrayOfAccounts count] > 0)
//            {
//                [self performSelectorOnMainThread:@selector(delayTwitterClickAfterAuthorize) withObject:nil waitUntilDone:YES];
//            }
//            else
//            {
//                [self performSelectorOnMainThread:@selector(delayTwitterClickAfterUnauthorize) withObject:nil waitUntilDone:YES];
//            }
//        }
//        else
//        {
//            if (error.code == 6)
//                [self performSelectorOnMainThread:@selector(delayTwitterClickAfterUnauthorize) withObject:nil waitUntilDone:YES];
//            else
//               [self performSelectorOnMainThread:@selector(delayTwitterClickDontAllow) withObject:nil waitUntilDone:YES];
//        }
//    }];
}

-(void)delayTwitterClickAfterAuthorize
{
    // [kAppDelegate hideProgressHUD];
    [self postToTwitter];
}
-(void)delayTwitterClickAfterUnauthorize
{
    [kAppDelegate hideProgressHUD];
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Twitter authorization" message:@"Please log into twitter in the settings, then try again!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}
-(void)delayTwitterClickDontAllow
{
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Access Denied." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [kAppDelegate  hideProgressHUD];
}
-(void)postToTwitter{
    
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
        
        [controller dismissViewControllerAnimated:YES completion:nil];
        
        switch(result){
            case SLComposeViewControllerResultCancelled:
            default:
            {
                NSLog(@"Cancelled.....");
                [self showInternalServerError];
                // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs://"]];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

            }
                break;
            case SLComposeViewControllerResultDone:
            {
                [self displayText:nil];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

            }
                break;
        }};
    [controller setCompletionHandler:completionHandler];
    [controller setInitialText:[NSString stringWithFormat:@"Congratulations! You are referred to participate in new progressive way of supporting #Fire Rescue Funding"]];
    [controller addURL:[NSURL URLWithString:kAppLink]];
    [controller addImage:[UIImage imageNamed:@"logo_share"]];
    
    [self presentViewController:controller animated:YES completion:Nil];

    
    
//    ACAccount *acct = [self.arrayOfAccounts objectAtIndex:0];
//    NSURL *urlPost = [NSURL URLWithString:@"https://api.twitter.com/1/statuses/update.json"];
//    NSDictionary *dictParams = [NSDictionary dictionaryWithObjectsAndKeys:
//                       [NSString stringWithFormat:@"Congratulations! You are referred to participate in new progressive way of supporting local causes with #iBuddyClub.com.Come and join us."], @"status",nil];
//    
//    TWRequest *postRequest = [[TWRequest alloc]
//                              initWithURL:   urlPost
//                              parameters:dictParams
//                              requestMethod: TWRequestMethodPOST
//                              ];
//    // Post the request
//    [postRequest setAccount:acct];
//    
//    // Block handler to manage the response
//    [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
//        NSString *output = [NSString stringWithFormat:@"HTTP response status: %i", [urlResponse statusCode]];
//        switch([urlResponse statusCode])
//        {
//            case 200:
//            {
//                [self performSelectorOnMainThread:@selector(displayText:) withObject:output waitUntilDone:NO];
//            }
//                break;
//            case 0:{
//                [self performSelectorOnMainThread:@selector(showInternetError) withObject:output waitUntilDone:NO];
//            }
//                break;
//            default:
//            {
//                [self performSelectorOnMainThread:@selector(showInternalServerError) withObject:output waitUntilDone:NO];
//            }
//                break;
//        }
//    }];
    
}
-(void)showInternetError
{
    [CommonFunction fnAlert:@"Alert!" message:@"Check your internet connection."];
    [kAppDelegate hideProgressHUD];
}
-(void)showInternalServerError
{
    [CommonFunction fnAlert:@"Error" message:@"Internal server error while posting the tweet."];
    [kAppDelegate hideProgressHUD];
    
}

-(void)displayText:(id)object
{
    [kAppDelegate hideProgressHUD];
    self.arrayOfAccounts = nil;
    [self dismissViewControllerAnimated:YES completion:nil];//:YES];
    [CommonFunction fnAlert:@"Alert!" message:@"Tweet has been posted successfully."];
}
#pragma mark - Facebook Share
-(IBAction)btnFacebookClicked:(id)sender{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        _lblStaticText.text=@"Please select any fundraiser to post text on the facebook.";
        [self getAllFundraisers];
        strBtnType=@"Facebook";

    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Please go to device settings and add your facebook account information." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    

}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    switch (state) {
        case FBSessionStateOpen: {
   
            [self postStatusUpdateClick];
            break;
        }
        case FBSessionStateClosed:
        {
            
        }
            break;
        case FBSessionStateClosedLoginFailed:
        {
            [FBSession.activeSession closeAndClearTokenInformation];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"OK", @"Facebook Connect")
                                                      otherButtonTitles:nil];
            [alertView show];
            //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            //[self openFacebookSession];
        }
            break;
        default:
            break;
    }
}
-(void)postStatusUpdateClick{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *strMessage=[NSString stringWithFormat:@"Please support %@ and enjoy numerous discounts at local participating businesses!",_txtNPOName.text];
    strMessage=[strMessage stringByAppendingString:@"\n"];
    strMessage=[strMessage stringByAppendingString:[NSString stringWithFormat:@"Use fundraising code: %@ ",_txtNPOCode.text]];
    
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
        
        [controller dismissViewControllerAnimated:YES completion:nil];
        
        switch(result){
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

            case SLComposeViewControllerResultCancelled:
            default:
            {
                NSLog(@"Cancelled.....");
                [self showAlert:@"testing Application" result:nil error:@"Error"];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

                // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs://"]];
                
            }
                break;
            case SLComposeViewControllerResultDone:
            {
                [self showAlert:@"testing Application" result:nil error:@"Success"];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

            }
                break;
        }};
    [controller setCompletionHandler:completionHandler];
    [controller setInitialText:strMessage];
    [controller addURL:[NSURL URLWithString:kAppLink]];
    [self presentViewController:controller animated:YES completion:Nil];


}
- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSString *)error {
    NSString *alertMsg = @"";;
    NSString *alertTitle;
    if ([error isEqualToString:@"Error"]) {
        alertTitle = @"Error";
        alertMsg = [NSString stringWithFormat:@"Your message could not be posted on facebook. Please try later."];
        
    } else {
        alertMsg = [NSString stringWithFormat:@"Your message has been posted successfully on facebook."];
        alertTitle = @"Success";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:alertMsg
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - Delegate Methods


#pragma mark -
#pragma mark - UITableView Deletgate & Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if([fundraisersFilteredArray count]==0){
        _tblFundraiserList.hidden=YES;
    }
    [self setFundraiserTableHeight:[fundraisersFilteredArray count] tableView:_tblFundraiserList];
    return fundraisersFilteredArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CityList";
    
    //  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    if (fundraisersFilteredArray.count>0) {
        UILabel *lblFundraiserName=[[UILabel alloc]init];
        lblFundraiserName.frame=CGRectMake(2, 3, tableView.frame.size.width, 30);
        lblFundraiserName.tag=101;
        lblFundraiserName.text=[NSString stringWithFormat:@"%@",[[fundraisersFilteredArray valueForKey:@"name"] objectAtIndex:indexPath.row]];
        lblFundraiserName.font=[UIFont fontWithName:kFont size:kFontText];
        lblFundraiserName.adjustsFontSizeToFitWidth=TRUE;
        [cell.contentView addSubview:lblFundraiserName];
        
        
        UILabel *lblFundraisingCode=[[UILabel alloc]init];
        lblFundraisingCode.frame=CGRectMake(2, 20, tableView.frame.size.width, 30);
        lblFundraisingCode.backgroundColor=[UIColor clearColor];
        lblFundraisingCode.textColor=[UIColor blackColor];
        lblFundraisingCode.tag=102;
        lblFundraisingCode.adjustsFontSizeToFitWidth=TRUE;
        lblFundraisingCode.text=[NSString stringWithFormat:@"Code:- %@",[[fundraisersFilteredArray valueForKey:@"code"] objectAtIndex:indexPath.row]];
        lblFundraisingCode.font=[UIFont fontWithName:kFont size:kFontText];
        [cell.contentView addSubview:lblFundraisingCode];
    }
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *strNPOName = [NSString stringWithFormat:@"%@",[[fundraisersFilteredArray valueForKey:@"name"] objectAtIndex:indexPath.row]];
    NSString *strFundraisingCode = [NSString stringWithFormat:@"%@",[[fundraisersFilteredArray valueForKey:@"code"] objectAtIndex:indexPath.row]];
    _txtNPOName.text = strNPOName;
    _txtNPOCode.text=strFundraisingCode;
    [_txtNPOName resignFirstResponder];
    tableView.hidden=YES;
    
}
-(void)setFundraiserTableHeight:(int)count tableView:(UITableView *)tableView
{
    if (kDevice==kIphone) {
        if (count<3) {
            tableView.frame=CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, count*50);
        }
        else{
            tableView.frame=CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, kFundraiserListHeightiPhone);;
        }
    }
    else{
        if (count<3) {
            tableView.frame=CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, count*50);
        }
        else{
            tableView.frame=CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, kFundraiserListHeightiPad);;
        }
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}
#pragma mark Get Webservice data

-(void)filterFundraisersArrayForText:(NSString *)textEntered
{
    NSString *stringToSearch = @"";
    if (_txtNPOName.text.length>0) {
        stringToSearch = [stringToSearch stringByAppendingString:_txtNPOName.text];
    }
    if (textEntered.length>0) {
        stringToSearch = [stringToSearch stringByAppendingString:textEntered];
    }
    else
        stringToSearch = [stringToSearch substringToIndex:stringToSearch.length-1];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name BEGINSWITH[cd] %@", stringToSearch];
    NSArray *arrayFileterd = [arrFundraisers filteredArrayUsingPredicate:predicate];
    NSUInteger count11 = arrayFileterd.count;
    if (count11 > 1000) count11 = 1000;
    fundraisersFilteredArray = [arrayFileterd objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, count11)]];
    [_tblFundraiserList reloadData];
    
}
-(void)getAllFundraisers{
    
    if (bitGetFundraisers==FALSE) {
        [kAppDelegate showProgressHUD:self.view];
        arrFundraisers=[[NSMutableArray alloc]init];
        [[SharedManager sharedManager]getFundraisers:@"" completeBlock:^(NSData *data) {
            NSError* error;
            NSDictionary* json = [NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:kNilOptions
                                  error:&error];
            arrFundraisers =[json valueForKey:@"fundraisers"];
            [kAppDelegate hideProgressHUD];
            [[SharedManager sharedManager] subViewAnimation:_vwPopUp];
            bitGetFundraisers=TRUE;
        } errorBlock:^(NSError *error) {
            [kAppDelegate hideProgressHUD];
        }];
    }
    else{
        [[SharedManager sharedManager] subViewAnimation:_vwPopUp];
    }
}
#pragma mark - TEXTFIELD DELEGATES

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)textEntered{
    if (textField == _txtNPOName ){
        if ((textField.text.length==0 && textEntered.length>0)|| textField.text.length) {
            _tblFundraiserList.hidden = NO;
            [self filterFundraisersArrayForText:textEntered];
        }
        else
            _tblFundraiserList.hidden = YES;
        
        if(textField.text.length==1 && textEntered.length<=0)
            _tblFundraiserList.hidden = YES;
    }
    
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField ==_txtNPOName)
    {
        if ( _txtNPOName.text.length>0) {
            _txtNPOName.text=@"";
        }
    }
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
