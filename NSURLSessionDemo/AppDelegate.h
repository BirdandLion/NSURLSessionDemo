//
//  AppDelegate.h
//  NSURLSessionDemo
//
//  Created by Gandalf on 17/1/3.
//  Copyright © 2017年 Gandalf. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDownloadProgressNotification @"downloadProgressNotification"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) void (^completionHandler)();

- (void)beginDownloadWithUrl:(NSString *)downloadURLString;
- (void)pauseDownload;
- (void)continueDownload;

@end

