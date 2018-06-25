//
//  JLTextFieldUtil.h
//  JLKit
//
//  Created by JiBaoBao on 2018/6/24.
//  Copyright © 2018年 JiBaoBao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JLTextFieldUtil : NSObject

/**
 金钱输入 合法性检验
 规则：只能出现"0-9"数字和"."； 最多输入9位； 当首字符为“0”，第二字符只能输入“.”； 最多两位小数； 小数点后不能在出现小数点
 */
+ (BOOL)validateAmountWithTextField:(UITextField *)textField range:(NSRange )range replacementString:(NSString *)string;

/**
 金钱输入 合法性检验1
 规则：只能出现"0-9"数字和"."； 最多输入9位； 当首字符为“0”，第二字符只能输入“.”； 最多两位小数； 小数点后不能在出现小数点
 局限：仅适用键盘上的字符输入，如果是复制粘贴过来的文本，则此方法无效
 */
+ (BOOL)validateAmount1WithTextField:(UITextField *)textField range:(NSRange )range replacementString:(NSString *)string;

/**
 手机号 空格格式化
 规则：先空3格，再空4格； 最多11位
 */
+ (BOOL)blankFormat_phoneWithtextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

/**
 银行卡 空格格式化
 规则：4位一空格； 最多20位
 */
+ (BOOL)blankFormat_bankCardWithtextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end
