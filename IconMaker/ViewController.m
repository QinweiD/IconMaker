//
//  ViewController.m
//  IconMaker
//
//  Created by Mac on 2017/11/8.
//  Copyright © 2017年 Qinwei. All rights reserved.
//

#import "ViewController.h"
#define delegateLength 7
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.assetPathTF.enabled = YES;
    self.imagePathTF.enabled = YES;
    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    // Update the view, if already loaded.
}

- (IBAction)clickToMakeIcons:(NSButton *)sender {
    [self setupAllConfig];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString *packScriptPath = [[NSBundle mainBundle] pathForResource:@"Auto_icon" ofType:@"sh"];
        NSError *error = nil;
        NSString *commandString = [NSString stringWithContentsOfFile:packScriptPath encoding:NSUTF8StringEncoding error:&error];
        NSLog(@"shell:%@",commandString);
        system([commandString UTF8String]);
    });
}
    

/**
 *  更新配置信息
 */
- (void)setupAllConfig
{
    
    // 打包脚本路径
    NSString *scriptPath = [NSString stringWithFormat:@"file://%@", [[NSBundle mainBundle] pathForResource:@"Auto_icon" ofType:@"sh"]];
   
    
    // 生成图标的路径
    if ([self replaceConfigStringWithSrc:scriptPath Pattern:@"(?<=ASSET_PATH=)(\"(.*?)\")" template:[NSString stringWithFormat:@"\"%@%@\"",self.assetPathTF.stringValue, @"/"]]) {
        // 成功后加入数据源数组
        NSLog(@"assetTF更改成功");
    } else {
        NSLog(@"assetTF更改失败");
    }
    
    // 生成图标所需图片路径
    if ([self replaceConfigStringWithSrc:scriptPath Pattern:@"(?<=IMAGE_PATH=)(\"(.*?)\")" template:[NSString stringWithFormat:@"\"%@\"", self.imagePathTF.stringValue]]) {
        // 成功后加入数据源数组
        NSLog(@"imageTF更改成功");
    } else {
        NSLog(@"imageTF更改失败");
    }
    
    // 生成图标路径
    if ([self replaceConfigStringWithSrc:scriptPath Pattern:@"(?<=JSON_PATH=)(\"(.*?)\")" template:[NSString stringWithFormat:@"\"%@\"",[[NSBundle mainBundle] pathForResource:@"Contents" ofType:@"json"]]]) {
        // 成功后加入数据源数组
        NSLog(@"congtentTF更改成功");
    } else {
        NSLog(@"congtentTF更改失败");
    }

}


/**
*  复制文件操作
*
*  @param src         原文件路径        带file://协议
*
*
*  @return 返回是否复制成功
*/
- (BOOL)replaceConfigStringWithSrc:(NSString *)src Pattern:(NSString *)pattern template:(NSString *)template
{
    NSString *scrPath = [self getPathWithfileString:src];
    NSURL *srcURL = [NSURL fileURLWithPath:scrPath];
    if (!srcURL) {
//        [self.results addObject:[NSString stringWithFormat:@"URL为空 %@",src]];
        return NO;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:scrPath];
    
    NSData *data = [file readDataToEndOfFile];
    NSString *xmlString = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSTextCheckingResult *result = [regex firstMatchInString:xmlString options:0 range:NSMakeRange(0, xmlString.length)];
    if (result) {
        
        // 替换匹配结果
        xmlString = [regex stringByReplacingMatchesInString:xmlString options:0 range:NSMakeRange(0, xmlString.length) withTemplate:template];
        
        // 文件已经存在，则先删除
        if ([fileManager fileExistsAtPath:scrPath]) {
            NSError *error = nil;
            [fileManager removeItemAtURL:srcURL error:&error];
            if (error) {
                return NO;
            } else {
                // 重新创建文件
                if ([fileManager createFileAtPath:scrPath contents:[xmlString dataUsingEncoding:NSUTF8StringEncoding] attributes:nil]) {
                    return YES;
                } else {
                    return NO;
                }
            }
            
        } else {
            // 重新创建文件
            if ([fileManager createFileAtPath:scrPath contents:[xmlString dataUsingEncoding:NSUTF8StringEncoding] attributes:nil]) {
                return YES;
            } else {
                return NO;
            }
        }
    }
    
    return NO;
}


/**
 *  去掉file://协议头
 *
 *  @param fileString 带协议头的路径
 *
 *  @return 返回去掉协议头的路径
 */
- (NSString *)getPathWithfileString:(NSString *)fileString
{
    return [fileString substringWithRange:NSMakeRange(delegateLength, fileString.length - delegateLength)];
}
@end
