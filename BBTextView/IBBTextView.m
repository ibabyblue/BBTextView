//
//  IBBTextView.m
//  BBTextView
//
//  Created by ibabyblue on 2017/12/26.
//  Copyright © 2017年 ibabyblue. All rights reserved.
//

#import "IBBTextView.h"

typedef void(^IBBTextViewBlock)(IBBTextView *textView);

@interface IBBTextView ()
@property (nonatomic, assign) NSInteger         offsetOfVertical;
@property (nonatomic, assign) NSInteger         offsetOfHorizon;
@property (nonatomic, assign) NSInteger         promptLength;
@property (nonatomic, assign) BOOL              isFirstSet;
@property (nonatomic, copy) IBBTextViewBlock    textViewBlock;
@end

@implementation IBBTextView
#pragma mark - 属性懒加载
- (void)setPlaceholder:(NSString *)placeholder{
    
    _placeholder = [placeholder copy];
    [self setNeedsDisplay];
    
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    
    _placeholderColor = placeholderColor;
    [self setNeedsDisplay];
    
}

- (void)setPromptNumber:(NSString *)promptNumber{
    
    if (_isFirstSet) {
        _promptLength = [promptNumber integerValue];
    }
    _isFirstSet = NO;
    _promptNumber = [promptNumber copy];
    
    if (self.offsetOfVertical) {
        self.contentInset = UIEdgeInsetsMake(0, 0, self.offsetOfVertical + (self.font.lineHeight ? self.font.lineHeight : [UIFont systemFontOfSize:12].lineHeight), 0);
    }else{
        self.contentInset = UIEdgeInsetsMake(0, 0, 10 + (self.font.lineHeight ? self.font.lineHeight : [UIFont systemFontOfSize:12].lineHeight), 0);
    }
    self.layoutManager.allowsNonContiguousLayout = NO;
    
    [self setNeedsDisplay];
    
}

- (void)setPromptNumberColor:(UIColor *)promptNumberColor{
    
    _promptNumberColor = promptNumberColor;
    [self setNeedsDisplay];
    
}

- (void)setPromptNumberFont:(UIFont *)promptNumberFont{
    
    _promptNumberFont = promptNumberFont;
    [self setNeedsDisplay];
    
}

- (void)setText:(NSString *)text{
    
    [super setText:text];
    [self setNeedsDisplay];
    
}

- (void)setFont:(UIFont *)font{
    
    [super setFont:font];
    [self setNeedsDisplay];
    
}

#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        //1.注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidBeginChange) name:UITextViewTextDidBeginEditingNotification object:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidEndChange) name:UITextViewTextDidEndEditingNotification object:self];

        _isFirstSet = YES;
    }
    return self;
    
}

- (instancetype)initWithPromptNumber:(NSString *)promptNumber offsetOfVertical:(NSInteger)offsetOfVertical offsetOfHorizon:(NSInteger)offsetOfHorizon textView:(void (^)(IBBTextView * _Nonnull))textViewBlock{
    
    if (self = [super init]) {
        //1.设置回调
        self.textViewBlock = textViewBlock;
        //2.设置提示数字
        self.promptNumber = promptNumber;
        //3.设置偏移量
        self.offsetOfVertical = offsetOfVertical;
        self.offsetOfHorizon = offsetOfHorizon;
    }
    return self;
    
}

+ (instancetype)textViewWithPromptNumber:(NSString *)promptNumber offsetOfVertical:(NSInteger)offsetOfVertical offsetOfHorizon:(NSInteger)offsetOfHorizon textView:(void (^)(IBBTextView * _Nonnull))textViewBlock{
    return [[self alloc] initWithPromptNumber:promptNumber offsetOfVertical:offsetOfVertical offsetOfHorizon:offsetOfVertical textView:textViewBlock];
}

#pragma mark - 通知方法
- (void)textDidBeginChange{
    
    if (self.textViewBlock) {
        self.textViewBlock(self);
    }
    
}
- (void)textDidChange{
    
    if (self.promptLength) {
        if (self.text.length <= self.promptLength) {
            self.promptNumber = [NSString stringWithFormat:@"%lu",(unsigned long)self.promptLength - self.text.length];
        }else{
            self.promptNumber = @"0";
        }
    }
    
    if (self.promptNumber && self.maxLength) {
        if (self.text.length > self.promptLength) {
            self.text = [self.text substringToIndex:self.promptLength];
        }
    }else if (self.maxLength){
        if (self.text.length > self.maxLength) {
            self.text = [self.text substringToIndex:self.maxLength];
        }
    }else if (self.promptNumber){
        if (self.text.length > self.promptLength) {
            self.text = [self.text substringToIndex:self.promptLength];
        }
    }else{
        
    }
    
    if (self.textViewBlock) {
        self.textViewBlock(self);
    }
    
    [self setNeedsDisplay];
    
}

- (void)textDidEndChange{
    
    if (self.textViewBlock) {
        self.textViewBlock(self);
    }
    
}

#pragma mark - 重绘方法
- (void)drawRect:(CGRect)rect{
    
    //1.绘制提醒数字
    if (self.promptNumber && ![self.promptNumber isEqualToString:@""]) {
        
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        UIFont *prompFont = self.promptNumberFont ? self.promptNumberFont : [UIFont systemFontOfSize:12];
        attrs[NSFontAttributeName] = prompFont;
        attrs[NSForegroundColorAttributeName] = self.promptNumberColor ? self.promptNumberColor : [UIColor grayColor];
        CGSize size = [self.promptNumber boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, prompFont.lineHeight) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
        CGFloat x       = rect.size.width - size.width - (self.offsetOfHorizon ? self.offsetOfHorizon : 10);
        CGFloat y       = rect.size.height - prompFont.lineHeight - (self.offsetOfVertical ? self.offsetOfVertical : 10) + rect.origin.y;
        CGFloat width   = size.width;
        CGFloat height  = prompFont.lineHeight;
        
        [self.promptNumber drawInRect:CGRectMake(x, y, width, height) withAttributes:attrs];
        
    }
    
    //2.判断是否存在字符
    if (self.hasText) return;
    
    //3.绘制占位文字
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.font;
    attrs[NSForegroundColorAttributeName] = self.placeholderColor ? self.placeholderColor : [UIColor grayColor];
    CGRect placeholderRect = CGRectMake(4, 7, rect.size.width - 2 * 4, rect.size.height - 2 * 7);
    [self.placeholder drawInRect:placeholderRect withAttributes:attrs];
    
}

#pragma mark - 控制器销毁时调用
-(void)dealloc{
    
    //1.移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidEndEditingNotification object:self];
    
}
@end
