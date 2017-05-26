//
//  CustomFormViewController.m
//  CustomRegistrationForm
//
//  Created by Abhimanu on 18/03/13.
//  Copyright (c) 2013 rakesh jogi. All rights reserved.
//

#import "CustomFormViewController.h"
#import "BSKeyboardControls.h"
#import "CustomPickerViewController.h"

@interface CustomFormViewController ()<BSKeyboardControlsDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    BSKeyboardControls *keyboardControls;
    NSMutableArray *arrPickerTextFieldsWithData;
    __block int currentTextFieldIndex;
    
}
@end

@implementation CustomFormViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        arrMultipleSelectedValues = [NSMutableArray new];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setLayoutForiOS7];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Text View Delegate Methods

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    __block int index = 0;
    __block BOOL value = YES;
    if ([self respondsToSelector:@selector(customTextViewShouldBeginEditing:)]) {
        
        value = [self customTextViewShouldBeginEditing:textView];
    }
    if (value) {
        
        [[[CustomPickerViewController sharedManager] view] setHidden:YES];
        [arrPickerTextFieldsWithData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UITextView *objTextField = (UITextView *)[obj valueForKey:@"pickerField"];
            if (objTextField == textView) {
                
                index = idx;
                value = NO;
                *stop = YES;
            }
            
        }];
        
        if (!value) {
            [txtPresent resignFirstResponder];
            [self addScrollAnimationWithFrame:textView.frame];
            NSDictionary * indexObject = [arrPickerTextFieldsWithData objectAtIndex:index];
            [[CustomPickerViewController sharedManager] setArrPicker:[indexObject valueForKey:@"pickerData"]];
            [[CustomPickerViewController sharedManager] showPickerOnCompletion:^(NSString *text, int row) {
                textView.text = text;
                
            } OnHiding:^(ControlsDirection direction) {
                if (direction == 1) {
                    
                    currentTextFieldIndex++;
                    UITextView *nextTextView = (UITextView *)[arrTextFields objectAtIndex:currentTextFieldIndex];
                    [nextTextView becomeFirstResponder];
                }
                else if (direction == 0) {
                    
                    currentTextFieldIndex--;
                    UITextView *previousTextView = (UITextView *)[arrTextFields objectAtIndex:currentTextFieldIndex];
                    [previousTextView becomeFirstResponder];
                }
                else
                {
                    txtPresent = textView;
                    [self removeScrollAnimation:textView.frame];
                }
                
            } selectedText:textView.text showSegment:YES multiSelection:NO fontSize:18.0];
            
            [self setSegmentInteractionsOfTextField:textView];
        }
    }
	return value;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
	BOOL value = YES;
    if ([self respondsToSelector:@selector(customTextViewShouldEndEditing:)]) {
        
        value = [self customTextViewShouldEndEditing:textView];
    }

	return value;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    txtPresent = textView;
    if ([keyboardControls.textFields containsObject:textView])
        keyboardControls.activeTextField = textView;
    if ([self respondsToSelector:@selector(customTextViewDidBeginEditing:)]) {
        
        [self customTextViewDidBeginEditing:textView];
    }
    [self addScrollAnimationWithFrame:textView.frame];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    txtPresent = textView;
    if ([self respondsToSelector:@selector(customTextViewDidEndEditing:)]) {
        
        [self customTextViewDidEndEditing:textView];
    }

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    BOOL value = YES;
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        value = NO;
    }
    else if ([self respondsToSelector:@selector(customTextView:shouldChangeCharactersInRange:replacementString:)]) {
        
        value = [self customTextView:textView shouldChangeCharactersInRange:range replacementString:text];
    }
	return value;
}

- (void)textViewDidChange:(UITextView *)textView {
    
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    
}


