//
//  IBReferEmailVC.m
//  iBuddyClient
//
//  Created by Anubha on 11/12/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import "IBReferEmailVC.h"
#define kPlusFactorRefer 5
#define  kCellWidthiPhoneRefer 145
#define kCellWidthiPadRefer 445
#define kReferAlertTag 4545
@interface IBReferEmailVC ()
@property (weak, nonatomic) IBOutlet UITableView *tblRecords;
@property (weak, nonatomic) IBOutlet UILabel *lblCopyRight;

@end

@implementation IBReferEmailVC
@synthesize tblCustomCellAddress,strReferType,lblCopyRight;

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

-(void)setInitialVariables
{
     self.lblCopyRight.text = [CommonFunction getCopyRightText];
    arrRecords=[[NSMutableArray alloc]init];
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *textField = (UILabel *)view;
            textField.font=[UIFont fontWithName:kFont size:textField.font.pointSize];
        }
    }
    [self getAllFundraisers];
}
#pragma mark - Button Actions

- (IBAction)btnAddClicked:(id)sender {
    if ([arrRecords count]<10) {
        IBAddReferEmailVC *objIBAddressVC;
        if (kDevice==kIphone) {
            objIBAddressVC=[[IBAddReferEmailVC alloc]initWithNibName:@"IBAddReferEmailVC" bundle:nil];
        }
        else{
            objIBAddressVC=[[IBAddReferEmailVC alloc]initWithNibName:@"IBAddReferEmailVC_iPad" bundle:nil];
        }
        objIBAddressVC.arrRecords =arrRecords;
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        if ([arrFundraisers count]>0) {
            [dict setObject:arrFundraisers forKey:@"fundraisersList"];
        }
        [dict setObject:@"AddMode" forKey:@"ModeType"];
        [dict setObject:strReferType forKey:@"strReferType"];

        objIBAddressVC.dictAddressIndexInfo = dict;
        [self.navigationController pushViewController:objIBAddressVC animated:YES];
    }
    else{
        [CommonFunction fnAlert:@"Alert" message:@"Not more than 10 addresses are allowed."];
    }
}

