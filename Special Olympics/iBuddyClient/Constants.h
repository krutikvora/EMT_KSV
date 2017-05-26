//
//  Constants.h
//  iBuddyClient
//
//  Created by Anubha on 02/05/13.
//  Copyright (c) 2013 Netsmartz. All rights reserved.
//

#ifndef iBuddyClient_Constants_h
#define iBuddyClient_Constants_h

/** Variable ---*/
#define kAppDelegate ((IBAppDelegate *)[[UIApplication sharedApplication] delegate])
/**-  Font Name ---*/
//#define kFont @"SouvenirITCbyBT-Demi"
#define kFont @"Georgia-Bold"
#define kFont2 @"Helvetica"
#define kFont3 @"Georgia"
#define kFontText 12.0

//////Local URL

//#define kURL @"http://ibuddyclub.netsmartz.us/webservice/"
//#define kCheckiBuddyWebsiteURL @"http://ibuddyclub.netsmartz.us/payment/paypalreturn?"
//#define kSubCategoryImage @"http://ibuddyclub.netsmartz.us/media/categoryImages/thumbnail/"

//Live URL
//#define kURL @"http://appsmaventech.com/ibuddy_test/webservice/"
#define kOlderURL @"http://ibuddyclub.com/webservice/"


#define kURL @"http://ibuddyclub.com/webservice/"
#define kCheckiBuddyWebsiteURL @"http://ibuddyclub.com/payment/paypalreturn?"
#define kSubCategoryImage @"http://ibuddyclub.com/media/categoryImages/thumbnail/"
//#define kExtraDonationLink @"http://ibuddyclub.com/extradonationcw/"
//#define kExtraDonationPaymentLink @"http://ibuddyclub.com/extradonationselectioncw/"
#define kExtraDonationLink @"http://ibuddyclub.com/extradonationfirerescuefunding/"
#define kExtraDonationPaymentLink @"http://ibuddyclub.com/extradonationselectionpagefirerescuefunding/"

//#define kExtraDonationPaymentLink @"http://appsmaventech.com/ibuddy_test/extradonationselectioncw/"


////--local
//#define kURL @"http://ibc.staging.netsmartz.us/webservice/"
//#define kCheckiBuddyWebsiteURL @"http://ibc.staging.netsmartz.us/payment/paypalreturn?"
//#define kSubCategoryImage @"http://ibc.staging.netsmartz.us/media/categoryImages/thumbnail/"
//#define kExtraDonationLink @"http://ibc.staging.netsmartz.us/extradonationbcourt/"
//#define kExtraDonationPaymentLink @"http://ibc.staging.netsmartz.us/extradonationselectionpagebcourt/"


//With live payment
//#define kURL @"http://ibuddyclub.demo.netsmartz.us/webservice/"
//#define kCheckiBuddyWebsiteURL @"http://ibuddyclub.demo.netsmartz.us/payment/paypalreturn?"
//#define kSubCategoryImage @"http://ibuddyclub.demo.netsmartz.us/media/categoryImages/thumbnail/"
//#define kExtraDonationLink @"http://ibuddyclub.demo.netsmartz.us/extradonation/"
//#define kExtraDonationPaymentLink @"http://ibuddyclub.demo.netsmartz.us/extradonationselectionpage/"

//With New Instance

//#define kURL @"http://ibuddyclubnew.demo.netsmartz.us/webservice/"
//#define kCheckiBuddyWebsiteURL @"http://ibuddyclubnew.demo.netsmartz.us/payment/paypalreturn?"
//#define kSubCategoryImage @"http://ibuddyclubnew.demo.netsmartz.us/media/categoryImages/thumbnail/"
//#define kExtraDonationLink @"http://ibuddyclubnew.demo.netsmartz.us/extradonation/"
//#define kExtraDonationPaymentLink @"http://ibuddyclubnew.demo.netsmartz.us/extradonationselectionpage/"

//Load Testing
//#define kURL @"http://ibuddytesting.demo.netsmartz.us/webservice/"
//#define kCheckiBuddyWebsiteURL @"http://ibuddytesting.demo.netsmartz.us/payment/paypalreturn?"
//#define kSubCategoryImage @"http://ibuddytesting.demo.netsmartz.us/media/categoryImages/thumbnail/"
//#define kExtraDonationLink @"http://ibuddytesting.demo.netsmartz.us/extradonationsoco/"
//#define kExtraDonationPaymentLink @"http://ibuddytesting.demo.netsmartz.us/extradonationselectionpagesoco/"

//fb login --- Mittali
#define kfbRegisterAPI @"newregisterFb"
#define KFBLoginAPI  @"loginFb"
#define ksendEmailRaisefunds @"raisefunds"