#pragma mark -
#pragma mark - Text Field Delegate Methods
int tabCount = 0;
// return NO to disallow editing.
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
//    if (!keyboardControls.isVirtualKeyPadPressed) {
//        tabCount = tabCount+1;
//        if (tabCount == arrTextFields.count -1) {
//            
//            keyboardControls.isVirtualKeyPadPressed = YES;
//            tabCount = 0;
//
//        }
//        return NO;
//    }
//    tabCount = 0;
//    keyboardControls.isVirtualKeyPadPressed = NO;
    __block int index = 0;
    __block BOOL value = YES;
    
    if ([self respondsToSelector:@selector(customTextFieldShouldBeginEditing:)]) {
        
        value = [self customTextFieldShouldBeginEditing:textField];
    }
    if (value) {
        
        [[[CustomPickerViewController sharedManager] view] setHidden:YES];
        [arrPickerTextFieldsWithData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UITextField *objTextField = (UITextField *)[obj valueForKey:@"pickerField"];
            if (objTextField == textField)
            {
                index = idx;
                value = NO;
                *stop = YES;
            }
        }];
        if (!value) {
            [txtPresent resignFirstResponder];
            [self addScrollAnimationWithFrame:textField.frame];
            
            NSMutableDictionary * indexObject = [arrPickerTextFieldsWithData objectAtIndex:index];
            NSNumber *isMultipleSelectionValue = [indexObject valueForKey:@"isMultiSelection"];
            if ([isMultipleSelectionValue boolValue]) {
                
                NSMutableDictionary * multipleSelectionInfo = [[arrMultipleSelectedValues filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"pickerField==%@",[indexObject objectForKey:@"pickerField"]]] lastObject];
                if ([indexObject valueForKey:@"selectedValues"]==nil) {
                    multipleSelectionInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSMutableArray alloc] init],@"selectedValues",[indexObject valueForKey:@"pickerField"],@"pickerField", nil];
                    [arrMultipleSelectedValues addObject:multipleSelectionInfo];
                }
                else {
                    multipleSelectionInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:[indexObject valueForKey:@"selectedValues"],@"selectedValues",[indexObject valueForKey:@"pickerField"],@"pickerField", nil];
                    [arrMultipleSelectedValues addObject:multipleSelectionInfo];
                }
                [CustomPickerViewController sharedManager].arrSelectedIndex = [multipleSelectionInfo objectForKey:@"selectedValues"];
            }
            else {
                [[CustomPickerViewController sharedManager] setArrSelectedIndex:[[NSMutableArray alloc] init]];
            }
            NSMutableArray * arrPicker = [indexObject valueForKey:@"pickerData"];
            id object = [arrPicker objectAtIndex:0];
            if ([object isKindOfClass:[NSDictionary class]]) {
//                NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"DataFieldText" ascending:YES];
//                arrPicker=[[arrPicker sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]] mutableCopy];
            }
            else {
//                if ([arrTextFields objectAtIndex:8] != textField && [arrTextFields objectAtIndex:3] != textField && [arrTextFields objectAtIndex:4] != textField ) {
//                    arrPicker = [[arrPicker sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] mutableCopy];
//                }
            }
            [[CustomPickerViewController sharedManager] setArrPicker:arrPicker];
            [[CustomPickerViewController sharedManager] showPickerOnCompletion:^(NSString *text, int row) {
                
                textField.text = text;
                if ([self respondsToSelector:@selector(customTextFieldDidChangePickerValue: index:)]) {
                    
                    [self customTextFieldDidChangePickerValue:textField index:row];
                }
            } OnHiding:^(int direction) {
                if (direction == 1) {
                    currentTextFieldIndex++;
                    UITextField *nextTextField = (UITextField *)[arrTextFields objectAtIndex:currentTextFieldIndex];
                NextField: {
                    if ([nextTextField isKindOfClass:[UITextField class]]) {
                        if (nextTextField.isEnabled == NO) {
                            currentTextFieldIndex++;
                            nextTextField = [arrTextFields objectAtIndex:currentTextFieldIndex];
                            goto NextField;
                        }
                    }
                }
                    [nextTextField becomeFirstResponder];
                }
                else if (direction == 0) {
                    currentTextFieldIndex--;
                    UITextField *previousTextField = (UITextField *)[arrTextFields objectAtIndex:currentTextFieldIndex];
                PreviousField: {
                    if ([previousTextField isKindOfClass:[UITextField class]]) {
                        if (previousTextField.isEnabled == NO) {
                            currentTextFieldIndex--;
                            previousTextField = [arrTextFields objectAtIndex:currentTextFieldIndex];
                            goto PreviousField;
                        }
                    }
                }
                    [previousTextField becomeFirstResponder];
                }
                else {
                    txtPresent = textField;
                    [self removeScrollAnimation:textField.frame];
                }
            } selectedText:textField.text showSegment:YES multiSelection:[isMultipleSelectionValue boolValue] fontSize:18.0];
            [self setSegmentInteractionsOfTextField:textField];
        }
    }
    else
    {
        [txtPresent resignFirstResponder];
    }
	return value;
}

// became first responder
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    txtPresent = textField;
    
    if ([keyboardControls.textFields containsObject:textField])
        keyboardControls.activeTextField = textField;
    if ([self respondsToSelector:@selector(customTextFieldDidBeginEditing:)]) {
        
        [self customTextFieldDidBeginEditing:textField];
    }
    [self addScrollAnimationWithFrame:textField.frame];
}

