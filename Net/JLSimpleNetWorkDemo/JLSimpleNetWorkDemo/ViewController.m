//
//  ViewController.m
//  JLSimpleNetWorkDemo
//
//  Created by JiBaoBao on 2018/7/19.
//  Copyright © 2018年 JiBaoBao. All rights reserved.
//

#import "ViewController.h"
#import "JLSimpleNetWork.h"
//#import "SinaPayNetWork.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSString *urlString = @"http://iappfree.candou.com:8080/free/applications/limited?currency=rmb&page=3";
    NSDictionary *params = nil;
    [JLSimpleNetWork getWithUrlString:urlString parameters:nil success:^(NSDictionary *dic) {
        NSLog(@"dic= %@",dic);
    } failure:^(NSError *error) {
        NSLog(@"error= %@",error);
    }];
    
//    [SinaPayNetWork getWithUrlString:urlString parameters:params success:^(NSDictionary *dic) {
//
//    } failure:^(NSError *error) {
//
//    }];
}

@end
