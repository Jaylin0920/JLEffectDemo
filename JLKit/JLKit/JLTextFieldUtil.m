//
//  JLTextFieldUtil.m
//  JLKit
//
//  Created by JiBaoBao on 2018/6/24.
//  Copyright © 2018年 JiBaoBao. All rights reserved.
//

#import "JLTextFieldUtil.h"

@implementation JLTextFieldUtil

/**
 金钱输入 合法性检验
 
 规则：只能是0-9数字，最多输入9位，最多两位小数，小数点后不能在出现小数点
 （0:空格键  46:"."   48:"0"   57:"9"）
 */
- (BOOL)validateAmountWithTextField:(UITextField *)textField range:(NSRange )range replacementString:(NSString *)string { 
    // 即将输入的下一个字符
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    const char * ch=[string cStringUsingEncoding:NSASCIIStringEncoding];
    
    /** 是否可输入 */
    if (*ch==0)return YES;
    if ((textField.text.length==1) && [textField.text isEqualToString:@"0"]){// 首字符0，后续只能输入 “.”
        if ([string isEqualToString:@"."]) return YES;
        else return NO;
    }
    if (toBeString.length>9) return NO; //大于9位数
    if((*ch != 46) && (*ch<48 || *ch>57)) return NO; // 只可以输入：“.”、0-9的数字
    if([textField.text rangeOfString:@"."].length==1){ // 有了小数点
        NSUInteger length=[textField.text rangeOfString:@"."].location;
        // 小数点后面两位小数 且不能再是小数点
        if([[textField.text substringFromIndex:length] length]>2 || *ch ==46) return NO;
    }
    return YES;
}


@end
