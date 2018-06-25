//
//  JLTextFieldUtil.m
//  JLKit
//
//  Created by JiBaoBao on 2018/6/24.
//  Copyright © 2018年 JiBaoBao. All rights reserved.
//

#import "JLTextFieldUtil.h"

@implementation JLTextFieldUtil


+ (BOOL)validateAmountWithTextField:(UITextField *)textField range:(NSRange )range replacementString:(NSString *)string {
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    // 只能出现"0-9"数字和"."
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789.\b"];
    if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
        return NO;
    }
    
    // 最多输入9位
    NSInteger limitCount = 9;
    if (toBeString.length > limitCount) {
        toBeString = [toBeString substringToIndex:limitCount];
    }
    
    // 当首字符为“0”，第二字符只能输入“.”
    if (toBeString.length >= 2){
        // 首字符为“0”
        if ([[toBeString substringToIndex:1] isEqualToString:@"0"]) {
            NSString *secondStr = [toBeString substringWithRange:NSMakeRange(1, 1)];
            // 第二字符只能为“.”
            if (![secondStr isEqualToString:@"."]) {
                toBeString = [toBeString substringToIndex:1];
            }
        }
    }
    
    // 有了小数点
    if([toBeString rangeOfString:@"."].length == 1) {
        NSUInteger location = [toBeString rangeOfString:@"."].location;
        // 小数点后面，不能再出现小数点
        NSArray *array = [toBeString componentsSeparatedByString:@"."];
        if (array.count>=2) {
            // 第二次出现小数点的位置
            NSInteger secondPointLocation = [array[0] length]+1+[array[1] length];
            toBeString = [toBeString substringToIndex:secondPointLocation];
        }
        
        // 小数点后面，只能有两位小数
        NSInteger limitDecimalsCount = 2;
        if ([toBeString substringFromIndex:location].length-1 > limitDecimalsCount) {
            NSInteger limtLength = location+1+limitDecimalsCount; //小数点前面长度+小数点长度+小数点后面
            toBeString = [toBeString substringToIndex:limtLength];
        }
    }
    [textField setText:toBeString];
    return NO;
}

+ (BOOL)validateAmount1WithTextField:(UITextField *)textField range:(NSRange )range replacementString:(NSString *)string {
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
