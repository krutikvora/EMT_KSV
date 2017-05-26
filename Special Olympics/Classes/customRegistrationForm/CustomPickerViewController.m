//
//  CustomPickerViewController.m
//  TextSmartControl
//
//  Created by Abhimanu on 28/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomPickerViewController.h"


@interface CustomPickerViewController ()

- (IBAction)datePickerValueChanged:(id)sender;
-(void) addCustomPicker;


@end

static SelectionBlock _block;
static HideCompletionBlock _hideBlock;

@implementation CustomPickerViewController
@synthesize picker;
@synthesize arrPicker;
@synthesize text;
@synthesize datePicker;
@synthesize previousNextSegment;
@synthesize arrSelectedIndex;
@synthesize fontSize;
@synthesize toolBar;
static CustomPickerViewController *sharedInstance = nil;

+(CustomPickerViewController *) sharedManager
{
    static dispatch_once_t onceQueue;
    dispatch_once(&onceQueue, ^{
        if(!sharedInstance || sharedInstance == nil) {
            sharedInstance = [[CustomPickerViewController alloc] initWithNibName:@"CustomPickerViewController" bundle:[NSBundle mainBundle]];
        }
    });
   return sharedInstance;
}
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

    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:datePicker];
    datePicker.timeZone = [NSTimeZone systemTimeZone];
    datePicker.frame = CGRectMake(0, 41,320,216);
    [self.view bringSubviewToFront:datePicker];
    if(iOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        previousNextSegment.tintColor = [UIColor colorWithRed:0/255.0 green:114/255.0 blue:222/255.0 alpha:1];
   }
    else{
        previousNextSegment.tintColor = [UIColor blackColor];
        
    }
   // previousNextSegment.segmentedControlStyle = UISegmentedControlStyleBar;
    datePicker.hidden = YES;
}

- (void)viewDidUnload
{
    [self setPicker:nil];
    previousNextSegment = nil;
    datePicker = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark UIPickerView Datasource methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if ([arrPicker count]<=0)
        return 1;
//    else {
//        id object = [arrPicker objectAtIndex:0];
//        if ([object isKindOfClass:[NSDictionary class]]) {
//            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"DataFieldText" ascending:YES];
//            arrPicker=[[arrPicker sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]] mutableCopy];
//        }
//        else {
//            arrPicker = [[arrPicker sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] mutableCopy];
//        }
//    }
    return [arrPicker count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 65.0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
       
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell setBounds: CGRectMake(0, 0, cell.frame.size.width -20 , 60)];
    
    if (_isMultiSelection) {
        
        UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleSelection:)];
        singleTapGestureRecognizer.numberOfTapsRequired = 1;
        [cell addGestureRecognizer:singleTapGestureRecognizer];
    }
    else
    {
        NSArray *arrayOfGestureRecognizers = cell.gestureRecognizers;
        [arrayOfGestureRecognizers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [cell removeGestureRecognizer:obj];
        }];
        
    }
    
        
    if (_isMultiSelection) {
        
        if([self.arrSelectedIndex containsObject:[NSString stringWithFormat:@"%d",row]])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }

    }
        cell.tag = row;
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:fontSize];//[UIFont boldSystemFontOfSize:14.0];
    id object = [arrPicker objectAtIndex:row];
    if ([object isKindOfClass:[NSDictionary class]]) {
        cell.textLabel.text = [object valueForKey:@"DataTextField"];
    }
    else
        cell.textLabel.text = object;
    cell.textLabel.numberOfLines = 2;
    return cell;

    /*
     DLog(@"Cusrome picker %@",arrPicker);
    NSString *strtitle=@"";
    strtitle=[arrPicker objectAtIndex:row];

    UILabel *pickerLabel = (UILabel *)view;
    if (pickerLabel == nil)
    {
        pickerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,280, 35)];
        pickerLabel.backgroundColor = [UIColor clearColor];
        
        pickerLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    pickerLabel.text = strtitle;
    return pickerLabel;
     */
    
}


