//
//  IBSalepersonSearchVC.m
//  iBuddyClient
//
//  Created by Anubha on 18/11/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import "IBSalepersonSearchVC.h"

@interface IBSalepersonSearchVC ()
@property (weak, nonatomic) IBOutlet UILabel *lblScreenTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnSales;
@property (weak, nonatomic) IBOutlet UIButton *btnFundraiser;
@property (weak, nonatomic) IBOutlet UIButton *btnStudent;
@property (weak, nonatomic) IBOutlet UIButton *btnSchool;

@property (weak, nonatomic) IBOutlet UIButton *btnCity;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) NSString *strSelectionType;
@property (strong, nonatomic) IBOutlet UIView *vwPopUp;
@property (weak, nonatomic) IBOutlet UILabel *lblFundraiserTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblFundraiserDescription;
@property (weak, nonatomic) IBOutlet UIScrollView *scrlView;
@property (weak, nonatomic) IBOutlet UILabel *lblStaticText;

@end

@implementation IBSalepersonSearchVC
@synthesize tblCustomCellSalespersonCode,lblCopyRight;
#pragma mark - LifeCycle

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Set Initial Labels
/**
 Set initial labels
 */
-(void)setInitialVariables
{
      self.lblCopyRight.text = [CommonFunction getCopyRightText];
    self.lblScreenTitle.font=[UIFont fontWithName:kFont size:self.lblScreenTitle.font.pointSize];
    self.lblFundraiserTitle.font=[UIFont fontWithName:kFont size:self.lblFundraiserTitle.font.pointSize];
    self.lblFundraiserDescription.font=[UIFont fontWithName:_lblFundraiserDescription.font.fontName size:self.lblFundraiserDescription.font.pointSize];

    self.btnSales.titleLabel.font=[UIFont fontWithName:kFont size:_btnSales.titleLabel.font.pointSize];
    self.btnFundraiser.titleLabel.font=[UIFont fontWithName:kFont size:_btnSales.titleLabel.font.pointSize];
    self.btnCity.titleLabel.font=[UIFont fontWithName:kFont size:_btnSales.titleLabel.font.pointSize];
    _strSelectionType=@"school";
     if(!iOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
      [[_searchBar.subviews objectAtIndex:0]removeFromSuperview];
     }
    _vwPopUp.frame=CGRectMake(_vwPopUp.frame.origin.x, _vwPopUp.frame.origin.y, _vwPopUp.frame.size.width, kAppDelegate.window.frame.size.height);
    _vwPopUp.alpha=0;
    [kAppDelegate.window addSubview:_vwPopUp];
    [self setButtonImages:_btnSchool];
    [self reloadTable];
}
#pragma mark Button Actions
- (IBAction)btnSchoolClicked:(id)sender
{
    _lblStaticText.text=@"Enter fundraiser name or fundraiser code.";
    [self setButtonImages:_btnSchool];
    [self reloadTable];

}
- (IBAction)btnStudentClicked:(id)sender
{
    _lblStaticText.text=@"Enter player name or player code.";
    [self setButtonImages:_btnStudent];
    [self reloadTable];

}
- (IBAction)btnSalesClicked:(id)sender {
    _lblStaticText.text=@"Enter Salesforce name or Salesforce code.";
    [self setButtonImages:_btnSales];
    [self reloadTable];
}

- (IBAction)btnFundriserClicked:(id)sender {
    _lblStaticText.text=@"Enter Fundraiser name or Fundraiser code.";

    [self setButtonImages:_btnFundraiser];
    [self reloadTable];
}

- (IBAction)btnCityClicked:(id)sender {
    _lblStaticText.text=@"Enter City name.";

    [self setButtonImages:_btnCity];
    [self reloadTable];

}

- (IBAction)btnSearchClicked:(id)sender {
    [_searchBar resignFirstResponder];
    [self getSalespersonList:_strSelectionType];
}

- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)btn_ViewClicked:(id)sender
{
    if([_strSelectionType isEqualToString:@"school"] || [_strSelectionType isEqualToString:@"student"])
    {
        [self getSalespersonDetail:[[[self.dict_SalespersonCodesList valueForKey:@"data"]objectAtIndex:[sender tag]]valueForKey:@"schoolId"]];

        
    }
    else
    {
    [self getSalespersonDetail:[[[self.dict_SalespersonCodesList valueForKey:@"data"]objectAtIndex:[sender tag]]valueForKey:@"id"]];
    }
    
}
#pragma mark - Set Selected Images Methods

/*** Method to set Images
 */
- (void)setButtonImages:(UIButton*)button {
    
    if (kDevice==kIphone) {
        if (button ==  _btnSales) {
            _btnSales.userInteractionEnabled=NO;
            [_btnSales setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tab-2_hr@2x" ofType:@"png"]] forState:UIControlStateNormal];
            _strSelectionType=@"salesperson";
        }
        else {
            _btnSales.userInteractionEnabled=YES;
            [_btnSales setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
        if (button ==  _btnFundraiser) {
            _btnFundraiser.userInteractionEnabled=NO;
            [_btnFundraiser setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tab-1_hr@2x" ofType:@"png"]] forState:UIControlStateNormal];
            _strSelectionType=@"fundraiser";

        }
        else {
            _btnFundraiser.userInteractionEnabled=YES;
            [_btnFundraiser setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
        if (button == _btnCity) {
            _btnCity.userInteractionEnabled=NO;
            [_btnCity setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tab-3_hr@2x" ofType:@"png"]] forState:UIControlStateNormal];
            _strSelectionType=@"city";

        }
        else {
            _btnCity.userInteractionEnabled=YES;
            [_btnCity setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
        if (button ==  _btnSchool)
        {
            _btnSchool.userInteractionEnabled=NO;
            [_btnSchool setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tab-1_hr@2x~ipad" ofType:@"png"]] forState:UIControlStateNormal];
            
            _strSelectionType=@"school";
        }
        else
        {
            _btnSchool.userInteractionEnabled=YES;
            [_btnSchool setBackgroundImage:[UIImage imageNamed:@"tab-1.png"] forState:UIControlStateNormal];
            
        }
        
        if (button ==  _btnStudent) {
            _btnStudent.userInteractionEnabled=NO;
            [_btnStudent setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tab-3_hr@2x" ofType:@"png"]] forState:UIControlStateNormal];
            _strSelectionType=@"student";
        }
        else {
          //  [_btnStudent setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tab-3" ofType:@"png"]] forState:UIControlStateNormal];
            [_btnStudent setBackgroundImage:[UIImage imageNamed:@"tab-3.png"] forState:UIControlStateNormal];

            _btnStudent.userInteractionEnabled=YES;
        }
    }
    else{
        if (button ==  _btnSchool) {
            _btnSchool.userInteractionEnabled=NO;
            [_btnSchool setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"red_tab-1_hr@2x~ipad" ofType:@"png"]] forState:UIControlStateNormal];
            
            _strSelectionType=@"school";
        }
        else {
            _btnSchool.userInteractionEnabled=YES;
            [_btnSchool setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tab-1p_hr@2x~ipad" ofType:@"png"]] forState:UIControlStateNormal];

        }
        
        if (button ==  _btnStudent) {
            _btnStudent.userInteractionEnabled=NO;
            [_btnStudent setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"red_tab-3_hr@2x~ipad" ofType:@"png"]] forState:UIControlStateNormal];
            _strSelectionType=@"student";
        }
        else {
            [_btnStudent setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tab-3p_hr@2x~ipad" ofType:@"png"]] forState:UIControlStateNormal];

            _btnStudent.userInteractionEnabled=YES;
        }
        
        if (button ==  _btnSales) {
            _btnSales.userInteractionEnabled=NO;
            [_btnSales setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tab-2_hr@2x~ipad" ofType:@"png"]] forState:UIControlStateNormal];
            _strSelectionType=@"salesperson";

        }
        else {
            _btnSales.userInteractionEnabled=YES;
            [_btnSales setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
        if (button ==  _btnFundraiser) {
            _btnFundraiser.userInteractionEnabled=NO;
            [_btnFundraiser setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tab-1_hr@2x~ipad" ofType:@"png"]] forState:UIControlStateNormal];
            _strSelectionType=@"fundraiser";

        }
        else {
            _btnFundraiser.userInteractionEnabled=YES;
            
            [_btnFundraiser setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
        if (button == _btnCity) {
            _btnCity.userInteractionEnabled=NO;
            [_btnCity setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tab-3_hr@2x~ipad" ofType:@"png"]] forState:UIControlStateNormal];
            _strSelectionType=@"city";

        }
        else {
            _btnCity.userInteractionEnabled=YES;
            [_btnCity setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
        }
}

#pragma mark-
#pragma mark - delegate Methods

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
    NSMutableArray *arrData=[self.dict_SalespersonCodesList valueForKey:@"data"];

    return [arrData count] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        static NSString *CellIdentifier = @"salespersonCellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (kDevice==kIphone) {
            if (cell == nil){
                [[NSBundle mainBundle] loadNibNamed:@"IBSalesPersonTableCell_iPhone" owner:self options:nil];
                cell=tblCustomCellSalespersonCode;
            }
        }
        else{
            if (cell == nil){
                [[NSBundle mainBundle] loadNibNamed:@"IBSalesPersonTableCell_iPad" owner:self options:nil];
                cell=tblCustomCellSalespersonCode;
            }
        }
    cell.backgroundColor=nil;
    UILabel *lblName=(UILabel *)[cell viewWithTag:101];
    lblName.textColor=[UIColor whiteColor];
    lblName.adjustsFontSizeToFitWidth=TRUE;
    lblName.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize];
    
    UILabel *lblSalespersonCode=(UILabel *)[cell viewWithTag:102];
    lblSalespersonCode.textColor=[UIColor whiteColor];
    lblSalespersonCode.adjustsFontSizeToFitWidth=TRUE;
    lblSalespersonCode.font=[UIFont italicSystemFontOfSize:lblSalespersonCode.font.pointSize];
    
    UILabel *lblFundraiser=(UILabel *)[cell viewWithTag:103];
      lblFundraiser.textColor=[UIColor whiteColor];
    lblFundraiser.adjustsFontSizeToFitWidth=TRUE;
    lblFundraiser.font=[UIFont fontWithName:kFont size:lblFundraiser.font.pointSize];
    if ([_strSelectionType isEqualToString:@"salesperson"]) {
        lblName.text=[[[self.dict_SalespersonCodesList valueForKey:@"data"]objectAtIndex:indexPath.row]valueForKey:@"name"];
        lblFundraiser.text=[[[self.dict_SalespersonCodesList valueForKey:@"data"]objectAtIndex:indexPath.row]valueForKey:@"fundraiser"];
        lblSalespersonCode.text=[[[self.dict_SalespersonCodesList valueForKey:@"data"]objectAtIndex:indexPath.row]valueForKey:@"code"];

    }
    else if ([_strSelectionType isEqualToString:@"school"] || [_strSelectionType isEqualToString:@"student"]) {
        lblName.text=[[[self.dict_SalespersonCodesList valueForKey:@"data"]objectAtIndex:indexPath.row]valueForKey:@"name"];
        lblFundraiser.text=[[[self.dict_SalespersonCodesList valueForKey:@"data"]objectAtIndex:indexPath.row]valueForKey:@"npo"];
        lblSalespersonCode.text=[[[[self.dict_SalespersonCodesList valueForKey:@"data"]objectAtIndex:indexPath.row]valueForKey:@"npo_code"] stringByAppendingString:[@"-" stringByAppendingString:[[[self.dict_SalespersonCodesList valueForKey:@"data"]objectAtIndex:indexPath.row]valueForKey:@"code"]]];

    }

    else{
        lblName.text=[[[self.dict_SalespersonCodesList valueForKey:@"data"]objectAtIndex:indexPath.row]valueForKey:@"fundraiser"];
        lblFundraiser.text=[[[self.dict_SalespersonCodesList valueForKey:@"data"]objectAtIndex:indexPath.row]valueForKey:@"name"];
        lblSalespersonCode.text=[[[self.dict_SalespersonCodesList valueForKey:@"data"]objectAtIndex:indexPath.row]valueForKey:@"code"];

    }
    if ([[cell.contentView.subviews lastObject]isKindOfClass:[UIButton class]]) {
        UIButton *btn=(UIButton *)[cell.contentView.subviews lastObject];
        if (kDevice==kIphone) {
            [btn setBackgroundImage:[UIImage imageNamed:@"icon_view-detail@2x.png"] forState:UIControlStateNormal];
        }
        else{
            [btn setBackgroundImage:[UIImage imageNamed:@"icon_view-detai~ipad"] forState:UIControlStateNormal];
        }
        btn.tag= indexPath.row;
    }
    else{
        UIButton  *btn_View=[UIButton buttonWithType:UIButtonTypeCustom];
        btn_View.tag= indexPath.row;
        if (kDevice==kIphone) {
            btn_View.frame=CGRectMake(215,20,40,40);
            [btn_View setBackgroundImage:[UIImage imageNamed:@"icon_view-detail@2x.png"] forState:UIControlStateNormal];
        }
        else{
            btn_View.frame=CGRectMake(520,28,48,48);
            [btn_View setBackgroundImage:[UIImage imageNamed:@"icon_view-detai~ipad"] forState:UIControlStateNormal];
        }
        [btn_View addTarget:self action:@selector(btn_ViewClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn_View];
    }

    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([_strSelectionType isEqualToString:@"school"] || [_strSelectionType isEqualToString:@"student"]) {
        [CommonFunction setValueInUserDefault:@"SearchedSalesperson" value:[[[[self.dict_SalespersonCodesList valueForKey:@"data"]objectAtIndex:indexPath.row]valueForKey:@"npo_code"] stringByAppendingString:[@"-" stringByAppendingString:[[[self.dict_SalespersonCodesList valueForKey:@"data"]objectAtIndex:indexPath.row]valueForKey:@"code"]]]];

        
    }
    else
        
    {
        [CommonFunction setValueInUserDefault:@"SearchedSalesperson" value:[[[self.dict_SalespersonCodesList valueForKey:@"data"]objectAtIndex:indexPath.row]valueForKey:@"code"]];

    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height=0;
    if (kDevice==kIphone) {
        height=72;
    }
    else{
        height=90;
    }
    return height;
    
}
-(void)reloadTable{
    [kAppDelegate showProgressHUD];
    self.dict_SalespersonCodesList=nil;
    [_tblView reloadData];
    _searchBar.text=@"";
    [kAppDelegate hideProgressHUD];
}
#pragma mark -
#pragma mark - WebService
/**
 @Method   -  getMerchantOffer - -> get merchant offer list
 @param    -  merchantId
 @Responce -  status = 1 -> success - return offersList
 status = 0 -> no records
 status = -1 -> error
 */

-(void)getSalespersonList:(NSString *)paramType
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:_searchBar.text forKey:paramType];
    [kAppDelegate showProgressHUD:self.view];
    [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:(NSMutableDictionary *) dict method:kGetSalesperson] completeBlock:^(NSData *data) {
        
        id result = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions error:nil];
        
        if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
            if (self.dict_SalespersonCodesList)
            {
                self.dict_SalespersonCodesList=nil;
            }
            self.tblView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
            self.dict_SalespersonCodesList=[[NSMutableDictionary alloc]init];
            self.dict_SalespersonCodesList=result;
            [self.tblView reloadData];
        }
        
        else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]){
            if (self.dict_SalespersonCodesList) {
                self.dict_SalespersonCodesList=nil;
            }
            self.dict_SalespersonCodesList=[[NSMutableDictionary alloc]init];
            self.dict_SalespersonCodesList=result;
            [self.tblView reloadData];
            [CommonFunction fnAlert:@"" message:@"No Records Found"];
        }
        else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]){
            [CommonFunction fnAlert:@"" message:@"Please try again"];
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

-(void)getSalespersonDetail:(NSString *)salespersonID
{

    if([_strSelectionType isEqualToString:@"school"] || [_strSelectionType isEqualToString:@"student"])
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:salespersonID forKey:@"schoolId"];
        [kAppDelegate showProgressHUD:self.view];
        [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:(NSMutableDictionary *) dict method:kgetSchoolDetails] completeBlock:^(NSData *data) {
            
            id result = [NSJSONSerialization JSONObjectWithData:data
                                                        options:kNilOptions error:nil];
            if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
                [kAppDelegate hideProgressHUD];
                [self setPopUp:[NSMutableDictionary dictionaryWithDictionary:result]];
            }
            
            else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]){
                [CommonFunction fnAlert:@"" message:@"No Details exist."];
                [kAppDelegate hideProgressHUD];
                
            }
            else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]){
                [CommonFunction fnAlert:@"" message:@"Please try again"];
                [kAppDelegate hideProgressHUD];
            }
            else {
                [CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
                [kAppDelegate hideProgressHUD];
            }
            
        } errorBlock:^(NSError *error) {
            if (error.code == NSURLErrorTimedOut) {
                [CommonFunction fnAlert:@"Alert!" message:kAlerTimedOut];
            }
            else{
                [CommonFunction fnAlert:@"Error" message:[error localizedDescription]];}
            [kAppDelegate hideProgressHUD];
        }];
    }
    else
    {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:salespersonID forKey:@"salespersonId"];
    [kAppDelegate showProgressHUD:self.view];
    [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:(NSMutableDictionary *) dict method:kgetsalespersondetail] completeBlock:^(NSData *data) {
        
        id result = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions error:nil];
        if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
            [kAppDelegate hideProgressHUD];
            [self setPopUp:[NSMutableDictionary dictionaryWithDictionary:result]];
        }
        
        else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]){
            [CommonFunction fnAlert:@"" message:@"No Details exist."];
            [kAppDelegate hideProgressHUD];

        }
        else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]){
            [CommonFunction fnAlert:@"" message:@"Please try again"];
            [kAppDelegate hideProgressHUD];
        }
        else {
            [CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
            [kAppDelegate hideProgressHUD];
        }
        
    } errorBlock:^(NSError *error) {
        if (error.code == NSURLErrorTimedOut) {
            [CommonFunction fnAlert:@"Alert!" message:kAlerTimedOut];
        }
        else{
            [CommonFunction fnAlert:@"Error" message:[error localizedDescription]];}
        [kAppDelegate hideProgressHUD];
    }];
    }
    
}
#pragma mark - Set Pop Up Methods

