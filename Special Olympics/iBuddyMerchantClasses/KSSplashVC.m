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
    kAppDelegate.navController=[[UINavigationController alloc]initWithRootViewController:objIBShortRegisterVC];
    /*commented by Utkarsha to hide Ads it not available
     [self addBottomADView];
     */
    kAppDelegate.navController.navigationBarHidden = YES;
    
    
    kAppDelegate.objSideBarVC = [[SideBarVC alloc] initWithNibName:@"SideBarVC" bundle:nil];
    
    kAppDelegate.sideMenuController = [LGSideMenuController sideMenuControllerWithRootViewController:kAppDelegate.navController leftViewController:kAppDelegate.objSideBarVC rightViewController:nil];
    
    kAppDelegate.sideMenuController.leftViewWidth = 260.0;
    kAppDelegate.sideMenuController.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideAbove;
    [kAppDelegate.window setRootViewController:kAppDelegate.sideMenuController];


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
    [kAppDelegate.navController pushViewController:objIBLoginVC animated:true];//=[[UINavigationController alloc]initWithRootViewController:objIBLoginVC];
    /*commented by Utkarsha to hide Ads it not available
     [self addBottomADView];
     */
    kAppDelegate.navController.navigationBarHidden = YES;

    
//    kAppDelegate.objSideBarVC = [[SideBarVC alloc] initWithNibName:@"SideBarVC" bundle:nil];
//    
//    kAppDelegate.sideMenuController = [LGSideMenuController sideMenuControllerWithRootViewController:kAppDelegate.navController leftViewController:kAppDelegate.objSideBarVC rightViewController:nil];
//    
//    kAppDelegate.sideMenuController.leftViewWidth = 260.0;
//    kAppDelegate.sideMenuController.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideAbove;
    [kAppDelegate.window setRootViewController:kAppDelegate.navController];


}
@end
