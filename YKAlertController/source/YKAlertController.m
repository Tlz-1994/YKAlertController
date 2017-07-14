//
//  YKAlertController.m
//  YKAlertController
//
//  Created by stefanie on 2017/6/27.
//  Copyright © 2017年 Stefanie. All rights reserved.
//

#import "YKAlertController.h"

#define BJHexColor(colorV) [UIColor colorWithRed:((Byte)(colorV >> 16))/255.0 green:((Byte)(colorV >> 8))/255.0 blue:((Byte)colorV)/255.0 alpha:1]

#define BJMainColor BJHexColor(0x3eccb3)
#define BJMainBackColor BJHexColor(0xeff1f2)
#define BJ333Color  BJHexColor(0x333333)
#define BJ666Color  BJHexColor(0x666666)
#define BJ999Color  BJHexColor(0x999999)
#define BJcccColor  BJHexColor(0xcccccc)

#import <Masonry.h>

@interface YKAlertController ()

@property (nonatomic, strong) UIWindow *alertWindow;
@property (nonatomic, strong) UIView *darkView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, copy) NSString *contentTitle;
@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) NSMutableArray<NSString *> *actions;
@property (nonatomic, strong) NSMutableArray<YKAlertControllerHandle> *handles;

@end

@implementation YKAlertController

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message {
    YKAlertController *alert = [[YKAlertController alloc] init];
    alert.contentTitle = title;
    alert.message = message;
    return alert;
}

