//
//  KSSplashVC.m
//  iBuddyClient
//
//  Created by krutik on 19/05/17.
//  Copyright © 2017 Netsmartz. All rights reserved.
//

#import "KSSplashVC.h"

@interface KSSplashVC ()

@end

@implementation KSSplashVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _btnSignup.layer.borderColor= [ UIColor whiteColor].CGColor;
    _btnSignup.layer.borderWidth = 0.5  ;
    if(kAppDelegate.dictUserInfo.count > 0)
    {
        _btnLogin.hidden=true;
        _btnSignup.hidden=true;
        [self getPaymentTokenForNewuser];
    }
    else
    {
        _btnLogin.hidden=false;
        _btnSignup.hidden=false;

    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnDashboardClick:(id)sender
{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnSignupClick:(id)sender {
    IBShortRegisterVC *objIBShortRegisterVC;
    if (kDevice==kIphone) {
        objIBShortRegisterVC=[[IBShortRegisterVC alloc]initWithNibName:@"IBShortRegisterVC" bundle:nil];
    }
    else{
        objIBShortRegisterVC=[[IBShortRegisterVC alloc]initWithNibName:@"IBShortRegisterVC_iPad" bundle:nil];
        
    }
    objIBShortRegisterVC.strEditProfile=@"fromSplash";
//    [self.navigationController pushViewController:objPaymentProgramVC animated:YES];
//    kAppDelegate.navController=[[UINavigationController alloc]initWithRootViewController:objIBShortRegisterVC];
    /*commented by Utkarsha to hide Ads it not available
     [self addBottomADView];
     */
//    kAppDelegate.navController.navigationBarHidden = YES;
    [kAppDelegate.navController pushViewController:objIBShortRegisterVC animated:true];
    
//    kAppDelegate.objSideBarVC = [[SideBarVC alloc] initWithNibName:@"SideBarVC" bundle:nil];
//    
//    kAppDelegate.sideMenuController = [LGSideMenuController sideMenuControllerWithRootViewController:kAppDelegate.navController leftViewController:kAppDelegate.objSideBarVC rightViewController:nil];
//    
//    kAppDelegate.sideMenuController.leftViewWidth = 260.0;
//    kAppDelegate.sideMenuController.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideAbove;
//    [kAppDelegate.window setRootViewController:kAppDelegate.navController];


}

-(void)getPaymentTokenForNewuser
{
//    NSLog(@"%@ %@",self.navController.topViewController, self.navController.visibleViewController);
    [kAppDelegate showProgressHUD:kAppDelegate.window];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    /*commented in order to implement not to log out unpaid user*/
    NSString *userID = [[kAppDelegate dictUserInfo]valueForKey:@"userId"];
    NSLog(@"GetPaymentToken");
    [dict setValue:userID forKey:@"userId"];
    [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:dict method:kGetPaymnetToken] completeBlock:^(NSData *data) {
        id result = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions error:nil];
        if([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]])
        {
            [kAppDelegate setDictUserInfo:nil];
            
            [CommonFunction setValueInUserDefault:kZipCode value:@""];
            [CommonFunction setValueInUserDefault:kZipCodeHighlighted value:@""];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kdictUserInfo];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            //            IBLoginVC *objIBLoginVC;
            //            if (kDevice == kIphone) {
            //                objIBLoginVC = [[IBLoginVC alloc]initWithNibName:@"IBLoginVC" bundle:nil];
            //            }
            //            else {
            //                objIBLoginVC = [[IBLoginVC alloc]initWithNibName:@"IBLoginVC_iPad" bundle:nil];
            //            }
            //            [self.navController pushViewController:objIBLoginVC animated:YES];
            [kAppDelegate hideProgressHUD];
            
        }
        else
        {
            if ([[result valueForKey:@"isSubscribed"]isEqualToString:@"1"]) {
                
                //                if(![[result valueForKey:@"last_name"] isEqual:[NSNull null]] && [[result valueForKey:@"last_name"] length]>0)
                //                {
                //                    [CommonFunction setValueInUserDefault:@"userName" value:[result valueForKey:@"first_name"]];
                //
                //                }
                //                else
                //                {
                [CommonFunction setValueInUserDefault:@"userName" value:[result valueForKey:@"first_name"]];
                
                //                }
                [CommonFunction setValueInUserDefault:@"last_name" value:[result valueForKey:@"last_name"]];
                
                NSLog(@"get value %@",[CommonFunction getValueFromUserDefault:@"address"]);
                [CommonFunction setValueInUserDefault:@"address" value:[result valueForKey:@"address"]];
                NSLog(@"get value %@",[CommonFunction getValueFromUserDefault:@"address"]);
                [CommonFunction setValueInUserDefault:@"EmailId" value:[result valueForKey:@"email"]];
                [CommonFunction setValueInUserDefault:@"zipCode" value:[result valueForKey:@"zipcode"]];
                [CommonFunction setValueInUserDefault:@"SelectedState" value:[result valueForKey:@"stateName"]];
                [CommonFunction setValueInUserDefault:@"SelectedCity" value:[result valueForKey:@"cityName"]];
                [CommonFunction setValueInUserDefault:@"SelectedStateID" value:[result valueForKey:@"stateId"]];
                [CommonFunction setValueInUserDefault:@"SelectedCityID" value:[result valueForKey:@"cityId"]];
                //                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshData" object:nil];
                [kAppDelegate hideProgressHUD];
                if (kDevice == kIphone) {
                    kAppDelegate.objIBCategoryVC = [[IBCategoryVC alloc]initWithNibName:@"IBCategoryVC" bundle:nil];
                }
                else {
                    kAppDelegate.objIBCategoryVC = [[IBCategoryVC alloc]initWithNibName:@"IBCategoryVC_iPad" bundle:nil];
                }
                
                /**Initial miles set in merchant class**/
                kAppDelegate.navController = [[UINavigationController alloc] initWithRootViewController:kAppDelegate.objIBCategoryVC];
                kAppDelegate.navController.navigationBarHidden = YES;
                /*commented by Utkarsha to hide Ads it not available
                 [self addBottomADView];
                 */
                
                [kAppDelegate.window makeKeyAndVisible];
                
                kAppDelegate.objSideBarVC = [[SideBarVC alloc] initWithNibName:@"SideBarVC" bundle:nil];
                
                kAppDelegate.sideMenuController = [LGSideMenuController sideMenuControllerWithRootViewController:kAppDelegate.navController leftViewController:kAppDelegate.objSideBarVC rightViewController:nil];
                
                kAppDelegate.sideMenuController.leftViewWidth = 260.0;
                kAppDelegate.sideMenuController.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideAbove;
                [kAppDelegate.window setRootViewController:kAppDelegate.sideMenuController];
                [kAppDelegate addBottomADView];
                
                [kAppDelegate.window makeKeyAndVisible];
                
            }
            else {
                if([[CommonFunction getValueFromUserDefault:kIsPaymentScreenCompleted]boolValue]==1)
                {
                    IBRegisterVC *objIBRegisterVC;
                    if (kDevice==kIphone)
                    {
                        objIBRegisterVC=[[IBRegisterVC alloc]initWithNibName:@"IBRegisterVC" bundle:nil];
                    }
                    else
                    {
                        objIBRegisterVC=[[IBRegisterVC alloc]initWithNibName:@"IBRegisterVC_iPad" bundle:nil];
                    }
                    objIBRegisterVC.strEditProfile=@"Edit";
                    kAppDelegate.navController = [[UINavigationController alloc] initWithRootViewController:objIBRegisterVC];
                    //  objIBRegisterVC.strDetailRegistration=@"DetailRegistration";
                    objIBRegisterVC.strController = @"My Profile";
                    objIBRegisterVC.isNewUser=true;
                    objIBRegisterVC.dictProfileData=[[kAppDelegate dictUserInfo] valueForKey:@"userDetail"];
                    
                    //    [self.navigationController pushViewController:objIBRegisterVC animated:YES];
                    
                    kAppDelegate.objSideBarVC = [[SideBarVC alloc] initWithNibName:@"SideBarVC" bundle:nil];
                    kAppDelegate.navController.navigationBarHidden=true;
                    
                    kAppDelegate.sideMenuController = [LGSideMenuController sideMenuControllerWithRootViewController:kAppDelegate.navController leftViewController:kAppDelegate.objSideBarVC rightViewController:nil];
                    
                    kAppDelegate.sideMenuController.leftViewWidth = 260.0;
                    kAppDelegate.sideMenuController.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideAbove;
                    [kAppDelegate.window setRootViewController:kAppDelegate.sideMenuController];
                    [kAppDelegate addBottomADView];
                    
                    [kAppDelegate.window makeKeyAndVisible];
                    
                }
                else
                {
                    PaymentProgramVC *objPaymentProgramVC;
                    if (kDevice==kIphone) {
                        objPaymentProgramVC=[[PaymentProgramVC alloc]initWithNibName:@"PaymentProgramVC" bundle:nil];
                    }
                    else{
                        objPaymentProgramVC=[[PaymentProgramVC alloc]initWithNibName:@"PaymentProgramVC_iPad" bundle:nil];
                    }
                    //            objIBRegisterVC.strEditProfile=@"Edit";
                    //            //  objIBRegisterVC.strDetailRegistration=@"DetailRegistration";
                    //            objIBRegisterVC.strController = @"My Profile";
                    //            objIBRegisterVC.isNewUser=YES;
                    //  objIBRegisterVC.dictProfileData=[result valueForKey:@"userDetail"];
                    //[[kAppDelegate dictUserInfo]setObject:[dictInfo valueForKey:@"userDetail"] forKey:@"userDetail"];
                    //objIBRegisterVC.dictProfileData=[dictInfo valueForKey:@"userDetail"];
                    // [kAppDelegate.navController presentModalViewController:objIBRegisterVC animated:YES];
                    objPaymentProgramVC.dictProfileData=[[kAppDelegate dictUserInfo] valueForKey:@"userDetail"];
                    kAppDelegate.navController= [[UINavigationController alloc]initWithRootViewController:objPaymentProgramVC];
                    kAppDelegate.navController.navigationBarHidden=true;
                    [kAppDelegate.window setRootViewController:kAppDelegate.navController];
                    [kAppDelegate addBottomADView];
                    
                    [kAppDelegate.window makeKeyAndVisible];
                    
                    
                }
                
                
            }
        }
        
        
        
    }
                     errorBlock:^(NSError *error) {
                         if (error.code == NSURLErrorTimedOut) {
                             [CommonFunction fnAlert:@"Alert!" message:kAlerTimedOut];
                         }
                         else{
                             [CommonFunction fnAlert:@"Error" message:[error localizedDescription]];}
                         [kAppDelegate hideProgressHUD];
                         
                     }];
}

