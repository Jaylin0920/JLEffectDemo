//
//  ViewController.m
//  JLInputMoney
//
//  Created by JiBaoBao on 2018/6/24.
//  Copyright © 2018年 JiBaoBao. All rights reserved.
//

#define myDotNumbers @"0123456789.\n"
#define myNumbers @"0123456789\n"

#import "ViewController.h"

@interface ViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textField.delegate = self;
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return [self validateAmountWithTextField:textField range:range replacementString:string];
}

/**
 金钱输入 合法性检验
 规则：只能出现"0-9"数字和"."，最多输入9位，最多两位小数，小数点后不能在出现小数点
 */
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


@end
