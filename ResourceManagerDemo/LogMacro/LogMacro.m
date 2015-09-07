//
//  LogMacro.c
//  MultiSliderTest
//
//  Created by abc on 13-6-24.
//  Copyright (c) 2013年 abc. All rights reserved.
//

#include <UIKit/UIKit.h>
#import "LogMacro.h"

//#define __SHOW__LOG__ON_VIEW__

#ifdef __SHOW__LOG__
//#define __Write_Log__

static int __LOG_LEVEL__ = LEVEL_ALL;

NSString *currentTimeString()
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy/MM/dd HH:mm:ss:SSS"];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];

    return dateStr;
}

@interface ShowLogView : UIView
{
    BOOL viewHidden;
}

@property (retain, nonatomic) IBOutlet UIButton *ctrlBtn;
@property (retain, nonatomic) IBOutlet UIView *bgView;
@property (retain, nonatomic) IBOutlet UITextView *txtView;
@property (retain, nonatomic) IBOutlet UIButton *clearBtn;
@property (retain, nonatomic) NSString *path;
@property (retain, nonatomic) NSString *logName;

-(void)showLogOnWindow:(NSString *)string level:(LOG_LEVEL)level;
+ (id)shareInstance;
@end
@implementation ShowLogView

#pragma mark - 模板，需要子类自己实现
+ (id)shareInstance
{
    static ShowLogView *__singletion__;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        __singletion__ =[[[NSBundle mainBundle]loadNibNamed:@"LogView" owner:nil options:nil]lastObject];
    });
    
    return __singletion__;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        viewHidden = NO;
        
#ifdef __Write_Log__
        
        self.logName = [self logNameString];
        NSString *doc = [NSHomeDirectory() stringByAppendingString:@"/Documents"];
        self.path = [NSString stringWithFormat:@"%@/%@.txt",doc,self.logName];
        
        NSFileManager *fm = [NSFileManager defaultManager];
        if (![fm fileExistsAtPath:self.path]) {
            [fm createFileAtPath:self.path contents:nil attributes:nil];
        }

        
        freopen([self.path cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
#endif
        
    }
    return self;
}
-(NSString  *)logNameString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [NSString stringWithString:[formatter stringFromDate:[NSDate date]]];

    return dateStr;
}
- (IBAction)clearLog:(UIButton *)sender
{
    self.txtView.text = nil;
}
- (IBAction)pressDouble:(UIButton *)sender
{
    viewHidden = !viewHidden;
    [self hiddenView:viewHidden];
}

-(void)hiddenView:(BOOL)hidden
{
    self.clearBtn.hidden = hidden;
    self.bgView.hidden = hidden;
    self.txtView.hidden = hidden;
    
}
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (viewHidden) {
        if (CGRectContainsPoint(self.ctrlBtn.frame, point)) {
            return YES;
        }
        return NO;
    }
    return CGRectContainsPoint(self.bgView.frame, point);
}
-(void)showLogOnWindow:(NSString *)string level:(LOG_LEVEL)level
{
#ifdef __Write_Log__
    //if (level == __LOG_LEVEL__) {
        //NSString *outString = [NSString stringWithFormat:@"%@ %@",string,currentTimeString()];
        printf("%s\n",[string UTF8String]);
        freopen([self.path cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
        //freopen([self.path cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
    //}

    
#else
    
#ifdef __SHOW__LOG__ON_VIEW__
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if (![window.subviews containsObject:self]) {
            CGRect frame = self.frame;
            frame.origin.y = window.bounds.size.height - frame.size.height;
            self.frame = frame;
            [window addSubview:self];
            
        }else {
            [window bringSubviewToFront:self];
        }
        
        NSString *outString = [NSString stringWithFormat:@"%@ %@",string,currentTimeString()];
        if (self.txtView.text.length > 100000) {
            self.txtView.text = outString;
            
        }else {
            self.txtView.text = [NSString stringWithFormat:@"%@\n%@",self.txtView.text,outString];
        }
        self.txtView.textColor = [UIColor whiteColor];
//        NSString *outString = [NSString stringWithFormat:@"%@ %@",string,currentTimeString()];
//        self.txtView.text = [NSString stringWithFormat:@"%@\n%@",self.txtView.text,outString];
//        self.txtView.textColor = [UIColor whiteColor];
    });
#endif
    
#endif
}

- (void)dealloc {}
@end


extern void myLevelLog(int line,char *functname,char *file,LOG_LEVEL level,int writeTofile, id formatstring,...)
{
    if (level == MyLevelLog) {
        
        if (!formatstring) return;
        
        @autoreleasepool {
            
            va_list arglist;
            va_start(arglist, formatstring);
            id outstring = [[NSString alloc]initWithFormat:formatstring arguments:arglist];
            va_end(arglist);
            

            NSString *fileName = [[NSString stringWithUTF8String:file]lastPathComponent];
            NSString *debug0 = [NSString stringWithFormat:@"[%@][%@-->%d行]:%@",currentTimeString(),fileName,line,outstring];
            printf("%s\n",[debug0 UTF8String]);
            
            if (writeTofile) {
                NSString * filePath = [NSString stringWithFormat:@"%@/%@",DocumentPath,LogFileName];
                NSFileManager * fileManager = [NSFileManager defaultManager];
                NSMutableData * existData = [[NSMutableData alloc] init];
                if ([fileManager fileExistsAtPath:filePath]) {
                    [existData appendData:[NSData dataWithContentsOfFile:filePath]];
                }else{
                    [fileManager createFileAtPath:filePath contents:nil attributes:nil];
                }
                debug0 = [debug0 stringByAppendingString:@"\n"];
                NSData * logData = [debug0 dataUsingEncoding:NSUTF8StringEncoding];
                [existData appendData:logData];
                
                [existData writeToFile:filePath atomically:YES];
            }
            
        }
        
    }
}


#endif
