//
//  SetingViewController.m
//  ReadAloud
//
//  Created by 卢腾达 on 2018/11/8.
//  Copyright © 2018 卢腾达. All rights reserved.
//

#import "SetingViewController.h"

@interface SetingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UILabel *rightLabel;

@end

@implementation SetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"设置";
    [self.view addSubview:self.tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightLabel];
}
- (void)sliderValueChanged:(UISlider *)sender{
    CGFloat value = sender.value;
    self.rightLabel.text = [NSString stringWithFormat:@"%.2f",value];
}
- (void)sliderTouchUpInside:(UISlider *)sender{
    [ReadAloudManager defaultManager].rate = sender.value;
}
#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = self.dataArray[section];
    return array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdf = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdf];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdf];
    }
    
    cell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];
    cell.textLabel.textColor = UIColorFromRGB(0x292929);
    cell.backgroundColor = UIColor.whiteColor;
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
 
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    if (section == 0) {
        [view  addSubview:self.slider];
    }
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 44;
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text isEqualToString:@"男声"]) {
        
    }else if ([cell.textLabel.text isEqualToString:@"女声"]){
        
    }
    
    if (indexPath.section == 1) {
        [ReadAloudManager defaultManager].language = cell.textLabel.text;
    }
    
}

#pragma mark - 懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = UIColorFromRGB(0xe2e2e2);
        _tableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    }
    return _tableView;
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        
        //    zh-HK
        //    zh-cn
        //    zh-TW
        _dataArray = [NSMutableArray array];
        NSArray *arr = @[@"男声",@"女声"];
        NSArray *arr2 = @[@"zh-HK",@"zh-cn",@"zh-TW"];
        [_dataArray addObject:arr];
        [_dataArray addObject:arr2];
    }
    return _dataArray;
}
- (UISlider *)slider{
    if (!_slider) {
        _slider = [[UISlider alloc]initWithFrame:CGRectMake(30, 10, self.view.bounds.size.width - 60, 30)];
        _slider.minimumValue = 0.4;
        _slider.maximumValue = 0.6;
        _slider.value = [ReadAloudManager defaultManager].rate;
        _slider.minimumValueImage = [ZNUtil imageWithString:@"慢" font:[UIFont systemFontOfSize:18] width:30 textAlignment:NSTextAlignmentRight];
        _slider.maximumValueImage = [ZNUtil imageWithString:@"快" font:[UIFont systemFontOfSize:18] width:30 textAlignment:NSTextAlignmentLeft];
        [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_slider addTarget:self action:@selector(sliderTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _slider;
}
- (UILabel *)rightLabel{
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
        _rightLabel.font = [UIFont systemFontOfSize:18];
        _rightLabel.textAlignment = NSTextAlignmentRight;
        _rightLabel.text = [NSString stringWithFormat:@"%.2f",[ReadAloudManager defaultManager].rate];
    }
    return _rightLabel;
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
