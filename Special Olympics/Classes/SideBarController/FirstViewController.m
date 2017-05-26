//
//  FirstViewController.m
//  iBuddyClient
//
//  Created by Meet Patel on 10/05/17.
//  Copyright © 2017 Netsmartz. All rights reserved.
//

#import "FirstViewController.h"
#import "Constants.h"

@interface FirstViewController ()

@end

@implementation FirstViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    txtName.leftView = paddingView;
    txtName.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    txtEmailID.leftView = paddingView1;
    txtEmailID.leftViewMode = UITextFieldViewModeAlways;

    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    txtConfirmEmailID.leftView = paddingView2;
    txtConfirmEmailID.leftViewMode = UITextFieldViewModeAlways;

    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    txtPhoneNumber.leftView = paddingView3;
    txtPhoneNumber.leftViewMode = UITextFieldViewModeAlways;

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnSubmitClicked:(id)sender {
    [kAppDelegate loadAppDel:[UIApplication sharedApplication] didFinishLaunchingWithOptions:kAppDelegate.dictOptions];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == txtName) {
        [textField resignFirstResponder];
        [txtEmailID becomeFirstResponder];
    } else if (textField == txtEmailID) {
        [textField resignFirstResponder];
        [txtConfirmEmailID becomeFirstResponder];
    } else if (textField == txtConfirmEmailID) {
        [textField resignFirstResponder];
        [txtPhoneNumber becomeFirstResponder];
    } else if (textField == txtPhoneNumber) {
        [textField resignFirstResponder];
    }
    return YES;
}

@end
