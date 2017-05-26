//
//  CustomFormViewController.h
//  CustomRegistrationForm
//
//  Created by Abhimanu on 18/03/13.
//  Copyright (c) 2013 Abhimanyu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 1) Protocol to add call the methods instead of custom UITextView delegate Methods.
 2) It will allow developer to customize the sequence of the custom form by adding these methods in his class, work similar as the normal delegate methods.
 */
@protocol CustomFormTextViewEvents <NSObject>

@optional


-(BOOL)customTextViewShouldBeginEditing:(UITextView *)textField;
-(void)customTextViewDidBeginEditing:(UITextView *)textField;
-(BOOL)customTextViewShouldEndEditing:(UITextView *)textField;
-(void)customTextViewDidEndEditing:(UITextView *)textField;
-(BOOL)customTextViewShouldReturn:(UITextView *)textField;
-(BOOL)customTextView:(UITextView *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)textEntered;
@end


/**
 1) Protocol to add call the methods instead of custom UITextField delegate Methods.
 2) It will allow developer to customize the sequence of the custom form by adding these methods in his class, work similar as the normal delegate methods.
 */

@protocol CustomFormTextFieldEvents <NSObject>

@optional

-(void)customTextFieldDidChangePickerValue:(UITextField *)textField index:(int)index;

-(BOOL)customTextFieldShouldBeginEditing:(UITextField *)textField;
-(void)customTextFieldDidBeginEditing:(UITextField *)textField;
-(BOOL)customTextFieldShouldEndEditing:(UITextField *)textField;
-(void)customTextFieldDidEndEditing:(UITextField *)textField;
-(BOOL)customTextFieldShouldReturn:(UITextField *)textField;
-(BOOL)customTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)textEntered;
@end

@protocol CustomKeyBoardEvents <NSObject>

@optional



@end



/**
 1) Class to manage all the text fields movement along with pickers and keyboard in any combination
 2) User needs to inhert his class from CustomFormViewController.
 3) Include the text fields or text Views in UIScrollView.
 4) Include arrTextFields with the objects of the textfields that are displayed in your form in the same order, in which user needs to call
 5) Call the method setUpCustomForm and this will automatically handle the form keyboard with previous and next and Done buttons with exact scroll size
 */
@interface CustomFormViewController : UIViewController <CustomFormTextFieldEvents, CustomFormTextViewEvents> {
    
    /**
     Instance of NSMutableArray, it will hold the objects of UItextFields and UItextViews that needs to be handled in the form. The Previous Next of every responder field move in the same order as added in this mutable array
     */
    NSMutableArray *arrTextFields;
    
    NSMutableArray *arrMultipleSelectedValues;
    UIScrollView *objScrollView;
    __block CGFloat maxHeight;

    
    id txtPresent;

}

-(void)dismissKeypad;
-(void)setUpScrollSize:(CGFloat )sizeHeight;
-(void)setUpCustomForm;
-(BOOL)createPickerForFields:(NSArray *)textFields withPickerDataInArrayFormat:(NSArray *) respectivePickerData;
-(BOOL)createPickerForFields:(NSArray *)textFields withPickerDataInArrayFormat:(NSArray *) respectivePickerData multiSelection:(NSArray*) multiSelection  selectedIndexes:(NSArray*)selectedIndexes;
-(void)updatePickerSourceAtIndex:(int)index withObject:(id)object;

-(void) removeScrollAnimation:(CGRect)txtFrame;
-(void) addScrollAnimationWithFrame:(CGRect)rect;

@end
