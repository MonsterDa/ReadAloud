//
//  HomePageViewController.m
//  ReadAloud
//
//  Created by 卢腾达 on 2018/11/6.
//  Copyright © 2018 卢腾达. All rights reserved.
//

#import "BooklistViewController.h"
#import "ReadAloudManager.h"
#import "ReadBookModel.h"
#import "ReadAloudParser.h"
#import "ReadViewController.h"
#import "SetingViewController.h"

@interface BooklistViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation BooklistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.tableView];
    [self getiTunesFile];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStyleDone target:self action:@selector(seting)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"暂停/继续" style:UIBarButtonItemStyleDone target:self action:@selector(stop)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getiTunesFile) name:@"HOME_GET_ITUNES_FILE" object:nil];
   
}
- (void)seting{
    SetingViewController *seting = [SetingViewController new];
    [self.navigationController pushViewController:seting animated:YES];
}
- (void)stop{
    [[ReadAloudManager defaultManager] pauseSpeech];
}

//获取iTunes的共享文件
- (void)getiTunesFile{
    self.dataArray = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    NSError *error = nil;
    NSArray *fileList = [[NSArray alloc] init];
    fileList = [fileManager contentsOfDirectoryAtPath:documentDir error:&error];
    for (NSString *file in fileList) {
        if ([file hasSuffix:@".txt"]) {
            NSString *bookPath = [documentDir stringByAppendingPathComponent:file];
            
            NSArray *lyricArr = [bookPath componentsSeparatedByString:@"/"];
            
            ReadBookModel *model = [ReadBookModel new];
            model.bookName = [lyricArr lastObject];
            model.bookPath = bookPath;
            [self.dataArray addObject:model];
        }
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"星辰变(内置)" ofType:@".txt"];
    NSArray *lyricArr = [path componentsSeparatedByString:@"/"];
    ReadBookModel *model = [ReadBookModel new];
    model.bookName = [lyricArr lastObject];
    model.bookPath = path;
    [self.dataArray addObject:model];
    [self.tableView reloadData];
}


#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdf = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdf];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdf];
    }
    ReadBookModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.bookName;
    cell.textLabel.textColor = UIColorFromRGB(0x292929);
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ReadBookModel *model = self.dataArray[indexPath.row];
    ReadAloudParser *parser = [ReadAloudParser new];
    [ZJCustomHud showWithStatus:@"解析中..."];
    [parser parserPathModel:model block:^(ReadBookModel *model) {
        [ZJCustomHud dismiss];
        ReadViewController *con = [ReadViewController new];
        con.model = model;
        [self.navigationController pushViewController:con animated:YES];
        
    }];
    
}

#pragma mark - 懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = UIColorFromRGB(0xe2e2e2);
    }
    return _tableView;
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