// return YES to allow editing to stop and to resign first responder status.
//NO to disallow the editing session to end
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
	BOOL value = YES;
    if ([self respondsToSelector:@selector(customTextFieldShouldEndEditing:)]) {
        
        value = [self customTextFieldShouldEndEditing:textField];
    }
	return value;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    txtPresent = textField;
    
    if ([self respondsToSelector:@selector(customTextFieldDidEndEditing:)]) {
        
        [self customTextFieldDidEndEditing:textField];
    }
  //  [self removeScrollAnimation:textField.frame];
//    keyboardControls.isVirtualKeyPadPressed = YES;

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
	BOOL value = YES;
    if ([self respondsToSelector:@selector(customTextFieldShouldReturn:)]) {
        
        value = [self customTextFieldShouldReturn:textField];
    }
    if (value == YES) {
        [textField resignFirstResponder];
    }
	return value;
}

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)textEntered {
    
    BOOL value = YES;
    if ([self respondsToSelector:@selector(customTextField:shouldChangeCharactersInRange:replacementString:)]) {
        
        value = [self customTextField:textField shouldChangeCharactersInRange:range replacementString:textEntered];
    }
    return value;
}



#pragma mark -
#pragma mark KeyBoard Delegate Methods


- (void)keyboardControlsDonePressed:(BSKeyboardControls *)controls
{
    UIView *view = (UIView *) controls.activeTextField;
    [self removeScrollAnimation:view.frame];
    [controls.activeTextField resignFirstResponder];

}

/** Either "Previous" or "Next" was pressed
 * Here we usually want to scroll the view to the active text field
 * If we want to know which of the two was pressed, we can use the "direction" which will have one of the following values:
 * KeyboardControlsDirectionPrevious        "Previous" was pressed
 * KeyboardControlsDirectionNext            "Next" was pressed
 */
- (void)keyboardControlsPreviousNextPressed:(BSKeyboardControls *)controls withDirection:(KeyboardControlsDirection)direction andActiveTextField:(id)textField
{
    
    [textField becomeFirstResponder];
    //[self addScrollAnimationWithFrame:txtPresent.frame];
    
}


#pragma mark -
#pragma mark Private Methods


-(void)updatePickerSourceAtIndex:(int)index withObject:(id)object {
    
    NSMutableDictionary * indexObject = [arrPickerTextFieldsWithData objectAtIndex:index];
    [indexObject setObject:object forKey:@"pickerData"];
}


-(void)dismissKeypad {
    [txtPresent resignFirstResponder];
    [[CustomPickerViewController sharedManager] view].hidden = YES;
}

-(void)setUpScrollSize:(CGFloat )sizeHeight {
    
    for (UIView *view in [self.view subviews]) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            
            UIScrollView *scroll = (UIScrollView *)view;
            objScrollView = scroll;
            [scroll setContentSize:CGSizeMake(scroll.contentSize.width, sizeHeight)];
        }
    }
}

-(void)setUpCustomForm
{
    [self setUpScrollSize:0];
    // Initialize the keyboard controls
    keyboardControls = [[BSKeyboardControls alloc] init];
    keyboardControls.isVirtualKeyPadPressed = YES;
    // Set the delegate of the keyboard controls
    keyboardControls.delegate = self;
    
    // Add all text fields you want to be able to skip between to the keyboard controls
    // The order of thise text fields are important. The order is used when pressing "Previous" or "Next"
    keyboardControls.textFields = arrTextFields;
    
    
    // Set the style of the bar. Default is UIBarStyleBlackTranslucent.
    keyboardControls.barStyle = UIBarStyleBlackTranslucent;
    
    // Set the tint color of the "Previous" and "Next" button. Default is black.
    //self.keyboardControls.previousNextTintColor = [UIColor blackColor];
    
    // Set the tint color of the done button. Default is a color which looks a lot like the original blue color for a "Done" butotn
    // self.keyboardControls.doneTintColor = [UIColor colorWithRed:34.0/255.0 green:164.0/255.0 blue:255.0/255.0 alpha:1.0];
    
    // Set title for the "Previous" button. Default is "Previous".
    keyboardControls.previousTitle = @"Previous";
    
    // Set title for the "Next button". Default is "Next".
    keyboardControls.nextTitle = @"Next";
    
    // Add the keyboard control as accessory view for all of the text fields
    // Also set the delegate of all the text fields to self
    for (id textField in keyboardControls.textFields)
    {
        if ([textField isKindOfClass:[UITextField class]])
        {
            ((UITextField *) textField).inputAccessoryView = keyboardControls;
            ((UITextField *) textField).delegate = self;
            
            // ((UITextField *) textField).adjustsFontSizeToFitWidth = YES;
        }
        else if ([textField isKindOfClass:[UITextView class]])
        {
            ((UITextView *) textField).inputAccessoryView = keyboardControls;
            ((UITextView *) textField).delegate = self;
        }
    }
    
    
    int height = objScrollView.frame.size.height;
    for (UIView *view in objScrollView.subviews) {
        if (view.hidden == NO) {
            
            if (view.frame.origin.y + view.frame.size.height > height) {
                
                height = view.frame.origin.y + view.frame.size.height;
                height = height+10;
            }
        }
        
    }
    maxHeight = height;
    [self setUpScrollSize:maxHeight];
}

