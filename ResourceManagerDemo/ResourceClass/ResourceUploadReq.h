//
//  ResourceReq.h
//  ResourceManager
//
//  Created by Ned on 9/7/15.
//  Copyright (c) 2015 Ned. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResourceUploadReq : NSObject

/**
 *  文件流
 */
@property (nonatomic, strong)NSData * file;

/**
 *  文件名
 */
@property (nonatomic, strong)NSString * fileName;

/**
 *  文件大小
 */
@property (nonatomic, assign)int fileSize;

/**
 *  分组名
 */
@property (nonatomic, strong)NSString * groupName;

@end
