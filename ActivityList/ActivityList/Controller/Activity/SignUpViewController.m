//
//  SignUpViewController.m
//  ActivityList
//
//  Created by admin on 2017/8/19.
//  Copyright © 2017年 Edu. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *verificationTextField;
- (IBAction)getVerificationAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;
- (IBAction)signUpAction:(UIButton *)sender forEvent:(UIEvent *)event;

@property(strong,nonatomic)UIActivityIndicatorView *avi;
@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - request
//获取验证码
- (void)request{
    //点击按钮的时候创建一个蒙层，并显示在当前页面
    _avi = [Utilities getCoverOnView:self.view];
    
    //参数
    NSDictionary *para = @{@"userTel" : _userNameTextField.text,@"type" : @1};
    //网络请求
    [RequestAPI requestURL:@"/register/verificationCode" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"验证码 = %@",responseObject);
        //当网络请求成功时让蒙层消失
        [_avi stopAnimating];
        if([responseObject[@"resultFlag"]intValue] == 8001){
            //NSDictionary *result = responseObject[@"result"];
//            NSString *exponent = result[@"exponent"];
//            NSString *modulus = result[@"modulus"];
//            //对内容进行MD5加密
//            NSString *md5Str = [_passwordTextField.text getMD5_32BitString];
//            //用模数与指数对MD5加密过后的密码进行加密
//            NSString *rsaStr = [NSString encryptWithPublicKeyFromModulusAndExponent:md5Str.UTF8String modulus:modulus exponent:exponent];
//            // NSLog(@"%@,%@",exponent,modulus);
//            [self registerRequest:rsaStr];
        }else {
            //业务逻辑失败的情况下
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"resultFlag"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        //当网络请求失败时让蒙层消失
        [_avi stopAnimating];
        [Utilities
         popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
}


//注册
- (void)registerRequest{
    //点击按钮的时候创建一个蒙层，并显示在当前页面
    _avi = [Utilities getCoverOnView:self.view];
    //对内容进行MD5加密
   // NSString *md5Str = [_passwordTextField.text getMD5_32BitString];
    //用模数与指数对MD5加密过后的密码进行加密
    //NSString *rsaStr = [NSString encryptWithPublicKeyFromModulusAndExponent:md5Str.UTF8String modulus:modulus exponent:exponent];
    // NSLog(@"%@,%@",exponent,modulus);
    //[self registerRequest:rsaStr];
    //参数
    NSDictionary *para = @{@"userTel" :  _userNameTextField.text,@"userPwd" :  _passwordTextField.text,@"nickname" : _nickNameTextField.text,@"nums" :  _verificationTextField.text,@"invitationCode" :  @"",@"deviceType" :  @7001,@"deviceId" : [Utilities uniqueVendor]};
    //网络请求
    [RequestAPI requestURL:@"/register" withParameters:para andHeader:nil byMethod:kPost andSerializer:kJson success:^(id responseObject) {
        //NSLog(@"登录 = %@",responseObject);
        //当网络请求成功时让蒙层消失
        [_avi stopAnimating];
        if([responseObject[@"resultFlag"]intValue] == 8001){
            NSDictionary *result = responseObject[@"result"];
           
          
        } else {
            //业务逻辑失败的情况下
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"resultFlag"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        //当网络请求失败时让蒙层消失
        [_avi stopAnimating];
        [Utilities
         popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
}


- (IBAction)getVerificationAction:(UIButton *)sender forEvent:(UIEvent *)event {
    //判断某个字符串中是否都是数字
    NSCharacterSet *notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if (_userNameTextField.text.length < 11 || [_userNameTextField.text rangeOfCharacterFromSet:notDigits].location != NSNotFound){
        [Utilities
            popUpAlertViewWithMsg:@"请输入有效的手机号码" andTitle:nil onView:self];
        return;
    }
    
    if (_userNameTextField.text.length == 0){
            [Utilities
             popUpAlertViewWithMsg:@"请输入你的手机号" andTitle:nil onView:self];
            return;
        }
    
    if (_nickNameTextField.text.length == 0){
        [Utilities
         popUpAlertViewWithMsg:@"请输入你的昵称" andTitle:nil onView:self];
        return;
    }
    
    if (_passwordTextField.text.length == 0){
        [Utilities
            popUpAlertViewWithMsg:@"请输入密码" andTitle:nil onView:self];
        return;
    }
    if (_passwordTextField.text.length < 6 || _passwordTextField.text.length > 18){
        [Utilities
            popUpAlertViewWithMsg:@"您输入的密码必须在6-18之间" andTitle:nil onView:self];
        return;
    }
    
    if (_confirmPwdTextField.text.length == 0){
        [Utilities
         popUpAlertViewWithMsg:@"请确认您的密码" andTitle:nil onView:self];
        return;
    }
    
    if (![_passwordTextField.text isEqualToString:_confirmPwdTextField.text]){
        [Utilities
         popUpAlertViewWithMsg:@"两次密码输入不一致" andTitle:nil onView:self];
        return;
    }
    
    [self request];
}
- (IBAction)signUpAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
