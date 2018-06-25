//
//  JLTextFieldUtil.m
//  JLKit
//
//  Created by JiBaoBao on 2018/6/24.
//  Copyright © 2018年 JiBaoBao. All rights reserved.
//

#import "JLTextFieldUtil.h"

@implementation JLTextFieldUtil

- (BOOL)validateAmountWithTextField:(UITextField *)textField range:(NSRange )range replacementString:(NSString *)string {
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    // 只可以输入：“.”、0-9的数字
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789.\b"];
    if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
        return NO;
    }
    const char *ch = [string cStringUsingEncoding:NSASCIIStringEncoding];
    // 首字符0，后续只能输入 “.”
    if ((textField.text.length==1) && [textField.text isEqualToString:@"0"]){
        if ([string isEqualToString:@"."]) return YES;
        else return NO;
    }
    // 最多输入9位
    if (toBeString.length>9) return NO;
    // 有了小数点
    if([textField.text rangeOfString:@"."].length==1) {
        NSUInteger length=[textField.text rangeOfString:@"."].location;
        // 小数点后面，只能有两位小数
        // 小数点后面，不能再出现小数点
        if([[textField.text substringFromIndex:length] length]>2 || *ch ==46) return NO;
    }
    return YES;
}

+ (BOOL)blankFormat_phoneWithtextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self jl_addBlankWithtextField:textField shouldChangeCharactersInRange:range replacementString:string isPhone:YES];
}

+ (BOOL)blankFormat_bankCardWithtextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self jl_addBlankWithtextField:textField shouldChangeCharactersInRange:range replacementString:string isPhone:NO];
}


#pragma mark - private method

+ (BOOL)jl_addBlankWithtextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string isPhone:(BOOL)isPhone {
    NSString *text = [textField text];
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
        return NO;
    }
    text = [text stringByReplacingCharactersInRange:range withString:string];
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (isPhone) {
        // 如果是电话号码格式化，需要添加这三行代码
        NSMutableString *temString = [NSMutableString stringWithString:text];
        [temString insertString:@" " atIndex:0];
        text = temString;
    }
    
    NSString *newString = @"";
    while (text.length > 0) {
        NSString *subString = [text substringToIndex:MIN(text.length, 4)];
        newString = [newString stringByAppendingString:subString];
        if (subString.length == 4) {
            newString = [newString stringByAppendingString:@" "];
        }
        text = [text substringFromIndex:MIN(text.length, 4)];
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
