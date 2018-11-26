//
//  ReadChapterModel.h
//  ReadAloud
//
//  Created by 卢腾达 on 2018/11/7.
//  Copyright © 2018 卢腾达. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReadChapterModel : NSObject <NSCoding>

@property (nonatomic, strong) NSString *bookName;
@property (nonatomic, strong) NSString *chapterName;
@property (nonatomic, strong) NSString *content;
//章节ID
@property (nonatomic, strong) NSString *chapterID;
//前一章节ID
@property (nonatomic, strong) NSString *lastChapterID;
//下一章节ID
@property (nonatomic, strong) NSString *nextChaperID;

- (void)save;

@end

NS_ASSUME_NONNULL_END
