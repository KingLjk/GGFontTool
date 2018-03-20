//
//  FontTestViewController.m
//  Test
//
//  Created by GG on 2018/3/20.
//  Copyright © 2018年 李佳贵. All rights reserved.
//

#import "FontTestViewController.h"



@interface FontTestViewController ()

@end

@implementation FontTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    CGRect frame = CGRectMake(0, 44 + 20, self.view.bounds.size.width, 40);
    UIColor *textColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1.0];
    textColor = [UIColor blackColor];
    NSString *title = @"背着炸药包炸学校，天天不起早";
    
    
    
    for (NSString *fontName in self.fontNames) {
        
        UILabel *label0 = [UILabel new];
        [self.view addSubview:label0];
        label0.frame = frame;
        label0.font = [UIFont fontWithName:fontName size:20];

        
        label0.text = title;
        frame = CGRectMake(frame.origin.x, CGRectGetMaxY(frame) + 20, frame.size.width, frame.size.height);
        
        label0.textColor = textColor;
    }
    
    
    
}


@end
