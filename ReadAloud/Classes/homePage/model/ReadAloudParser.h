//
//  ReadAloudParser.h
//  ReadAloud
//
//  Created by 卢腾达 on 2018/11/7.
//  Copyright © 2018 卢腾达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReadBookModel.h"

typedef void(^parserBlock)(ReadBookModel *model);
NS_ASSUME_NONNULL_BEGIN

@interface ReadAloudParser : NSObject

- (void)parserPathModel:(ReadBookModel *)model block:(parserBlock)pBlock;

- (ReadBookModel *)parserPathModel:(ReadBookModel *)model;

- (NSString *)EncodeURL:(NSURL *)url;
@end

NS_ASSUME_NONNULL_END
