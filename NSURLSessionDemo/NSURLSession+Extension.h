//
//  NSURLSession+Extension.h
//  NSURLSessionDemo
//
//  Created by Gandalf on 17/1/5.
//  Copyright © 2017年 Gandalf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLSession (Extension)

- (NSURLSessionDownloadTask *)downloadTaskWithCorrectResumeData:(NSData *)resumeData;

@end
