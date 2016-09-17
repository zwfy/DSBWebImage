//
//  DownloaderOperation.m
//  仿SDWebImage
//
//  Created by HM on 16/9/17.
//  Copyright © 2016年 itheima. All rights reserved.
//

/*
 DownloaderOperation的作用
 1.异步下载网络图片
    需要图片的地址
 2.使用block把图片数据传递到VC
 */

#import "DownloaderOperation.h"

@interface DownloaderOperation ()

/// 接收VC传入的图片地址
@property (nonatomic, copy) NSString *URLString;

/// 接收VC传入的下载完成的代码块
@property (nonatomic, copy) void(^successBlock)(UIImage *image);

@end

@implementation DownloaderOperation

// 实现创建操作对象的类方法 : 这个方法是先于main方法调用的
+ (instancetype)downloaderOperationWithURLString:(NSString *)URLString successBlock:(void (^)(UIImage *))successBlock
{
    DownloaderOperation *op = [[DownloaderOperation alloc] init];
    
    // 保存外界传入的数据
    op.URLString = URLString;
    op.successBlock = successBlock;
    
    return op;
}

// 任何操作在执行执行都会调用main方法 : 一旦队列调度操作执行,首先自动执行start方法,然后自动执行main方法
/// 重写main方法 : 所有操作的入口 (相当于教室的门)
- (void)main
{
    NSLog(@"传入 %@",self.URLString);
    
    // 模拟网络延迟
    [NSThread sleepForTimeInterval:1.0];
    
    // 异步下载
    NSURL *URL = [NSURL URLWithString:self.URLString];
    NSData *data = [NSData dataWithContentsOfURL:URL];
    UIImage *image = [UIImage imageWithData:data];
    
    // 断言 : 保证某一个条件一定是满足的;如果不满足,就直接崩溃,并且提供崩溃的自定义的信息;只在开发阶段有效;APP上线之后,就无效了
    NSAssert(self.successBlock != nil, @"图片下载完成的回调不能为空!");
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.successBlock(image);
    }];
}

@end
