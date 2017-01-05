//
//  ViewController.m
//  NSURLSessionDemo
//
//  Created by Gandalf on 17/1/3.
//  Copyright © 2017年 Gandalf. All rights reserved.
//

#import "ViewController.h"

static NSString *jsonUrlStr = @"http://rap.taobao.org/mockjsdata/9800/api/videoList";

@interface ViewController () <NSURLSessionDataDelegate>

@property (nonatomic, strong) NSMutableData *receivedData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}

#pragma mark - data task, 有代理
- (void)dataTaskWithDelegate
{
    // 1. 创建session
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    // 2. 创建task
    NSURL *url = [NSURL URLWithString:jsonUrlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request];
    
    [task resume];
}

#pragma mark - data task, 无代理
- (void)dataTaskWithoutDelegate
{
    // 1. 创建session
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    // 2. 创建task
    NSURL *url = [NSURL URLWithString:jsonUrlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error: %@", error);
        } else {
            // 4. 打印收到的数据
            NSHTTPURLResponse *res = (NSHTTPURLResponse*)response;
            NSLog(@"%@ \n %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], res.allHeaderFields);
        }
    }];
    
    // 3. 执行task
    [task resume];
}

#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    NSLog(@"接收到服务器响应的时候调用 -- %@", [NSThread currentThread]);
    
    //默认情况下不接收数据
    //必须告诉系统是否接收服务器返回的数据
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    NSLog(@"接受到服务器返回数据的时候调用,可能被调用多次");
    
    [self.receivedData appendData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"请求完成或者是失败的时候调用");
    //解析服务器返回数据
    NSLog(@"%@", [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding]);
}

#pragma mark - 懒加载
- (NSMutableData *)receivedData
{
    if (_receivedData == nil) {
        _receivedData = [NSMutableData data];
    }
    
    return _receivedData;
}

@end