#pragma mark -
#pragma mark UIPickerView Delegate methods

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
//     DLog(@"Cusrome picker %@",arrPicker);
    if ([arrPicker count]>0)
    {
        NSString *str = [arrPicker objectAtIndex:row];
        _block(str,row);
     
    }
    else {
        _block(@"Error",-1);
       
    }
    
}


#pragma mark -
#pragma mark Custom Methods


-(void)showPickerOnCompletion: (void(^)(NSString *text,int row))selectedtextHandler OnHiding:(void(^)(ControlsDirection direction))hideCompletionHandler selectedText:(NSString *)str showSegment:(BOOL)show multiSelection:(BOOL)isMultiSelection fontSize:(CGFloat)size {
        
    [self addCustomPicker];
    _isMultiSelection = isMultiSelection;
    if (_isMultiSelection) {
        self.picker.showsSelectionIndicator = NO;
    }
    if (_isMultiSelection) {
        self.picker.showsSelectionIndicator = YES;
    }
    [self.picker reloadAllComponents];
    [self.picker setHidden:NO];
    datePicker.hidden = YES;
    previousNextSegment.hidden = !show;
    [previousNextSegment setEnabled:YES forSegmentAtIndex:0];
    [previousNextSegment setEnabled:YES forSegmentAtIndex:1];
    
    _block = [selectedtextHandler copy];
    _hideBlock = [hideCompletionHandler copy];
    
    CGRect pickerRect =  sharedInstance.view.frame;
    sharedInstance.view.hidden = NO;
    sharedInstance.view.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height,320,[[UIScreen mainScreen] bounds].size.height);
    sharedInstance.view.frame = pickerRect;
    fontSize = size;
    
    BOOL isFound = NO;
    for(int i=0;i<[self.arrPicker count];i++) {
        
        id object = [self.arrPicker objectAtIndex:i];
        NSString *value = nil;
        if ([object isKindOfClass:[NSDictionary class]]) {
            value = [object valueForKey:@"DataTextField"];
        }
        else
            value = object;
        
        if([value isEqualToString:[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]) {
            isFound = YES;
            [self.picker selectRow:i inComponent:0 animated:YES];

            if([self.arrSelectedIndex count]==0)
            {
                [self.arrSelectedIndex addObject:[NSString stringWithFormat:@"%d",i]];
            }
            [picker reloadAllComponents];
            _block(value,i);
            break;
        }
    }
    if (!isFound) {
        [self.picker selectRow:0 inComponent:0 animated:YES];
        id object = [arrPicker objectAtIndex:0];
        NSString *str = nil;
        if ([object isKindOfClass:[NSDictionary class]]) {
            str = [object valueForKey:@"DataTextField"];
        }
        else
        {
            str = object;
        }
        [self.arrSelectedIndex addObject:[NSString stringWithFormat:@"%d",0]];
        [picker reloadAllComponents];
        _block(str,0);
    }
}



-(void)showDatePickerOnCompletion  :(void(^)(NSString *text))selectedtextHandler OnHiding:(void(^)(int direction))hideCompletionHandler selectedText:(NSString *)str showSegment:(BOOL)show  datePickerMode:(int)mode
{
    [self addCustomPicker];
    if (mode == UIDatePickerModeTime) {
        datePicker.minimumDate = nil;
    }
    else
    {
        datePicker.minimumDate = [NSDate date];
    }
    datePicker.datePickerMode = mode;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    // [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormat setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormat setLocale:[NSLocale currentLocale]];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    NSDate *dateToDisplay = [dateFormat dateFromString:str];//getLocalDate];
    
    if(!dateToDisplay)
    {
        datePicker.date = [NSDate date];
    }
    else
        datePicker.date = dateToDisplay;
    
    previousNextSegment.hidden = !show;
    [previousNextSegment setEnabled:YES forSegmentAtIndex:0];
    [previousNextSegment setEnabled:YES forSegmentAtIndex:1];
    
    [self.picker setHidden:YES];
    datePicker.hidden = NO;
    
    self.view.hidden = NO;
    _block = [selectedtextHandler copy];
    _hideBlock = [hideCompletionHandler copy];
    CGRect pickerRect =  sharedInstance.view.frame;
    sharedInstance.view.hidden = NO;
    sharedInstance.view.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height,320,[[UIScreen mainScreen] bounds].size.height);
    sharedInstance.view.frame = pickerRect;
    //    [UIView animateWithDuration:0.25 animations:^{
    //        sharedInstance.view.frame =pickerRect;
    //    }];
    
    
}



