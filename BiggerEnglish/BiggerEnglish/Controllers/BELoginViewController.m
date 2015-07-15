//
//  BELoginViewController.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/6/3.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import "BELoginViewController.h"

@interface BELoginViewController ()  <UITextFieldDelegate, MBProgressHUDDelegate>

@property (nonatomic, strong) UILabel *descriptLabel;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UITextField *usernameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *loginButton;

@end

@implementation BELoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    [self configureView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)configureView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    
    UIButton *closeButton   = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame       = CGRectMake(20, 32, 30, 30);
    [closeButton setAdjustsImageWhenHighlighted:YES];
    UIImage *image = [UIImage imageNamed:@"icon_close"];
    [closeButton setImage:[image imageWithTintColor:[UIColor BEDeepFontColor]] forState:UIControlStateNormal];
    [closeButton setImage:[image imageWithTintColor:[UIColor BEHighLightFontColor]] forState:UIControlStateHighlighted];
    [closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
    
    [self.view addSubview:self.descriptLabel];
    [self.view addSubview:self.avatarImageView];
    [self.view addSubview:self.usernameTextField];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.loginButton];
    
    [self.descriptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(80);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descriptLabel.mas_bottom).with.offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(@80);
        make.width.mas_equalTo(@80);
    }];
    [self.usernameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView.mas_bottom).with.offset(50);
        make.centerX.equalTo(self.view.mas_centerX);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
    }];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.usernameTextField.mas_bottom).with.offset(30);
        make.centerX.equalTo(self.view.mas_centerX);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
    }];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextField.mas_bottom).with.offset(30);
        make.centerX.equalTo(self.view.mas_centerX);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
    }];

}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [hud removeFromSuperview];
    hud.delegate = nil;
    hud = nil;
}

- (void)login:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"都说了这只是一个演习！";
    hud.delegate = self;
    [hud hide:YES afterDelay:1.5];
}

- (UILabel *)descriptLabel {
    if (_descriptLabel != nil) {
        return _descriptLabel;
    }
    _descriptLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _descriptLabel.textAlignment = NSTextAlignmentLeft;
    _descriptLabel.textColor = [UIColor BEHighLightFontColor];
    _descriptLabel.font = [UIFont systemFontOfSize:16];
    _descriptLabel.text = @"这只是一个演习！";
    
    return _descriptLabel;
}

- (UIImageView *)avatarImageView {
    if (_avatarImageView != nil) {
        return _avatarImageView;
    }
    _avatarImageView                    = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatar_default"]];
    _avatarImageView.contentMode        = UIViewContentModeScaleAspectFill;
    _avatarImageView.clipsToBounds      = YES;
    _avatarImageView.layer.cornerRadius = 40;
    _avatarImageView.layer.borderWidth  = 1.0f;
    _avatarImageView.layer.borderColor  = [UIColor BEHighLightFontColor].CGColor;
    _avatarImageView.alpha              = 0.8;
    
    return _avatarImageView;
}

- (UITextField *)usernameTextField {
    if (_usernameTextField != nil) {
        return _usernameTextField;
    }
    _usernameTextField                               = [[UITextField alloc] init];
    _usernameTextField.textColor                     = [UIColor BEDeepFontColor];
    _usernameTextField.font                          = [UIFont systemFontOfSize:18];
    _usernameTextField.placeholder                   = @"输入用户名";
    _usernameTextField.adjustsFontSizeToFitWidth     = YES;
    _usernameTextField.clearButtonMode               = UITextFieldViewModeWhileEditing;
    _usernameTextField.borderStyle                   = UITextBorderStyleRoundedRect;
    _usernameTextField.returnKeyType                 = UIReturnKeyDone;
    _usernameTextField.enablesReturnKeyAutomatically = YES;
    _usernameTextField.delegate                      = self;
    _usernameTextField.textAlignment                 = NSTextAlignmentCenter;
    _usernameTextField.borderStyle                   = UITextBorderStyleNone;
    return _usernameTextField;
}

- (UITextField *)passwordTextField {
    if (_passwordTextField != nil) {
        return _passwordTextField;
    }
    _passwordTextField                               = [[UITextField alloc] init];
    _passwordTextField.textColor                     = [UIColor BEDeepFontColor];
    _passwordTextField.font                          = [UIFont systemFontOfSize:18];
    _passwordTextField.placeholder                   = @"输入密码";
    _passwordTextField.adjustsFontSizeToFitWidth     = YES;
    _passwordTextField.clearButtonMode               = UITextFieldViewModeWhileEditing;
    _passwordTextField.borderStyle                   = UITextBorderStyleRoundedRect;
    _passwordTextField.returnKeyType                 = UIReturnKeyDone;
    _passwordTextField.enablesReturnKeyAutomatically = YES;
    _passwordTextField.delegate                      = self;
    _passwordTextField.textAlignment                 = NSTextAlignmentCenter;
    _passwordTextField.borderStyle                   = UITextBorderStyleNone;
    _passwordTextField.secureTextEntry               = YES;
    return _passwordTextField;
}

- (UIButton *)loginButton {
    if (_loginButton != nil) {
        return _loginButton;
    }
    _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    _loginButton.backgroundColor = [UIColor BEFrenchGrayColor];
    _loginButton.size = CGSizeMake(180, 44);
    [_loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];

    return _loginButton;
}


@end
