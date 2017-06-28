//
//  YKAlertController.h
//  YKAlertController
//
//  Created by stefanie on 2017/6/27.
//  Copyright © 2017年 Stefanie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BJAlertControllerHandle)();

@interface YKAlertController : UIViewController

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message;

- (void)showWithAnimated:(BOOL)animated;
- (void)hideWithAnimated:(BOOL)animated;

@property (nonatomic, copy) BJAlertControllerHandle cancleHandle;          // 取消事件回调
@property (nonatomic, copy) BJAlertControllerHandle clickActionHandle;     // 点击确认事件回调

@property (nonatomic, copy) NSString *contentTitle;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *cancleString;
@property (nonatomic, copy) NSString *sureString;

@end