#define kLogin @"login"


//#define kGetAds @"getrandomad"
#define kGetAds @"getadslist"
#define kRegister @"register"
#define kGetMerchantsin100miles @"getmerchantsin100miles"
#define kOffersListMerchantID @"offersbymerchant"
#define kOffersListUserID @"useravailableoffers"
#define kredeemedoffersbyuser @"redeemedoffersbyuser"
#define kOffersDescription @"getofferdetail"
#define kForgotPassword @"iphoneuserforgotpwd"
#define kRedeemoffer @"redeemoffer"
#define kChangePassword @"changepassword"
#define kLogOut @"logout"
#define kUserDashboard @"getuserdashboard"
#define kValidateSalespersonCode @"validatesalespersoncode"
#define kUserCards @"getcardbyuser"
#define kGetAmounts @"getamounts"
#define kGetRedemptionAmounts @"getredemptionamounts"
#define kGetGiftAmount @"getgiftamount"
#define kRedemptionCode @"validateredemptioncode"
#define kCancelRegistration @"userdelete"
#define kSaveRedeemedOffers @"viewredeemedoffersbyuser"
#define kGetFeaturedData @"coutapidata"
#define kCreditCardService @"creditcardservice"
#define khandleplusonedonations @"handleplusonedonations"
#define kCreateactiveusercard @"createactiveusercard"
#define kGetMerchantList @"merchantlist"
#define kStoreGifteeInfo @"storegifteeinfo"
#define kDeviceToken @"Devicetoken"
#define kCheckPayment @"checkpayment"
#define kUpdateNotifyCnt @"updatenotifycnt"
#define kUpdateProfile @"edituserprofile"
#define kAlerTimedOut @"Unable to connect to server"
#define kPaypalPaymentService @"paypalpaymentservice"
#define kSendForgotMail @"sendforgotmail"
#define kGetCategories @"categorieslist"
#define kGetSalesperson @"getsalesperson"
#define kgetsalespersondetail @"getsalespersondetail"
#define kgetfundraisers @"getfundraisers"
#define kReferAFriend @"referafriendSOCO"
#define kCheckUserStatus @"checkuserstatus"
#define kGetPaymnetToken @"getuserpaymenttoken"
#define kMakeCreditCardPaymentWithToken @"creditcardservicetoken"
#define kgetSchoolDetails @"getSchoolDetails"
#define kValidateStudentCode @"validateStudentCode"

/** Values for user default */

#define kUserType @"UserType"
#define kMiles @"Miles"
#define kZipCode @"ZipCode"
#define kRememberMe @"RememberMe"
#define kEmailId @"EmailId"
#define kPassword @"Password"
#define kZipCodeHighlighted @"ZipCodeHighLightted"
#define kUserId @"userId"
#define kTotalPayment @"TotalPayment"
#define kTax @"Tax"
#define KSubscriptionPayment @"SubscriptionPayment"
#define kDonation @"donation"
#define kDonationType @"donationType"
#define kTotalPaymentUpdated @"TotalPaymentUpdated"
#define kPasswordChanged @"PasswordChanged"
#define kdictUserInfo @"dictUserInfo"
#define kdictUserPaymentInfo @"dictUserPaymentInfo"

/*Pooja*/
#define kgettrollieslist @"trollieslist"
#define kgetfeaturedofferslist @"featuredofferslist"
#define kGetEventDetail @"eventdetail"
#define kGetMerchantEventDetail @"merchanteventdetail"
#define kMerchantEventlistbymerchant @"merchanteventlistbymerchant"

#define iOS_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

/*Utkarsha*/
#define kNewRegister @"newregister"
#define kNpoDonationbyId @"npodonationbyid"
#define knotificationhistory @"notification-history"
#define kNotificationBadgeCount @"notificationBadgeCount"
#define kGeoFencingNotification @"geo-fencing-notifications"

/** Dict values**/
#define kLatitude @"Latitude"
#define kLongitude @"Longitude"
#define kDonationOneDollar @"Donation"
#define kGiftee @"Giftee"
#define KDonationThroughCreditCard @"DonationOrGift"
#define kGiftUser @"GIFTSOCA"
#define kDonationUser @"DONATION"
#define kGiftClass @"giftClass"
#define kOffers @"Offers"
#define kReferEmail @"Email"
#define kReferSMS @"SMS"
//#define kAppLink @"http://ibuddyclub.com/BTCApp"
#define kAppLink @"a"

#define kFacebookAppId @"209231079587519"
#define kTerms @"Terms"
#define kPrivacy @"Privacy"

#define kArrCoordinates @"arrCoordinates" 
#define kZipCodeRetained @"ZipCodeRetained"
#endif



