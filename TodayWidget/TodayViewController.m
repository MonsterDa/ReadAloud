//
//  TodayViewController.m
//  TodayWidget
//
//  Created by 卢腾达 on 2018/11/9.
//  Copyright © 2018 卢腾达. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.clearColor;
    self.preferredContentSize = CGSizeMake(0, 110);
    UIButton *openApp = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
    [openApp setTitle:@"最近收听" forState:UIControlStateNormal];
    [openApp setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [openApp addTarget:self action:@selector(openApp) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:openApp];
    
}

- (void)openApp{
    [self.extensionContext openURL:[NSURL URLWithString:@"readAloud://1234567890"] completionHandler:^(BOOL success) {
        
    }];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    

    completionHandler(NCUpdateResultNewData);
}

@end