- (IBAction)btnLoginClick:(id)sender {
    IBLoginVC *objIBLoginVC;
    
    if (kDevice == kIphone) {
        objIBLoginVC = [[IBLoginVC alloc]initWithNibName:@"IBLoginVC" bundle:nil];
    }
    else {
        objIBLoginVC = [[IBLoginVC alloc]initWithNibName:@"IBLoginVC_iPad" bundle:nil];
    }
    objIBLoginVC.classType = @"Cards";
//    [kAppDelegate.navController pushViewController:objIBLoginVC animated:YES];
    
    
    /**Initial miles set in merchant class**/
//    [kAppDelegate.navController pushViewController:objIBLoginVC animated:true];//=[[UINavigationController alloc]initWithRootViewController:objIBLoginVC];
    /*commented by Utkarsha to hide Ads it not available
     [self addBottomADView];
     */
//    kAppDelegate.navController.navigationBarHidden = YES;
    [kAppDelegate.navController pushViewController:objIBLoginVC animated:true];

    
//    kAppDelegate.objSideBarVC = [[SideBarVC alloc] initWithNibName:@"SideBarVC" bundle:nil];
//    
//    kAppDelegate.sideMenuController = [LGSideMenuController sideMenuControllerWithRootViewController:kAppDelegate.navController leftViewController:kAppDelegate.objSideBarVC rightViewController:nil];
//    
//    kAppDelegate.sideMenuController.leftViewWidth = 260.0;
//    kAppDelegate.sideMenuController.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideAbove;
//    [kAppDelegate.window setRootViewController:kAppDelegate.navController];


}
@end
