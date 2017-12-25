//
//  BBTextView.m
//  BBTextView
//
//  Created by ibabyblue on 2017/12/19.
//  Copyright © 2017年 ibabyblue. All rights reserved.
//  布局公式:firstItem.firstAttribute {==,<=,>=} secondItem.secondAttribute * multiplier + constant

#import "BBTextView.h"

#define iOS_8_3 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.3f
#define kScreenW [[UIScreen mainScreen] bounds].size.width
//根据iPhone6字体字体设置
#define font(R) (R)*(kScreenW)/375.0

typedef void(^textViewBlock)(DDTextView *textView);

@interface BBTextView ()<UITextViewDelegate>
@property (nonatomic, strong) UILabel                   *prompt;
@property (nonatomic, strong) DDTextView                *textView;
@property (nonatomic, assign) BBTextViewStyle           style;
@property (nonatomic, assign) BOOL                      isHavePrompt;
@property (nonatomic, copy) textViewBlock               textViewBlock;
@property (nonatomic, copy) NSString                    *promptNumber;
@end

@implementation BBTextView

#pragma mark - DDStyleTextView属性懒加载
- (UILabel *)prompt{
    if (_prompt == nil) {
        _prompt = [[UILabel alloc] init];
        _prompt.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _prompt;
}
#pragma mark - DDStyleTextView属性setter方法
- (void)setPlaceHolder:(NSString *)placeHolder{
    _placeHolder = placeHolder;
    if (self.style != BBTextViewStyleNormal) {
        self.textView.placeholder.text = placeHolder;
    }
    if ([self.textView.placeholder isHidden]) {
        if (!self.text) {
            self.textView.placeholder.hidden = NO;
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.textView setNeedsLayout];
    });
}

- (void)setPlaceHolderColor:(UIColor *)placeHolderColor{
    _placeHolderColor = placeHolderColor;
    self.textView.placeholder.textColor = placeHolderColor;
}

- (void)setText:(NSString *)text{
    _text = text;
    self.textView.text = text;
    if (self.promptNumber) {
        [self setPromptNumber:self.promptNumber];
    }
    if (text && ![text isEqualToString:@""]) {
        self.textView.placeholder.hidden = YES;
    }
}

- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    self.textView.textColor = textColor;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment{
    _textAlignment = textAlignment;
    self.textView.textAlignment = textAlignment;
}

- (void)setFont:(UIFont *)font{
    _font = font;
    self.textView.font = font;
    self.textView.placeholder.font = font;
}

- (void)setPromptNumber:(NSString *)promptNumber{
    _promptNumber = promptNumber;
    if ([promptNumber integerValue] == self.text.length - 1) {
        self.text ? (self.prompt.text = @"0") : (self.prompt.text = promptNumber);
    }else{
        self.text ? (self.prompt.text = [NSString stringWithFormat:@"%lu",(unsigned long)[promptNumber integerValue] - self.text.length]) : (self.prompt.text = promptNumber);
    }
}

- (void)setPromptColor:(UIColor *)promptColor{
    _promptColor = promptColor;
    self.prompt.textColor = promptColor;
}

- (void)setPromptFont:(UIFont *)promptFont{
    _promptFont = promptFont;
    self.prompt.font = promptFont;
}

- (void)setLineSpacing:(CGFloat)lineSpacing{
    _lineSpacing = lineSpacing;
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = lineSpacing;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:self.font ? self.font : [UIFont systemFontOfSize:font(12)],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    self.textView.typingAttributes = attributes;
}

- (void)setSelectable:(BOOL)selectable{
    _selectable = selectable;
    self.textView.selectable = selectable;
}

- (void)setMaxLength:(CGFloat)maxLength{
    _maxLength = maxLength;
    
}

#pragma mark - DDStyleTextView初始化
- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //1.初始化
        [self setupUI];
        //2，设置默认类型
        if (!_isHavePrompt) {
            if (!self.style) {
                self.style = BBTextViewStyleNormal;
            }
        }
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        //1.初始化
        [self setupUI];
        //2，设置默认类型
        if (!_isHavePrompt) {
            if (!self.style) {
                self.style = BBTextViewStyleNormal;
            }
        }
    }
    return self;
}

- (instancetype)initWithStyle:(BBTextViewStyle)style textView:(void (^ _Nullable)(DDTextView * _Nullable))textView{
    if (self = [super init]) {
        //1.保存类型
        self.style = style;
        //2.保存block
        self.textViewBlock = textView;
    }
    return self;
}

- (instancetype)initWithPromptNumber:(NSString *)promptNumber textView:(nonnull void (^)(DDTextView * _Nonnull))textView{
    
    //1.设置是否存在提醒数字
    self.isHavePrompt = YES;
    
    if (self = [super init]) {
        //1.保存block
        self.textViewBlock = textView;
        //2.设置提醒数字
        self.promptNumber = promptNumber;
    }
    return self;
}