-(void)setPopUp:(NSDictionary *)dict{
    NSArray *arrLabels=[[NSMutableArray alloc]initWithObjects:_lblFundraiserTitle,_lblFundraiserDescription, nil];
    NSArray *kFonts=[[NSMutableArray alloc]initWithObjects:kFont,@"Georgia",nil];
    NSArray *incrementParameter=[[NSMutableArray alloc]initWithObjects:@"X",@"Y", nil];

    if([_strSelectionType isEqualToString:@"school"] || [_strSelectionType isEqualToString:@"student"])
    {
        NSArray *arrLabelValues=[[NSMutableArray alloc]initWithObjects:[[dict valueForKey:@"data"]valueForKey:@"s_title"],[[dict valueForKey:@"data"]valueForKey:@"s_description"], nil];
        [[SharedManager sharedManager] setFrames:arrLabels labelValues:arrLabelValues incrementType:incrementParameter kFonts:kFonts plusfactor:5 initialYValue:5];

    }
    else
    {
        NSArray *arrLabelValues=[[NSMutableArray alloc]initWithObjects:[[dict valueForKey:@"data"]valueForKey:@"title"],[[dict valueForKey:@"data"]valueForKey:@"description"], nil];
        [[SharedManager sharedManager] setFrames:arrLabels labelValues:arrLabelValues incrementType:incrementParameter kFonts:kFonts plusfactor:5 initialYValue:5];


    }
    self.scrlView.contentSize=CGSizeMake(0, self.lblFundraiserDescription.frame.origin.y+self.lblFundraiserDescription.frame.size.height+5);
    [[SharedManager sharedManager] subViewAnimation:_vwPopUp];
}

- (IBAction)btnCrossClicked:(id)sender {
    [[SharedManager sharedManager] removeAnimation:_vwPopUp];
}
#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self getSalespersonList:_strSelectionType];
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

@end
