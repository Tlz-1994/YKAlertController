//
//  ViewController.m
//  YKAlertController
//
//  Created by stefanie on 2017/6/28.
//  Copyright © 2017年 Stefanie. All rights reserved.
//

#import "ViewController.h"
#import "YKAlertController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showAlertAction:(UIButton *)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        YKAlertController *alertController = [YKAlertController alertControllerWithTitle:@"弹出来吧" message:@"具体的弹出样式和动画可以参考'YKAlertController.m'文件的写法"];
        [alertController addActionWithTitle:@"取消" clickHandle:nil];
        [alertController addActionWithTitle:@"确认" clickHandle:^{
            
        }];
        [alertController addActionWithTitle:@"取消" clickHandle:nil];
        [alertController addActionWithTitle:@"确认" clickHandle:^{
            
        }];
        [alertController showWithAnimated:YES];
    });
}

@end
