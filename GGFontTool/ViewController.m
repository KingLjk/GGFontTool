//
//  ViewController.m
//  Test
//
//  Created by GG on 2018/3/13.
//  Copyright © 2018年 李佳贵. All rights reserved.
//

#import "ViewController.h"

#import "FontTestViewController.h"


#import "GGFontTool.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UILabel *label;

@property (nonatomic, strong)NSMutableArray *fontNames;

@end


///STXingkaiSC-Light
/// DFWaWaSC-W5
@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width);
    
    [self addTableViewWithSuperView:self.view frame:frame delegate:self];
    
}
/**
 创建UITableView实例 并将其添加到父视图
 
 @param superView 父视图
 @param frame UITableView实例的Frame
 @param delegate <UITableViewDelegate,UITableViewDataSource>代理
 @return 返回UITableView实例
 */
- (UITableView *)addTableViewWithSuperView:(UIView *)superView frame:(CGRect)frame delegate:(id <UITableViewDelegate,UITableViewDataSource>)delegate{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    [superView addSubview:tableView];
    tableView.delegate = delegate;
    tableView.dataSource = delegate;
    
    return tableView;
}
#pragma *********************<UITableViewDataSource,UITableViewDelegate> *********************

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.fontNames.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    NSString *fontName = self.fontNames[indexPath.row];
    cell.textLabel.text = fontName;
    
    if ([GGFontTool isFontDownloaded:fontName]) {
        
        cell.detailTextLabel.text = @"直接可显示！";
        cell.detailTextLabel.font = [UIFont fontWithName:fontName size:14];
        
    }
    
    return cell;
}
- (NSMutableArray *)fontNames{
    if (!_fontNames) {
        _fontNames = [NSMutableArray array];
        [_fontNames addObject:@"STXingkaiSC-Light"];
        [_fontNames addObject:@"STLibianSC-Regular"];
        
        [_fontNames addObject:@"MLingWaiMedium-SC"];
        //        [_fontNames addObject:@""];
        
        [_fontNames addObject:@"DFWaWaSC-W5"];
        [_fontNames addObject:@"HanziPenSC-W3"];
        [_fontNames addObject:@"AppleSDGothicNeo-SemiBold"];
        
    }
    return _fontNames;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString *fontName = self.fontNames[indexPath.row];
    
    if ([GGFontTool isFontDownloaded:fontName]) {
        
        cell.detailTextLabel.text = @"已下载完毕，并可检测到！";
        cell.detailTextLabel.font = [UIFont fontWithName:fontName size:14];
        
    }else{
        [GGFontTool downLoadFontWithFontName:fontName resultBlock:^(NSError *error) {
            
            if (error) {
                NSLog(@"下载失败：%@",error);
            }else{
                cell.detailTextLabel.text = @"已下载完毕！";
                cell.detailTextLabel.font = [UIFont fontWithName:fontName size:14];
            }
        }];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    FontTestViewController *vc = [FontTestViewController new];
    vc.title = @"测试字体";
    vc.fontNames = self.fontNames;
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end

