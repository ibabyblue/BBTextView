# BBTextView
## 功能：
    1.提供占位文字。
    2.提供右下角提示剩余输入字数。
    3.提供最大字数限制。

## 如何使用：
    1.需求：只需要占位文字
    1）导入IBBTextView.h头文件。
    2）
    
```Objective-C
IBBTextView *ibb = [[IBBTextView alloc] initWithFrame:CGRectMake(100, 100, 200, 100)];
//设置占位文字
ibb.placeholder = @"偶是个占位文字...";
//设置占位文字颜色,默认灰色
ibb.placeholderColor = [UIColor lightGrayColor];
//设置输入最大字符数
ibb.maxLength = 10;
[self.view addSubview:ibb];
```
        
    2.需求：需要占位文字和提示剩余可输入字数
    1）导入IBBTextView.h头文件。
    2）
    
```Objective-C
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
```

## 注意点：
    1.同时输入提示字数和最大字符数，最大字符数会失效，以提示字数作为最大限制输入字符。
    2.如果设置了上述方法的偏移量，即使不设置提示字数，输入内容区域依旧会偏移。

## 后续更新点：
    1.图文混排。
    2.是否可选、可copy。
    3.是否禁止开始、结束编辑时回调。
    4.将一些可选的功能设置开关，可以一键开启或者结束。
    5.暂时没有想到..piupiupiu.....这是一个项目需求的产物，可能功能不够，不过后续会持续增加一些小功能。
    6....
    7...
    8..
    9.
