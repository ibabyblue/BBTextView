//
//  ViewController.m
//  BBTextView
//
//  Created by ibabyblue on 2017/12/19.
//  Copyright © 2017年 ibabyblue. All rights reserved.
//

#import "ViewController.h"

#import "IBBTextView.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    IBBTextView *ibb = [[IBBTextView alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
//    //设置占位文字
//    ibb.placeholder = @"偶是个占位文字...";
//    //设置占位文字颜色,默认灰色
//    ibb.placeholderColor = [UIColor lightGrayColor];
//    //设置输入最大字符数
//    ibb.maxLength = 10;
//    ibb.promptNumber = @"50";
//    [self.view addSubview:ibb];
    
    
    
    
    
    IBBTextView *ibb = [[IBBTextView alloc] initWithPromptNumber:@"100" offsetOfVertical:10 offsetOfHorizon:20 textView:^(IBBTextView * _Nonnull textView) {
        NSLog(@"%@",textView);
    }];
    ibb.frame = CGRectMake(100, 100, 200, 100);
    //设置占位文字
    ibb.placeholder = @"偶是个占位文字...";
    //设置占位文字颜色,默认灰色
    ibb.placeholderColor = [UIColor lightGrayColor];
    //设置提示可输入字数字体大小，默认12
    ibb.promptNumberFont = [UIFont systemFontOfSize:14];
    //设置提示可输入字数字体颜色
    ibb.promptNumberColor = [UIColor grayColor];
    [self.view addSubview:ibb];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
