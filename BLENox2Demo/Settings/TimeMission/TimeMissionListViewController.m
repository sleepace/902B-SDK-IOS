//
//  TimeMissionListViewController.m
//  SA1001-2-demo
//
//  Created by jie yang on 2018/11/13.
//  Copyright © 2018年 jie yang. All rights reserved.
//

#import "TimeMissionListViewController.h"

#import "SLPWeekDay.h"
#import "AlarmDataModel.h"
#import "AlarmViewController.h"
#import "TitleValueSwitchCellTableViewCell.h"
#import <BleNox/BleNox.h>
#import <BleNox/BleNoxAlarmInfo.h>
#import "TimeMissionViewController.h"

@interface TimeMissionListViewController ()<UITableViewDataSource, UITableViewDelegate, TimeMissionControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (weak, nonatomic) IBOutlet UILabel *emptyLbl;
@property (nonatomic, copy) NSArray *timeMissionList;

@end

@implementation TimeMissionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loadData];
    
    [self setUI];
}

- (void)loadData
{
//    __weak typeof(self) weakSelf = self;
//    [SLPBLESharedManager bleNox:SharedDataManager.peripheral getAlarmListTimeout:0 completion:^(SLPDataTransferStatus status, id data) {
//        weakSelf.alramList = data;
//        if (self.alramList && self.alramList.count > 0) {
//            self.tableView.hidden = NO;
//            self.emptyView.hidden = YES;
//            [weakSelf.tableView reloadData];
//        }else{
//            self.tableView.hidden = YES;
//            self.emptyView.hidden = NO;
//        }
//    }];
    
    self.timeMissionList = SharedDataManager.timeMissionList;
    if (self.timeMissionList && self.timeMissionList.count > 0) {
        self.tableView.hidden = NO;
        self.emptyView.hidden = YES;
        [self.tableView reloadData];
    }else{
        self.tableView.hidden = YES;
        self.emptyView.hidden = NO;
    }
    
//    [SLPBLESharedManager SAB:SharedDataManager.peripheral getAlarmListTimeout:0 completion:^(SLPDataTransferStatus status, id data) {
//        weakSelf.alramList = data;
//        if (self.alramList && self.alramList.count > 0) {
//            self.tableView.hidden = NO;
//            self.emptyView.hidden = YES;
//            [weakSelf.tableView reloadData];
//        }else{
//            self.tableView.hidden = YES;
//            self.emptyView.hidden = NO;
//        }
//    }];
}

- (void)setUI
{
    self.titleLabel.text = LocalizedString(@"定时任务");
    self.emptyLbl.text = LocalizedString(@"暂无");
    [self.addButton setTitle:LocalizedString(@"add") forState:UIControlStateNormal];
    
    if (self.timeMissionList && self.timeMissionList.count > 0) {
        self.tableView.hidden = NO;
        self.emptyView.hidden = YES;
    }else{
        self.tableView.hidden = YES;
        self.emptyView.hidden = NO;
    }
}

- (IBAction)addAlarm:(id)sender {
    [self goAddAlarm];
}

- (void)goAddAlarm
{
    if (self.timeMissionList.count >= 10) {
        [Utils showMessage:LocalizedString(@"more_5") controller:self];
        return;
    }
    
    BleNoxAlarmInfo *alarmInfo = [self.timeMissionList lastObject];
    NSInteger alarmID = alarmInfo.alarmID + 1;
    
    TimeMissionViewController *vc = [TimeMissionViewController new];
    vc.addAlarmID = alarmID;
    vc.delegate = self;
    vc.timeMissionPageType = TimeMissionPageType_Add;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.timeMissionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TitleValueSwitchCellTableViewCell *cell = (TitleValueSwitchCellTableViewCell *)[SLPUtils tableView:tableView cellNibName:@"TitleValueSwitchCellTableViewCell"];
    
    BleNoxAlarmInfo *alarmData = [self.timeMissionList objectAtIndex:indexPath.row];
    cell.titleLabel.text = [self getAlarmTimeStringWithDataModle:alarmData];
    cell.subTitleLbl.text = [SLPWeekDay getAlarmRepeatDayStringWithWeekDay:alarmData.repeat];
    cell.switcher.on = alarmData.isOpen;
    
    __weak typeof(self) weakSelf = self;
    cell.switchBlock = ^(UISwitch *sender) {
        if (sender.on) {
            [weakSelf turnOnAlarmWithAlarm:alarmData];
        }else{
            [weakSelf turnOffAlarmWithAlarm:alarmData];
        }
    };
    
    return cell;
}

- (void)turnOnAlarmWithAlarm:(BleNoxAlarmInfo *)alarmInfo
{
    __weak typeof(self) weakSelf = self;
    [SLPBLESharedManager bleNox:SharedDataManager.peripheral enableAlarm:alarmInfo.alarmID timeout:0 callback:^(SLPDataTransferStatus status, id data) {
        if (status != SLPDataTransferStatus_Succeed) {
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
            [weakSelf.tableView reloadData];
        }else{
            alarmInfo.isOpen = YES;
        }
    }];
//    [SLPBLESharedManager SAB:SharedDataManager.peripheral enableAlarm:alarmInfo.alarmID timeout:0 callback:^(SLPDataTransferStatus status, id data) {
//        if (status != SLPDataTransferStatus_Succeed) {
//            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
//            [weakSelf.tableView reloadData];
//        }else{
//            alarmInfo.isOpen = YES;
//        }
//    }];
}

- (void)turnOffAlarmWithAlarm:(BleNoxAlarmInfo *)alarmInfo
{
    if (![SLPBLESharedManager blueToothIsOpen]) {
        [self.tableView reloadData];
        [Utils showMessage:LocalizedString(@"phone_bluetooth_not_open") controller:self];
        return;
    }
    __weak typeof(self) weakSelf = self;
    [SLPBLESharedManager bleNox:SharedDataManager.peripheral disableAlarm:alarmInfo.alarmID timeout:0 callback:^(SLPDataTransferStatus status, id data) {
        if (status != SLPDataTransferStatus_Succeed) {
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
            [weakSelf.tableView reloadData];
        }else{
            alarmInfo.isOpen = YES;
        }
    }];
//    [SLPBLESharedManager SAB:SharedDataManager.peripheral disableAlarm:alarmInfo.alarmID timeout:0 callback:^(SLPDataTransferStatus status, id data) {
//        if (status != SLPDataTransferStatus_Succeed) {
//            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
//            [weakSelf.tableView reloadData];
//        }else{
//            alarmInfo.isOpen = YES;
//        }
//    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BleNoxAlarmInfo *alarmData = [self.timeMissionList objectAtIndex:indexPath.row];
    
    [self goAlarmVCWithAlarmData:alarmData];
}

- (void)goAlarmVCWithAlarmData:(BleNoxAlarmInfo *)alarmData
{
    TimeMissionViewController *vc = [TimeMissionViewController new];
    vc.delegate = self;
    vc.orignalAlarmData = alarmData;
    vc.timeMissionPageType = TimeMissionPageType_edit;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSString *)getAlarmTimeStringWithDataModle:(BleNoxAlarmInfo *)dataModel {
    return [SLPUtils timeStringFrom:dataModel.hour minute:dataModel.minute isTimeMode24:[SLPUtils isTimeMode24]];
}

- (void)editAlarmInfoAndShouldReload
{
    [self loadData];
}
@end
