//
//  CustomPickerViewController.h
//  TextSmartControl
//
//  Created by Abhimanu on 28/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SelectionBlock)(NSString *text, int row);
typedef void (^HideCompletionBlock)(int direction);

typedef enum {
    DirectionPrevious,
    DirectionNext,
    DirectionDone = -1
} ControlsDirection;

typedef enum {
    
    firstIndex,
    middleIndex,
    lastIndex
} PickerFormPositionIndex;


@interface CustomPickerViewController : UIViewController<UIPickerViewDelegate>
{
    IBOutlet UISegmentedControl *previousNextSegment;
    IBOutlet UIDatePicker *datePicker;
    CGFloat fontSize;
    
}
@property (nonatomic,assign) CGFloat fontSize;
@property (nonatomic,assign) BOOL isMultiSelection;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSMutableArray *arrSelectedIndex;
@property (strong, nonatomic) NSMutableArray *arrPicker;
@property (nonatomic, strong) IBOutlet UISegmentedControl *previousNextSegment;
@property (nonatomic, weak) IBOutlet UIToolbar *toolBar;

+(CustomPickerViewController *) sharedManager;
-(void)showPickerOnCompletion: (void(^)(NSString *text,int row))selectedtextHandler OnHiding:(void(^)(ControlsDirection direction))hideCompletionHandler selectedText:(NSString *)str showSegment:(BOOL)show multiSelection:(BOOL)isMultiSelection fontSize:(CGFloat)size;
-(void)hidePickerView;
- (IBAction)doneBtnClicked:(id)sender;
- (IBAction)segmentControlClicked:(id)sender;
-(void)showDatePickerOnCompletion  :(void(^)(NSString *text))selectedtextHandler OnHiding:(void(^)(int direction))hideCompletionHandler selectedText:(NSString *)str showSegment:(BOOL)show  datePickerMode:(int)mode;
-(void)currentPickerPosition:(PickerFormPositionIndex)positionIndex;


@end

@interface CommonFunctionClass : NSObject {
    
}

+(NSDate*)dateFromString:(NSString*)dateString;
+(NSString*)stringFromDate:(NSDate*)date;
+(NSString*)stringFromDateInLocalTimeZone:(NSDate*)date;
+(NSDate*)dateFromStringInLocalTimeZone:(NSString*)dateString;

+(BOOL)validateAlphaNumerics:(NSString *)stringToMatch;
+(BOOL)validateNumeric:(NSString *)stringToMatch;
+(BOOL)validateAlphabets:(NSString *)stringToMatch;
+(BOOL) validateEmail: (NSString *) candidate;
+(BOOL)validateOnlyNumeric:(NSString *)stringToMatch;
+(BOOL)validateSpecialCharacters:(NSString *)stringToMatch;
+(BOOL) IsBlank: (NSString *) strInput;
+(void)fnAlert:(NSString*) msg;
+ (CGFloat) heightOfLabel :(NSString*)text andWidth:(CGFloat)width fontName:(NSString *)name fontSize:(CGFloat)size;
+ (CGFloat) widthOfLabel :(NSString*)text andWidth:(CGFloat)width fontSize:(CGFloat)size;
+(NSString *)convertDateToString:(NSString *)strFormat :(NSDate *)date;
+(NSDate *)convertStringToDate :(NSString *)strFormat strDate:(NSString *)strDate;
+(NSInteger)returnDifference:(NSDate *)date selectedDate:(NSDate *)dateSelected;



@end

