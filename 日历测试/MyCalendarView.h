//
//  MyCalendarView.h
//  日历测试
//
//  Created by apple on 16/8/8.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyCalendarViewDelegate <NSObject>

- (void)didSelectMyCalendarViewChooseCurrentDate:(NSString *)currentDate chineseDate:(NSString *)chineseDate;

@end
@interface MyCalendarView : UIView

@property (nonatomic , strong) NSDate *currentDate;//选中的日期
@property (nonatomic , strong) NSDate *nowDate;//当前系统日期

@property (nonatomic,weak)id<MyCalendarViewDelegate>delegate;

- (void)showInView:(UIView *)supView;

@end
