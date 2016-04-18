//
//  ViewController.m
//  秒表
//
//  Created by MCJ on 15/9/9.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#define SCR_W [UIScreen mainScreen].bounds.size.width
#import "ViewController.h"

@interface ViewController ()
{
    UILabel *_mainTimeLable;
    UILabel *_detailTimeLable;
    
    // 定时器
    NSTimer *_timer;
    
    // 时分秒，毫秒
    int h, m, s,_S;
    
    BOOL _isRunning;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建显示时间的Label
    [self creatTimeLable];
    
    // 创建Button
    [self creatButtons];
    
    // 添加定时器
    [self creatTimer];
    
}

- (void)creatTimeLable
{
    // 初始化_mainTimeLable
    CGFloat X = 30;
    CGFloat Y = 60;
    CGFloat W = SCR_W - 2*X - 10;
    CGFloat H = 60;
    _mainTimeLable = [[UILabel alloc] initWithFrame:CGRectMake(X, Y, W, H)];
    _mainTimeLable.text = @"00:00:00";
    _mainTimeLable.font = [UIFont systemFontOfSize:80];
    _mainTimeLable.adjustsFontSizeToFitWidth = YES;
    
    [self.view addSubview:_mainTimeLable];
    
    // 毫秒Lable
    CGFloat dX = CGRectGetMaxX(_mainTimeLable.frame);
    CGFloat dY = Y;
    CGFloat dW = 20;
    CGFloat dH = H;
    
    _detailTimeLable = [[UILabel alloc] initWithFrame:CGRectMake(dX, dY
, dW, dH)];
    _detailTimeLable.text = @"0";
    _detailTimeLable.font = _mainTimeLable.font;
    _detailTimeLable.adjustsFontSizeToFitWidth = YES;
    _detailTimeLable.textColor = [UIColor redColor];
    [self.view addSubview:_detailTimeLable];
}

- (void)creatButtons
{
    NSArray *array = @[@"【开始】",@"【停止】",@"【复位】"];
    
    for (int i = 0; i < array.count; i ++) {
        
        // 初始化Button
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCR_W/2 - 100, CGRectGetMaxY(_mainTimeLable.frame)+ 50+(10+50)*i, 200, 50)];
        [btn setTitle:array[i] forState:UIControlStateNormal];
         btn.titleLabel.font = [UIFont systemFontOfSize:40];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
        
        // 给Button添加相应事件
        btn.tag = 100 +i;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:btn];
    }
}

- (void)clickBtn:(UIButton *)btn
{
    switch (btn.tag - 100) {
            // 点击了开始按钮
        case 0:
            [self starBtnClick:btn];
            break;
            // 点击了停止按钮
        case 1:
            [self stopBtnClick:btn];
            break;
            // 点击了复位按钮
        case 2:
            [self resetBtnClick:btn];
            break;
            
        default:
            break;
    }
}

- (void)starBtnClick:(UIButton *)btn
{
    
    if (_isRunning == NO) {
        [_timer setFireDate:[NSDate distantPast]];
        [btn setTitle:@"【暂停】" forState:UIControlStateNormal];
        _isRunning = YES;
    }else{
        [_timer setFireDate:[NSDate distantFuture]];
        [btn setTitle:@"【继续】" forState:UIControlStateNormal];
        _isRunning = NO;
    }
    
}

- (void)stopBtnClick:(UIButton *)btn
{
    [_timer setFireDate:[NSDate distantFuture]];
    h = m = s = _S = 0;
    
    UIButton *starBtn = (UIButton *)[self.view viewWithTag:100];
    [starBtn setTitle:@"【开始】" forState:UIControlStateNormal];
    _isRunning = NO;
}

- (void)resetBtnClick:(UIButton *)btn
{
    [self stopBtnClick:btn];
    _S = -1;
    [self run];
}

- (void)creatTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(run) userInfo:nil repeats:YES];
    
    // 定时器启动后立马暂定
    _timer.fireDate = [NSDate distantFuture];
    
}

- (void)run
{
    _S ++;
    if (_S == 10) {
        _S = 0;
        s ++;
        if (s == 60) {
            s = 0;
            m++;
            if (m == 60) {
                m = 0;
                h ++;
                if (h == 100) {
                    h = 0;
                }
            }
        }
    }
    
    _mainTimeLable.text = [NSString stringWithFormat:@"%.2d:%.2d:%.2d",h,m,s];
    _detailTimeLable.text = [NSString stringWithFormat:@"%d",_S];
}

- (void)dealloc
{
    if (_timer) {
        [_timer invalidate];
    }
}
@end
