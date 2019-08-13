//
//  CenterSettingViewController.m
//  SA1001-2-demo
//
//  Created by jie yang on 2018/11/14.
//  Copyright © 2018年 jie yang. All rights reserved.
//

#import "CenterSettingViewController.h"

#import "SelectItemCell.h"
#import <BleNox/BleNox.h>

@interface CenterSettingViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property (nonatomic, assign) NSInteger selectItemsNumNew;

@property (nonatomic, copy) NSArray *selectItemList;

@end

@implementation CenterSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}

- (void)setUI
{
    self.titleLabel.text = LocalizedString(@"sa_center_set");
    [self.saveBtn setTitle:LocalizedString(@"save") forState:UIControlStateNormal];
    
    self.selectItemsNumNew = self.selectItemsNum;
    
    self.selectItemList = [self getSelectItems:self.selectItemsNumNew];
}
- (IBAction)saveAction:(id)sender {
    
    BOOL musicEnable = self.selectItemsNumNew & 0x01;
    
    NSInteger offset = 0x01 << 1;
    BOOL lightEnable = self.selectItemsNumNew & offset;
    
    offset = 0x01 << 2;
    BOOL aromaEnable = self.selectItemsNumNew & offset;
    
    if (![SLPBLESharedManager blueToothIsOpen]) {
        [Utils showMessage:LocalizedString(@"phone_bluetooth_not_open") controller:self];
        return;
    }
    __weak typeof(self) weakSelf = self;
//    [SLPBLESharedManager SAB:SharedDataManager.peripheral setCenterKey:lightEnable musicEnable:musicEnable aromaEnable:aromaEnable timeout:0 callback:^(SLPDataTransferStatus status, id data) {
//        if (status != SLPDataTransferStatus_Succeed) {
//            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
//        }else{
//            SharedDataManager.selectItemsNum = self.selectItemsNumNew;
//            [weakSelf.navigationController popViewControllerAnimated:YES];
//        }
//    }];
    
}

- (NSArray *)getSelectItems:(NSInteger)selectItemsNum
{
    NSMutableArray *repeatItemArr = [NSMutableArray array];
    NSInteger repeatItemsNum = selectItemsNum;
    for (int i = 0; i < 3; i++) {
        NSInteger offset = 0x01 << i;
        BOOL isSelected = repeatItemsNum & offset;
        [repeatItemArr addObject:@(isSelected)];
    }
    return [repeatItemArr copy];
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectItemCell *cell = (SelectItemCell *)[SLPUtils tableView:tableView cellNibName:@"SelectItemCell"];
    if (indexPath.row == 0) {
        cell.titleLabel.text = LocalizedString(@"sa_center_set_option1");
    }else if (indexPath.row == 1){
        cell.titleLabel.text = LocalizedString(@"sa_center_set_option2");
    }else{
        cell.titleLabel.text = LocalizedString(@"sa_center_set_option3");
    }
    
    BOOL isSelected = [[self.selectItemList objectAtIndex:indexPath.row] boolValue];
    cell.selectIcon.hidden = !isSelected;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger repeatItems = self.selectItemsNumNew;
    NSInteger offset = 0x01 << indexPath.row;
    self.selectItemsNumNew = repeatItems ^ offset;
    
    if (self.selectItemsNumNew == 0) {
        self.selectItemsNumNew = repeatItems;
    }else{
        self.selectItemList = [self getSelectItems:self.selectItemsNumNew];
        [self.tableView reloadData];
    }
    
}
@end
