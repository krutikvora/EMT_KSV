//
//  IBAddressVC.m
//  iBuddyClient
//
//  Created by Anubha on 04/12/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import "IBAddressVC.h"
#define kTableHeightState 150
#define kTableHeightCity 100

#define kDeleteRecordAlertTag 9090
@interface IBAddressVC (){
    NSArray *statesFilteredArray;
    NSArray *cityFilteredArray;

    NSMutableArray *arrStates;
    NSMutableArray *arrCities;
    int mSelectedStateId;
    NSString *selectedState;


}
@property (weak, nonatomic) IBOutlet UITextField *txtGifterName;
@property (weak, nonatomic) IBOutlet UITextField *txtGifteeName;
@property (weak, nonatomic) IBOutlet UITextField *txtNPOName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextView *txtAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblEmailPostal;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIScrollView *scrlView;
@property (weak, nonatomic) IBOutlet UILabel *lblState;
@property (weak, nonatomic) IBOutlet UITextField *txtState;
@property (weak, nonatomic) IBOutlet UILabel *lblCity;
@property (weak, nonatomic) IBOutlet UITableView *tblStates;
@property (weak, nonatomic) IBOutlet UITextField *txtCity;
@property (weak, nonatomic) IBOutlet UITableView *tblCities;
@property (weak, nonatomic) IBOutlet UITableView *tblFundraisers;

@property (weak, nonatomic) IBOutlet UILabel *lblCopyRight;
/**
 *  Keyboard controls.
 */
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@end

