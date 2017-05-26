//
//  IBAddReferEmailVC.m
//  iBuddyClient
//
//  Created by Anubha on 11/12/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import "IBAddReferEmailVC.h"
#define kDeleteAlertTag 6767
#define kFundraiserTableHeightiPhone 115
#define kFundraiserTableHeightiPad 130

@interface IBAddReferEmailVC ()
{
    NSArray *fundraisersFilteredArray;
}
@property (weak, nonatomic) IBOutlet UITextField *txtFriendName;
@property (weak, nonatomic) IBOutlet UITextField *txtFundraisingCode;
@property (weak, nonatomic) IBOutlet UITextField *txtNPOName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextView *txtAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtRefererName;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIScrollView *scrlView;
@property (weak, nonatomic) IBOutlet UILabel *lblEmailOrPhone;
@property (weak, nonatomic) IBOutlet UITableView *tblFundraisers;
@property (weak, nonatomic) IBOutlet UILabel *lblCopyRight;

/**
 *  Keyboard controls.
 */
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@end

@implementation IBAddReferEmailVC
@synthesize arrRecords;
@synthesize dictAddressIndexInfo,lblCopyRight;
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
    [self setLayoutForiOS7];
    [self setInitialVariables];
    [self getAllFundraisers];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Set Initial Variables
-(void)setInitialVariables{
     self.lblCopyRight.text = [CommonFunction getCopyRightText];
    if ([[dictAddressIndexInfo valueForKey:@"strReferType"]isEqualToString:kReferEmail]) {
        _lblEmailOrPhone.text=@"Friend's Email*";
    }
    else{
        _lblEmailOrPhone.text=@"Friend's Phone No.*";
        
    }
    
    if ([[dictAddressIndexInfo valueForKey:@"ModeType"]isEqualToString:@"EditMode"]) {
        _txtFriendName.text=[[arrRecords objectAtIndex:[[dictAddressIndexInfo valueForKey:@"selectedArrayIndex"]intValue]]valueForKey:@"Friend Name"];
        _txtFundraisingCode.text=[[arrRecords objectAtIndex:[[dictAddressIndexInfo valueForKey:@"selectedArrayIndex"]intValue]]valueForKey:@"Fundraising Code"];
        _txtNPOName.text=[[arrRecords objectAtIndex:[[dictAddressIndexInfo valueForKey:@"selectedArrayIndex"]intValue]]valueForKey:@"NPO Name"];
        _txtEmail.text=[[arrRecords objectAtIndex:[[dictAddressIndexInfo valueForKey:@"selectedArrayIndex"]intValue]]valueForKey:@"Email"];
        _txtRefererName.text=[[arrRecords objectAtIndex:[[dictAddressIndexInfo valueForKey:@"selectedArrayIndex"]intValue]]valueForKey:@"refererName"];
        _btnDelete.hidden=FALSE;
    }
    else{
        _btnDelete.hidden=TRUE;
        _btnSave.frame=CGRectMake(self.view.frame.size.width/2-_btnSave.frame.size.width/2, _btnSave.frame.origin.y, _btnSave.frame.size.width, _btnSave.frame.size.height);
    }
    
    NSString *userID=[[kAppDelegate dictUserInfo]valueForKey:@"userId"];
    if ([userID length]>0 && [[kAppDelegate.dictUserInfo valueForKey:@"name"] length]>0) {
        _txtRefererName.text=[kAppDelegate.dictUserInfo valueForKey:@"name"];
        _txtRefererName.enabled=NO;
        arrTextFields=[[NSMutableArray alloc] initWithObjects:_txtFriendName,_txtNPOName,_txtEmail,nil];
        
    }
    else {
        _txtRefererName.enabled=YES;
        arrTextFields=[[NSMutableArray alloc] initWithObjects:_txtFriendName,_txtRefererName,_txtNPOName,_txtEmail,nil];
    }
    
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *textField = (UILabel *)view;
            textField.font=[UIFont fontWithName:kFont size:textField.font.pointSize];
        }
    }
    for (UIView *view in _scrlView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *lbl = (UILabel *)view;
            lbl.font=[UIFont fontWithName:kFont size:lbl.font.pointSize];
            [lbl highlightTextInLabel:@"*"];
        }
        [self setUpCustomForm];
    }
}

