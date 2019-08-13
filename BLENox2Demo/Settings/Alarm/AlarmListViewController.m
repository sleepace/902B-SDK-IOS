//
//  AlarmListViewController.m
//  SA1001-2-demo
//
//  Created by jie yang on 2018/11/13.
//  Copyright © 2018年 jie yang. All rights reserved.
//

#import "AlarmListViewController.h"

#import "SLPWeekDay.h"
#import "AlarmDataModel.h"
#import "AlarmViewController.h"
#import "TitleValueSwitchCellTableViewCell.h"
#import <BleNox/BleNox.h>
#import <BleNox/BleNoxAlarmInfo.h>

@interface AlarmListViewController ()<UITableViewDataSource, UITableViewDelegate, AlarmViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (weak, nonatomic) IBOutlet UILabel *emptyLbl;
@property (nonatomic, copy) NSArray *alramList;

@end

@implementation AlarmListViewController

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
    
    self.alramList = SharedDataManager.alarmList;
    if (self.alramList && self.alramList.count > 0) {
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
    self.titleLabel.text = LocalizedString(@"alarm");
    self.emptyLbl.text = LocalizedString(@"sa_no_alarm");
    [self.addButton setTitle:LocalizedString(@"add") forState:UIControlStateNormal];
    
    if (self.alramList && self.alramList.count > 0) {
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
    if (self.alramList.count >= 5) {
        [Utils showMessage:LocalizedString(@"more_5") controller:self];
        return;
    }
    
    BleNoxAlarmInfo *alarmInfo = [self.alramList lastObject];
    NSInteger alarmID = alarmInfo.alarmID + 1;
    
    AlarmViewController *vc = [AlarmViewController new];
    vc.addAlarmID = alarmID;
    vc.delegate = self;
    vc.alarmPageType = AlarmPageType_Add;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.alramList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TitleValueSwitchCellTableViewCell *cell = (TitleValueSwitchCellTableViewCell *)[SLPUtils tableView:tableView cellNibName:@"TitleValueSwitchCellTableViewCell"];
    
    BleNoxAlarmInfo *alarmData = [self.alramList objectAtIndex:indexPath.row];
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
    
    BleNoxAlarmInfo *alarmData = [self.alramList objectAtIndex:indexPath.row];
    
    [self goAlarmVCWithAlarmData:alarmData];
}

- (void)goAlarmVCWithAlarmData:(BleNoxAlarmInfo *)alarmData
{
    AlarmViewController *vc = [AlarmViewController new];
    vc.delegate = self;
    vc.orignalAlarmData = alarmData;
    vc.alarmPageType = AlarmPageType_edit;
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