@implementation IBAddressVC
@synthesize arrRecords,pageModeType;
@synthesize dictAddressIndexInfo,lblCopyRight;
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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark Set Initial Variables
-(void)setInitialVariables{
      self.lblCopyRight.text = [CommonFunction getCopyRightText];
    if ([[dictAddressIndexInfo valueForKey:@"strgiftType"]isEqualToString:@"Address"]) {
        _txtAddress.hidden=FALSE;
        _txtEmail.hidden=TRUE;
        _lblCity.hidden=FALSE;
        _txtCity.hidden=FALSE;
        _txtState.hidden=FALSE;
        _lblState.hidden=FALSE;
        _tblStates.hidden=FALSE;
        _tblCities.hidden=FALSE;

        if (pageModeType==editMode) {
            _txtGifterName.text=[[arrRecords objectAtIndex:[[dictAddressIndexInfo valueForKey:@"selectedArrayIndex"]intValue]]valueForKey:@"Gifter Name"];
            _txtGifteeName.text=[[arrRecords objectAtIndex:[[dictAddressIndexInfo valueForKey:@"selectedArrayIndex"]intValue]]valueForKey:@"Giftee Name"];
            _txtNPOName.text=[[arrRecords objectAtIndex:[[dictAddressIndexInfo valueForKey:@"selectedArrayIndex"]intValue]]valueForKey:@"NPO Name"];
            _txtAddress.text=[[arrRecords objectAtIndex:[[dictAddressIndexInfo valueForKey:@"selectedArrayIndex"]intValue]]valueForKey:@"Email"];
            _txtState.text=[[arrRecords objectAtIndex:[[dictAddressIndexInfo valueForKey:@"selectedArrayIndex"]intValue]]valueForKey:@"State"];
            _txtCity.text=[[arrRecords objectAtIndex:[[dictAddressIndexInfo valueForKey:@"selectedArrayIndex"]intValue]]valueForKey:@"City"];

            _btnDelete.hidden=FALSE;
        }
        else{
            _btnDelete.hidden=TRUE;
            _btnSave.frame=CGRectMake(self.view.frame.size.width/2-_btnSave.frame.size.width/2, _btnSave.frame.origin.y, _btnSave.frame.size.width, _btnSave.frame.size.height);
            _txtGifterName.text=[kAppDelegate.dictUserInfo valueForKey:@"name"];
            _txtNPOName.text=[kAppDelegate.dictUserInfo valueForKey:@"npoName"];
        }
        
        arrTextFields=[[NSMutableArray alloc] initWithObjects:_txtGifteeName,_txtAddress,_txtState,_txtCity,nil];
        _lblEmailPostal.text=@"Giftee's Address*";
        _txtAddress.layer.borderWidth=1.0;
        _txtAddress.layer.cornerRadius=5.0;
        _txtAddress.layer.borderColor=[[UIColor whiteColor]CGColor];
        _btnContactList.hidden=TRUE;
    }
    else{
        _txtAddress.hidden=TRUE;
        _txtEmail.hidden=FALSE;
           if (pageModeType==editMode) {
            _txtGifterName.text=[[arrRecords objectAtIndex:[[dictAddressIndexInfo valueForKey:@"selectedArrayIndex"]intValue]]valueForKey:@"Gifter Name"];
            _txtGifteeName.text=[[arrRecords objectAtIndex:[[dictAddressIndexInfo valueForKey:@"selectedArrayIndex"]intValue]]valueForKey:@"Giftee Name"];
            _txtNPOName.text=[[arrRecords objectAtIndex:[[dictAddressIndexInfo valueForKey:@"selectedArrayIndex"]intValue]]valueForKey:@"NPO Name"];
            _txtEmail.text=[[arrRecords objectAtIndex:[[dictAddressIndexInfo valueForKey:@"selectedArrayIndex"]intValue]]valueForKey:@"Email"];
            _btnDelete.hidden=FALSE;
        }
        else{
            _btnDelete.hidden=TRUE;
            _btnSave.frame=CGRectMake(self.view.frame.size.width/2-_btnSave.frame.size.width/2, _btnSave.frame.origin.y, _btnSave.frame.size.width, _btnSave.frame.size.height);
            _txtGifterName.text=[kAppDelegate.dictUserInfo valueForKey:@"name"];
            _txtNPOName.text=[kAppDelegate.dictUserInfo valueForKey:@"npoName"];
        }
        arrTextFields=[[NSMutableArray alloc] initWithObjects:_txtGifteeName,_txtEmail,nil];
        _lblEmailPostal.text=@"Giftee's Email*";
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
    }
    [self setUpCustomForm];
    arrStates=[[NSMutableArray alloc]init];
    arrCities=[[NSMutableArray alloc]init];
    [self fetchStatePlistData];
}
#pragma mark -
#pragma mark Button Actions
- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSaveClicked:(id)sender {
    
    if ([[dictAddressIndexInfo valueForKey:@"strgiftType"]isEqualToString:@"Address"]) {

        if ([self.txtGifterName.text isEqualToString:@""]||[self.txtGifterName.text length]==0) {
            [CommonFunction fnAlert:@"Alert" message:@"Please enter Gifter Name."];
        }
        else if ([self.txtGifteeName.text isEqualToString:@""]||[self.txtGifteeName.text length]==0) {
            
            [CommonFunction fnAlert:@"Alert" message:@"Please enter Giftee Name."];
        }
        else if ([self.txtGifteeName.text length]>20) {
            
            [CommonFunction fnAlert:@"Alert" message:@"Giftee Name cannot be more than 20 characters."];
        }
        else if ([self.txtNPOName.text isEqualToString:@""]||[self.txtNPOName.text length]==0)
        {
             //**** Changed by Utkarsha on 13 July 14 --NPO name to fundraiser name on client request***/
            [CommonFunction fnAlert:@"Alert" message:@"Please enter Fundraiser Name."];
            
        }
        else if ([self.txtAddress.text isEqualToString:@""]||[self.txtAddress.text length]==0 ) {
            [CommonFunction fnAlert:@"Alert" message:@"Please enter Giftee's Address."];
        }
        else if ([self.txtState.text isEqualToString:@""]||[self.txtState.text length]==0 ) {
            [CommonFunction fnAlert:@"Alert" message:@"Please enter Giftee's State."];
        }
        else if ([self.txtCity.text isEqualToString:@""]||[self.txtCity.text length]==0 ) {
            [CommonFunction fnAlert:@"Alert" message:@"Please enter Giftee's City."];
        }
   
    else{
        NSMutableDictionary *dictRecord=[[NSMutableDictionary alloc]init];
        [dictRecord setValue:_txtGifterName.text forKey:@"Gifter Name"];
        [dictRecord setValue:_txtGifteeName.text forKey:@"Giftee Name"];
        [dictRecord setValue:_txtNPOName.text forKey:@"NPO Name"];
        [dictRecord setValue:_txtAddress.text forKey:@"Email"];
        [dictRecord setValue:_txtState.text forKey:@"State"];
        [dictRecord setValue:_txtCity.text forKey:@"City"];
        
        
        NSArray *arrCity=[_txtCity.text componentsSeparatedByString:@","];
        if ([arrCity count]<3) {
            [CommonFunction fnAlert:@"Alert!" message:@"Please select valid city"];
            _txtCity.text=@"";
            return;
        }
        NSString *strAddress=_txtAddress.text;
        strAddress=[strAddress stringByAppendingString:@"\n"];
        strAddress=[strAddress stringByAppendingString:[arrCity objectAtIndex:0]];
        strAddress=[strAddress stringByAppendingString:@", "];
        strAddress=[strAddress stringByAppendingString:[arrCity objectAtIndex:1]];
        strAddress=[strAddress stringByAppendingString:@", "];
        strAddress=[strAddress stringByAppendingString:[arrCity objectAtIndex:2]];
        [dictRecord setValue:strAddress forKey:@"Address"];

        if([[self.arrRecords valueForKey:@"Address"] containsObject:strAddress])
        {
            [CommonFunction fnAlert:@"Alert" message:@"This Address already exists."];
        }else{
        if (pageModeType==addMode) {
            [self.arrRecords addObject:dictRecord];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            [self.arrRecords replaceObjectAtIndex:[[dictAddressIndexInfo valueForKey:@"selectedArrayIndex"]intValue] withObject:dictRecord];
            [self.navigationController popViewControllerAnimated:YES];
        }}
    }
    }
    else{
        
            if ([self.txtGifterName.text isEqualToString:@""]||[self.txtGifterName.text length]==0) {
                [CommonFunction fnAlert:@"Alert" message:@"Please enter Gifter Name."];
             }
            else if ([self.txtGifteeName.text isEqualToString:@""]||[self.txtGifteeName.text length]==0) {
                
                [CommonFunction fnAlert:@"Alert" message:@"Please enter Giftee Name."];
            }
            else if ([self.txtGifteeName.text length]>20) {
                
                [CommonFunction fnAlert:@"Alert" message:@"Giftee Name cannot be more than 20 characters."];
            }
            else if ([self.txtNPOName.text isEqualToString:@""]||[self.txtNPOName.text length]==0) {
                //**** Changed by Utkarsha on 13 July 14 --NPO name to fundraiser name on client request***/

                [CommonFunction fnAlert:@"Alert" message:@"Please enter Fundraiser Name."];
                
            }
            else if ([self.txtEmail.text isEqualToString:@""]||[self.txtEmail.text length]==0 ) {
                [CommonFunction fnAlert:@"Alert" message:@"Please enter Giftee's Email."];
                
            }
            else if(![CommonFunction checkEmail:self.txtEmail.text]) {
                [CommonFunction fnAlert:@"Alert" message:@"Please enter valid Email Address."];
            }
            else{
                NSMutableDictionary *dictRecord=[[NSMutableDictionary alloc]init];
                [dictRecord setValue:_txtGifterName.text forKey:@"Gifter Name"];
                [dictRecord setValue:_txtGifteeName.text forKey:@"Giftee Name"];
                [dictRecord setValue:_txtNPOName.text forKey:@"NPO Name"];
                [dictRecord setValue:_txtEmail.text forKey:@"Email"];
                [self checkUserExistsOrNot:dictRecord];

            }
    }
}

