//
//  ReadViewController.m
//  ReadAloud
//
//  Created by 卢腾达 on 2018/11/6.
//  Copyright © 2018 卢腾达. All rights reserved.
//

#import "ReadViewController.h"
#import "ReadChapterModel.h"
#import "ReadAloudManager.h"

@interface ReadViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = self.model.bookName;
    [self.view addSubview:self.tableView];
    self.dataArray = [NSMutableArray arrayWithArray:self.model.chapterModels];
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
    ReadChapterModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.chapterName;
    cell.textLabel.textColor = UIColorFromRGB(0x292929);
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ReadChapterModel *model = self.dataArray[indexPath.row];
    ReadAloudManager *manager = [ReadAloudManager defaultManager];
    [manager startReadBookModel:_model chapterModel:model];
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
