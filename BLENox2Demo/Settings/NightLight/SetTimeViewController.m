//
//  SetTimeViewController.m
//  BLENox2Demo
//
//  Created by jie yang on 2019/7/30.
//  Copyright © 2019 jie yang. All rights reserved.
//

#import "SetTimeViewController.h"
#import "SLPTimePicker.h"
#import "TitleSubTitleArrowCell.h"

@interface SetTimeViewController ()<UITableViewDelegate, UITableViewDataSource, SLPTimePickerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet SLPTimePicker *timePicker;

@property (nonatomic, assign) BOOL startTimeSelected;

@property (nonatomic, assign, readonly) BOOL endTimeSelected;

@end

@implementation SetTimeViewController

- (BOOL)endTimeSelected {
    return !self.startTimeSelected;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = LocalizedString(@"setTime");
    
    self.timePicker.delegate = self;
    [self.timePicker setMode:SLPTimePickerMode_24Hour];
    SLPTime24 *time24 = [[SLPTime24 alloc] init];
    time24.hour = self.startHour;
    time24.minute = self.startMinute;
    [self.timePicker setMode:![SLPUtils isTimeMode24]];
    [self.timePicker setTime:time24 animated:YES];
    
    self.startTimeSelected = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TitleSubTitleArrowCell *cell = (TitleSubTitleArrowCell *)[SLPUtils tableView:tableView cellNibName:@"TitleSubTitleArrowCell"];
    NSString *title = LocalizedString(@"start_time");
    
    NSString *subTitle = [self getAlarmTimeStringWithHour:self.startHour minute:self.startMinute];
    
    if (indexPath.row == 1) {
        title = LocalizedString(@"end_time");
        subTitle = [self getAlarmTimeStringWithHour:self.endHour minute:self.endMinute];
    }
    
    cell.titleLabel.text = title;
    cell.subTitleLabel.text = subTitle;
    return cell;
}

- (NSString *)getAlarmTimeStringWithHour:(NSInteger)hour minute:(NSInteger)minute {
    return [SLPUtils timeStringFrom:hour minute:minute isTimeMode24:[SLPUtils isTimeMode24]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        SLPTime24 *time24 = [[SLPTime24 alloc] init];
        time24.hour = self.endHour;
        time24.minute = self.endMinute;
        [self.timePicker setTime:time24 animated:YES];
        self.startTimeSelected = NO;
    } else{
        SLPTime24 *time24 = [[SLPTime24 alloc] init];
        time24.hour = self.startHour;
        time24.minute = self.startMinute;
        [self.timePicker setTime:time24 animated:YES];
        self.startTimeSelected = YES;
    }
    
    [self.tableView reloadData];
}

- (CGFloat)slpTimePicker:(SLPTimePicker *)pickerView widthForComponent:(NSInteger)component {
    return kTimePickerWidth;
}

- (CGFloat)slpTimePicker:(SLPTimePicker *)pickerView rowHeightForComponent:(NSInteger)component {
    return kTimePickerHeight;
}

- (UIFont *)slpTimerPicker:(SLPTimePicker *)pickerView titleFontForRow:(NSInteger)row forComponent:(NSInteger)component {
    UIFont *font = nil;
    switch (component) {
        case SLPTimerPickerComponent_AMPM:
            font = [UIFont systemFontOfSize:kAMPMFont];
            break;
        default:
            font = [UIFont systemFontOfSize:kTimePickerTitleFont];
            break;
    }
    return font;
}
- (UIColor *)slpTimerPicker:(SLPTimePicker *)pickerView titleColorForRow:(NSInteger)row forComponent:(NSInteger)component {
    return Theme.C3;
}

- (void)slpTimePickerValueChanged:(SLPTimePicker *)pickerView {
    SLPTime24 *time24 = pickerView.time;
    if (self.startTimeSelected) {
        self.startHour = time24.hour;
        self.startMinute = time24.minute;
    }
    if (self.endTimeSelected) {
        self.endHour = time24.hour;
        self.endMinute = time24.minute;
    }
    [self.tableView reloadData];

    if ([self.delegate respondsToSelector:@selector(timeChangedWithStartHour:startMinute:endHour:endMinute:)]) {
        [self.delegate timeChangedWithStartHour:self.startHour startMinute:self.startMinute endHour:self.endHour endMinute:self.endMinute];
    }
}

@end
