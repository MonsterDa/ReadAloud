//
//  ZNUtil.h
//  zhaoNiuWang
//
//  Created by 卢腾达 on 2018/10/19.
//  Copyright © 2018 卢腾达. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZNUtil : NSObject
///计算label高度 宽度
+ (CGSize)makeSize:(NSString*)string font:(NSInteger)font width:(CGFloat)width hight:(CGFloat)hight;
+ (UIImage *)imageWithString:(NSString *)string font:(UIFont *)font width:(CGFloat)width textAlignment:(NSTextAlignment)textAlignment;
@end

NS_ASSUME_NONNULL_END
