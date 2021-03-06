//
//  ViewController.m
//  仿SDWebImage
//
//  Created by HM on 16/9/17.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import "ViewController.h"
#import "DownloaderOperation.h"
#import "AFNetworking.h"
#import "YYModel.h"
#import "APPModel.h"
#import "DownloaderManager.h"
#import "UIImageView+DSB.h"

@interface ViewController ()

@property (nonatomic, strong) NSOperationQueue *queue;
/// 数据源数组
@property (nonatomic, strong) NSArray *appList;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
/// 操作缓存池
@property (nonatomic, strong) NSMutableDictionary *OPsCache;
/// 保存上一次的图片地址
@property (nonatomic, copy) NSString *lastURLString;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xxoo) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    // 实例化全局队列
    self.queue = [[NSOperationQueue alloc] init];
    /// 实例化操作缓存池
    self.OPsCache = [[NSMutableDictionary alloc] init];
    
    // 测试框架 : 当appList有数据之后,我就点击屏幕随机下载图片
    [self loadJSONData];
}

// 测试
- (void)xxoo
{
    NSLog(@"%s",__func__);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 获取随机数
    int random = arc4random_uniform((u_int32_t)self.appList.count);
    // 使用随机数,随机的取出模型
    APPModel *app = self.appList[random];
    
    // 使用分类方法实现图片下载
    [self.iconImageView DSB_setImageWithURLString:app.icon];
}

/// 测试框架的 : 加载JSON数据的主方法
- (void)loadJSONData
{
    // 1.创建网络请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 2.发送请求
    [manager GET:@"https://raw.githubusercontent.com/zhangxiaochuZXC/ServerFile21/master/apps.json" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *responseObject) {
        
        // 给数据源数组赋值 : 把字典数组转成模型数组
        self.appList = [NSArray yy_modelArrayWithClass:[APPModel class] json:responseObject];
        NSLog(@"%@",self.appList);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
