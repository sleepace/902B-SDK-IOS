//
//  NightLightViewContronller.m
//  BLENox2Demo
//
//  Created by jie yang on 2019/7/30.
//  Copyright © 2019 jie yang. All rights reserved.
//

#import "NightLightViewContronller.h"
#import <BleNox/BleNox.h>
#import "SLPTimePicker.h"
#import "TitleSubTitleArrowCell.h"
#import "TitleSwitchCell.h"
#import "SetLightViewController.h"
#import "SetTimeViewController.h"

@interface NightLightViewContronller ()<UITableViewDelegate, UITableViewDataSource, SetLightViewControllerDelegate, SetTimeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) BOOL enable;

@property (nonatomic, assign) int r;
@property (nonatomic, assign) int g;
@property (nonatomic, assign) int b;
@property (nonatomic, assign) int w;
@property (nonatomic, assign) int brightness;

@property (nonatomic, assign) UInt8 startHour;
@property (nonatomic, assign) UInt8 startMinute;

@property (nonatomic, assign) UInt8 endHour;
@property (nonatomic, assign) UInt8 endMinute;

@property (nonatomic, assign) BOOL saved;

@end

@implementation NightLightViewContronller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.titleLabel.text = LocalizedString(@"nightLight");
    [self.saveBtn setTitle:LocalizedString(@"save") forState:UIControlStateNormal];
    
    self.enable = SharedDataManager.nightLightInfo.enable;
    
    self.startHour = SharedDataManager.nightLightInfo.startHour;
    self.startMinute = SharedDataManager.nightLightInfo.startMinute;
    
    int time = SharedDataManager.nightLightInfo.startHour * 60 + SharedDataManager.nightLightInfo.startMinute + SharedDataManager.nightLightInfo.duration;
    int hour = (int)(time / 60);
    if (hour >= 24) {
        hour = hour - 24;
    }
    
    int minute = time % 60;
    
    self.endHour = hour;
    self.endMinute = minute;
    
    self.r = SharedDataManager.nightLightInfo.light.r;
    self.g = SharedDataManager.nightLightInfo.light.g;
    self.b = SharedDataManager.nightLightInfo.light.b;
    self.w = SharedDataManager.nightLightInfo.light.w;
    self.brightness = SharedDataManager.nightLightInfo.brightness;
}

- (NSInteger)tableRowData
{
    if (self.enable) {
        return 3;
    }
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self tableRowData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TitleSubTitleArrowCell *cell = (TitleSubTitleArrowCell *)[SLPUtils tableView:tableView cellNibName:@"TitleSubTitleArrowCell"];
    NSString *title = LocalizedString(@"nightLight");
    if (indexPath.row == 0) {
        TitleSwitchCell *switchCell = (TitleSwitchCell *)[SLPUtils tableView:tableView cellNibName:@"TitleSwitchCell"];
        switchCell.switcher.on = self.enable;
        
        __weak typeof(self) weakSelf = self;
        switchCell.switchBlock = ^(UISwitch *sender) {
            weakSelf.enable = sender.on;
            [weakSelf.tableView reloadData];
        };
        switchCell.titleLabel.text = title;
        return switchCell;
    }else if (indexPath.row == 1) {
        title = LocalizedString(@"setLight");
        cell.subTitleLabel.text = @"";
    }else if(indexPath.row == 2) {
        title = LocalizedString(@"setTime");
        NSString *str1 = [self getAlarmTimeStringWithHour:self.startHour minute:self.startMinute];
        NSString *str2 = [self getAlarmTimeStringWithHour:self.endHour minute:self.endMinute];
        cell.subTitleLabel.text = [NSString stringWithFormat:@"%@:%@", str1, str2];
    }
    cell.titleLabel.text = title;
    return cell;
}

- (NSString *)getAlarmTimeStringWithHour:(NSInteger)hour minute:(NSInteger)minute {
    return [SLPUtils timeStringFrom:hour minute:minute isTimeMode24:[SLPUtils isTimeMode24]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
    
    UILabel *lbl = [[UILabel alloc] init];
    lbl.frame = CGRectMake(15, 10, SCREEN_WIDTH - 30, 0);
    lbl.text = LocalizedString(@"setnightLight");
    lbl.font = [UIFont systemFontOfSize:14];
    lbl.numberOfLines = 3;
    [view addSubview:lbl];
    [lbl sizeToFit];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        [self goSetLight];
    } else if (indexPath.row == 2) {
        [self goSetTime];
    }
}

