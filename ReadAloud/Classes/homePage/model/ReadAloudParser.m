//
//  ReadAloudParser.m
//  ReadAloud
//
//  Created by 卢腾达 on 2018/11/7.
//  Copyright © 2018 卢腾达. All rights reserved.
//

#import "ReadAloudParser.h"
#import "ReadChapterModel.h"


@implementation ReadAloudParser

- (void)parserPathModel:(ReadBookModel *)model block:(parserBlock)pBlock{
    dispatch_queue_t globalQueue = dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0);
    dispatch_async(globalQueue, ^{
        
        ReadBookModel *readModel = [self parserPathModel:model];
        
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            
            pBlock(readModel);
        });
        
    });
}

- (ReadBookModel *)parserPathModel:(ReadBookModel *)model{
    
    ReadBookModel *readModel = [ReadBookModel new];
    if (![readModel IsExistReadModelBookName:model.bookName]) {
        
        readModel = [self readAloudBookParserModel:model];
        readModel.bookPath = model.bookPath;
        [readModel save];
    }else{
       readModel = [readModel readModelBookName:model.bookName];
    }
    
    return readModel;
}

//解析小说
- (ReadBookModel *)readAloudBookParserModel:(ReadBookModel *)model{
    
    NSString *path = model.bookPath;
    
    ReadBookModel *readBookModel = [ReadBookModel new];
    readBookModel.bookName = model.bookName;
    
    NSString *parten = @"第[0-9一二三四五六七八九十百千]*[章回].*";
    NSURL *url = [NSURL fileURLWithPath:path];
    NSString *content = [self EncodeURL:url];
    
    NSError *error;
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:parten options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) {
        return readBookModel;
    }
    
    content = [self composingContent:content];
    NSArray *chapterArray = [regular matchesInString:content options:NSMatchingReportCompletion range:NSMakeRange(0, content.length)];
    
    // 数量
    NSUInteger count = chapterArray.count;
    NSMutableArray *chapterContentArray = [NSMutableArray array];
    if (count >0) {
        
        // 记录最后一个Range
        NSRange lastRange = NSMakeRange(0, 0);
        // 记录 上一章 模型
        ReadChapterModel * lastReadChapterModel;
        for (int i = 0; i < count; i++) {
            
            NSLog(@"总章节数:%lu  当前解析到:%d",(unsigned long)count,i+1);
            NSTextCheckingResult *result = chapterArray[i];
            NSRange range = NSMakeRange(0, 0);
            NSInteger location = 0;
            
            if (i < count) {
                range = result.range;
                location = range.location;
            }
            ReadChapterModel *readChapterModel = [ReadChapterModel new];
            readChapterModel.bookName = model.bookName;
            readChapterModel.chapterID = [NSString stringWithFormat:@"%d",i];
            if (i == 0) {
                // 章节名
                readChapterModel.chapterName = @"开始";
                // 内容
                readChapterModel.content = [content substringWithRange:NSMakeRange(0, location)];
                // 记录
                lastRange = range;
            }else if (i == count - 1){
                // 章节名
                readChapterModel.chapterName = [content substringWithRange:lastRange];
                // 内容
                readChapterModel.content = [content substringWithRange:NSMakeRange(lastRange.location, content.length - lastRange.location)];
                
            }else{
                // 章节名
                readChapterModel.chapterName = [content substringWithRange:lastRange];
                // 内容
                readChapterModel.content = [content substringWithRange:NSMakeRange(lastRange.location, location - lastRange.location)];
            }
            //删除章节名称
            readChapterModel.content = [readChapterModel.content stringByReplacingOccurrencesOfString:readChapterModel.chapterName withString:@""];

            //判断章节内容是否有内容 如果没有就跳过
            if (readChapterModel.content.length < 10 || [readChapterModel.content isEqualToString:@"\n"]){
                continue;
            }
            // 设置上下章ID
            if (lastReadChapterModel) {
                readChapterModel.lastChapterID = lastReadChapterModel.chapterID;
                lastReadChapterModel.nextChaperID = readChapterModel.chapterID;
            }
            // 保存
//            [readChapterModel save];
//            if (lastReadChapterModel) {
//                [lastReadChapterModel save];
//            }
            [chapterContentArray addObject:readChapterModel];
            
            // 记录
            lastRange = range;
            lastReadChapterModel = readChapterModel;
        }
    }
    readBookModel.chapterModels = chapterContentArray;
    return readBookModel;
}


//清除多余字符
- (NSString *)composingContent:(NSString *)content{
    
    content = [content stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    NSRegularExpression* regularExpression = [NSRegularExpression regularExpressionWithPattern:@"\\s*\\n+\\s*" options:NSRegularExpressionCaseInsensitive error:nil];

    content = [regularExpression stringByReplacingMatchesInString:content options:NSMatchingReportProgress range:NSMakeRange(0, content.length) withTemplate:@"\n"];
    
    return content;
}

- (NSString *)EncodeURL:(NSURL *)url{
    NSString* content = @"";
    // 检查URL是否有值
    if (url.absoluteString.length == 0) {
        return content;
    }
    // NSUTF8StringEncoding 解析
    content = [self EncodeURL:url encoding:NSUTF8StringEncoding];
    // 进制编码解析
    if (!content) {
//        GB 18030
        content = [self EncodeURL:url encoding:0x80000632];
    }
    if (!content) {
//        GBK
        content = [self EncodeURL:url encoding:0x80000631];
    }
    if (!content) {
        content = @"";
    }
    return content;
}

- (NSString *)EncodeURL:(NSURL *)url encoding:(uint)encoding{
    
    NSError *error;
    NSString *content = [NSString stringWithContentsOfURL:url encoding:encoding error:&error];
    if (!error) {
        return content;
    }
    return nil;
}

@end
