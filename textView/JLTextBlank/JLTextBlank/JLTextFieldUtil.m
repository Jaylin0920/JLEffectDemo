//
//  JLTextFieldUtil.m
//  JLTextBlank
//
//  Created by JiBaoBao on 2018/6/24.
//  Copyright © 2018年 JiBaoBao. All rights reserved.
//

#import "JLTextFieldUtil.h"

@implementation JLTextFieldUtil

+ (BOOL)blankFormat_phoneWithtextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self jl_addBlankWithtextField:textField shouldChangeCharactersInRange:range replacementString:string isPhone:YES];
}

+ (BOOL)blankFormat_bankCardWithtextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self jl_addBlankWithtextField:textField shouldChangeCharactersInRange:range replacementString:string isPhone:NO];
}


#pragma mark - private method

+ (BOOL)jl_addBlankWithtextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string isPhone:(BOOL)isPhone {
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
    toBeString = [toBeString stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
        return NO;
    }

    if (isPhone) {
        // 如果是电话号码格式化，需要添加这三行代码
        NSMutableString *temString = [NSMutableString stringWithString:toBeString];
        [temString insertString:@" " atIndex:0];
        toBeString = [temString copy];
    }
    
    NSString *newString = @"";
    NSInteger blankInterval = 4;
    while (toBeString.length > 0) {
        NSString *subString = [toBeString substringToIndex:MIN(toBeString.length, blankInterval)];
        newString = [newString stringByAppendingString:subString];
        if (subString.length == blankInterval) {
            newString = [newString stringByAppendingString:@" "];
        }
        toBeString = [toBeString substringFromIndex:MIN(toBeString.length, blankInterval)];
    }
    newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
    
    NSInteger limitCount = isPhone? 13:23;
    if (newString.length >= limitCount) {
        newString = [newString substringToIndex:limitCount];
    }
    [textField setText:newString];
    return NO;
}

/*
 textField手动输入时，会触发notification、UIControlEventEditingChanged;
 textField.text=@""时，会触发kvo
 如碰到自定义键盘，空格格式化无效，可尝试调用以下方法
 */
+ (void)jl_addValueChangeWithTextField:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:nil];
    [textField sendActionsForControlEvents:UIControlEventEditingChanged];
}


@end