- (IBAction)btnDeleteClicked:(id)sender {
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Do you want to delete this record?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    alert.tag=kDeleteRecordAlertTag;
    [alert show];
    
}
- (IBAction)btnContactListClicked:(id)sender {
    ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
    NSNumber* emailProp = [NSNumber numberWithInt:kABPersonEmailProperty];
    peoplePicker.addressBook = ABAddressBookCreateWithOptions(NULL, nil);
    peoplePicker.displayedProperties = [NSArray arrayWithObject:emailProp];
    [peoplePicker setPeoplePickerDelegate:self];
    [self presentViewController:peoplePicker animated:YES completion:nil];
    
  //  [self presentModalViewController:peoplePicker animated:YES];
}
#pragma mark ABPeoplePicker Delegates
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    NSString *strEmail;
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
    return NO;
}
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
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
            [CommonFunction fnAlert:@"Alert" message:@"This email address has already been used to register the iBuddyClub application."];
        }
       else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]) {
//            if([[self.arrRecords valueForKey:@"Email"] containsObject:self.txtEmail.text])
//            {
//                [CommonFunction fnAlert:@"Alert" message:@"This Email already exists."];
//            }
//            else{
                if (pageModeType==addMode) {
                    [self.arrRecords addObject:dictRecord];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else{
                    [self.arrRecords replaceObjectAtIndex:[[dictAddressIndexInfo valueForKey:@"selectedArrayIndex"]intValue] withObject:dictRecord];
                    [self.navigationController popViewControllerAnimated:YES];
                }
           // }
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
#pragma mark -
#pragma mark - UITableView Deletgate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
    if (tableView==_tblStates) {
        [self setStateTableHeight:statesFilteredArray.count tableView:_tblStates];
        return statesFilteredArray.count;
    }
    else{
        [self setCityTableHeight:cityFilteredArray.count tableView:_tblCities];
        return cityFilteredArray.count;
    }
}
/**
 Method to set state table height*/
-(void)setStateTableHeight:(int)count tableView:(UITableView *)tableView
{
        if (count<4) {
            tableView.frame=CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, count*50);
        }
        else{
            tableView.frame=CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, kTableHeightState);;
        }
    
}
-(void)setCityTableHeight:(int)count tableView:(UITableView *)tableView
{
    if (kDevice==kIphone) {
        if (count<3) {
            tableView.frame=CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, count*50);
        }
        else{
            tableView.frame=CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, kTableHeightCity);;
        }
    }
    else{
        if (count<4) {
            tableView.frame=CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, count*50);
        }
        else{
            tableView.frame=CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, kTableHeightState);;
        }
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_tblStates) {
        static NSString *CellIdentifier = @"StateList";
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if (statesFilteredArray.count>0) {
            UILabel *lblStateName=[[UILabel alloc]init];
            lblStateName.frame=CGRectMake(2, 3, tableView.frame.size.width, 30);
            lblStateName.tag=101;
            lblStateName.text=[[statesFilteredArray valueForKey:@"Name"]objectAtIndex:indexPath.row];
            lblStateName.font=[UIFont fontWithName:kFont size:kFontText];
            lblStateName.adjustsFontSizeToFitWidth=TRUE;
            [cell.contentView addSubview:lblStateName];
        }
        else{
            UILabel *lblStateName=(UILabel *)[cell viewWithTag:101];
            lblStateName.text=[[statesFilteredArray valueForKey:@"Name"]objectAtIndex:indexPath.row];
            lblStateName.textColor=[UIColor blackColor];
            lblStateName.adjustsFontSizeToFitWidth=TRUE;
            lblStateName.font=[UIFont fontWithName:kFont size:kFontText];
            
        }
        return cell;
    }
    else{
        static NSString *CellIdentifier = @"CityList";
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if (cityFilteredArray.count>0) {
            UILabel *lblCityName=[[UILabel alloc]init];
            lblCityName.frame=CGRectMake(2, 3, tableView.frame.size.width, 30);
            lblCityName.tag=101;
            lblCityName.text=[NSString stringWithFormat:@"%@,%@",[[cityFilteredArray valueForKey:@"City_Alias"] objectAtIndex:indexPath.row],selectedState];
            lblCityName.font=[UIFont fontWithName:kFont size:kFontText];
            lblCityName.adjustsFontSizeToFitWidth=TRUE;
            [cell.contentView addSubview:lblCityName];
            
            UILabel *lblZipCode=[[UILabel alloc]init];
            lblZipCode.frame=CGRectMake(2, 20, tableView.frame.size.width, 30);
            lblZipCode.backgroundColor=[UIColor clearColor];
            lblZipCode.textColor=[UIColor blackColor];
            
            lblZipCode.tag=102;
            lblZipCode.adjustsFontSizeToFitWidth=TRUE;
            lblZipCode.text=[NSString stringWithFormat:@"Zip Code:- %@",[[cityFilteredArray valueForKey:@"ZipCode"] objectAtIndex:indexPath.row]];
            lblZipCode.font=[UIFont fontWithName:kFont size:kFontText];
            
            [cell.contentView addSubview:lblZipCode];
            
        }
        else{
            UILabel *lblCityName=(UILabel *)[cell viewWithTag:101];
            lblCityName.text=[NSString stringWithFormat:@"%@,%@",[[cityFilteredArray valueForKey:@"City_Alias"] objectAtIndex:indexPath.row],selectedState];
            lblCityName.textColor=[UIColor blackColor];
            lblCityName.adjustsFontSizeToFitWidth=TRUE;
            
            lblCityName.font=[UIFont fontWithName:kFont size:kFontText];
            
            UILabel *lblZipCode=(UILabel *)[cell viewWithTag:102];
            lblZipCode.text=[NSString stringWithFormat:@"Zip Code:- %@",[[cityFilteredArray valueForKey:@"ZipCode"] objectAtIndex:indexPath.row]];
            lblZipCode.textColor=[UIColor blackColor];
            lblZipCode.adjustsFontSizeToFitWidth=TRUE;
            lblZipCode.font=[UIFont fontWithName:kFont size:kFontText];
            
        }
        return cell;
    }
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_tblStates) {
        
        _txtState.text=[[statesFilteredArray valueForKey:@"Name"]objectAtIndex:indexPath.row];
        mSelectedStateId = [[[statesFilteredArray valueForKey:@"StateID"] objectAtIndex:indexPath.row]intValue];
        selectedState=[[statesFilteredArray valueForKey:@"ShortName"] objectAtIndex:indexPath.row];
        _txtCity.text = @"";
        [kAppDelegate showProgressHUD:self.view];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self fetchCityPlistData:TRUE];
        });
        [_txtState resignFirstResponder];
    }
    else{
        NSString *strCity = [NSString stringWithFormat:@"%@, %@, %@",[[cityFilteredArray valueForKey:@"City_Alias"] objectAtIndex:indexPath.row],selectedState,[[cityFilteredArray valueForKey:@"ZipCode"] objectAtIndex:indexPath.row]];
        _txtCity.text = strCity;
        [_txtCity resignFirstResponder];
      [self removeScrollAnimation:_txtCity.frame];
    }
    tableView.hidden=YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 50.f;
    return height;
}



