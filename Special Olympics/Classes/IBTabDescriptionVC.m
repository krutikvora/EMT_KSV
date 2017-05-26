//
//  IBTabDescriptionVC.m
//  iBuddyClient
//
//  Created by Mittali on 04/07/16.
//  Copyright © 2016 Netsmartz. All rights reserved.
//

#import "IBTabDescriptionVC.h"

@interface IBTabDescriptionVC ()
{
    IBOutlet UILabel *_lbl_Top;
    IBOutlet UITextView *_txtViewAboutUs;
}
@end

@implementation IBTabDescriptionVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _lbl_Top.font=[UIFont fontWithName:kFont size:_lbl_Top.font.pointSize];
    _txtViewAboutUs.font=[UIFont fontWithName:kFont size:_txtViewAboutUs.font.pointSize];
   // _txtViewAboutUs.scrollsToTop=YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
      [_txtViewAboutUs scrollRangeToVisible:NSMakeRange(0, 0)];
    //    [_txtViewAboutUs scrollRectToVisible:CGRectMake(0, 0, _txtViewAboutUs.contentSize.width, 10) animated:NO];
}
- (void)viewDidLayoutSubviews
{
    [_txtViewAboutUs setContentOffset:CGPointZero animated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showMenu:(id)sender {
    [kAppDelegate showMenu];
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
