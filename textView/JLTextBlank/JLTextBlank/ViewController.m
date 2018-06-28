//
//  ViewController.m
//  JLTextBlank
//
//  Created by JiBaoBao on 2018/6/24.
//  Copyright © 2018年 JiBaoBao. All rights reserved.
//

#import "ViewController.h"
#import "JLTextFieldUtil.h"

@interface ViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *bankCardTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bankCardTextField.delegate = self;
    self.phoneTextField.delegate = self;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.phoneTextField) {
        return [JLTextFieldUtil blankFormat_phoneWithtextField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    if (textField == self.bankCardTextField) {
        return [JLTextFieldUtil blankFormat_bankCardWithtextField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    return YES;
}

@end