-(void)hidePickerView {
    CGRect pickerRect =  sharedInstance.view.frame;
    [UIView animateWithDuration:0.25 animations:^{
        sharedInstance.view.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height,320,[[UIScreen mainScreen] bounds].size.height);
        
    } completion:^(BOOL finished) {
        self.view.hidden=YES;
        sharedInstance.view.frame = pickerRect;
        
    }];
    _hideBlock(-1);
}



-(void) addCustomPicker
{
    id appDelegate_For_Picker = [[UIApplication sharedApplication]delegate];
    for(UIView *view in [[appDelegate_For_Picker window] subviews])
    {
        if(view.tag == 645)
        {
            [view removeFromSuperview];
        }
    }
    [CustomPickerViewController sharedManager];
    if(kDevice==kIphone){
        sharedInstance.view.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-236, 320, 258);
    }
    else
    {
        sharedInstance.view.frame = CGRectMake(0, 0, 320, 258);
        
    }
    sharedInstance.view.tag = 645;
    if (kDevice == kIphone) {
        [[appDelegate_For_Picker window] addSubview:sharedInstance.view];
    }
    sharedInstance.view.hidden = YES;
}



-(void)currentPickerPosition:(PickerFormPositionIndex)positionIndex
{
    if (positionIndex == firstIndex) {
        [previousNextSegment setEnabled:NO forSegmentAtIndex:0];
        [previousNextSegment setEnabled:YES forSegmentAtIndex:1];
        return;
    }
    if (positionIndex == lastIndex) {
        [previousNextSegment setEnabled:YES forSegmentAtIndex:0];
        [previousNextSegment setEnabled:NO forSegmentAtIndex:1];
        return;
    }
    
}

#pragma mark - Action methods

- (IBAction)doneBtnClicked:(id)sender  {
    [self hidePickerView];
}

- (IBAction)segmentControlClicked:(id)sender {
    
    UISegmentedControl *temp = (UISegmentedControl *)sender;
    self.view.hidden=YES;
    _hideBlock(temp.selectedSegmentIndex);
}


- (IBAction)datePickerValueChanged:(id)sender 
{
    UIDatePicker *pickerDate = (UIDatePicker *)sender;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormat setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormat setLocale:[NSLocale currentLocale]];
    if (pickerDate.datePickerMode == UIDatePickerModeDate) {
        [dateFormat setDateFormat:@"MM/dd/yyyy"];
        
    }
    else
    {
        [dateFormat setDateFormat:@"HH:mm"];
        
    }
    NSString *dateString = [dateFormat stringFromDate:pickerDate.date];
    _block([NSString stringWithFormat:@"%@",dateString],0);
    
    
    
}