- (IBAction)btnSubmitClicked:(id)sender {
    if ([arrRecords count]==0) {
        if ([strReferType isEqualToString:kReferEmail]) {
            [CommonFunction fnAlert:@"Alert" message:@"At least fill one Email to post."];
        }
        else{
            [CommonFunction fnAlert:@"Alert" message:@"At least fill one Phone No to post."];
        }
    }
    else{
        [self postRecords];
    }
    
}
-(void)btn_EditClicked:(id)sender
{
    IBAddReferEmailVC *objIBAddressVC;
    if (kDevice==kIphone) {
        objIBAddressVC=[[IBAddReferEmailVC alloc]initWithNibName:@"IBAddReferEmailVC" bundle:nil];
    }
    else{
        objIBAddressVC=[[IBAddReferEmailVC alloc]initWithNibName:@"IBAddReferEmailVC_iPad" bundle:nil];
    }
    objIBAddressVC.arrRecords =arrRecords;
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:[NSNumber numberWithInt:[sender tag]] forKey:@"selectedArrayIndex"];
    if ([arrFundraisers count]>0) {
        [dict setObject:arrFundraisers forKey:@"fundraisersList"];
    }
    [dict setObject:@"EditMode" forKey:@"ModeType"];
    [dict setObject:strReferType forKey:@"strReferType"];

    objIBAddressVC.dictAddressIndexInfo = dict;
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
    static NSString *CellIdentifier = @"IBReferFriend";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (kDevice==kIphone) {
        if (cell == nil){
            [[NSBundle mainBundle] loadNibNamed:@"IBReferCustomCell_iPhone" owner:self options:nil];
            cell=tblCustomCellAddress;
        }
    }
    else{
        if (cell == nil){
            [[NSBundle mainBundle] loadNibNamed:@"IBReferCustomCell_iPad" owner:self options:nil];
            cell=tblCustomCellAddress;
        }
    }
    cell.backgroundColor=nil;
    UILabel *lblFriendName=(UILabel *)[cell viewWithTag:1001];
    UILabel *lblNPOName=(UILabel *)[cell viewWithTag:1002];
    UILabel *lblCode=(UILabel *)[cell viewWithTag:1003];
    UILabel *lblEmail=(UILabel *)[cell viewWithTag:1004];
    UILabel *lblRefererName=(UILabel *)[cell viewWithTag:1005];

   
    UILabel *txtFriendName=(UILabel *)[cell viewWithTag:101];
    txtFriendName.text=[[arrRecords objectAtIndex:indexPath.row]valueForKey:@"Friend Name"];
    
    UILabel *txtNPOName=(UILabel *)[cell viewWithTag:102];
    txtNPOName.text=[[arrRecords objectAtIndex:indexPath.row]valueForKey:@"NPO Name"];
    
    UILabel *txtCode=(UILabel *)[cell viewWithTag:103];
    txtCode.text=[[arrRecords objectAtIndex:indexPath.row]valueForKey:@"Fundraising Code"];
    
    UILabel *txtEmail=(UILabel *)[cell viewWithTag:104];
    
    UILabel *txtRefererName=(UILabel *)[cell viewWithTag:105];
    txtRefererName.text=[[arrRecords objectAtIndex:indexPath.row]valueForKey:@"refererName"];
    
    if ([strReferType isEqualToString:kReferEmail]) {
        lblEmail.text=@"Friend's Email";
        txtEmail.text=[[arrRecords objectAtIndex:indexPath.row]valueForKey:@"Email"];

    }
    else{
        lblEmail.text=@"Friend's Phone No";
        txtEmail.text=[[arrRecords objectAtIndex:indexPath.row]valueForKey:@"PhoneNumber"];

    }
    
    NSArray *arrLabels=[[NSMutableArray alloc]initWithObjects:lblFriendName,txtFriendName,lblRefererName,txtRefererName,lblNPOName,txtNPOName,lblCode,txtCode,lblEmail,txtEmail, nil];
    
    NSArray *arrLabelValues=[[NSMutableArray alloc]initWithObjects:@"Friend's Name",[[arrRecords objectAtIndex:indexPath.row]valueForKey:@"Friend Name"],@"Referrer Name",[[arrRecords objectAtIndex:indexPath.row]valueForKey:@"refererName"],@"Fundraiser Name",[[arrRecords objectAtIndex:indexPath.row]valueForKey:@"NPO Name"],@"Fundraising Code",[[arrRecords objectAtIndex:indexPath.row]valueForKey:@"Fundraising Code"],lblEmail.text,txtEmail.text, nil];
    
    NSArray *kFonts=[[NSMutableArray alloc]initWithObjects:@"Helvetica Neue",kFont2,@"Helvetica Neue",kFont2,@"Helvetica Neue",kFont2,@"Helvetica Neue",kFont2,@"Helvetica Neue",kFont2, nil];
    
    NSArray *incrementParameter=[[NSMutableArray alloc]initWithObjects:@"X",@"X",@"Y",@"X",@"Y",@"X",@"Y",@"X",@"Y",@"X", nil];
    
    [[SharedManager sharedManager] setFrames:arrLabels labelValues:arrLabelValues incrementType:incrementParameter kFonts:kFonts plusfactor:5 initialYValue:0];
    
    UIImageView *imgDivider=(UIImageView *)[cell viewWithTag:106];
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
            btn_Edit.frame=CGRectMake(260,35,40,40);
            [btn_Edit setBackgroundImage:[UIImage imageNamed:@"icon_edit@2x.png"] forState:UIControlStateNormal];
        }
        else{
            btn_Edit.frame=CGRectMake(660,40,47,47);
            [btn_Edit setBackgroundImage:[UIImage imageNamed:@"icon_edit~ipad"] forState:UIControlStateNormal];
        }
        [btn_Edit addTarget:self action:@selector(btn_EditClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn_Edit];
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    IBAddReferEmailVC *objIBAddressVC;
    if (kDevice==kIphone) {
        objIBAddressVC=[[IBAddReferEmailVC alloc]initWithNibName:@"IBAddReferEmailVC" bundle:nil];
    }
    else{
        objIBAddressVC=[[IBAddReferEmailVC alloc]initWithNibName:@"IBAddReferEmailVC_iPad" bundle:nil];
    }
    objIBAddressVC.arrRecords =arrRecords;
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:[NSNumber numberWithInteger:indexPath.row] forKey:@"selectedArrayIndex"];
    objIBAddressVC.dictAddressIndexInfo = dict;
    [dict setObject:@"EditMode" forKey:@"ModeType"];
    [dict setObject:strReferType forKey:@"strReferType"];
    [self.navigationController pushViewController:objIBAddressVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height=0;
    NSString *strAddress;
    if ([strReferType isEqualToString:kReferEmail]) {
        strAddress=[[arrRecords objectAtIndex:indexPath.row]valueForKey:@"Email"];
    }
    else{
        strAddress=[[arrRecords objectAtIndex:indexPath.row]valueForKey:@"PhoneNumber"];
    }
    
    if (kDevice==kIphone) {
        height=[CommonFunction heightOfLabel:[[arrRecords objectAtIndex:indexPath.row]valueForKey:@"Friend Name"] andWidth:kCellWidthiPhoneRefer fontName:kFont2 fontSize:13]+[CommonFunction heightOfLabel:[[arrRecords objectAtIndex:indexPath.row]valueForKey:@"refererName"] andWidth:kCellWidthiPhoneRefer fontName:kFont2 fontSize:13]+[CommonFunction heightOfLabel:[[arrRecords objectAtIndex:indexPath.row]valueForKey:@"NPO Name"] andWidth:kCellWidthiPhoneRefer fontName:kFont2 fontSize:13]+[CommonFunction heightOfLabel:[[arrRecords objectAtIndex:indexPath.row]valueForKey:@"Fundraising Code"] andWidth:kCellWidthiPhoneRefer fontName:kFont2 fontSize:13]+[CommonFunction heightOfLabel:strAddress andWidth:kCellWidthiPhoneRefer fontName:kFont2 fontSize:13]+(kPlusFactorRefer*5)+10;
    }
    else{
        height=[CommonFunction heightOfLabel:[[arrRecords objectAtIndex:indexPath.row]valueForKey:@"Friend Name"] andWidth:kCellWidthiPadRefer fontName:kFont2 fontSize:15]+[CommonFunction heightOfLabel:[[arrRecords objectAtIndex:indexPath.row]valueForKey:@"refererName"] andWidth:kCellWidthiPadRefer fontName:kFont2 fontSize:15]+[CommonFunction heightOfLabel:[[arrRecords objectAtIndex:indexPath.row]valueForKey:@"NPO Name"] andWidth:kCellWidthiPadRefer fontName:kFont2 fontSize:15]+[CommonFunction heightOfLabel:[[arrRecords objectAtIndex:indexPath.row]valueForKey:@"Fundraising Code"] andWidth:kCellWidthiPadRefer fontName:kFont2 fontSize:15]+[CommonFunction heightOfLabel:strAddress andWidth:kCellWidthiPadRefer fontName:kFont2 fontSize:15]+(kPlusFactorRefer*5)+10;
    }
    return height;
}
#pragma mark-
#pragma mark - Webservice Methods
-(void)postRecords{
    //referr_by
     NSMutableArray *arr =[[NSMutableArray alloc] init];
    if([arrRecords count]>0)
       
        for(int i=0;i<arrRecords.count;i++)
        {
            [[arrRecords objectAtIndex:i] setValue:[[kAppDelegate dictUserInfo]valueForKey:@"userId"] forKey:@"referr_by"];
          
            NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] initWithDictionary:[arrRecords objectAtIndex:i]];
            [arr addObject:dict1];
            
        }
    
    
      NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSError *error;
    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:arrRecords options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
    
    
//    [dict setValue:strReferType forKey:@"referType"];
//    [dict setValue:@"CyclingWins" forKey:@"app"];
    [dict setValue:arr forKey:@"data"];
    NSLog(@"%@",dict);
    [kAppDelegate showProgressHUD:self.view];
    [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:(NSMutableDictionary *) dict method:kReferAFriend] completeBlock:^(NSData *data) {
        id result = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions error:nil];
        if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Success!" message:@"Refer a Friend complete!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            alert.tag=kReferAlertTag;
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

-(void)getAllFundraisers{
    arrFundraisers=[[NSMutableArray alloc]init];
    [[SharedManager sharedManager]getFundraisers:@"" completeBlock:^(NSData *data) {
        NSError* error;
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:data
                              options:kNilOptions
                              error:&error];
        arrFundraisers =[json valueForKey:@"fundraisers"];
    } errorBlock:^(NSError *error) {
        
    }];
}
#pragma mark - Alert View Delegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView tag]==kReferAlertTag && buttonIndex==0) {
        [self btnBackClicked:nil];
       }
}

@end
