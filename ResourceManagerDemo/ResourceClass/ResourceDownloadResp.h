//
//  ResourceDownloadResp.h
//  ResourceManagerDemo
//
//  Created by Ned on 9/7/15.
//  Copyright (c) 2015 Ned. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResourceDownloadResp : NSObject

/**
 *  文件流
 */
@property (nonatomic, strong)NSData * file;

/**
 *  自定义文件名
 */
@property (nonatomic, strong)NSString * fileName;

/**
 *  分组名
 */
@property (nonatomic, strong)NSString * groupName;

/**
 *  远程文件名
 */
@property (nonatomic, strong)NSString * remoteFileName;

@end