#pragma mark get plist data


//Fetch the States data from the Plist
-(void) fetchStatePlistData {
    
    //Adding values form State plist into State array
    NSString *statePath = [[NSBundle mainBundle] pathForResource:@"states1" ofType:@"plist"];
    NSMutableArray *arrState = [[NSMutableArray alloc] initWithContentsOfFile:statePath];
    for (int stateCounter = 0; stateCounter < [arrState count]; stateCounter++) {
        [arrStates addObject:[arrState objectAtIndex:stateCounter]];
    }
}
-(void)filterStateArrayForText:(NSString *)textEntered
{
    NSString *stringToSearch = @"";
    if (_txtState.text.length>0) {
        stringToSearch = [stringToSearch stringByAppendingString:_txtState.text];
    }
    if (textEntered.length>0) {
        stringToSearch = [stringToSearch stringByAppendingString:textEntered];
    }
    else
    stringToSearch = [stringToSearch substringToIndex:stringToSearch.length-1];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Name BEGINSWITH[cd] %@", stringToSearch];
    NSArray *arrayFileterd = [arrStates filteredArrayUsingPredicate:predicate];
    NSUInteger count11 = arrayFileterd.count;
    if (count11 > 1000) count11 = 1000;
    statesFilteredArray = [arrayFileterd objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, count11)]];

    [_tblStates reloadData];
    
}
-(void)filterCityArrayForText:(NSString *)textEntered
{
    NSString *stringToSearch = @"";
    if (_txtCity.text.length>0) {
        stringToSearch = [stringToSearch stringByAppendingString:_txtCity.text];
    }
    if (textEntered.length>0) {
        stringToSearch = [stringToSearch stringByAppendingString:textEntered];
    }
    else
        stringToSearch = [stringToSearch substringToIndex:stringToSearch.length-1];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"City_Alias BEGINSWITH[cd] %@", stringToSearch];
    NSArray *arrayFileterd = [arrCities filteredArrayUsingPredicate:predicate];
    NSUInteger count11 = arrayFileterd.count;
    if (count11 > 1000) count11 = 1000;
    cityFilteredArray = [arrayFileterd objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, count11)]];
    
    [_tblCities reloadData];
    
}
-(void) fetchCityPlistData :(BOOL)becomeResponder {
    [arrCities removeAllObjects];
    NSString *cityPath = [[NSBundle mainBundle] pathForResource:@"cities" ofType:@"plist"];
    NSMutableArray *arrCity = [[NSMutableArray alloc] initWithContentsOfFile:cityPath];
    NSMutableArray *arrUnsortedArray = [[NSMutableArray alloc] init];
    
    for (int stateCounter = 0; stateCounter < [arrCity count]; stateCounter++) {
        if ([[[arrCity objectAtIndex:stateCounter] valueForKey:@"StateID"] isEqualToString:[NSString stringWithFormat:@"%d",mSelectedStateId]]) {
            [arrUnsortedArray addObject:[arrCity objectAtIndex:stateCounter]];
        }
    }
    NSSortDescriptor *brandDescriptor = [[NSSortDescriptor alloc] initWithKey:@"City_Alias" ascending:YES] ;
    NSArray *sortDescriptors  = [NSArray arrayWithObject:brandDescriptor];
    [arrCities addObjectsFromArray:[arrUnsortedArray sortedArrayUsingDescriptors:sortDescriptors]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [kAppDelegate hideProgressHUD];
        if (becomeResponder==TRUE) {
            [_txtCity becomeFirstResponder];
        }
    });
}


