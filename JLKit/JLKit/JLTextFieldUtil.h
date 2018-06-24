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
- (BOOL)validateAmountWithTextField:(UITextField *)textField range:(NSRange )range replacementString:(NSString *)string;

@end