- (void)addActionWithTitle:(NSString *)title clickHandle:(YKAlertControllerHandle)handle {
    if (!title) {
        [self.actions addObject:@"标题非空"];
    } else {
        [self.actions addObject:title];
    }
    if (!handle) {
        YKAlertControllerHandle nilHanle = ^(){};
        [self.handles addObject:nilHanle];
    } else {
        [self.handles addObject:handle];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _darkView = [[UIView alloc] init];
    _darkView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self.view addSubview:_darkView];
    [_darkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsZero);
    }];
    _darkView.alpha = 0;
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_contentView];
    __weak __typeof(self)weakSelf = self;
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(260);
        make.height.offset(180);
        make.center.mas_equalTo(weakSelf.view);
    }];
    _contentView.alpha = 0;
    _contentView.layer.cornerRadius = 10;
    _contentView.clipsToBounds = YES;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [_contentView addSubview:titleLabel];
    titleLabel.textColor = BJHexColor(0x333333);
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(30);
        make.centerX.mas_equalTo(weakSelf.view);
    }];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.contentTitle;
    [titleLabel sizeToFit];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    [_contentView addSubview:contentLabel];
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = BJHexColor(0x666666);
    contentLabel.font = [UIFont systemFontOfSize:15];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(25);
        make.left.offset(20);
        make.right.offset(-20);
        make.centerX.mas_equalTo(weakSelf.view);
    }];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [paragraphStyle setLineSpacing:4];
    NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:self.message attributes:@{NSParagraphStyleAttributeName: paragraphStyle}];
    contentLabel.attributedText = attributeString;
    [contentLabel sizeToFit];
    
    UIView *sepView = [[UIView alloc] init];
    [_contentView addSubview:sepView];
    sepView.backgroundColor = BJHexColor(0xeeeeee);
    [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentLabel.mas_bottom).offset(25);
        make.height.offset(0.5);
        make.left.offset(15);
        make.right.offset(-15);
    }];
    
    // 如果只有一个按钮
    if (self.actions.count == 1) {
        UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        actionButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_contentView addSubview:actionButton];
        [actionButton setTitle:self.actions[0] forState:UIControlStateNormal];
        [actionButton setTitleColor:BJHexColor(0x3eccb3) forState:UIControlStateNormal];
        [actionButton setTitleColor:BJHexColor(0x3eccb3) forState:UIControlStateHighlighted];
        [actionButton setBackgroundImage:[self imageWithColor:BJHexColor(0xf5f5f5)] forState:UIControlStateHighlighted];
        [actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(sepView.mas_bottom).offset(0);
            make.left.right.offset(0);
            make.height.offset(47);
        }];
        [actionButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView layoutIfNeeded];
        [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(260);
            make.height.offset(actionButton.frame.origin.y+actionButton.frame.size.height);
            make.center.mas_equalTo(weakSelf.view);
        }];
        actionButton.tag = 0;   // 用tag标记点击的按钮位置
    }
    
    else if (self.actions.count == 2) {
        UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancleButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_contentView addSubview:cancleButton];
        [cancleButton setTitle:self.actions[0] forState:UIControlStateNormal];
        [cancleButton setTitleColor:BJHexColor(0x3eccb3) forState:UIControlStateNormal];
        [cancleButton setTitleColor:BJHexColor(0x3eccb3) forState:UIControlStateHighlighted];
        [cancleButton setBackgroundImage:[self imageWithColor:BJHexColor(0xf5f5f5)] forState:UIControlStateHighlighted];
        [cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(sepView.mas_bottom).offset(0);
            make.left.offset(0);
            make.size.mas_equalTo(CGSizeMake(130, 47));
        }];
        cancleButton.tag = 0;
        [cancleButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        actionButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_contentView addSubview:actionButton];
        [actionButton setTitle:self.actions[1] forState:UIControlStateNormal];
        [actionButton setTitleColor:BJHexColor(0x3eccb3) forState:UIControlStateNormal];
        [actionButton setTitleColor:BJHexColor(0x3eccb3) forState:UIControlStateHighlighted];
        [actionButton setBackgroundImage:[self imageWithColor:BJHexColor(0xf5f5f5)] forState:UIControlStateHighlighted];
        [actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(sepView.mas_bottom).offset(0);
            make.left.offset(130);
            make.size.mas_equalTo(CGSizeMake(130, 47));
        }];
        [actionButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        actionButton.tag = 1;
        
        UIView *verticalView = [[UIView alloc] init];
        verticalView.backgroundColor = BJHexColor(0xeeeeee);;
        [_contentView addSubview:verticalView];
        [verticalView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(actionButton);
            make.centerX.mas_equalTo(weakSelf.contentView);
            make.size.mas_equalTo(CGSizeMake(0.5, 20));
        }];
        
        [_contentView layoutIfNeeded];
        [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(260);
            make.height.offset(actionButton.frame.origin.y+actionButton.frame.size.height);
            make.center.mas_equalTo(weakSelf.view);
        }];
    } else {
        // 按钮数量大于2
        for (int i = 0; i < self.actions.count; i++) {
            UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
            actionButton.titleLabel.font = [UIFont systemFontOfSize:17];
            [_contentView addSubview:actionButton];
            [actionButton setTitle:self.actions[i] forState:UIControlStateNormal];
            [actionButton setTitleColor:BJHexColor(0x3eccb3) forState:UIControlStateNormal];
            [actionButton setTitleColor:BJHexColor(0x3eccb3) forState:UIControlStateHighlighted];
            [actionButton setBackgroundImage:[self imageWithColor:BJHexColor(0xf5f5f5)] forState:UIControlStateHighlighted];
            [actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(sepView.mas_bottom).offset(47*i);
                make.left.right.offset(0);
                make.height.offset(47);
            }];
            if (i != self.actions.count - 1) {
                UIView *sepView = [[UIView alloc] init];
                [_contentView addSubview:sepView];
                sepView.backgroundColor = BJHexColor(0xeeeeee);
                [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(actionButton.mas_bottom).offset(0);
                    make.height.offset(0.5);
                    make.left.offset(15);
                    make.right.offset(-15);
                }];
            }
            
            [_contentView layoutIfNeeded];
            [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.offset(260);
                make.height.offset(actionButton.frame.origin.y+actionButton.frame.size.height);
                make.center.mas_equalTo(weakSelf.view);
            }];
            [actionButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
            actionButton.tag = i;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self.alertWindow layoutIfNeeded];
    self.contentView.transform = CGAffineTransformMakeScale(1.3, 1.3);
    [super viewWillAppear:animated];
    [UIView animateWithDuration:0.3 delay:0 options:7<<16 animations:^{
        self.contentView.alpha = 1;
        self.darkView.alpha = 1;
        self.contentView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        self.contentView.transform = CGAffineTransformIdentity;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showWithAnimated:(BOOL)animated {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        window.windowLevel = UIWindowLevelAlert;
        [window makeKeyAndVisible];
        self.alertWindow = window;
        window.rootViewController = self;
    });
}

- (void)hideWithAnimated:(BOOL)animated {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.darkView.alpha = 0;
            self.contentView.transform = CGAffineTransformMakeScale(0.0, 0.0);
        } completion:^(BOOL finished) {
            self.alertWindow.rootViewController = nil;
            self.alertWindow = nil;
        }];
    });
}

- (void)clickAction:(UIButton *)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.darkView.alpha = 0;
            self.contentView.transform = CGAffineTransformMakeScale(0.0, 0.0);
        } completion:^(BOOL finished) {
            self.alertWindow.rootViewController = nil;
            self.alertWindow = nil;
            YKAlertControllerHandle handle = self.handles[sender.tag];
            if (handle) handle();
        }];
    });
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect=CGRectMake(0,0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (NSMutableArray *)actions {
    if (!_actions) {
        _actions = [[NSMutableArray alloc] init];
    }
    return _actions;
}

- (NSMutableArray *)handles {
    if (!_handles) {
        _handles = [[NSMutableArray alloc] init];
    }
    return _handles;
}


@end
