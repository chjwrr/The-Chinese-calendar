//
//  MyCalendarView.m
//  日历测试
//
//  Created by apple on 16/8/8.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "MyCalendarView.h"
#import "MyCalendarCell.h"


NSString *const CellWithReuseIdentifier=@"cell";


@interface MyCalendarView ()<UICollectionViewDelegate , UICollectionViewDataSource>{
    NSArray *_weekDayArray;
    UILabel *lab_title;
    
    NSCalendar *lunarCalendar;
    
    NSArray *_lunarDays;
    NSArray *_lunarMonths;
    NSDateFormatter *dateFormatter;

}

@property (nonatomic , strong) UICollectionView *collectionView;


@end

@implementation MyCalendarView

- (instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        [self subViews];
    }
    return self;
}

//重写set方法
- (void)setCurrentDate:(NSDate *)currentDate {
    _currentDate = currentDate;
    
    lab_title.text=[NSString stringWithFormat:@"%ld年 %ld月",[self year:_currentDate],[self month:_currentDate]];
    
    [_collectionView reloadData];
}

- (void)subViews {
    
    //日期格式
    dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];


    //中国农历 日历
    lunarCalendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    lunarCalendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];

    //农历日期名
    _lunarDays =[NSArray arrayWithObjects:@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",
                 @"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",
                 @"廿一",@"廿二",@"廿三",@"廿四",@"廿五",@"廿六",@"廿七",@"廿八",@"廿九",@"三十",nil];
    
    //农历月份名
    _lunarMonths=  [NSArray arrayWithObjects:@"正",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"腊",nil];
    
    
    _weekDayArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    
    CGFloat width=self.frame.size.width / 7;
    CGFloat height=(self.frame.size.height - 80)/ 7;
    
    
    lab_title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    [self addSubview:lab_title];
    lab_title.textAlignment=NSTextAlignmentCenter;
    lab_title.textColor=[UIColor purpleColor];
    lab_title.font=[UIFont boldSystemFontOfSize:20];
    
    
    
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.sectionInset=UIEdgeInsetsMake(0, 0, 0, 0);
    layout.itemSize=CGSizeMake(width, height);
    layout.minimumLineSpacing=0;
    layout.minimumInteritemSpacing=0;
    
    _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 40, self.frame.size.width, self.frame.size.height-80) collectionViewLayout:layout];
    [_collectionView setCollectionViewLayout:layout animated:YES];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    [self addSubview:_collectionView];
    
    [_collectionView registerClass:[MyCalendarCell class] forCellWithReuseIdentifier:CellWithReuseIdentifier];
    _collectionView.backgroundColor=[UIColor whiteColor];
    
    
    
    UIButton *lastMonth=[[UIButton alloc]initWithFrame:CGRectMake(0, self.frame.size.height-40, 100, 40)];
    [self addSubview:lastMonth];
    [lastMonth setTitle:@"上一个月" forState:UIControlStateNormal];
    [lastMonth setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [lastMonth addTarget:self action:@selector(lastMonthAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *nextMonth=[[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-100, self.frame.size.height-40, 100, 40)];
    [self addSubview:nextMonth];
    [nextMonth setTitle:@"下一个月" forState:UIControlStateNormal];
    [nextMonth setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [nextMonth addTarget:self action:@selector(nextMonthAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)showInView:(UIView *)supView {
    [supView addSubview:self];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (section == 0) {
        return [_weekDayArray count];
    }
    
    return 6*7; // 6 行 7 列
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyCalendarCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:CellWithReuseIdentifier forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        cell.dateLabel.text=[_weekDayArray objectAtIndex:indexPath.row];
        cell.dateLabel.backgroundColor=[UIColor whiteColor];
        cell.dateLabel.textColor=[UIColor blackColor];
        
        cell.chineseDateLabel.text=@"";
    }else{
        
        
        NSInteger totalDayInMonth=[self totalDaysInMonth:_currentDate];//日期所在的月份一共有几天
        NSInteger firstWeekDay=[self firstWeekDayInMonth:_currentDate];//日期所在月份的第一天是周几
        
        
        //1号之前的和月末的cell不显示数字
        if (indexPath.row < firstWeekDay || indexPath.row > firstWeekDay + totalDayInMonth -1) {
            cell.dateLabel.text=@"";
            cell.chineseDateLabel.text=@"";

        }else {
            
            //日期转成字符串进行比较
            
            NSString *now_str=[dateFormatter stringFromDate:_nowDate];
            NSString *current_str=[dateFormatter stringFromDate:_currentDate];

            if ([now_str compare:current_str] == NSOrderedSame) {
                //如果是当前年月日  显示为空色背景
                if ([self day:_nowDate] == indexPath.row-firstWeekDay+1) {
                    cell.dateLabel.backgroundColor=[UIColor redColor];
                    cell.dateLabel.textColor=[UIColor blackColor];

                }else if ([self day:_nowDate] < indexPath.row-firstWeekDay+1){
                    //当前以后的日期 字体显示为灰色
                    cell.dateLabel.textColor=[UIColor grayColor];
                    
                }else{
                    //当前以前的日期 字体显示为黑色
                    cell.dateLabel.backgroundColor=[UIColor whiteColor];
                    cell.dateLabel.textColor=[UIColor blackColor];
                    
                }
                
            }else if ([_nowDate compare:_currentDate] == NSOrderedAscending) {
                //大于当前日期
                cell.dateLabel.backgroundColor=[UIColor whiteColor];
                cell.dateLabel.textColor=[UIColor grayColor];

            }else{
                //小于当前日期
                cell.dateLabel.backgroundColor=[UIColor whiteColor];
                cell.dateLabel.textColor=[UIColor blackColor];

            }
            
            
            //正常日期显示
            cell.dateLabel.text=[NSString stringWithFormat:@"%ld",indexPath.row-firstWeekDay+1];
 
            
            NSString *time=[NSString stringWithFormat:@"%ld%02ld%02ld",[self year:_currentDate],[self month:_currentDate],indexPath.row-firstWeekDay+1];
            
            //农历日期显示
            cell.chineseDateLabel.text=[self chineseCalendarFormatterDate:time];
            
        }
        
    }
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
    }else{
        
        
        NSInteger totalDayInMonth=[self totalDaysInMonth:_currentDate];//日期所在的月份一共有几天
        NSInteger firstWeekDay=[self firstWeekDayInMonth:_currentDate];//日期所在月份的第一天是周几
        
        
        //1号之前的和月末的cell不显示数字
        if (indexPath.row < firstWeekDay || indexPath.row > firstWeekDay + totalDayInMonth -1) {
        }else {
           
            NSString *currentDate=[NSString stringWithFormat:@"%ld-%ld-%ld",[self year:_currentDate],[self month:_currentDate],indexPath.row-firstWeekDay+1];
            
            
            
            NSString *time=[NSString stringWithFormat:@"%ld%02ld%02ld",[self year:_currentDate],[self month:_currentDate],indexPath.row-firstWeekDay+1];
            
            //农历日期显示
            NSString *chineseDate=[self chineseCalendarFormatterDate:time];


            [_delegate didSelectMyCalendarViewChooseCurrentDate:currentDate chineseDate:chineseDate];
            
        }
    }
    

}

/**
 *  格式化字符串日期并返回日期的农历
 *
 *  @param str_time 日期字符串
 *
 *  @return 返回农历日期
 */
- (NSString *)chineseCalendarFormatterDate:(NSString *)str_time {
    NSDate *date=[dateFormatter dateFromString:str_time];

    return [self chineseCalendar:date];
}

/**
 *  计算给定日期的农历日期
 *
 *  @return 返回农历日期   例:八月十五
 */
- (NSString *)chineseCalendar:(NSDate *)date{
    
    NSInteger day = [lunarCalendar components:NSCalendarUnitDay fromDate:date].day;
    NSInteger month = [lunarCalendar components:NSCalendarUnitMonth fromDate:date].month;
    
    NSString* dayStr=_lunarDays[day-1];
    NSString* monthStr=_lunarMonths[month-1];
    
    NSString *lunarDate = [NSString stringWithFormat:@"%@月%@",monthStr,dayStr];

    return lunarDate;
}


/**
 *  上一个月
 */
- (void)lastMonthAction {
    self.currentDate=[self lastMonth:_currentDate];
}

/**
 *  下一个月
 */
- (void)nextMonthAction {
    self.currentDate=[self nextMonth:_currentDate];

}

/**
 *  日期所在的月份一共有几天
 *
 *  @param date 日期
 *
 *  @return 返回一共有几天
 
 */
- (NSInteger)totalDaysInMonth:(NSDate *)date {
    NSRange totalDaysInMonth=[[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return totalDaysInMonth.length;
}

/**
 *  日期所在月份的第一天是周几
 *
 *  @param date 日期
 *
 *  @return 返回星期几
 */
- (NSInteger)firstWeekDayInMonth:(NSDate *)date {
    
    NSCalendar *calendar=[NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    
    NSDateComponents *comp=[calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    NSDate *firstDayOfMonthDate=[calendar dateFromComponents:comp];//第一天的日期
    
    NSUInteger fistWeekDay=[calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    
    return fistWeekDay-1;
}

/**
 *  返回上一个月的今日的日期
 *
 *  @param date 日期
 *
 *  @return 返回上月的今日 的日期
 */
- (NSDate *)lastMonth:(NSDate *)date {
    NSDateComponents *dateComponents=[[NSDateComponents alloc]init];
    dateComponents.month=-1;
    NSDate *newDate=[[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

/**
 *  返回下一个月的今日的日期
 *
 *  @param date 日期
 *
 *  @return 返回下月的今日 的日期
 */
- (NSDate *)nextMonth:(NSDate *)date {
    NSDateComponents *dateComponents=[[NSDateComponents alloc]init];
    dateComponents.month=+1;
    NSDate *newDate=[[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}


/**
 *  根据给定的日期获取  日期中的日
 *
 *  @param date 给定的日期
 */
- (NSInteger)day:(NSDate *)date {
    NSDateComponents *components=[[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    return components.day;
}

/**
 *  根据给定的日期获取  日期中的月
 *
 *  @param date 给定的日期
 */
- (NSInteger)month:(NSDate *)date {
    NSDateComponents *components=[[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    return components.month;
}

/**
 *  根据给定的日期获取  日期中的年
 *
 *  @param date 给定的日期
 */
- (NSInteger)year:(NSDate *)date {
    NSDateComponents *components=[[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    return components.year;
}




@end
