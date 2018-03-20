//
//  GGFontTool.h
//  Test
//
//  Created by GG on 2018/3/20.
//  Copyright © 2018年 李佳贵. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGFontTool : NSObject
+ (BOOL)isFontDownloaded:(NSString *)fontName;


+ (void)downLoadFontWithFontName:(NSString *)fontName resultBlock:(void(^)(NSError *error))result;

+ (void)downLoadFontWithFontName:(NSString *)fontName resultBlock:(void(^)(NSError *error))result progress:(void(^)(double progress))progress;


+ (NSMutableArray *)getAllFonts;
@end