#pragma mark - CUSTOM TEXTFIELD DELEGATES
-(BOOL)customTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)textEntered{
     if (textField == _txtCity ) {
        
        if ((textField.text.length==0 && textEntered.length>0)|| textField.text.length) {
            _tblCities.hidden = NO;
            [self filterCityArrayForText:textEntered];
        }
        else
            _tblCities.hidden = YES;
        
        if(textField.text.length==1 && textEntered.length<=0)
            _tblCities.hidden = YES;
    }
    else if (textField == _txtState ) {
        if ((textField.text.length==0 && textEntered.length>0)|| textField.text.length) {
            _tblStates.hidden = NO;
            _tblStates.frame =_tblStates.frame;
            [self filterStateArrayForText:textEntered];
        }
        else
            _tblStates.hidden = YES;
        if(textField.text.length==1 && textEntered.length<=0)
            _tblStates.hidden = YES;
    }
    return YES;
}
-(BOOL)customTextFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField ==_txtState)
    {
        _tblCities.hidden=YES;
        _txtState.text=@"";
    }
    if(textField ==_txtCity)
    {
        if (mSelectedStateId>0 && _txtState.text.length>0) {
            _txtCity.text=@"";
        }
        else
        {
            _txtState.text=@"";
            _txtCity.text=@"";
            _tblCities.hidden = YES;
            _tblStates.hidden=YES;
            [CommonFunction fnAlert:@"Alert!" message:@"Please select valid state, so that the cities of a selected state will be displayed."];
            return NO;
        }
        if (_txtCity.text.length) {
        }
    }
    return YES;
    
}
-(BOOL)customTextFieldShouldReturn:(UITextField *)textField
{
    if ([[dictAddressIndexInfo valueForKey:@"strgiftType"]isEqualToString:@"Address"]) {
        if (![[arrCities valueForKey:@"City_Alias"]containsObject:_txtCity.text]) {
            [CommonFunction fnAlert:@"Alert!" message:@"Please select valid city"];
            _txtCity.text=@"";
        }
    }
       return YES;
}
#pragma mark -  TextView Delegates
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}
#pragma mark - Alert View Delegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView tag]==kDeleteRecordAlertTag && buttonIndex==0) {
        [self.arrRecords removeObjectAtIndex:[[dictAddressIndexInfo valueForKey:@"selectedArrayIndex"]intValue]];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
