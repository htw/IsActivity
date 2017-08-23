//
//  LeftViewController.m
//  ActivityList
//
//  Created by admin on 2017/8/19.
//  Copyright © 2017年 Edu. All rights reserved.
//

#import "LeftViewController.h"
#import "SignInViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UserModel.h"
@interface LeftViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
- (IBAction)loginAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
- (IBAction)settingAction:(UIButton *)sender forEvent:(UIEvent *)event;

@property (strong, nonatomic)NSArray *arr;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self uiLayout];
    [self dataInitalize];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([Utilities loginCheck]) {
        //已登录
        _loginBtn.hidden = YES;
        _usernameLabel.hidden = NO;
        UserModel *user = [[StorageMgr singletonStorageMgr] objectForKey:@"MemberInfo"];
        [_avatarImgView sd_setImageWithURL:[NSURL URLWithString:user.avatarUrl] placeholderImage:[UIImage imageNamed:@"头像"]];
        _usernameLabel.text = user.nickname;
        
    }else{
        //未登录
        _loginBtn.hidden = NO;
        _usernameLabel.hidden = YES;
        _avatarImgView.image = [UIImage imageNamed:@"头像"];
        _usernameLabel.text = @"游客";
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)uiLayout{
    //设置头像边框颜色
    _avatarImgView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
}

-(void)dataInitalize{
    _arr = @[@"我的活动",@"我的推广",@"积分中心",@"意见反馈",@"关于我们"];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//一共多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0){
        return _arr.count;
    } else {
        return  1;
    }
}

//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0){
        return 50.f;
    } else {
        return UI_SCREEN_H - 500;
    }
    
}

//设置每一组中每一行细胞被点击以后要做的事情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if ([Utilities loginCheck]) {
            switch (indexPath.row) {
                case 0:{
                    [self performSegueWithIdentifier:@"Let2MyAct" sender:nil];
                }
                    
                    break;
                case 1:{
                    
                }
                    
                    break;
                case 2:{
                    
                }
                    
                    break;
                case 3:{
                    
                }
                    
                    break;
                case 4:{
                    
                }
                    
                    break;
                default:
                    break;
            }
        }
    }else{
        //获取要跳转的页面实例
        UINavigationController *nc = [Utilities getStoryboardInstance:@"Member" byIdentity:@"SignNavi"];
        //2、用某种方式跳转到上述页面（这里用Modal的方式跳转）//执行跳转
        [self presentViewController:nc animated:YES completion:nil];
    }
    
   
}

//每行细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberCell" forIndexPath:indexPath];
        cell.textLabel.text = _arr[indexPath.row];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EmptyCell" forIndexPath:indexPath];
        cell.textLabel.text = @"";
        return  cell;
    } 
}





- (IBAction)loginAction:(UIButton *)sender forEvent:(UIEvent *)event {
    //获取要跳转的页面实例
    UINavigationController *nc = [Utilities getStoryboardInstance:@"Member" byIdentity:@"SignNavi"];
    //2、用某种方式跳转到上述页面（这里用Modal的方式跳转）//执行跳转
    [self presentViewController:nc animated:YES completion:nil];
    
}
- (IBAction)settingAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if ([Utilities loginCheck])
    {
        
    }
    else{
        //获取要跳转的页面实例
        UINavigationController *nc = [Utilities getStoryboardInstance:@"Member" byIdentity:@"SignNavi"];
        //2、用某种方式跳转到上述页面（这里用Modal的方式跳转）//执行跳转
        [self presentViewController:nc animated:YES completion:nil];
    }
}
@end
