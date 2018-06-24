//
//  JLTextFieldUtil.h
//  JLTextBlank
//
//  Created by JiBaoBao on 2018/6/24.
//  Copyright © 2018年 JiBaoBao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JLTextFieldUtil : NSObject

/**
 手机号格式化
 
 @param textField textField
 @param range range
 @param string 字符串
 @return 格式化后的string
 */
+ (BOOL)formatPhone_addBlankWithtextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

/**
 银行卡格式化
 
 @param textField textField
 @param range range
 @param string 字符串
 @return 格式化后的string
 */
+ (BOOL)formatBankCard_addBlankWithtextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end
