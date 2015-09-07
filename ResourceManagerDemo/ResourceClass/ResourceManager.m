//
//  ResourceManager.m
//  ResourceManager
//
//  Created by Ned on 9/7/15.
//  Copyright (c) 2015 Ned. All rights reserved.
//

#import "ResourceManager.h"



@implementation ResourceManager

- (ResourceUploadResp *)uploadResource:(ResourceUploadReq *)request
{

    NSString * urlString = [NSString stringWithFormat:@"%@/%@/upload",@"http://192.168.0.155:9080/fileUploadEngine",request.groupName];
    urlString = [NSString stringWithFormat:@"%@/%@/upload",@"http://192.168.0.144:8080",request.groupName];
    NSDate *date = [NSDate date];
    NSTimeInterval interval = [date timeIntervalSince1970];
    NSString *boundary = [NSString stringWithFormat:@"7d%x", (int)interval * 1000];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [URLRequest setHTTPMethod:@"POST"];
    [URLRequest addValue:contentType forHTTPHeaderField:@"Content-Type"];
    NSMutableString *header = [[NSMutableString alloc] initWithCapacity:0];
    
    NSString *endItemBoundary = [NSString stringWithFormat:@"\r\n--%@\r\n",boundary];
    
    [header appendString:@"--"];
    [header appendString:boundary];
    [header appendString:@"\r\n"];
    [header appendString:@"Content-Disposition: form-data; name=fileName\r\n\r\n"];
    [header appendString:[NSString stringWithFormat:@"%@.png",request.fileName]];
    [header appendString:endItemBoundary];

    [header appendString:@"Content-Disposition: form-data; name=fileSize\r\n\r\n"];
    [header appendString:[NSString stringWithFormat:@"%d",request.fileSize]];
    [header appendString:endItemBoundary];
    
    [header appendString:@"Content-Disposition: form-data; name=\""];
    [header appendString:@"file"];
    [header appendString:@"\"; filename=\""];
    [header appendString:request.fileName];
    [header appendString:@".png"];
    [header appendString:@"\""];
    [header appendString:@"\r\n"];
    [header appendString:@"Content-Type: application/octet-stream"];
    [header appendString:@"\r\n"];
    [header appendString:@"\r\n"];
    NSLog(@"%s,%@",__func__,header);
    NSMutableData *uploadData = [[NSMutableData alloc] initWithCapacity:0];
    NSStringEncoding enc = NSUTF8StringEncoding;
    [uploadData appendData:[header dataUsingEncoding:enc]];
    [uploadData appendData:request.file];
    [uploadData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary]
                            dataUsingEncoding:enc]];
    [URLRequest setHTTPBody:uploadData];
    NSHTTPURLResponse * response = nil;;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:URLRequest returningResponse:&response error:&error];
    if (response.statusCode == 200) {
        NSString * returnStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary * dic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@%@",returnStr,dic);
        
        ResourceUploadResp * response = [[ResourceUploadResp alloc] init];
        response.remoteFileName = [dic objectForKey:@"goupName"];
        response.groupName = [dic objectForKey:@"remoteFileName"];
    }
    return nil;
}

- (ResourceDownloadResp *)downloadResource:(ResourceDownloadReq *)request
{
    NSString * urlString = [NSString stringWithFormat:@"%@/%@/%@",@"http://192.168.0.204",request.groupName,request.remoteFileName];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [URLRequest setHTTPMethod:@"GET"];

    NSHTTPURLResponse * response = nil;;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:URLRequest returningResponse:&response error:&error];
    if (response.statusCode == 200) {
        ResourceDownloadResp * response = [[ResourceDownloadResp alloc] init];
        response.remoteFileName = request.remoteFileName;
        response.file = data;
        NSString * filePath = [DocumentPath stringByAppendingPathComponent:request.fileName];
        NSFileManager * fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:filePath]) {
            [fileManager createFileAtPath:filePath contents:nil attributes:nil];
        }
        [data writeToFile:filePath atomically:YES];
        return response;
        
    }
    return nil;

}

@end