- (void)toggleSelection:(UITapGestureRecognizer *)recognizer {
    
    NSInteger rowTag = recognizer.view.tag;

    UITableViewCell *cell = (UITableViewCell *)recognizer.view;
    if(cell.accessoryType==UITableViewCellAccessoryCheckmark) {
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.arrSelectedIndex removeObject:[NSString stringWithFormat:@"%d",rowTag]];
        if ([arrPicker count]>0) {
            if (_isMultiSelection && self.arrSelectedIndex.count) {
                
                id object = [arrPicker objectAtIndex:[[self.arrSelectedIndex lastObject]intValue]];
                NSString *str = nil;
                if ([object isKindOfClass:[NSDictionary class]]) {
                    str = [object valueForKey:@"DataTextField"];
                }
                else
                    str = @"";
                _block(str,rowTag);
            }
            else {
                _block(@"",rowTag);
            }
        }
        else {
            _block(@"Error",-1);
        }
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        if(_isMultiSelection==NO)
        {
            if([self.arrSelectedIndex count]>0)
            {
                [self.arrSelectedIndex removeAllObjects];
            }
        }
        if(![self.arrSelectedIndex containsObject:[NSString stringWithFormat:@"%d",rowTag]])
        {
          [self.arrSelectedIndex addObject:[NSString stringWithFormat:@"%d",rowTag]];
        }
        [picker reloadAllComponents];
        if ([arrPicker count]>0) {
            
            id object = [arrPicker objectAtIndex:rowTag];
            NSString *str = nil;
            if ([object isKindOfClass:[NSDictionary class]]) {
                str = [object valueForKey:@"DataTextField"];
            }
            else
                str = object;
            _block(str,rowTag);
        }
        else {
            _block(@"Error",-1);
        }
    }
}



@end


#pragma mark - CommonFunction Class



@implementation CommonFunctionClass

#pragma mark - Date and Time Conversion Methods


