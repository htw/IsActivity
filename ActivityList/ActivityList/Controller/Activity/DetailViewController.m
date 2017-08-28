//
//  DetailViewController.m
//  ActivityList
//
//  Created by admin on 2017/8/1.
//  Copyright © 2017年 Edu. All rights reserved.
//

#import "DetailViewController.h"
#import "PurchaseTableViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ActivityModel.h"
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
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong,nonatomic)NSArray *arr;
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
//活动详情接口
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
            NSDictionary *result = responseObject[@"result"];
            _activity = [[ActivityModel alloc] initWithDetialDictionary:result];
           [self uiLayout];
        }else{
            
        }
    }
failure:^(NSInteger statusCode, NSError *error) {
    [aiv stopAnimating];
    [Utilities
     popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
}];
}
-(void)uiLayout{
    [_activityImgView sd_setImageWithURL:[NSURL URLWithString:_activity.imgUrl] placeholderImage:[UIImage imageNamed:@"Image"]];
    _applyFeeLbl.text = [NSString stringWithFormat:@"%@元",_activity.applyFee];
    _attendenceLbl.text = [NSString stringWithFormat:@"%@/%@",_activity.attendence,_activity.limitation];
    _typeLbl.text = _activity.type;
    _issuerLbl.text = _activity.issuer;
    _addressLbl.text = _activity.adress;
    _contentLbl.text = _activity.content;
    [_phoneBtn setTitle:[NSString stringWithFormat:@"联系活动发布者:%@",_activity.phone] forState:UIControlStateNormal];
    NSString *dueTimeStr = [Utilities dateStrFromCstampTime:_activity.dueTime withDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *startTimeStr = [Utilities dateStrFromCstampTime:_activity.startTime withDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *endTimeStr = [Utilities dateStrFromCstampTime:_activity.endTime withDateFormat:@"yyyy-MM-dd HH:mm"];
    _timeLbl.text = [NSString stringWithFormat:@"%@ ~%@",startTimeStr,endTimeStr];
    _applyDueLbl.text =  [NSString stringWithFormat:@"报名截止时间 (%@)",dueTimeStr];
    //获得当前时间
    NSDate *now = [NSDate date];
    NSTimeInterval nowTime = [now timeIntervalSince1970InMilliSecond];
    _applyStartView.backgroundColor = [UIColor grayColor];
    if(nowTime >= _activity.dueTime){
        _applyDueView.backgroundColor = [UIColor grayColor];
        [_applyBtn setTitle:@"报名截止" forState:UIControlStateNormal];
        if(nowTime >= _activity.startTime){
            _applyStartView.backgroundColor = [UIColor grayColor];
            if(nowTime >= _activity.endTime){
                _applyEndView.backgroundColor = [UIColor grayColor];
            }
        }
    }
    if(_activity.attendence >= _activity.limitation){
        [_applyBtn setTitle:@"活动满员" forState:UIControlStateNormal];
        
    }
    switch (_activity.status) {
        case 0:{
           _applyStateLbl.text = @"已取消";
        }
            break;
        case 1:{
            _applyStateLbl.text = @"待付款";
        }
            break;
        case 2:{
            _applyStateLbl.text = @"已报名";
             [_applyBtn setTitle:@"已报名" forState:UIControlStateNormal];
            _applyBtn.enabled = NO;
        }
            break;
        case 3:{
            _applyStateLbl.text = @"退款中";
             [_applyBtn setTitle:@"退款中" forState:UIControlStateNormal];
            _applyBtn.enabled = NO;
        }
            break;
        case 4:{
            _applyStateLbl.text = @"已退款";
        }
            break;
            
        default:
             _applyStateLbl.text = @"待报名";
            break;
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

- (IBAction)applyAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if([Utilities loginCheck]){
        PurchaseTableViewController *purchaseVC = [Utilities getStoryboardInstance:@"Detail" byIdentity:@"Purchase"];
        //传参
        purchaseVC.activity = _activity;
        //push跳转
        [self.navigationController pushViewController:purchaseVC animated:YES];
    }else{
        //获取要跳转过去的页面
        UINavigationController *signNavi = [Utilities getStoryboardInstance:@"Member" byIdentity:@"SignNavi"];
        //执行跳转
           [self presentViewController:signNavi animated:YES completion:nil];
    }
}
- (IBAction)callAction:(UIButton *)sender forEvent:(UIEvent *)event {
    //配置电话app的路径，并将要拨打的电话组合到路径中
    NSString *targetAppStr = [NSString stringWithFormat:@"telprompt://%@",_activity.phone];
    
    //将字符串转换为url对象
    NSURL *targetAppUrl = [NSURL URLWithString:targetAppStr];
    
    //从当前app跳转到其他APP中
    [[UIApplication sharedApplication]openURL:targetAppUrl];
}
- (void)addTapGestureRecognizer:(id)any {
    //初始化一个单击手势，设置响应事件为tapClick：
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    //将手势添加给入参
    [any addGestureRecognizer:tap];
} 
//小图的单击手势响应事件
- (void) tapClick:(UILongPressGestureRecognizer *)tap {
    
    if (tap.state == UIGestureRecognizerStateRecognized){
        //拿到单击手势在_activityTableView中的位置
        CGPoint location =  [tap locationInView:self.view];
        //通过上述的点拿到在_activityTableView对应的位置（indexPath）
       // NSIndexPath *indexPath = [_scrollView indexPathForRowAtPoint:location];
        //防范式编程
        if (_arr != nil && _arr.count != 0){
         //   ActivityModel *activity = _arr[indexPath.row];
            //设置大图片的位置大小
            self.view = [[UIImageView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
            //用户交互作用
            _activityImgView.userInteractionEnabled = YES;
            _activityImgView.backgroundColor = [UIColor blackColor];
            
            //_zoomIV.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:activity.imgUrl]]];
            NSURL *URL = [NSURL URLWithString:_activity.imgUrl];
            [_activityImgView sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"4"]];
            //设置图片的内容模式
            _activityImgView.contentMode = UIViewContentModeScaleAspectFit;
            //获得窗口实例，并将大图放置到窗口实例方法，根据苹果规则后添加的控件会覆盖前添加的控件
            [[UIApplication sharedApplication].keyWindow addSubview:_activityImgView];
            //[self addTapGestureRecognizer:_zoomIV];
            
            UITapGestureRecognizer *zoomIVTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoomTap:)];
            [_activityImgView addGestureRecognizer:zoomIVTap];
        }
        
        
    }
}

@end
