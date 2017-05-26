//
//  UILabel+UILabel_highlightColor.m
//  icd9_database
//
//  Created by Abhimanu on 21/06/13.
//  Copyright (c) 2013 abc. All rights reserved.
//

#import "UILabel+UILabel_highlightColor.h"

@implementation UILabel (UILabel_highlightColor)

-(void)highlightTextInLabel:(NSString *)higlightedText
{
    NSString *text = self.text;
    if (!text.length) {
        return;
    }
    
    // If attributed text is supported (iOS6+)
    if ([self respondsToSelector:@selector(setAttributedText:)]) {
        
        // Define general attributes for the entire text
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName: self.textColor,
                                  NSFontAttributeName: self.font
                                  };
        NSMutableAttributedString *attributedText =
        [[NSMutableAttributedString alloc] initWithString:text
                                               attributes:attribs];
        
        // Red text attributes
        UIColor *redColor = [UIColor redColor];
        NSRange redTextRange = [text rangeOfString:higlightedText options:NSCaseInsensitiveSearch];
        [attributedText setAttributes:@{NSForegroundColorAttributeName:redColor}
                                range:redTextRange];
        
//        // Green text attributes
//        UIColor *greenColor = [UIColor greenColor];
//        NSRange greenTextRange = [text rangeOfString:greenText];
//        [attributedText setAttributes:@{NSForegroundColorAttributeName:greenColor}
//                                range:greenTextRange];
//        
//        // Purple and bold text attributes
//        UIColor *purpleColor = [UIColor purpleColor];
//        UIFont *boldFont = [UIFont boldSystemFontOfSize:self.label.font.pointSize];
//        NSRange purpleBoldTextRange = [text rangeOfString:purpleBoldText];
//        [attributedText setAttributes:@{NSForegroundColorAttributeName:purpleColor,
//                  NSFontAttributeName:boldFont}
//                                range:purpleBoldTextRange];
        
        self.attributedText = attributedText;
    }
    // If attributed text is NOT supported (iOS5-)
    else {
        self.text = text;
    }
}

@end