-(void)getAllFundraisers{
    if (![dictAddressIndexInfo valueForKey:@"fundraisersList"]) {
        [[SharedManager sharedManager]getFundraisers:@"" completeBlock:^(NSData *data) {
            NSError* error;
            NSDictionary* json = [NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:kNilOptions
                                  error:&error];
            [dictAddressIndexInfo setValue:[json valueForKey:@"fundraisers"] forKey:@"fundraisersList"];
            
        } errorBlock:^(NSError *error) {
            
        }];
    }
}
#pragma mark Button Actions
- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSaveClicked:(id)sender {
    if ([[dictAddressIndexInfo valueForKey:@"strReferType"]isEqualToString:kReferEmail]) {
        if ([self.txtFriendName.text isEqualToString:@""]||[self.txtFriendName.text length]==0) {
            [CommonFunction fnAlert:@"Alert" message:@"Please enter Friend's Name."];
        }
        else if ([self.txtRefererName.text isEqualToString:@""]||[self.txtRefererName.text length]==0) {
            [CommonFunction fnAlert:@"Alert" message:@"Please enter Referer Name."];
        }
        else if ([self.txtNPOName.text isEqualToString:@""]||[self.txtNPOName.text length]==0)
        {
            //**** Changed by Utkarsha on 13 July 14 --NPO name to fundraiser name on client request***/

            [CommonFunction fnAlert:@"Alert" message:@"Please enter Fundraiser Name."];
        }
        else if ([self.txtFundraisingCode.text isEqualToString:@""]||[self.txtFundraisingCode.text length]==0) {
            [CommonFunction fnAlert:@"Alert" message:@"Please enter Fundraising Code."];
        }
        else if ([self.txtEmail.text isEqualToString:@""]||[self.txtEmail.text length]==0 ) {
            [CommonFunction fnAlert:@"Alert" message:@"Please enter Friend's Email."];
        }
        else if(![CommonFunction checkEmail:self.txtEmail.text]) {
            [CommonFunction fnAlert:@"Alert" message:@"Please enter valid Email Address."];
        }
        
        else{
            NSMutableDictionary *dictRecord=[[NSMutableDictionary alloc]init];
            [dictRecord setValue:_txtFriendName.text forKey:@"Friend Name"];
            [dictRecord setValue:_txtNPOName.text forKey:@"NPO Name"];
            [dictRecord setValue:_txtFundraisingCode.text forKey:@"Fundraising Code"];
            [dictRecord setValue:_txtEmail.text forKey:@"Email"];
            [dictRecord setValue:_txtRefererName.text forKey:@"refererName"];
            [self checkUserExistsOrNot:dictRecord];

        }
    }
    else{
        if ([self.txtFriendName.text isEqualToString:@""]||[self.txtFriendName.text length]==0) {
            [CommonFunction fnAlert:@"Alert" message:@"Please enter Friend's Name."];
        }
        else if ([self.txtRefererName.text isEqualToString:@""]||[self.txtRefererName.text length]==0) {
            [CommonFunction fnAlert:@"Alert" message:@"Please enter Referer Name."];
        }
        else if ([self.txtNPOName.text isEqualToString:@""]||[self.txtNPOName.text length]==0) {
            //**** Changed by Utkarsha on 13 July 14 --NPO name to fundraiser name on client request***/

            [CommonFunction fnAlert:@"Alert" message:@"Please enter Fundraiser Name."];
        }
        else if ([self.txtFundraisingCode.text isEqualToString:@""]||[self.txtFundraisingCode.text length]==0) {
            [CommonFunction fnAlert:@"Alert" message:@"Please enter Fundraising Code."];
        }
        else if ([self.txtEmail.text isEqualToString:@""]||[self.txtEmail.text length]==0 ) {
            [CommonFunction fnAlert:@"Alert" message:@"Please enter Friend's Phone No."];
        }
        
        else{
            NSMutableString *strPhoneNumber=[_txtEmail.text mutableCopy];
             [strPhoneNumber replaceOccurrencesOfString:@"(" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [strPhoneNumber length])];
            [strPhoneNumber replaceOccurrencesOfString:@")" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [strPhoneNumber length])];
            [strPhoneNumber replaceOccurrencesOfString:@"-" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [strPhoneNumber length])];

            NSMutableDictionary *dictRecord=[[NSMutableDictionary alloc]init];
            [dictRecord setValue:_txtFriendName.text forKey:@"Friend Name"];
            [dictRecord setValue:_txtNPOName.text forKey:@"NPO Name"];
            [dictRecord setValue:_txtFundraisingCode.text forKey:@"Fundraising Code"];
            [dictRecord setValue:strPhoneNumber forKey:@"Email"];
            [dictRecord setValue:_txtEmail.text forKey:@"PhoneNumber"];

            [dictRecord setValue:_txtRefererName.text forKey:@"refererName"];
            if([[self.arrRecords valueForKey:@"Email"] containsObject:self.txtEmail.text])
            {
                [CommonFunction fnAlert:@"Alert" message:@"This Phone No. already exists."];

            }
            else{
                if ([[dictAddressIndexInfo valueForKey:@"ModeType"]isEqualToString:@"AddMode"]) {
                    [self.arrRecords addObject:dictRecord];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else{
                    [self.arrRecords replaceObjectAtIndex:[[dictAddressIndexInfo valueForKey:@"selectedArrayIndex"]intValue] withObject:dictRecord];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
            
        }
    }
}

