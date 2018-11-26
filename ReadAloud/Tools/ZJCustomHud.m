//
//  ZJCustomHud.m
//  ZJMsgListViewCtl
//
//  Created by zj on 2016/12/8.
//  Copyright © 2016年 zj. All rights reserved.
//

#import "ZJCustomHud.h"

@interface ZJCustomHud()

@end
@implementation ZJCustomHud
static ZJCustomHud * Hud = nil;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    }
    return self;
}


+ (void)showWithText:(NSString*)text WithDurations:(CGFloat)duration{
    
    
    //动态计算文字的高度  如果高于40 就取计算值
    CGSize size =  [ZNUtil makeSize:text font:14 width:[UIScreen mainScreen].bounds.size.width*0.42 hight:0];
    CGFloat h = 40;
    
    h = size.height+30;

    static ZJCustomHud * custom;
    static UILabel* label;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        custom = [[ZJCustomHud alloc]initWithFrame:[UIScreen mainScreen].bounds];
        label = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-[UIScreen mainScreen].bounds.size.width*0.42/2, [UIScreen mainScreen].bounds.size.height/2-20, [UIScreen mainScreen].bounds.size.width*0.42, h)];
    });
    [[UIApplication sharedApplication].keyWindow addSubview:custom];
 
    //添加提示框
    label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:12];
    label.textColor = [UIColor whiteColor];
    [custom addSubview:label];
    label.layer.masksToBounds=YES;
    label.layer.cornerRadius=3;
    label.numberOfLines = 0;
    
    //视图消失
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [custom removeFromSuperview];
    });
    
    
}


+ (void)showWithStatus:(NSString*)text
{
    ZJCustomHud * custom = [[ZJCustomHud alloc]initWithFrame:[UIScreen mainScreen].bounds];
    Hud=custom;
    [[UIApplication sharedApplication].keyWindow addSubview:custom];
    
    
    UIView * customView = [[UIView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-75, [UIScreen mainScreen].bounds.size.height/2-50, 150, 120)];
    customView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [custom addSubview:customView];
    customView.layer.masksToBounds = YES;
    customView.layer.cornerRadius=10;
    
    
    
    UIImageView *heartImageView = [[UIImageView alloc]initWithFrame:CGRectMake(customView.frame.size.width/2-25, 25,50, 50)];
    [customView addSubview:heartImageView];
//    NSMutableArray *images = [[NSMutableArray alloc]initWithCapacity:7];

    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"ZNload" withExtension:@"gif"]; //加载GIF图片
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef) fileUrl, NULL);           //将GIF图片转换成对应的图片源
    size_t frameCout = CGImageSourceGetCount(gifSource);                                         //获取其中图片源个数，即由多少帧图片组成
    NSMutableArray *frames = [[NSMutableArray alloc] init];                                      //定义数组存储拆分出来的图片
    for (size_t i = 0; i < frameCout; i++) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifSource, i, NULL); //从GIF图片中取出源图片
        UIImage *imageName = [UIImage imageWithCGImage:imageRef];                  //将图片源转换成UIimageView能使用的图片源
        [frames addObject:imageName];                                              //将图片加入数组中
        CGImageRelease(imageRef);
    }
    
    
    heartImageView.animationImages = frames;
    heartImageView.animationDuration = 0.4 ;
    heartImageView.animationRepeatCount = MAXFLOAT;
    [heartImageView startAnimating];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(customView.frame.size.width/2-50, 80, 100, 40)];
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = [UIColor whiteColor];
    [customView addSubview:label];
    
}


+(void)showWithSuccess:(NSString*)successString//成功提示
{
    ZJCustomHud * custom = [[ZJCustomHud alloc]initWithFrame:[UIScreen mainScreen].bounds];
    Hud=custom;
    [[UIApplication sharedApplication].keyWindow addSubview:custom];
    
    
    UIView * customView = [[UIView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-75, [UIScreen mainScreen].bounds.size.height/2-50, 150, 100)];
    customView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [custom addSubview:customView];
    customView.layer.masksToBounds = YES;
    customView.layer.cornerRadius=10;
    
    
    
    UIImageView *heartImageView = [[UIImageView alloc]initWithFrame:CGRectMake(customView.frame.size.width/2-20, 15,40, 40.0)];
    heartImageView.contentMode=1;
    [customView addSubview:heartImageView];
    heartImageView.image = [UIImage imageNamed:@"成功图片"];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(customView.frame.size.width/2-50, 55, 100, 40)];
    label.text = successString;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = [UIColor whiteColor];
    [customView addSubview:label];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [custom removeFromSuperview];
    });
}

//失败提示
+(void)showWithError:(NSString *)errorString
{
    ZJCustomHud * custom = [[ZJCustomHud alloc]initWithFrame:[UIScreen mainScreen].bounds];
    Hud=custom;
    [[UIApplication sharedApplication].keyWindow addSubview:custom];
    
    
    UIView * customView = [[UIView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-75, [UIScreen mainScreen].bounds.size.height/2-50, 150, 100)];
    customView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [custom addSubview:customView];
    customView.layer.masksToBounds = YES;
    customView.layer.cornerRadius=10;
    
    
    
    UIImageView *heartImageView = [[UIImageView alloc]initWithFrame:CGRectMake(customView.frame.size.width/2-20, 15,40, 40.0)];
    heartImageView.contentMode=1;
    [customView addSubview:heartImageView];
    heartImageView.image = [UIImage imageNamed:@"失败图片"];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(customView.frame.size.width/2-50, 55, 100, 40)];
    label.text = errorString;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = [UIColor whiteColor];
    [customView addSubview:label];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [custom removeFromSuperview];
    });
}

+(void)dismiss
{
    [Hud removeFromSuperview];
}





@end
