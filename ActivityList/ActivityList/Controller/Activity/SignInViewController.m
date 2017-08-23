//
//  SignInViewController.m
//  ActivityList
//
//  Created by admin on 2017/8/19.
//  Copyright © 2017年 Edu. All rights reserved.
//

#import "SignInViewController.h"
#import "UserModel.h"
@interface SignInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signInBtn;
- (IBAction)signInAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
- (IBAction)registerAction:(UIButton *)sender forEvent:(UIEvent *)event;

@property (strong,nonatomic)UIActivityIndicatorView *avi;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviConfig];
    [self uilayout];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) naviConfig{ 
    //设置导航条的风格颜色
    self.navigationController.navigationBar.barTintColor = [UIColor darkGrayColor];
    //设置导航条标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor] };
    //设置导航条是否隐藏
    self.navigationController.navigationBar.hidden = NO;
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = YES;
    //为导航条左上角创建一个按钮
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = left;
}

//用Modal方式返回上一页
- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
    // [self.navigationController popViewControllerAnimated:YES];
}

-(void)uilayout{
    //判断是否存在用户记忆体
    if (![[Utilities getUserDefaults:@"Username"] isKindOfClass:[NSNull class]]) {
        if ([Utilities getUserDefaults:@"Username"] != nil) {
            //将用户名显示在输入框中
            _usernameTextField.text = [Utilities getUserDefaults:@"Username"];
        }
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)signInAction:(UIButton *)sender forEvent:(UIEvent *)event {
    //判断某个字符串中是否都是数字
    NSCharacterSet *notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if (_usernameTextField.text.length < 11 || [_usernameTextField.text rangeOfCharacterFromSet:notDigits].location != NSNotFound){
        [Utilities
         popUpAlertViewWithMsg:@"请输入有效的手机号码" andTitle:nil onView:self];
        return;
    }
    
    if (_usernameTextField.text.length == 0){
        [Utilities
         popUpAlertViewWithMsg:@"请输入你的手机号" andTitle:nil onView:self];
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
    //无输入异常,开始正式执行登陆接口
     [self request];
}

#pragma mark - request
//获取指数与模数
- (void)request{
    //点击按钮的时候创建一个蒙层，并显示在当前页面
    _avi = [Utilities getCoverOnView:self.view];
    
    //参数
    NSDictionary *para = @{@"deviceType" :  @7001,@"deviceId" : [Utilities uniqueVendor]};
    //NSLog(@"参数：%@",para);
    //网络请求
    [RequestAPI requestURL:@"/login/getKey" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        //NSLog(@"模数指数 = %@",responseObject);
        //当网络请求成功时让蒙层消失
        //[avi stopAnimating];
        if([responseObject[@"resultFlag"]intValue] == 8001){
            NSDictionary *result = responseObject[@"result"];
            NSString *exponent = result[@"exponent"];
            NSString *modulus = result[@"modulus"];
            //对内容进行MD5加密
            NSString *md5Str = [_passwordTextField.text getMD5_32BitString];
            //用模数与指数对MD5加密过后的密码进行加密
             NSString *rsaStr = [NSString encryptWithPublicKeyFromModulusAndExponent:md5Str.UTF8String modulus:modulus exponent:exponent];
           // NSLog(@"%@,%@",exponent,modulus);
            [self signInWithEncrytPwd:rsaStr];
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

//登录
- (void)signInWithEncrytPwd:(NSString *)encrytPwd{
    //点击按钮的时候创建一个蒙层，并显示在当前页面
 
    //参数
    NSDictionary *para = @{@"userName" :  _usernameTextField.text,@"password" :encrytPwd,@"deviceType" :  @7001,@"deviceId" : [Utilities uniqueVendor]};
    //网络请求
    [RequestAPI requestURL:@"/login" withParameters:para andHeader:nil byMethod:kPost andSerializer:kJson success:^(id responseObject) {
        //NSLog(@"登录 = %@",responseObject);
        //当网络请求成功时让蒙层消失
        [_avi stopAnimating];
        if([responseObject[@"resultFlag"]intValue] == 8001){
            NSDictionary *result = responseObject[@"result"];
            UserModel *user = [[UserModel alloc] initWithDictionary:result];
            //将登录获取到的用户信息打包存储到单例化全局变量中
            [[StorageMgr singletonStorageMgr] addKey:@"MemberInfo" andValue:user];
            //单独将用户的ID存储到单例化全局变量来作为用户是否已经登录的判断依据，同时也方便其他页面更快的使用用户ID参数
            [[StorageMgr singletonStorageMgr] addKey:@"MemberId" andValue:user.memberId];
            //如果键盘还打开就让它收回去
            [self.view endEditing:YES];
            //清空密码输入框的内容
            _passwordTextField.text = @"";
            //记忆用户名
            [Utilities setUserDefaults:@"Username" content:_usernameTextField.text];
            //用model的方式跳回上一页
            [self dismissViewControllerAnimated:YES completion:nil];
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

- (IBAction)registerAction:(UIButton *)sender forEvent:(UIEvent *)event {
}


//键盘收回
- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //让根视图结束编辑状态来达到收起键盘的目的
    [self.view endEditing:YES];
}
//按ruturn按钮收回
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //结束第一响应者
    [textField resignFirstResponder];
    return YES;
}
@end