- (void)setupUI{
    //1.初始化
    self.textView = [[DDTextView alloc] init];
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    self.textView.delegate = self;
    [self addSubview:self.textView];
    
    //2.提醒数字
    self.prompt.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.prompt];
    self.promptColor ? (self.prompt.textColor = self.promptColor) : (self.prompt.textColor = [UIColor colorWithRed:212.0/255.0 green:212.0/255.0 blue:212.0/255.0 alpha:1]);
    self.promptFont ? (self.prompt.font = self.promptFont) : (self.prompt.font = [UIFont systemFontOfSize:font(12)]);
    
    //3.设置placeholder颜色
    self.placeHolderColor ? (self.textView.placeholder.textColor = self.placeHolderColor) : (self.textView.placeholder.textColor = [UIColor colorWithRed:212.0/255.0 green:212.0/255.0 blue:212.0/255.0 alpha:1]);
    
}

#pragma mark - 系统布局回调函数
- (void)updateConstraints{
    
    //1.正常布局（无提示数字）
    void (^normalStyleBlock)(void) = ^(){
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.textView.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.textView.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        [self addConstraints:@[topConstraint,leftConstraint]];
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.textView.superview attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.textView.superview attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
        [self addConstraints:@[widthConstraint,heightConstraint]];
    };
    
    //1.带有提示数字的布局
    void (^promptStyleBlock)(void) = ^(){
        
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.textView.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.textView.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.textView.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.textView.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-30];
        [self addConstraints:@[topConstraint,leftConstraint,rightConstraint,bottomConstraint]];
        
        NSLayoutConstraint *promptRightConstraint = [NSLayoutConstraint constraintWithItem:self.prompt attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.prompt.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:-15];
        NSLayoutConstraint *promptBottomConstraint = [NSLayoutConstraint constraintWithItem:self.prompt attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.prompt.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10];
        NSLayoutConstraint *promptHeightConstraint = [NSLayoutConstraint constraintWithItem:self.prompt attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:20];
        [self addConstraints:@[promptRightConstraint,promptBottomConstraint,promptHeightConstraint]];
        
    };
    
    switch (self.style) {
        case BBTextViewStyleNormal:
            normalStyleBlock();
            break;
        case BBTextViewStylePlaceHolder:
            normalStyleBlock();
            break;
        default:
            break;
    }
    
    if (_isHavePrompt) {
        promptStyleBlock();
    }
    
    [super updateConstraints];
}

+ (BOOL)requiresConstraintBasedLayout{
    return YES;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    [super setBackgroundColor:backgroundColor];
    self.textView.backgroundColor = backgroundColor;
}

#pragma mark - UITextView代理方法
- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length <= [self.promptNumber integerValue]) {
        self.prompt.text = [NSString stringWithFormat:@"%lu",(unsigned long)[self.promptNumber integerValue] - textView.text.length];
    }else{
        self.prompt.text = @"0";
    }
    
    if (self.promptNumber && self.maxLength) {
        if (textView.text.length > [self.promptNumber integerValue]) {
            textView.text = [textView.text substringToIndex:[self.promptNumber integerValue]];
        }
    }else if (self.maxLength){
        if (textView.text.length > self.maxLength) {
            textView.text = [textView.text substringToIndex:self.maxLength];
        }
    }else if (self.promptNumber){
        if (textView.text.length > [self.promptNumber integerValue]) {
            textView.text = [textView.text substringToIndex:[self.promptNumber integerValue]];
        }
    }else{
        
    }
    
    if (!(iOS_8_3)) {
        if ([textView.text isEqualToString:@""]) {
            self.textView.placeholder.hidden = NO;
        }else{
            self.textView.placeholder.hidden = YES;
        }
    }
    
    if (self.textViewBlock) {
        self.textViewBlock((DDTextView *)textView);
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (self.textViewBlock) {
        self.textViewBlock((DDTextView *)textView);
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if (self.textViewBlock) {
        self.textViewBlock((DDTextView *)textView);
    }
    return YES;
}

@end

@interface DDTextView ()
@end
@implementation DDTextView
#pragma mark - DDTextView属性懒加载
- (UILabel *)placeholder{
    if (_placeholder == nil) {
        _placeholder = [[UILabel alloc] init];
    }
    return _placeholder;
}

#pragma mark - DDTextView初始化
- (instancetype)init{
    if (self = [super init]) {
        //1.初始化
        [self setupUI];
    }
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    return self;
}

/**
 初始化
 */
- (void)setupUI{
    
    //1.占位文字
    self.font ? (self.placeholder.font = self.font) : (self.placeholder.font = [UIFont systemFontOfSize:font(12)]);
    //1.1添加此代码是为了确保在不设置UITextView的文字大小的时候，占位文字正常显示。（不添加，在不设置UITextView的文字大小时，出现文件上移，删除为空后回复正常）
    self.font ? nil : [self setFont:[UIFont systemFontOfSize:font(12)]];
    self.placeholder.textAlignment = NSTextAlignmentLeft;
    self.placeholder.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.placeholder sizeToFit];
    [self addSubview:self.placeholder];
    
    if (iOS_8_3) {
        [self setValue:self.placeholder forKey:@"_placeholderLabel"];
    }else{
        
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.placeholder attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.placeholder.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:7];
        NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.placeholder attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.placeholder.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:6];
        [self addConstraints:@[topConstraint,leftConstraint]];

    }
}

#pragma mark - 字体setter方法
-(void)setFont:(UIFont *)font{
    [super setFont:font];
    self.placeholder.font = font;
}
@end

