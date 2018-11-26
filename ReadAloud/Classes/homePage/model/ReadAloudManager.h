//
//  ReadAloudManager.h
//  ReadAloud
//
//  Created by 卢腾达 on 2018/11/6.
//  Copyright © 2018 卢腾达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReadBookModel.h"
#import "ReadChapterModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReadAloudManager : NSObject

@property (nonatomic, strong) NSString *language;
@property (nonatomic, assign) CGFloat rate;

+ (instancetype)defaultManager;

- (void)startReadBookModel:(ReadBookModel *)readModel chapterModel:(ReadChapterModel *)chapterModel;



/**
 开始朗读
 */
- (void)startSpeech;

/**
 暂停
 */
- (void)pauseSpeech;

/**
 继续
 */
- (void)continueSpeech;

/**
 取消
 */
- (void)cancelSpeech;

/**
 下一章
 */
- (void)nextChapter;

/**
 上一章
 */
- (void)previousChapter;


@end

NS_ASSUME_NONNULL_END
