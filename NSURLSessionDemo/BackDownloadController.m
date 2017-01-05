//
//  BackDownloadController.m
//  NSURLSessionDemo
//
//  Created by Gandalf on 17/1/4.
//  Copyright © 2017年 Gandalf. All rights reserved.
//

#import "BackDownloadController.h"
#import "AppDelegate.h"

static NSString *Kugou_url = @"http://dlsw.baidu.com/sw-search-sp/soft/0c/25762/KugouMusicForMac.1395978517.dmg";
static NSString *QQ_url = @"http://sw.bos.baidu.com/sw-search-sp/software/797b4439e2551/QQ_mac_5.0.2.dmg";

@interface BackDownloadController ()

// 进度条
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

// 进度值
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

// 下载任务
@property (nonatomic, strong) NSURLSessionDownloadTask *task;

// session
@property (nonatomic, strong) NSURLSession *backgroundSeesion;

@end

@implementation BackDownloadController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDownloadProgress:) name:kDownloadProgressNotification object:nil];
}

- (void)updateDownloadProgress:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    CGFloat fProgress = [userInfo[@"progress"] floatValue];
    self.progressLabel.text = [NSString stringWithFormat:@"%.2f%%",fProgress * 100];
    self.progressView.progress = fProgress;
}

- (IBAction)startBtn {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate beginDownloadWithUrl:Kugou_url];
}

- (IBAction)suspendBtn {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate pauseDownload];
}

- (IBAction)resumeBtn {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate continueDownload];
}

@end