- (IBAction)btnDeleteClicked:(id)sender {
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Do you want to delete this record?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    alert.tag=kDeleteAlertTag;
    [alert show];
    
}

- (IBAction)btnContactListClicked:(id)sender {
    ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
    NSNumber* emailProp = [NSNumber numberWithInt:kABPersonEmailProperty];
    //ABAddressBookRef test = [self getValidEmailAddress];
    //  [picker setAddressBook:test];
    peoplePicker.addressBook = ABAddressBookCreateWithOptions(Nil,nil);
    peoplePicker.displayedProperties = [NSArray arrayWithObject:emailProp];
    [peoplePicker setPeoplePickerDelegate:self];
    [self presentViewController:peoplePicker animated:YES completion:nil];
}

//validating email

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
        _tblFundraisers.hidden=YES;
    }
    [self setFundraiserTableHeight:[fundraisersFilteredArray count] tableView:_tblFundraisers];
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
    _txtFundraisingCode.text=strFundraisingCode;
    [_txtNPOName resignFirstResponder];
    [_txtEmail becomeFirstResponder];
    _keyboardControls.showSegment=YES;
    tableView.hidden=YES;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}
-(void)setFundraiserTableHeight:(int)count tableView:(UITableView *)tableView
{
    if (kDevice==kIphone) {
        if (count<3) {
            tableView.frame=CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, count*50);
        }
        else{
            tableView.frame=CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, kFundraiserTableHeightiPhone);;
        }
    }
    else{
        if (count<3) {
            tableView.frame=CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, count*50);
        }
        else{
            tableView.frame=CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, kFundraiserTableHeightiPad);;
        }
    }
    
}
#pragma mark - CUSTOM TEXTFIELD DELEGATES


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
    NSArray *arrayFileterd = [[dictAddressIndexInfo valueForKey:@"fundraisersList"] filteredArrayUsingPredicate:predicate];
    NSUInteger count11 = arrayFileterd.count;
    if (count11 > 1000) count11 = 1000;
    fundraisersFilteredArray = [arrayFileterd objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, count11)]];
    [_tblFundraisers reloadData];
    
}
-(BOOL)customTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)textEntered{
    if (textField == _txtNPOName ){
        if ((textField.text.length==0 && textEntered.length>0)|| textField.text.length) {
            _tblFundraisers.hidden = NO;
            [self filterFundraisersArrayForText:textEntered];
        }
        else
            _tblFundraisers.hidden = YES;
        
        if(textField.text.length==1 && textEntered.length<=0)
            _tblFundraisers.hidden = YES;
    }
    if (textField == self.txtEmail)
    {
      if ([[dictAddressIndexInfo valueForKey:@"strReferType"]isEqualToString:kReferSMS]) {
        {
            NSCharacterSet *NUMBERS	= [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
            for (int i = 0; i < [textEntered length]; i++)
            {
                unichar d = [textEntered characterAtIndex:i];
                if (![NUMBERS characterIsMember:d])
                {
                    UIAlertView *alertIntCheck=[[UIAlertView alloc]initWithTitle:@"Please enter numbers only." message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertIntCheck show];
                    return NO;
                }
                NSString *str=@"";
                str=_txtEmail.text;
                if(str.length==0)
                {
                    str=[str stringByAppendingString:@"("];
                    _txtEmail.text=str;
                }
                if(str.length==4)
                {
                    str=[str stringByAppendingString:@")"];
                    _txtEmail.text=str;
                }
                else if(str.length==8)
                {
                    str=[str stringByAppendingString:@"-"];
                    _txtEmail.text=str;
                }
                if([str length]>12)
                {
                    _txtEmail.text = [str substringToIndex:13];
                    UIAlertView *alertIntCheck=[[UIAlertView alloc]initWithTitle:@"Phone number can't be greater than 10 digits." message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertIntCheck show];
                    return NO;
                }
                else
                {
                    return YES;
                }
        }
      
        }
    }
    }
    return YES;
}
-(BOOL)customTextFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField ==_txtNPOName)
    {
        if ( _txtNPOName.text.length>0) {
            _txtNPOName.text=@"";
            _keyboardControls.showSegment=NO;
        }
    }
    
    return YES;
}

