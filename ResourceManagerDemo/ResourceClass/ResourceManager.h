//
//  ResourceManager.h
//  ResourceManager
//
//  Created by Ned on 9/7/15.
//  Copyright (c) 2015 Ned. All rights reserved.
//


#import "ResourceUploadReq.h"
#import "ResourceUploadResp.h"
#import "ResourceDownloadReq.h"
#import "ResourceDownloadResp.h"

@interface ResourceManager : NSObject

- (ResourceUploadResp *)uploadResource:(ResourceUploadReq *)request;

- (ResourceDownloadResp *)downloadResource:(ResourceDownloadReq *)request;

@end


