//
//  GGFontTool.m
//  Test
//
//  Created by GG on 2018/3/20.
//  Copyright © 2018年 李佳贵. All rights reserved.
//

#import "GGFontTool.h"

#import <CoreText/CoreText.h>

@implementation GGFontTool

+ (NSMutableArray *)getAllFonts{
    NSArray<NSString *> *familyNames = [UIFont familyNames];
    
    NSMutableArray *mArray = [NSMutableArray array];
    
    
    for (NSString *familyName in familyNames) {
        NSArray<NSString *> *fontNames = [UIFont fontNamesForFamilyName:familyName];
        
        
        NSDictionary *dict =@{
                              @"familyName":familyName,
                              @"fontNames":fontNames,
                              };
        [mArray addObject:dict];
    }
    return mArray;
}


+ (BOOL)isFontDownloaded:(NSString *)fontName {
    UIFont* aFont = [UIFont fontWithName:fontName size:12.0];
    if (aFont && ([aFont.fontName compare:fontName] == NSOrderedSame
                  || [aFont.familyName compare:fontName] == NSOrderedSame)) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)downLoadFontWithFontName:(NSString *)fontName resultBlock:(void(^)(NSError *error))result{
    return [self downLoadFontWithFontName:fontName resultBlock:result progress:nil];
}


+ (void)downLoadFontWithFontName:(NSString *)fontName resultBlock:(void(^)(NSError *error))result progress:(void(^)(double progress))progress{
    
    // 用字体的 PostScript 名字创建一个 Dictionary
    NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:fontName, kCTFontNameAttribute, nil];
    // 创建一个字体描述对象 CTFontDescriptorRef
    CTFontDescriptorRef desc = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)attrs);
    // 将字体描述对象放到一个 NSMutableArray 中
    NSMutableArray *descs = [NSMutableArray arrayWithCapacity:0];
    [descs addObject:(__bridge id)desc];
    CFRelease(desc);
    
    
    __block BOOL errorDuringDownload = NO;
    CTFontDescriptorMatchFontDescriptorsWithProgressHandler( (__bridge CFArrayRef)descs, NULL,  ^(CTFontDescriptorMatchingState state, CFDictionaryRef progressParameter) {
        
        double progressValue = [[(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingPercentage] doubleValue];
        
        if (state == kCTFontDescriptorMatchingDidBegin) {
            NSLog(@"kCTFontDescriptorMatchingDidBegin: 字体已经匹配 ");
        } else if (state == kCTFontDescriptorMatchingDidFinish) {
            if (!errorDuringDownload) {
                
                NSLog(@"kCTFontDescriptorMatchingDidFinish: 字体 %@ 下载完成 ->检测：%d ",fontName,[self isFontDownloaded:fontName]);
                if (result) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        result(nil);
                    });
                }
            }
        } else if (state == kCTFontDescriptorMatchingWillBeginDownloading) {
            NSLog(@" 字体开始下载 ");
        } else if (state == kCTFontDescriptorMatchingDidFinishDownloading) {
            NSLog(@"kCTFontDescriptorMatchingDidFinishDownloading: 字体下载完成 ->检测：%d ",[self isFontDownloaded:fontName]);
            if (result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    result(nil);
                });
            }
            
        } else if (state == kCTFontDescriptorMatchingDownloading) {
            NSLog(@" 下载进度 %.0f%% ", progressValue);
            
            if (progress) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    progress(progressValue);
                });
            }
            
        } else if (state == kCTFontDescriptorMatchingDidFailWithError) {
            NSError *error = [(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingError];
            if (error != nil) {
                
                if (result) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        result(error);
                    });
                }
                
            } else {
                
                NSError *error = [NSError errorWithDomain:@"ERROR MESSAGE IS NOT AVAILABLE!" code:99 userInfo:nil];
                if (result) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        result(error);
                    });
                }
            }
            // 设置标志
            errorDuringDownload = YES;
        }
        return (BOOL)YES;
    });
    
    
    
}



@end
