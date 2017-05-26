//
//  IBUserProfileVC.m
//  iBuddyClient
//
//  Created by Anubha on 16/05/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#import "IBUserProfileVC.h"
#import "UIImageView+WebCache.h"

@interface IBUserProfileVC ()

@property (weak, nonatomic) IBOutlet UILabel *txtAddress;
@property (weak, nonatomic) IBOutlet UILabel *txtEmail;
@property (weak, nonatomic) IBOutlet UILabel *txtPhone;
@property (weak, nonatomic) IBOutlet UILabel *txtUserName;
@property (weak, nonatomic) IBOutlet UIImageView *imgProfile;
@property (weak, nonatomic) IBOutlet UILabel *txtFundraiser;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;
@property (weak, nonatomic) IBOutlet UILabel *lblFundraiser;

@end

@implementation IBUserProfileVC
@synthesize dictUserProfileInfo;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark - View LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Added by Utkarsha so as to make iAds compatible to iOS 7 Layout
    [self setLayoutForiOS7];

    [self setTextValues];
    [self setInitialVaribles];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)viewDidUnload {
    [self setTxtUserName:nil];
    [self setTxtFundraiser:nil];
    [self setLblAddress:nil];
    [super viewDidUnload];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown
            ||interfaceOrientation == UIInterfaceOrientationPortrait);
    
}

#pragma mark- Initial Settings
-(void)setInitialVaribles
{
    _txtUserName.font=[UIFont fontWithName:kFont size:kAppDelegate.fontSize+2];
}
/**Method to set text field values
 */
-(void)setTextValues
{
    NSString *strAddress;
    /*********Commented by Utkarsha on 14 july so as to remove name from address as per client request******/

    //strAddress=[NSString stringWithFormat:@"%@",[dictUserProfileInfo valueForKey:@"name"]];
    /*********Added by Utkarsha so as to remove , if their is no address ******/
    //strAddress=[strAddress stringByAppendingString:@"\n"];
    NSString *strAddr = [dictUserProfileInfo valueForKey:@"address"];
    if (![strAddr isEqualToString:@""])
    {
        strAddress=[dictUserProfileInfo valueForKey:@"address"];
        strAddress=[strAddress stringByAppendingString:@"\n"];
        strAddress=[strAddress stringByAppendingString:[dictUserProfileInfo valueForKey:@"city"]];
        strAddress=[strAddress stringByAppendingString:@", "];
        strAddress=[strAddress stringByAppendingString:[dictUserProfileInfo valueForKey:@"state"]];
        strAddress=[strAddress stringByAppendingString:@"\n"];
        strAddress=[strAddress stringByAppendingString:[dictUserProfileInfo valueForKey:@"zipcode"]];
        _txtAddress.text=strAddress;
    }
    else
    {
        strAddress=@"--";
        _txtAddress.text=strAddress;
    }
    _txtEmail.text=[dictUserProfileInfo valueForKey:@"email"];
    _txtFundraiser.text=[[kAppDelegate dictUserInfo]valueForKey:@"npoName"];
    
    if ([[dictUserProfileInfo valueForKey:@"phone_no"] length]>0) {
        _txtPhone.text=[dictUserProfileInfo valueForKey:@"phone_no"];
    }
    else{
        _txtPhone.text=@"--";
    }
    _txtUserName.text=[NSString stringWithFormat:@"%@ %@",[dictUserProfileInfo valueForKey:@"name"],[dictUserProfileInfo valueForKey:@"last_name"]];
    [_imgProfile setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dictUserProfileInfo valueForKey:@"profileImage"]]]
                placeholderImage:[UIImage imageNamed:@"user_placeHolder.png"]];
    [[kAppDelegate dictUserInfo]setValue:[dictUserProfileInfo valueForKey:@"profileImage"] forKey:@"profileImage"];//set again profile image
    [self setFrames:strAddress];
    
}
-(void)setFrames:(NSString *)strAddress
{
    NSArray *arrLabels=[[NSMutableArray alloc]initWithObjects:self.lblAddress,self.txtAddress,self.lblEmail,self.txtEmail,self.lblPhone,self.txtPhone,self.lblFundraiser,self.txtFundraiser,nil];
    //**** Changed by Utkarsha on 13 July 14 --NPO name to fundraiser name on client request***/
    NSArray *arrLabelValues=[[NSMutableArray alloc]initWithObjects:@"Address",strAddress,@"Email",[dictUserProfileInfo valueForKey:@"email"],@"Phone No.",_txtPhone.text,@"Fundraiser Name",[[kAppDelegate dictUserInfo]valueForKey:@"npoName"], nil];
    
    NSArray *kFonts=[[NSMutableArray alloc]initWithObjects:kFont,kFont3,kFont,kFont3,kFont,kFont3,kFont,kFont3, nil];
    
    NSArray *incrementParameter=[[NSMutableArray alloc]initWithObjects:@"Y",@"X",@"Y",@"X",@"Y",@"X",@"Y",@"X", nil];
    
    [[SharedManager sharedManager] setFrames:arrLabels labelValues:arrLabelValues incrementType:incrementParameter kFonts:kFonts plusfactor:10 initialYValue:_imgProfile.frame.origin.y+_imgProfile.frame.size.height+10];
    
    self.scrlView.contentSize = CGSizeMake(0, self.txtFundraiser.frame.origin.y + 100);

    
}

@end