#pragma mark ABPeoplePicker Delegates
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    if ([[dictAddressIndexInfo valueForKey:@"strReferType"]isEqualToString:kReferEmail]) {
        NSString *strEmail=@"";
        ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
        CFStringRef email1;
        if(ABMultiValueGetCount(emails) > 0)
        {
            email1 = ABMultiValueCopyValueAtIndex(emails, 0);
            strEmail=(__bridge NSString *) email1;
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            strEmail = @"";
            [CommonFunction fnAlert:@"Alert" message:@"No Email address found."];
        }
        _txtEmail.text=strEmail;
    }
    else{
        NSString *strEmail=@"";
        ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonPhoneProperty);
        CFStringRef email1;
        if(ABMultiValueGetCount(emails) > 0)
        {
            email1 = ABMultiValueCopyValueAtIndex(emails, 0);
            strEmail=(__bridge NSString *) email1;
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            strEmail = @"";
            [CommonFunction fnAlert:@"Alert" message:@"No Phone No found."];
        }
        _txtEmail.text=strEmail;
    }
    
    return NO;
}
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}
#pragma mark - Alert View Delegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView tag]==kDeleteAlertTag && buttonIndex==0) {
        [self.arrRecords removeObjectAtIndex:[[dictAddressIndexInfo valueForKey:@"selectedArrayIndex"]intValue]];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)checkUserExistsOrNot:(NSMutableDictionary *)dictRecord{
    
    [kAppDelegate showProgressHUD:self.view];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    /*commented in order to implement not to log out unpaid user*/
    [dict setValue:_txtEmail.text forKey:@"email"];
    [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dict method:kCheckUserStatus] completeBlock:^(NSData *data) {
        id result = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions error:nil];
        if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
            
         [CommonFunction fnAlert:@"Alert" message:@"This Email address has already been used to register the iBuddyClub application."];
           
        }
        else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]) {
            if([[self.arrRecords valueForKey:@"Email"] containsObject:self.txtEmail.text])
            {
                    [CommonFunction fnAlert:@"Alert" message:@"This Email already exists."];
               
            }
            else{
                if ([[dictAddressIndexInfo valueForKey:@"ModeType"]isEqualToString:@"AddMode"]) {
                    [self.arrRecords addObject:dictRecord];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else{
                    [self.arrRecords replaceObjectAtIndex:[[dictAddressIndexInfo valueForKey:@"selectedArrayIndex"]intValue] withObject:dictRecord];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
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


@end