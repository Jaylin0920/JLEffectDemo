//
//  NSString+JLFormat.m
//  JLKit
//
//  Created by JiBaoBao on 2018/6/28.
//  Copyright © 2018年 JiBaoBao. All rights reserved.
//

#import "NSString+JLFormat.h"

@implementation NSString (JLFormat)

+ (NSString *)validateAmountWithToBeString:(NSString *)toBeString replacementString:(NSString *)string {
    // 只能出现"0-9"数字和"."
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789.\b"];
    if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
        return @"";
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
            NSInteger limitLength = location+1+limitDecimalsCount; //小数点前面长度+小数点长度+小数点后面
            toBeString = [toBeString substringToIndex:limitLength];
        }
    }
    return toBeString;
}


@end
