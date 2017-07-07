//
//  YKAlertController.h
//  YKAlertController
//
//  Created by stefanie on 2017/6/27.
//  Copyright © 2017年 Stefanie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YKAlertControllerHandle)();

@interface YKAlertController : UIViewController

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message;

- (void)showWithAnimated:(BOOL)animated;
- (void)hideWithAnimated:(BOOL)animated;

- (void)addActionWithTitle:(NSString *)title clickHandle:(YKAlertControllerHandle)handle;

@end
