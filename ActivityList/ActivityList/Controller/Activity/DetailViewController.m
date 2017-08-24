//
//  DetailViewController.m
//  ActivityList
//
//  Created by admin on 2017/8/1.
//  Copyright © 2017年 Edu. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *activityImgView;
@property (weak, nonatomic) IBOutlet UILabel *applyFeeLbl;

@property (weak, nonatomic) IBOutlet UIButton *applyBtn;
@property (weak, nonatomic) IBOutlet UILabel *applyStateLbl;
@property (weak, nonatomic) IBOutlet UILabel *attendenceLbl;
@property (weak, nonatomic) IBOutlet UILabel *typeLbl;
@property (weak, nonatomic) IBOutlet UILabel *issuerLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UILabel *applyDueLbl;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UIView *applyStartView;
@property (weak, nonatomic) IBOutlet UIView *applyDueView;
@property (weak, nonatomic) IBOutlet UIView *applyIngView;
@property (weak, nonatomic) IBOutlet UIView *applyEndView;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;
- (IBAction)applyAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)callAction:(UIButton *)sender forEvent:(UIEvent *)event;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviConfig];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self networkRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) naviConfig{
    //设置导航条标题文字
    self.navigationItem.title =_activity.name1;
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
}
-(void)networkRequest{
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    NSString *request =[NSString stringWithFormat:@"/event/%@",_activity.activityId];
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    if([Utilities loginCheck]){
        [parameters setObject:[[StorageMgr singletonStorageMgr]objectForKey:@"MemberId"]forKey:@"memberId"];
    }
    [RequestAPI requestURL:request withParameters:parameters andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
         [aiv stopAnimating];
        NSLog(@"responseObject:%@",responseObject);
       
        if([responseObject[@"resultFlag"]intValue] == 8001){
            

        }else{
            
        }
    }
failure:^(NSInteger statusCode, NSError *error) {
    [aiv stopAnimating];
    [Utilities
     popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
}];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)applyAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
- (IBAction)callAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
