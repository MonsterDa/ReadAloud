//
//  ReadBookModel.h
//  ReadAloud
//
//  Created by 卢腾达 on 2018/11/6.
//  Copyright © 2018 卢腾达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReadChapterModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReadBookModel : NSObject<NSCoding>

@property (nonatomic, strong) NSString *bookName;
@property (nonatomic, strong) NSString *bookPath;
@property (nonatomic, strong) NSArray *chapterModels;

- (void)save;
- (ReadBookModel *)readModelBookName:(NSString *)bookName;
- (BOOL)IsExistReadModelBookName:(NSString *)bookName;
@end

NS_ASSUME_NONNULL_END
