//
//  ViewController.m
//  日历测试
//
//  Created by apple on 16/8/8.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "ViewController.h"

#import "MyCalendarView.h"

@interface ViewController ()<MyCalendarViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //_date=[NSDate date];//当前日期
    
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    
    MyCalendarView *calendarView=[[MyCalendarView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.width+80)];
    calendarView.currentDate=[NSDate date];
    
    calendarView.nowDate=calendarView.currentDate;
    
    calendarView.delegate=self;
    
    [calendarView showInView:self.view];
}

/**
 *  选择日期
 *
 *  @param currentDate 返回阳历日期
 *  @param chineseDate 返回农历日期
 */
- (void)didSelectMyCalendarViewChooseCurrentDate:(NSString *)currentDate chineseDate:(NSString *)chineseDate {
    NSLog(@"阳历日期：%@",currentDate);
    NSLog(@"农历日期：%@",chineseDate);

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
