//
//  MyCalendarCell.m
//  日历测试
//
//  Created by apple on 16/8/8.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "MyCalendarCell.h"

@implementation MyCalendarCell
- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] initWithFrame:self.bounds];
        [_dateLabel setTextAlignment:NSTextAlignmentCenter];
        [_dateLabel setFont:[UIFont systemFontOfSize:17]];
        [self addSubview:_dateLabel];
    }
    return _dateLabel;
}

- (UILabel *)chineseDateLabel
{
    if (!_chineseDateLabel) {
        _chineseDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-20, self.bounds.size.width, 20)];
        [_chineseDateLabel setTextAlignment:NSTextAlignmentCenter];
        [_chineseDateLabel setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:_chineseDateLabel];
    }
    return _chineseDateLabel;
}

@end
