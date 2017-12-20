//
//  BBTextView.h
//  BBTextView
//
//  Created by ibabyblue on 2017/12/19.
//  Copyright © 2017年 ibabyblue. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DDTextView;

typedef NS_ENUM(NSUInteger, BBTextViewStyle) {
    /**正常,默认*/
    BBTextViewStyleNormal          = 1 << 0,
    /**带有placeholder*/
    BBTextViewStylePlaceHolder     = 1 << 1,
};

@interface BBTextView : UIView
/**显示文字*/
@property (nonatomic, copy, null_resettable) NSString   *text;
/**占位文字*/
@property (nonatomic, copy, nullable) NSString          *placeHolder;
/**显示文字字体大小，默认字体12*/
@property (nonatomic, strong, nullable) UIFont          *font;
/**显示文字字体颜色*/
@property (nonatomic, strong, nullable) UIColor         *textColor;
/**占位文字字体颜色*/
@property (nonatomic, strong, nullable) UIColor         *placeHolderColor;
/**提示数字字体颜色*/
@property (nonatomic, strong, nullable) UIColor         *promptColor;
/**提示数字字体大小*/
@property (nonatomic, strong, nullable) UIFont          *promptFont;
/**显示文字行间距*/
@property (nonatomic, assign) CGFloat                   lineSpacing;
/**显示文字对齐方式*/
@property (nonatomic, assign) NSTextAlignment           textAlignment;
/**是否可选、可交互，默认可选、可交互*/
@property (nonatomic, assign) BOOL                      selectable;
/**最大输入字符数*/
@property (nonatomic, assign) CGFloat                   maxLength;

/**
 初始化方法
 
 @param style 类型：UITextViewStyle
 */
- (instancetype _Nullable )initWithStyle:(BBTextViewStyle)style textView:(void(^_Nullable)(DDTextView * _Nullable textView))textView;
NS_ASSUME_NONNULL_BEGIN
/**
 初始化方法（提示数字）
 
 @param promptNumber 提示数字
 @param textView Block回调
 */
- (instancetype)initWithPromptNumber:(NSString *)promptNumber textView:(void(^)(DDTextView *textView))textView;
NS_ASSUME_NONNULL_END
@end

@interface DDTextView : UITextView
@property(nonatomic, strong) UILabel * _Nullable placeholder;
@end
