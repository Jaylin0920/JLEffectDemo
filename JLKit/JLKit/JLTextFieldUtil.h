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
 
 规则：只能是0-9数字，最多输入9位，最多两位小数，小数点后不能在出现小数点
 （0:空格键  46:"."   48:"0"   57:"9"）
 */
+ (BOOL)validateAmountWithTextField:(UITextField *)textField range:(NSRange )range replacementString:(NSString *)string;

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