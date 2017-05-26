//
//  IBMerchantByNameViewController.m
//  iBuddyClient
//
//  Created by Neelesh Rai on 12/22/15.
//  Copyright (c) 2015 Netsmartz. All rights reserved.
//

#import "IBMerchantByNameViewController.h"
#define kMerchantTableWidthIPhone 189
#define kMerchantTableWidthIPad 546
#define kIncrementFactorMerchant 5
#define kTableCellGapFromYMerchant 7

@interface IBMerchantByNameViewController ()
{
    BOOL alertDisplayed;

}
@end

@implementation IBMerchantByNameViewController
@synthesize tblMerchants,arrMerchants,txtSearch;
@synthesize tblCustomCellMerchant;
@synthesize dictData;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLayoutForiOS7];
    arrMerchants=[[NSMutableArray alloc]init];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)getMerchantsList:(NSString *)str {
    [kAppDelegate showProgressHUD];
    
    
    [dictData setValue:[NSString stringWithFormat:@"%@",str] forKey:@"merchantName"];
    
    [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:(NSMutableDictionary *)dictData method:@"getSearchedMerchant"] completeBlock: ^(NSData *data) {
        
        id result = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions error:nil];
        if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
            
            arrMerchants=[[NSMutableArray alloc]init];
            //     NSLog(@"[[result valueForKey:@""]count]%d",[[result valueForKey:@"merchantsList"]count]);
            self.tblMerchants.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            NSMutableDictionary *dict_MerchantList = [[NSMutableDictionary alloc]init];
            dict_MerchantList = [result mutableCopy];
            NSArray *arrData=[dict_MerchantList valueForKey:@"merchantDetails"];
            
            [arrMerchants addObjectsFromArray:arrData];
            //[self.dict_MerchantList setObject:arrMerchants forKey:@"merchantsList"];
            alertDisplayed=FALSE;

            [self.tblMerchants reloadData];
        }
        
        else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]) {
            if(alertDisplayed==FALSE)
            {
                [CommonFunction fnAlert:@"" message:@"No match found."];
                alertDisplayed=TRUE;
                [arrMerchants removeAllObjects];
                [self.tblMerchants reloadData];
            }
        }
        else {
            [CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
        }
        [kAppDelegate hideProgressHUD];
    } errorBlock: ^(NSError *error) {
        if (error.code == NSURLErrorTimedOut) {
            [CommonFunction fnAlert:@"Alert!" message:kAlerTimedOut];
        }
        else {
            [CommonFunction fnAlert:@"Error" message:[error localizedDescription]];
        }
        [kAppDelegate hideProgressHUD];
    }];
}
#pragma mark - UITableView Deletgate & Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [arrMerchants count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //        static NSString *CellIdentifier = @"merchantCellIdentifier";
    UITableViewCell *cell = nil;    //[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (kDevice == kIphone) {
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"IBMerchantTableCell_iPhone" owner:self options:nil];
            cell = tblCustomCellMerchant;
        }
    }
    else {
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"IBMerchantCustomCell_iPad" owner:self options:nil];
            cell = tblCustomCellMerchant;
        }
        cell.backgroundColor = nil;
    }
    [self fillMerchantRows:indexPath cell:cell];

   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [CommonFunction callHideViewFromSideBar];
        IBOffersVC *objIBOffersVC;
        if (kDevice == kIphone) {
            objIBOffersVC = [[IBOffersVC alloc]initWithNibName:@"IBOffersVC" bundle:nil];
        }
        else {
            objIBOffersVC = [[IBOffersVC alloc]initWithNibName:@"IBOfffersVC_iPad" bundle:nil];
        }
        NSMutableDictionary *dictMerchantInfo = [[NSMutableDictionary alloc]init];
        [dictMerchantInfo setValue:[[arrMerchants objectAtIndex:indexPath.row] valueForKey:@"merchantId"] forKey:@"merchantId"];
        [dictMerchantInfo setValue:[[arrMerchants objectAtIndex:indexPath.row] valueForKey:@"categoryId"] forKey:@"categoryId"];
        [dictMerchantInfo setValue:@"0" forKey:@"IsEvent"];
        
        objIBOffersVC.dictMerchantInfo = dictMerchantInfo;
        [self.navigationController pushViewController:objIBOffersVC animated:YES];
    //}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    float height = 0;
    float width = 0;
    if (kDevice == kIphone) {
        width = kMerchantTableWidthIPhone;
    }
    else {
        width = kMerchantTableWidthIPad;
    }
        NSString *strStateCityName = [[arrMerchants objectAtIndex:indexPath.row] valueForKey:@"cityName"];
        strStateCityName = [strStateCityName stringByAppendingString:@", "];
        strStateCityName = [[arrMerchants objectAtIndex:indexPath.row] valueForKey:@"stateName"];
        
        height = [CommonFunction heightOfOfferCell:[[arrMerchants objectAtIndex:indexPath.row] valueForKey:@"merchantName"] andWidth:width fontName:kFont fontSize:kAppDelegate.fontSize] + [CommonFunction heightOfOfferCell:strStateCityName andWidth:width fontName:kFont fontSize:kAppDelegate.fontSize] + kTableCellGapFromYMerchant;
  
    
    if (height < 50) {
        height = 50 + kTableCellGapFromYMerchant + kIncrementFactorMerchant;
    }
    else {
        height = height + kIncrementFactorMerchant;
    }
    return height;
}
- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)fillMerchantRows:(NSIndexPath *)indexPath cell:(UITableViewCell *)cell {
    UIImageView *imgView = (UIImageView *)[cell viewWithTag:101];
    [imgView setImageWithURL:[NSURL URLWithString:[[arrMerchants objectAtIndex:indexPath.row] valueForKey:@"thumb"] ]
            placeholderImage:[UIImage imageNamed:@"default_offers_img.png"]];
    
    //Added by UTKARSHA GUPTA to show featured merchants on the top of the list on 26th jun 14
    UIImageView *imgViewFeatured = (UIImageView *)[cell viewWithTag:106];
    NSMutableDictionary *dict=[arrMerchants objectAtIndex:indexPath.row];
    if ([[[arrMerchants objectAtIndex:indexPath.row] valueForKey:@"is_golden_egg_merchant"] isEqualToString:@"1"] ||[[[arrMerchants objectAtIndex:indexPath.row] valueForKey:@"isFeatured"] isEqualToString:@"1"])
        
    {
        [imgViewFeatured setImage:[UIImage imageNamed:@"featured_badge.png"]];
    }
    else {
        [imgViewFeatured setImage:NULL];
    }
    
    UILabel *lblMerchantTitle = (UILabel *)[cell viewWithTag:102];
    lblMerchantTitle.text = [dict valueForKey:@"merchantName"];
    lblMerchantTitle.textColor = [UIColor blackColor];
    // lblMerchantTitle.adjustsFontSizeToFitWidth=TRUE;
    lblMerchantTitle.font = [UIFont fontWithName:kFont size:kAppDelegate.fontSize];
    lblMerchantTitle.frame = CGRectMake(lblMerchantTitle.frame.origin.x, lblMerchantTitle.frame.origin.y, lblMerchantTitle.frame.size.width, [CommonFunction heightOfOfferCell:[dict valueForKey:@"merchantName"] andWidth:lblMerchantTitle.frame.size.width fontName:kFont fontSize:kAppDelegate.fontSize]);
    
    UILabel *lblStateCityName = (UILabel *)[cell viewWithTag:103];
    NSString *strStateCityName = [dict valueForKey:@"cityName"];
    strStateCityName = [strStateCityName stringByAppendingString:@", "];
    strStateCityName = [strStateCityName stringByAppendingString:[dict valueForKey:@"stateName"]];
    lblStateCityName.text = strStateCityName;
    lblStateCityName.textColor = [UIColor blackColor];
    lblStateCityName.adjustsFontSizeToFitWidth = TRUE;
    lblStateCityName.frame = CGRectMake(lblStateCityName.frame.origin.x, lblMerchantTitle.frame.origin.y + lblMerchantTitle.frame.size.height, lblStateCityName.frame.size.width, [CommonFunction heightOfOfferCell:strStateCityName andWidth:lblStateCityName.frame.size.width fontName:kFont fontSize:kAppDelegate.fontSize]);
    lblStateCityName.font = [UIFont italicSystemFontOfSize:lblStateCityName.font.pointSize];
    
    
    UILabel *lblMiles = (UILabel *)[cell viewWithTag:105];
    NSLog(@"%@",[dict valueForKey:@"global_merchant"]);
    if([[dict valueForKey:@"global_merchant"] isEqualToString:@"1"])
    {
        lblMiles.text = @"Nationwide";
        
    }
    else
    {
        lblMiles.text = [dict valueForKey:@"distance"];
        
    }
    lblMiles.hidden=YES;
    lblMiles.textColor = [UIColor blackColor];
    lblMiles.adjustsFontSizeToFitWidth = TRUE;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField == txtSearch) {
        [self getMerchantsList:txtSearch.text];
    }
        return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *str =[textField.text stringByReplacingCharactersInRange:range withString:string];
    if([str length]>=3)
    {
        [self getMerchantsList:str];

    }
    else
    {
        arrMerchants=[[NSMutableArray alloc]init];
        [tblMerchants reloadData];
    }
//    if (textField == txtSearch) {
//        if ((textField.text.length == 0 && string.length > 0) || textField.text.length) {
//            
//        }
//        else
//
//            arrMerchants=[[NSMutableArray alloc]init];
//            [tblMerchants reloadData];
//            
//    }
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
