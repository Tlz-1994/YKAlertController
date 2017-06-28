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

@end

@implementation YKAlertController

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message {
    YKAlertController *alert = [[YKAlertController alloc] init];
    alert.contentTitle = title;
    alert.message = message;
    return alert;
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
    titleLabel.textColor = BJ333Color;
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
    contentLabel.textColor = BJ666Color;
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
    
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [_contentView addSubview:cancleButton];
    [cancleButton setTitle:self.cancleString forState:UIControlStateNormal];
    [cancleButton setTitleColor:BJMainColor forState:UIControlStateNormal];
    [cancleButton setTitleColor:BJMainColor forState:UIControlStateHighlighted];
    [cancleButton setBackgroundImage:[self imageWithColor:BJHexColor(0xf5f5f5)] forState:UIControlStateHighlighted];
    [cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(sepView.mas_bottom).offset(0);
        make.left.offset(0);
        make.size.mas_equalTo(CGSizeMake(130, 47));
    }];
    [cancleButton addTarget:self action:@selector(hideWithAnimated:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    actionButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [_contentView addSubview:actionButton];
    [actionButton setTitle:self.sureString forState:UIControlStateNormal];
    [actionButton setTitleColor:BJMainColor forState:UIControlStateNormal];
    [actionButton setTitleColor:BJMainColor forState:UIControlStateHighlighted];
    [actionButton setBackgroundImage:[self imageWithColor:BJHexColor(0xf5f5f5)] forState:UIControlStateHighlighted];
    [actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(sepView.mas_bottom).offset(0);
        make.left.offset(130);
        make.size.mas_equalTo(CGSizeMake(130, 47));
    }];
    [actionButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    
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
        make.center.mas_equalTo(self.view);
    }];
    [_contentView layoutIfNeeded];
}

// 因为
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
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.windowLevel = UIWindowLevelAlert;
    [window makeKeyAndVisible];
    self.alertWindow = window;
    window.rootViewController = self;
}

- (void)hideWithAnimated:(BOOL)animated {
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.darkView.alpha = 0;
        self.contentView.transform = CGAffineTransformMakeScale(0.0, 0.0);
    } completion:^(BOOL finished) {
        self.alertWindow.rootViewController = nil;
        self.alertWindow = nil;
        if (self.cancleHandle) self.cancleHandle();
    }];
}

- (void)clickAction:(UIButton *)sender {
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.darkView.alpha = 0;
        self.contentView.transform = CGAffineTransformMakeScale(0.0, 0.0);
    } completion:^(BOOL finished) {
        self.alertWindow.rootViewController = nil;
        self.alertWindow = nil;
        if (self.clickActionHandle) self.clickActionHandle();
    }];
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

- (void)dealloc {
}

@end