- (void)goSetLight
{
    SetLightViewController *vc = [SetLightViewController new];
    vc.delegate = self;
    vc.r = self.r;
    vc.g = self.g;
    vc.b = self.b;
    vc.w = self.w;
    vc.brightness = self.brightness;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goSetTime
{
    SetTimeViewController *vc = [SetTimeViewController new];
    vc.startHour = self.startHour;
    vc.startMinute = self.startMinute;
    vc.endHour = self.endHour;
    vc.endMinute = self.endMinute;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)timeChangedWithStartHour:(UInt8)startHour startMinute:(UInt8)startMinute endHour:(UInt8)endHour endMinute:(UInt8)endMinute
{
    self.startHour = startHour;
    self.startMinute = startMinute;
    self.endHour = endHour;
    self.endMinute = endMinute;
    [self.tableView reloadData];
}

-(void)colorChangedWithR:(int)r g:(int)g b:(int)b w:(int)w brightness:(int)brightness
{
    self.r = r;
    self.g = g;
    self.b = b;
    self.w = w;
    self.brightness = brightness;
}

-(void)brightnessChanged:(int)brightness
{
    self.brightness = brightness;
}

- (IBAction)saveNightLightInfo:(UIButton *)sender {
    self.saved = YES;
    
    BleNoxNightLightInfo *info = [[BleNoxNightLightInfo alloc] init];
    
    SLPLight *light = [[SLPLight alloc] init];
    light.r = self.r;
    light.g = self.g;
    light.b = self.b;
    light.w = self.w;
    info.light = light;
    info.enable = self.enable;
    info.brightness = self.brightness;
    info.startHour = self.startHour;
    info.startMinute = self.startMinute;
    
    NSInteger duration = (self.endHour - self.startHour)*60 + self.endMinute - self.startMinute;
    if (duration < 0){
        duration += 24*60;
    }
    
    info.duration = duration;
    
    [self showLoadingView];
    __weak typeof(self) weakSelf = self;
    [SLPBLESharedManager bleNox:SharedDataManager.peripheral nigthLightConfig:info timeout:0 callback:^(SLPDataTransferStatus status, id data) {
        [weakSelf unshowLoadingView];
        if (status != SLPDataTransferStatus_Succeed) {
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
            return;
        }
        
//        SharedDataManager.nightLightInfo.enable = weakSelf.enable;
//        SharedDataManager.nightLightInfo.light.r = weakSelf.r;
//        SharedDataManager.nightLightInfo.light.g = weakSelf.g;
//        SharedDataManager.nightLightInfo.light.b = weakSelf.b;
//        SharedDataManager.nightLightInfo.light.w = weakSelf.w;
//        SharedDataManager.nightLightInfo.brightness = weakSelf.brightness;
//        SharedDataManager.nightLightInfo.startHour = weakSelf.startHour;
//        SharedDataManager.nightLightInfo.startMinute = weakSelf.startMinute;
//        SharedDataManager.nightLightInfo.duration = duration;
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
        [SLPBLESharedManager bleNox:SharedDataManager.peripheral turnOffLightTimeout:0 callback:^(SLPDataTransferStatus status, id data) {
            if (status != SLPDataTransferStatus_Succeed) {
                [Utils showDeviceOperationFailed:status atViewController:weakSelf];
            }
        }];
    }];
    
}


-(void)back
{
    if (self.saved) {
        [super back];
        return;
    }
    if (![SLPBLESharedManager blueToothIsOpen]) {
        [Utils showMessage:LocalizedString(@"phone_bluetooth_not_open") controller:self];
        return;
    }
    __weak typeof(self) weakSelf = self;
    [SLPBLESharedManager bleNox:SharedDataManager.peripheral turnOffLightTimeout:0 callback:^(SLPDataTransferStatus status, id data) {
        weakSelf.saved = YES;
        if (status != SLPDataTransferStatus_Succeed) {
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
        }
    }];
    
    [super back];
}

@end