+(NSDate*)dateFromString:(NSString*)dateString {
    
    dateString = [[dateString stringByReplacingOccurrencesOfString:@"PM" withString:@""] stringByReplacingOccurrencesOfString:@"AM" withString:@""];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy hh:mm:ss"];
    [df setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    if ([dateString length]>18) {
        return [df dateFromString:[dateString substringToIndex:18]];
    }
    return [df dateFromString:dateString];
}

+(NSString*)stringFromDate:(NSDate*)date {
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy hh:mm:ss"];
    [df setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    return [df stringFromDate:date];
}

+(NSString*)stringFromDateInLocalTimeZone:(NSDate*)date {
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy hh:mm:ss"];
    [df setTimeZone:[NSTimeZone defaultTimeZone]];
    return [df stringFromDate:date];
}

+(NSDate*)dateFromStringInLocalTimeZone:(NSString*)dateString {
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy hh:mm:ss"];
    [df setTimeZone:[NSTimeZone defaultTimeZone]];
    return [df dateFromString:dateString];
}


#pragma mark - Email Validation Method
+(BOOL) validateEmail: (NSString *) candidate {
	
	NSString *emailString = candidate; // storing the entered email in a string.
	
	// Regular expression to check the email format.
	NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailReg];
	
	if (([emailTest evaluateWithObject:emailString] != YES) || [emailString isEqualToString:@""]) {
		return FALSE;
	}
	return TRUE;
}

+(BOOL)validateNumeric:(NSString *)stringToMatch
{
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789-_.'\","] invertedSet];
    
    if ([stringToMatch rangeOfCharacterFromSet:set].location != NSNotFound) {
        
        return FALSE;
    }
    else{
        return TRUE;
    }
}
+(BOOL)validateOnlyNumeric:(NSString *)stringToMatch
{
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *trimmedString = [stringToMatch stringByTrimmingCharactersInSet:set];
    
    if([trimmedString length])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
+(BOOL)validateSpecialCharacters:(NSString *)stringToMatch
{
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"!@#$%^&*()_+|=-/.,;':~`[]{}<>?\""] invertedSet];
    
    NSString *trimmedString = [stringToMatch stringByTrimmingCharactersInSet:set];
    
    if([trimmedString length])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+(BOOL)validateAlphaNumerics:(NSString *)stringToMatch
{
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"] invertedSet];
    NSString *trimmedString = [stringToMatch stringByTrimmingCharactersInSet:set];
    
    if([trimmedString length])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+(BOOL)validateAlphabets:(NSString *)stringToMatch
{
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"] invertedSet];
    
    if ([stringToMatch rangeOfCharacterFromSet:set].location != NSNotFound) {
        
        return FALSE;
    }
    else{
        return TRUE;
    }
}

#pragma mark - Empty String Validation Method
+(BOOL) IsBlank: (NSString *) strInput {
	NSString *tmp = [strInput stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
	if ([tmp length]>0)
		return FALSE;
	else
	{
		return TRUE;
	}
}

#pragma mark - Alert View Custom Method

+(void)fnAlert:(NSString*) msg{
    
	UIAlertView *myAlertView=[[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
	[myAlertView show];
}

#pragma mark - Calculate label height dynamically

+ (CGFloat) heightOfLabel :(NSString*)text andWidth:(CGFloat)width fontName:(NSString *)name fontSize:(CGFloat)size
{
	CGSize titleSize = {0, 0};
    //DLog(@"text=%@,size=%f",text,size);
	if (text && ![text isEqualToString:@""])
		titleSize = [text sizeWithFont:[UIFont fontWithName:name size:size]
                     constrainedToSize:CGSizeMake(width, 999)
                         lineBreakMode:NSLineBreakByWordWrapping];
	return titleSize.height;
}

#pragma mark - Calculate label height dynamically

+ (CGFloat) widthOfLabel :(NSString*)text andWidth:(CGFloat)width fontSize:(CGFloat)size
{
	CGSize titleSize = {0, 0};
    //  DLog(@"text=%@,size=%f",text,size);
	if (text && ![text isEqualToString:@""])
		titleSize = [text sizeWithFont:[UIFont boldSystemFontOfSize:size]
                     constrainedToSize:CGSizeMake(width, 999)
                         lineBreakMode:NSLineBreakByWordWrapping];
	return titleSize.width;
}

+(NSString *)convertDateToString:(NSString *)strFormat :(NSDate *)date
{
    NSString *strDate;
    NSDateFormatter *dtFormatter = [[NSDateFormatter alloc] init];
    [dtFormatter setDateFormat:strFormat];
    [dtFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    strDate = [dtFormatter stringFromDate:date];
    strDate = strDate == nil?@"":strDate;
    return strDate;
}
+(NSDate *)convertStringToDate :(NSString *)strFormat strDate:(NSString *)strDate
{
    NSDate *dtDate;
    NSDateFormatter *dtFormatter = [[NSDateFormatter alloc] init];
    [dtFormatter setDateFormat:strFormat];
    [dtFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    dtDate = [dtFormatter dateFromString:strDate];
    // dtDate = dtDate == nil?[NSDate date]:dtDate;
    return dtDate;
}

+(NSInteger)returnDifference:(NSDate *)date selectedDate:(NSDate *)dateSelected
{
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:date];
    // dateComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:date];
    NSInteger year=[dateComponents year];
    dateComponents = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:date];
    NSInteger month = [dateComponents month];
    dateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:date];
    NSInteger day = [dateComponents day];
    
    NSDateComponents *dateComponentsSelectedDate = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:dateSelected];
    //dateComponentsSelectedDate = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:dateSelected];
    NSInteger yearSelectedDate=[dateComponentsSelectedDate year];
    dateComponentsSelectedDate = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:dateSelected];
    NSInteger monthSelected = [dateComponentsSelectedDate month];
    dateComponentsSelectedDate = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:dateSelected];
    NSInteger daySelected = [dateComponentsSelectedDate day];
    
    NSInteger yearDifference = 0;
    
    if (monthSelected<=month) {
        
        if(daySelected>day)
        {
            if((year-yearSelectedDate)>0){
                yearDifference = (year-yearSelectedDate)-1;
            }
        }
        else{
            yearDifference = (year-yearSelectedDate);
        }
    }
    else{
        
        if((year-yearSelectedDate)>0)
        {
            yearDifference = (year-yearSelectedDate)-1;
        }
    }
    return yearDifference;
    
}



@end