-(BOOL)createPickerForFields:(NSArray *)textFields withPickerDataInArrayFormat:(NSArray *) respectivePickerData multiSelection:(NSArray*) multiSelection selectedIndexes:(NSArray*)selectedIndexes {
    
    BOOL isCorrect = [self checkPickerFields:textFields pickerDataInArrayFormat:respectivePickerData];
    if (!isCorrect) {
        return isCorrect;
    }
    if (arrPickerTextFieldsWithData == nil) {
        arrPickerTextFieldsWithData = [[NSMutableArray alloc] init];
    }
    else
    {
        [arrPickerTextFieldsWithData removeAllObjects];
    }
    if (multiSelection == nil) {
        
        for (int i = 0;i<[textFields count];i++) {
            
            NSDictionary *dictionary = [[NSMutableDictionary alloc] initWithObjects:@[[textFields objectAtIndex:i],[respectivePickerData objectAtIndex:i]] forKeys:@[@"pickerField",@"pickerData"]];
            [arrPickerTextFieldsWithData addObject:dictionary];
        }
    }
    else {
        for (int i = 0;i<[textFields count];i++) {
            
            NSDictionary *dictionary = [[NSMutableDictionary alloc] initWithObjects:@[[textFields objectAtIndex:i],[respectivePickerData objectAtIndex:i],[multiSelection objectAtIndex:i],[selectedIndexes objectAtIndex:i]] forKeys:@[@"pickerField",@"pickerData", @"isMultiSelection", @"selectedValues"]];
            [arrPickerTextFieldsWithData addObject:dictionary];
        }
    }
    return YES;
}


-(BOOL)createPickerForFields:(NSArray *)textFields withPickerDataInArrayFormat:(NSArray *) respectivePickerData  {
    return [self createPickerForFields:textFields withPickerDataInArrayFormat:respectivePickerData multiSelection:nil selectedIndexes:nil];
}

-(BOOL)checkPickerFields:(NSArray *)textFields pickerDataInArrayFormat:(NSArray *) respectivePickerData
{
    __block BOOL isCorect = YES;
    if (textFields.count == respectivePickerData.count) {
        
        [respectivePickerData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (![obj isKindOfClass:[NSArray class]]) {
                isCorect = NO;
            }
        }];
        
        if (!isCorect) {
            NSLog(@"The array picker data is not in the form of array");
        }
    }
    else
    {
        NSLog(@"Mismatch Between respective textfield array and the pickerdata");
        isCorect = NO;
    }
    
    
    return isCorect;
}

-(void)setSegmentInteractionsOfTextField:textField {
    
    __block int index = -1;
    [arrTextFields enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UITextField *objTextfied = (UITextField *)obj;
        if (objTextfied == textField) {
            index = idx;
            *stop = YES;
        }
    }];
    
    if (index == [arrTextFields count]-1) {
        [[CustomPickerViewController sharedManager] currentPickerPosition:lastIndex];
    }
    else if(index == 0)
    {
        [[CustomPickerViewController sharedManager] currentPickerPosition:firstIndex];
    }
    else
    {
        [[CustomPickerViewController sharedManager] currentPickerPosition:middleIndex];
    }
    currentTextFieldIndex = index;
}

#pragma mark Scroll Animation

-(void) removeScrollAnimation:(CGRect)txtFrame
{
    /** Commented and added by Utkarsha to correct the scroll content
     
    [UIView animateWithDuration:0.5 animations:^{
        objScrollView.contentOffset = CGPointMake(objScrollView.contentOffset.x,txtFrame.origin.y - 44);
        objScrollView.contentSize = CGSizeMake(objScrollView.contentSize.width,maxHeight);
    } completion:^(BOOL finished) {
        objScrollView.contentSize = CGSizeMake(objScrollView.contentSize.width,maxHeight);
    }];
     */
    
    [UIView animateWithDuration:0.5 animations:^{
        objScrollView.contentSize = CGSizeMake(objScrollView.contentSize.width,maxHeight );
    } completion:^(BOOL finished) {
           }];
}

-(void) addScrollAnimationWithFrame:(CGRect)rect
{
    objScrollView.contentSize = CGSizeMake(0, maxHeight+10 +200);
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.5];
    [objScrollView setContentOffset: CGPointMake(0,(rect.origin.y-44)) animated:NO];
    [UIView commitAnimations];
}


@end
