//
//  ZNUtil.m
//  zhaoNiuWang
//
//  Created by 卢腾达 on 2018/10/19.
//  Copyright © 2018 卢腾达. All rights reserved.
//

#import "ZNUtil.h"

@implementation ZNUtil


+ (CGSize)makeSize:(NSString*)string font:(NSInteger)font width:(CGFloat)width hight:(CGFloat)hight{
    CGSize textSize=[string boundingRectWithSize:CGSizeMake(width, hight) options:         NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:font]} context:nil].size;
    
    return textSize;
}

+ (UIImage *)imageWithString:(NSString *)string font:(UIFont *)font width:(CGFloat)width textAlignment:(NSTextAlignment)textAlignment{
    NSDictionary *attributeDic = @{NSFontAttributeName:font};
    
    CGSize size = [string boundingRectWithSize:CGSizeMake(width, 10000)
                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine
                                    attributes:attributeDic
                                       context:nil].size;
    
    if ([UIScreen.mainScreen respondsToSelector:@selector(scale)])
    {
        if (UIScreen.mainScreen.scale == 2.0)
        {
            UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);
        } else
        {
            UIGraphicsBeginImageContext(size);
        }
    }
    else
    {
        UIGraphicsBeginImageContext(size);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor whiteColor] set];
    
    CGRect rect = CGRectMake(0, 0, size.width + 1, size.height + 1);
    
    CGContextFillRect(context, rect);
    
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = textAlignment;
    
    NSDictionary *attributes = @ {
    NSForegroundColorAttributeName:[UIColor blackColor],
    NSFontAttributeName:font,
    NSParagraphStyleAttributeName:paragraph
    };
    
    [string drawInRect:rect withAttributes:attributes];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
@end
