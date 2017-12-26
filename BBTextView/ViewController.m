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
    
    IBBTextView *ibb = [[IBBTextView alloc] initWithPromptNumber:nil offsetOfVertical:10 offsetOfHorizon:20 textView:^(IBBTextView * _Nonnull textView) {
        NSLog(@"%@",textView);
    }];
    ibb.placeholder = @"wa o tian na ";
    ibb.promptNumberColor = [UIColor redColor];
    ibb.frame = CGRectMake(20, 400, 200, 50);
    ibb.backgroundColor = [UIColor greenColor];
    [self.view addSubview:ibb];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
