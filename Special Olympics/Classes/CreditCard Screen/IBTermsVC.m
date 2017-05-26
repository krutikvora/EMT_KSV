//
//  IBTermsVC.m
//  iBuddyClient
//
//  Created by Anubha on 03/01/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import "IBTermsVC.h"

@interface IBTermsVC ()
@property (weak, nonatomic) IBOutlet UILabel *lblCopyRight;

@end

@implementation IBTermsVC
@synthesize strTermsOrPrivacy,lblCopyRight;
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
#pragma mark - Button Actions

- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Set Initial Variables

-(void)setInitialVariables
{
     self.lblCopyRight.text = [CommonFunction getCopyRightText];
    if ([strTermsOrPrivacy isEqualToString:kPrivacy]) {
      _lbl_Top.text=@"PRIVACY POLLICY™";
        _txtViewTerms.hidden=YES;
        
    }
    else{
        _lbl_Top.text=@"TERMS & CONDITIONS™";
        _txtViewPolicy.hidden=YES;


    }
    _lbl_Top.font=[UIFont fontWithName:kFont size:_lbl_Top.font.pointSize];
    _txtViewTerms.font=[UIFont fontWithName:kFont size:_txtViewTerms.font.pointSize];
    _txtViewPolicy.font=[UIFont fontWithName:kFont size:_txtViewPolicy.font.pointSize];
    self.txtViewPolicy.text=self.txtViewPolicy.text;

    self.txtViewTerms.text=self.txtViewTerms.text;
}
#pragma mark - UIScrollView Delegate Methods

-(void)scrollViewDidScroll: (UIScrollView*)scrollView
{
    float scrollViewHeight = scrollView.frame.size.height;
    float scrollContentSizeHeight = scrollView.contentSize.height;
    float scrollOffset = scrollView.contentOffset.y;
    
    if (scrollOffset == 0)
    {
        btnArrowUp.hidden=TRUE;
        btnArrowDown.hidden=FALSE;
    }
    else if (scrollOffset + scrollViewHeight == scrollContentSizeHeight)
    {
        btnArrowUp.hidden=FALSE;
        btnArrowDown.hidden=TRUE;
    }
    else if (scrollOffset > 0&&scrollOffset + scrollViewHeight != scrollContentSizeHeight)
    {
        btnArrowUp.hidden=FALSE;
        btnArrowDown.hidden=FALSE;
    }
}
@end
