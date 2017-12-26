//
//  IBBTextView.h
//  BBTextView
//
//  Created by ibabyblue on 2017/12/26.
//  Copyright © 2017年 ibabyblue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IBBTextView : UITextView
/**占位文字*/
@property (nonatomic, copy, nullable) NSString  *placeholder;
/**占位文字字体颜色*/
@property (nonatomic, strong, nullable) UIColor *placeholderColor;
/**提示剩余可输入文字*/
@property (nonatomic, copy, nullable) NSString  *promptNumber;
/**提示剩余可输入文字字体颜色,默认为灰色*/
@property (nonatomic, strong, nullable) UIColor *promptNumberColor;
/**提示剩余可输入文字字体大小,默认大小为12*/
@property (nonatomic, strong, nullable) UIFont  *promptNumberFont;
/**最大输入字符数,如果设置了promptNumber，
 则此属性无效，限制字符数以promptNumber为准。*/
@property (nonatomic, assign) CGFloat           maxLength;

/**
 初始化动态方法（提示数字）

 @param promptNumber 提示数字
 @param offsetOfVertical 垂直方向上偏移量（底边距偏移量，默认偏移10pt）
 @param offsetOfHorizon 水平方向偏移量（右边距偏移量，默认偏移10pt）
 @param textViewBlock Block回调
 */
- (instancetype _Nullable )initWithPromptNumber:(NSString *_Nullable)promptNumber offsetOfVertical:(NSInteger)offsetOfVertical offsetOfHorizon:(NSInteger)offsetOfHorizon textView:(void(^_Nullable)(IBBTextView * _Nonnull textView))textViewBlock;

/**
 初始化静态方法（提示数字）

 @param promptNumber 提示数字
 @param offsetOfVertical 垂直方向上偏移量（底边距偏移量，默认偏移10pt）
 @param offsetOfHorizon 水平方向偏移量（右边距偏移量，默认偏移10pt）
 @param textViewBlock Block回调
 */
+ (instancetype _Nullable)textViewWithPromptNumber:(NSString *_Nullable)promptNumber offsetOfVertical:(NSInteger)offsetOfVertical offsetOfHorizon:(NSInteger)offsetOfHorizon textView:(void(^_Nullable)(IBBTextView * _Nonnull textView))textViewBlock;
@end
