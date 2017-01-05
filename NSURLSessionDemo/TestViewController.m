//
//  TestViewController.m
//  NSURLSessionDemo
//
//  Created by Gandalf on 17/1/3.
//  Copyright © 2017年 Gandalf. All rights reserved.
//

#import "TestViewController.h"

static NSString *downloadUrlStr = @"http://sw.bos.baidu.com/sw-search-sp/software/48fb368daa41e/QQ_mac_5.2.0.dmg";

static NSString *imageUrlStr = @"http://d.lanrentuku.com/down/png/1610/30-color-american-indigenous-elements/dreamcatcher.png";

@interface TestViewController () <NSURLSessionDownloadDelegate>

// 进度条视图
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
// 下载任务
@property (nonatomic, weak) NSURLSessionDownloadTask *task;
// 接收到的数据
@property (nonatomic, strong) NSData *receivedData;
// session
@property (nonatomic, strong) NSURLSession *session;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

#pragma mark - 下载，无代理
- (void)downloadWithoutDelegate
{
    // 1.创建session
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 2.创建任务
    NSURL *url = [NSURL URLWithString:imageUrlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"临时下载位置：%@", location);
        
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
        
        /**
         fileURLWithPath:有协议头
         URLWithString:无协议头
         */
        NSError *fileError = nil;
        [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:fullPath] error:&fileError];
        if (fileError) {
            NSLog(@"保存下载的文件失败：%@", fileError);
        } else {
            NSLog(@"保存成功：%@", fullPath);
        }
    }];
    
    // 3.发送请求
    [task resume];
}

#pragma mark - 下载，有代理
- (IBAction)startDownload {
    // 1.创建session
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = 10;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    self.session = session;
    
    // 2.创建任务
    NSString *fileUrlStr = [downloadUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:fileUrlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request];
    self.task = task;
    
    // 3.开始任务
    [task resume];
}

- (IBAction)cancelDownload {
    if (self.task) {
        [self.task cancel];
        self.task = nil;
        
        [self.progressView setProgress:0.0 animated:YES];
    }
    
}

- (IBAction)suspendDownload {
    if (self.session) {
        __weak typeof(self) weakSelf = self;
        [self.task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            weakSelf.receivedData = resumeData;
        }];
    }
}

- (IBAction)resumeDownload {
    if (self.session) {
        self.task = [self.session downloadTaskWithResumeData:self.receivedData];
    }
    
    [self.task resume];
}

#pragma mark - NSURLSessionDownloadDelegate
/*
 1.当接收到下载数据的时候调用,可以在该方法中监听文件下载的进度
 该方法会被调用多次
 totalBytesWritten:已经写入到文件中的数据大小
 totalBytesExpectedToWrite:目前文件的总大小
 bytesWritten:本次下载的文件数据大小
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    float progress = totalBytesWritten * 1.0 / totalBytesExpectedToWrite;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.progressView setProgress:progress animated:YES];
    });
    
    NSLog(@"%@", [NSThread currentThread]);
}

/*
 2.恢复下载的时候调用该方法
 fileOffset:恢复之后，要从文件的什么地方开发下载
 expectedTotalBytes：该文件数据的总大小
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{}

/*
 3.下载完成之后调用该方法
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSString *catchDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [catchDir stringByAppendingPathComponent:@"QQ_mac_5.2.0.dmg"];
    
    NSError *fileError = nil;
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    [[NSFileManager defaultManager] moveItemAtURL:location toURL:fileURL error:&fileError];
    
    if (fileError) {
        NSLog(@"保存下载文件出错：%@", fileError);
    } else {
        NSLog(@"保存成功：%@", filePath);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"任务完成");
}

#pragma mark - 懒加载
- (NSData *)receivedData
{
    if (_receivedData == nil) {
        _receivedData = [[NSData alloc] init];
    }
    
    return _receivedData;
}

@end
