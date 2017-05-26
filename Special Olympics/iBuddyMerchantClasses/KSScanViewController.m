//
//  KSScanViewController.m
//  iBuddyClub
//
//  Created by Karamjeet Singh on 12/03/13.
//  Copyright (c) 2013 Netsmartz Info Tech. All rights reserved.
//

#import "KSScanViewController.h"
#import "KSOffersViewController.h"
//#import "zbar.h"
#import "NSData-AES.h"
@interface KSScanViewController ()//<ZBarReaderDelegate>
@property (nonatomic, retain) IBOutlet UIImageView *resultImage;
@property (nonatomic, retain) NSString *userID;
@property (weak, nonatomic) IBOutlet UILabel *lbl_ScreenTitle;
@property (weak, nonatomic) IBOutlet UIButton *btn_Scan;
@property (nonatomic,assign)BOOL isSubscribed;
@end

@implementation KSScanViewController
@synthesize userID;
@synthesize isSubscribed;
#pragma mark -
#pragma mark - View Life Cycle
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

	// Do any additional setup after loading the view.
    self.lbl_ScreenTitle.font=[UIFont fontWithName:kFont size:self.lbl_ScreenTitle.font.pointSize];
    self.btn_Scan.titleLabel.font=[UIFont fontWithName:kFont size:self.btn_Scan.titleLabel.font.pointSize];
}
- (void)viewDidUnload {
    [self setLbl_ScreenTitle:nil];
    [self setBtn_Scan:nil];
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown
            ||interfaceOrientation == UIInterfaceOrientationPortrait);
    
}
#pragma mark -
#pragma mark - Delegate Methods

#pragma mark -
#pragma mark - ImagePicker Controller

//- (void) imagePickerController: (UIImagePickerController*) readerontroller
// didFinishPickingMediaWithInfo: (NSDictionary*) info
//{
//    if ([timer isValid]) {
//        [timer invalidate];
//    }
//    // ADD: get the decode results
//    id<NSFastEnumeration> results =
//    [info objectForKey: ZBarReaderControllerResults];
//    ZBarSymbol *symbol = nil;
//    for(symbol in results)
//        break;
//    /* Once the bar code scanded then Decript the code & call the webservice for get the scaned code offers */
//    
//    userID=[self DecryptedData:[NSString stringWithFormat:@"%@",symbol.data]];
//    [self getScanedOffer:userID];
//    self.resultImage.image =
//    [info objectForKey: UIImagePickerControllerOriginalImage];
//    [reader dismissViewControllerAnimated:YES completion:nil];
//}
//- (void) readerControllerDidFailToRead: (ZBarReaderController*) reader
//                             withRetry: (BOOL) retry
//{
//	KaramNSLog(@"NOT SCANNED");
//}
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//{
//    if ([timer isValid]) {
//        [timer invalidate];
//    }
//    //[self getScanedOffer:@"615"];
//
//    [reader dismissViewControllerAnimated:YES completion:nil];
//}
#pragma mark -
#pragma mark - Segues
/**
 @Method    -  prepareForSegue: -> Use if you want to send/set value to destination controller
 */

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"segue_ScanCode"]){
        [segue.destinationViewController setViewForOffer:viewForScannedoffers];
        [segue.destinationViewController setUserID:userID];
        [segue.destinationViewController setIsSubscribed:self.isSubscribed];
    }
}

#pragma mark -
#pragma mark - Private Methods

#pragma mark -
#pragma mark - WebService
/**
 @Method   -  getScanedOffer - -> get merchant offer list by scaning QR code
 @param    -  merchantId, userId (from scaned QR code)
 @Responce -  status = 1 -> success - return offersList
 status = 0 -> no records
 status = -1 -> error
 */

-(void)getScanedOffer:(NSString *)userId{
    [kAppDelegate showProgressHUD:self.view];
    int intUserID=[userId intValue];
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:
                         [CommonFunction getValueFromUserDefault:kMerchantId], @"merchantId",
                         [NSString stringWithFormat:@"%d",intUserID], @"userId",
                         nil];
    [AsyncURLConnection request:[[AsyncURLConnection sharedManager]createJSONRequestForDictionary:(NSMutableDictionary *)dict method:kuseravailableoffers] completeBlock:^(NSData *data) {
        id result = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions error:nil];
        if ([[result valueForKey:@"isSubscribed"] isEqualToString:@"yes"]&&[[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]]) {
            self.isSubscribed=TRUE;
            [self performSegueWithIdentifier:@"segue_ScanCode" sender:self];
        }
        else if([[result valueForKey:@"isSubscribed"] isEqualToString:@"no"]&&[[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:1]])
        {
            self.isSubscribed=FALSE;
            [CommonFunction fnAlert:@"Alert!" message:@"Your iBuddyClub account is not active, please subscribe or renew."];
        }
        else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:0]]){
            [CommonFunction fnAlert:@"Alert!" message:@"Your iBuddyClub account is not active, please subscribe or renew."];}
        else if ([[result valueForKey:@"status"]isEqual:[NSNumber numberWithChar:-1]]){
            [CommonFunction fnAlert:@"Alert!" message:@"Could not match the QR code, please rescan QR code or scan correct QR code."];
        }
        else {
            [CommonFunction fnAlert:@"Server Error!" message:@"Please try again"];
            
        }
        [kAppDelegate hideProgressHUD];
        
    } errorBlock:^(NSError *error) {
        [CommonFunction fnAlert:@"Error" message:[error localizedDescription]];
        [kAppDelegate hideProgressHUD];
    }];
}

#pragma mark -
#pragma mark -Decription
/*
 Return decrypted string
 */
-(NSString *)DecryptedData:(NSString *)text
{
    //Decode
    NSData *data = [Base64 decode:text];
    //Decrypt
    NSData *AESEncryptdata= [data AESDecryptWithPassphrase:@"29xdVi33L5W32SL2"];
    NSString *strUserID = [[NSString alloc] initWithData:AESEncryptdata encoding:NSUTF8StringEncoding];
    return strUserID;
}
#pragma mark -
#pragma mark - All Buttons Action
/*
Action of scan button
 */
//- (IBAction)scanAction:(id)sender {
//    /**
//     ZbarClass for scan the bar code.
//     */
//    
//    reader = [ZBarReaderViewController new];
//    reader.readerDelegate = self;
//    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
//    ZBarImageScanner *scanner = reader.scanner;
//    // TODO: (optional) additional reader configuration here
//    
//    // EXAMPLE: disable rarely used I2/5 to improve performance
//    [scanner setSymbology: ZBAR_I25
//                   config: ZBAR_CFG_ENABLE
//                       to: 0];
//    // present and release the controller
//    [self presentViewController:reader animated:YES completion:nil];
//    timer=[NSTimer scheduledTimerWithTimeInterval:60
//                                           target:self
//                                         selector:@selector(showAlert)
//                                         userInfo:nil
//                                          repeats:NO];
//}
/*
 Method to show alert 
 after a time period*/
-(void)showAlert
{
    if ([timer isValid]) {
        [timer invalidate];
    }
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"It seems that you are not scanning right QR code so please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([timer isValid]) {
        [timer invalidate];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
