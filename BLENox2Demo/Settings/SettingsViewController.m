//
//  SettingsViewController.m
//  SA1001-2-demo
//
//  Created by jie yang on 2018/11/13.
//  Copyright © 2018年 jie yang. All rights reserved.
//

#import "SettingsViewController.h"
#import "AlarmListViewController.h"
#import "CenterSettingViewController.h"
#import "TitleSubTitleArrowCell.h"
#import <BleNox/BleNox.h>
#import "ResetCell.h"
#import "NightLightViewContronller.h"
#import "GestureControlViewController.h"
#import "AlarmViewController.h"
#import "TimeMissionListViewController.h"

enum {
    Row_Alarm = 0,
    Row_NightLight,
    Row_TimeMission,
    Row_CountDown,
    Row_Bottom,
};

@interface SettingsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
    [self addNotificationObservre];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self showConnected:SharedDataManager.connected];
}

- (void)addNotificationObservre {
    NSNotificationCenter *notificationCeter = [NSNotificationCenter defaultCenter];
    [notificationCeter addObserver:self selector:@selector(deviceConnected:) name:kNotificationNameBLEDeviceConnected object:nil];
    [notificationCeter addObserver:self selector:@selector(deviceDisconnected:) name:kNotificationNameBLEDeviceDisconnect object:nil];
}

- (void)deviceConnected:(NSNotification *)notification {
    SharedDataManager.connected = YES;
    [self showConnected:YES];
}

- (void)deviceDisconnected:(NSNotification *)notfication {
    SharedDataManager.connected = NO;
    [self showConnected:NO];
}

- (void)showConnected:(BOOL)connected {
    CGFloat alpha = connected ? 1.0 : 0.3;
    [self.view setAlpha:alpha];
    
    [self.view setUserInteractionEnabled:connected];
}

- (void)setUI
{
    self.titleLabel.text = LocalizedString(@"setting");
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

#pragma mark UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return Row_Bottom;
    }
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 60;
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TitleSubTitleArrowCell *cell = (TitleSubTitleArrowCell *)[SLPUtils tableView:tableView cellNibName:@"TitleSubTitleArrowCell"];
    NSString *title = LocalizedString(@"alarm");
    NSInteger section = indexPath.section;
    if (section == 0) {
        if (indexPath.row == Row_NightLight) {
            title = LocalizedString(@"nightLight");
        } else if (indexPath.row == Row_TimeMission) {
            title = LocalizedString(@"定时任务");
        } else if (indexPath.row == Row_CountDown) {
            title = LocalizedString(@"倒计时");
        }
    }else{
        if (indexPath.row == 0) {
            title = LocalizedString(@"Wave");
        }else if(indexPath.row == 1){
            title = LocalizedString(@"Hover");
        }else if(indexPath.row == 2) {
            ResetCell *resetCell = (ResetCell *)[SLPUtils tableView:tableView cellNibName:@"ResetCell"];
            __weak typeof(self) weakSelf = self;
            resetCell.resetBlock = ^{
                [weakSelf resetDevice];
            };
            return resetCell;
        }
        
    }
    [Utils configCellTitleLabel:cell.textLabel];
    [cell.textLabel setText:title];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    if (section == 1) {
        view.backgroundColor = Theme.normalLineColor;
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
        UILabel *txtLbl = [[UILabel alloc] init];
        txtLbl.frame = CGRectMake(15, 0, 300, 40);
        txtLbl.text = LocalizedString(@"setGesture");
        txtLbl.font = [UIFont systemFontOfSize:13];
        [view addSubview:txtLbl];
    }
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 40;
    }
    
    return 0;
}

- (void)resetDevice
{
    if (![SLPBLESharedManager blueToothIsOpen]) {
        [Utils showMessage:LocalizedString(@"phone_bluetooth_not_open") controller:self];
        return;
    }
    __weak typeof(self) weakSelf = self;
    [SLPBLESharedManager bleNox:SharedDataManager.peripheral deviceInitTimeout:0 callback:^(SLPDataTransferStatus status, id data) {
        if (status != SLPDataTransferStatus_Succeed) {
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
        }else{
            [SharedDataManager reset];
            //            [Utils showAlertTitle:@"" message:LocalizedString(@"factory_reset_send") confirmTitle:LocalizedString(@"confirm") atViewController:weakSelf];
            
            [Utils showMessage:LocalizedString(@"factory_reset_send") controller:weakSelf];
        }
    }];
//    [SLPBLESharedManager SAB:SharedDataManager.peripheral deviceInitTimeout:0 callback:^(SLPDataTransferStatus status, id data) {
//        if (status != SLPDataTransferStatus_Succeed) {
//            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
//        }else{
//            [SharedDataManager reset];
////            [Utils showAlertTitle:@"" message:LocalizedString(@"factory_reset_send") confirmTitle:LocalizedString(@"confirm") atViewController:weakSelf];
//            
//            [Utils showMessage:LocalizedString(@"factory_reset_send") controller:weakSelf];
//        }
//    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    if (section == 0) {
        if (indexPath.row == 0) {
            [self goAlarmPage];
        }else if (indexPath.row == 1){
            [self goNightLightPage];
        }else if (indexPath.row == 2){
            [self goTimeMissionList];
        }else if (indexPath.row == 3){
            [self goNightLightPage];
        }
    } else if (section == 1){
        [self goGesturePageWithMode:indexPath.row];
    }
    
}

- (void)goGesturePageWithMode:(GestureMode)mode
{
    GestureControlViewController *vc = [GestureControlViewController new];
    vc.mode = mode;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goAlarmPage
{
//    AlarmListViewController *vc = [AlarmListViewController new];
//    [self.navigationController pushViewController:vc animated:YES];
    [self goAddAlarm];
}

- (void)goNightLightPage
{
    NightLightViewContronller *vc = [NightLightViewContronller new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goTimeMissionList {
    TimeMissionListViewController *vc = [TimeMissionListViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goCountDown {
    
}

- (void)goAddAlarm
{
    NSInteger timeStamp = [[NSDate date] timeIntervalSince1970];
    NSInteger alarmID = timeStamp;
    
    AlarmViewController *vc = [AlarmViewController new];
    vc.addAlarmID = alarmID;
//    vc.delegate = self;
    vc.alarmPageType = AlarmPageType_Add;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
