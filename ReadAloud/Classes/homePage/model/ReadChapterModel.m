//
//  ReadChapterModel.m
//  ReadAloud
//
//  Created by 卢腾达 on 2018/11/7.
//  Copyright © 2018 卢腾达. All rights reserved.
//

#import "ReadChapterModel.h"
#import <objc/message.h>

@implementation ReadChapterModel

/**
 归档按照bookName 和章节ID
 */
- (void)save{
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [NSString stringWithFormat:@"%@/ReadAloud/%@",[documentPaths objectAtIndex:0],self.bookName];
    NSFileManager *manager = [NSFileManager defaultManager];
    
    
    //判断是否存在文件夹
    BOOL isDic;
    if(![manager fileExistsAtPath:documentDir isDirectory:&isDic]||(!isDic)){
        if([manager createDirectoryAtPath:documentDir withIntermediateDirectories:YES attributes:nil error:nil]) {
            
            documentDir = [NSString stringWithFormat:@"%@/%@",documentDir,self.chapterID];
        }
    }else{
        documentDir = [NSString stringWithFormat:@"%@/%@",documentDir,self.chapterID];
    }

    
    
    [NSKeyedArchiver archiveRootObject:self toFile:documentDir];
}


- (void)encodeWithCoder:(NSCoder *)aCoder{
    unsigned  int  count;
    Ivar * vars =   class_copyIvarList([self class], &count);
    for (int i = 0 ; i < count; i ++) {
        Ivar var = vars[i];
        char * s  =  (char*)ivar_getName(var);
        NSString * key =[NSString stringWithUTF8String:s];
        [aCoder encodeObject:[self valueForKey:key] forKey:key];
    }
    free(vars);
    
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    unsigned int count = 0;
    Ivar * vars = class_copyIvarList([self class], &count);
    for (int i = 0 ; i < count;  i ++) {
        Ivar var = vars [i];
        const char * name = ivar_getName(var);
        NSString * key = [NSString stringWithUTF8String:name];
        id object = [aDecoder decodeObjectForKey:key];
        [self setValue:object forKey:key];
    }
    free(vars);
    return self;
}
@end
