//
//  GestureControlViewController.m
//  BLENox2Demo
//
//  Created by jie yang on 2019/7/31.
//  Copyright © 2019 jie yang. All rights reserved.
//

#import "GestureControlViewController.h"
#import "SLPTableSectionData.h"
#import "SLPCellHeaderView.h"
#import "SLPTitleImageCell.h"
#import "SLPTitleTableViewCell.h"
#import <BleNox/BleNox.h>

static NSString *const kDeviceSetting_Gesture = @"kDeviceSetting_Gesture";
static NSString *const kWaveSection_Title = @"kWaveSection_Title";
static NSString *const kWaveSection_Scene = @"kWaveSection_Scene";
static NSString *const kWaveSection_Color = @"kWaveSection_Color";
static NSString *const kWaveSection_Music = @"kWaveSection_Music";
static NSString *const kWaveSection_Album = @"kWaveSection_Album";
static NSString *const kWaveSection_Disable = @"kWaveSection_Disable";
static NSString *const kHoverSection_Title = @"kHoverSection_Title";
static NSString *const kHoverSection_PlayOrStop = @"kHoverSection_PlayOrStop";
static NSString *const kHoverSection_Disable = @"kHoverSection_Disable";

@interface GestureControlViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    BOOL _isSavedChange;
}

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray <SLPTableSectionData *>* sectionDataList;

@property (nonatomic, assign) GestureActionMode orignalGestureAction;

@property (nonatomic, assign) GestureActionMode currentGestureAction;

@property (nonatomic, strong) SLPCellHeaderView *guideView;

@end

@implementation GestureControlViewController

- (SLPCellHeaderView *)guideView {
    if (!_guideView) {
        _guideView = [SLPCellHeaderView loadFormNib];
        NSString *imageStr = @"";
        switch (self.mode) {
            case GestureModeWave:
                imageStr = @"device_pic_nox2_usetutorial_page2.jpg";
                break;
            case GestureModeHover:
                imageStr = @"device_pic_nox2_handstop.jpg";
                break;
            default:
                break;
        }
        
        _guideView.img_product.image = [UIImage imageNamed:imageStr];
    }
    return _guideView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self loadLocalData];
    [self loadSectionListData];
}

- (void)loadLocalData {
    switch (self.mode) {
        case GestureModeWave:
            self.orignalGestureAction = SharedDataManager.waveAction;
            break;
        case GestureModeHover:
            self.orignalGestureAction = SharedDataManager.hoverAction;
            break;
        default:
            break;
    }
    self.currentGestureAction = self.orignalGestureAction;
}

- (void)setupUI {
    switch (self.mode) {
        case GestureModeWave:
            self.titleLabel.text = LocalizedString(@"Wave");
            break;
        case GestureModeHover:
            self.titleLabel.text = LocalizedString(@"Hover");
            break;
        default:
            break;
    }
   [self.saveBtn setTitle:LocalizedString(@"save") forState:UIControlStateNormal];
}

- (void)loadSectionListData {
    
    NSMutableArray *aSectionList = [NSMutableArray array];
    SLPTableSectionData *deviceInfoData = [SLPTableSectionData new];
    deviceInfoData.sectionEnum = kDeviceSetting_Gesture;
    switch (self.mode) {
        case GestureModeWave:
        {
            NSMutableArray *deviceInfoRowEnumList = [NSMutableArray arrayWithObjects:kWaveSection_Title, kWaveSection_Color, kWaveSection_Music, kWaveSection_Disable, nil];;
            
            [deviceInfoData setRowEnumList:deviceInfoRowEnumList];
        }
            break;
        case GestureModeHover:
        {
            NSMutableArray *deviceInfoRowEnumList = [NSMutableArray arrayWithObjects:kHoverSection_Title, kHoverSection_PlayOrStop, kHoverSection_Disable, nil];
            [deviceInfoData setRowEnumList:deviceInfoRowEnumList];
        }
            break;
        default:
            break;
    }
    [aSectionList addObject:deviceInfoData];
    [self setSectionDataList:aSectionList];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionDataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SLPTableSectionData *settingData = self.sectionDataList[section];
    return settingData.rowEnumList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SCREEN_WIDTH * 2/ 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = nil;
    SLPTableSectionData *sectionData = [self.sectionDataList objectAtIndex:section];
    if ([sectionData.sectionEnum isEqualToString:kDeviceSetting_Gesture]){
        headView = self.guideView;
    }
    return headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    SLPTableSectionData *sectionData = [self.sectionDataList objectAtIndex:indexPath.section];
    NSString *rowEnum = [sectionData.rowEnumList objectAtIndex:indexPath.row];
    SLPTitleImageCell *cell = (SLPTitleImageCell *)[SLPUtils tableView:tableView cellNibName:@"SLPTitleImageCell"];
    GestureActionMode gestureAction = [self getMatchGestureWithIndexPath:indexPath];
    cell.icon.hidden = !(self.currentGestureAction == gestureAction);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([rowEnum isEqualToString:kWaveSection_Color]) {
        
        BOOL isCurrent = (self.currentGestureAction == gestureAction) || (self.currentGestureAction == GestureActionModeDefault);
        cell.icon.hidden = !isCurrent;
        cell.titleLabel.text = LocalizedString(@"ChangeLightColor");
    } else if ([rowEnum isEqualToString:kWaveSection_Music]) {
        cell.titleLabel.text = LocalizedString(@"ChangeMusic");
    } else if ([rowEnum isEqualToString:kWaveSection_Disable]) {
        cell.titleLabel.text = LocalizedString(@"Disable");
    } else if ([rowEnum isEqualToString:kHoverSection_PlayOrStop]) {
        BOOL isCurrent = (self.currentGestureAction == gestureAction) || (self.currentGestureAction == GestureActionModeDefault);
        cell.icon.hidden = !isCurrent;
        cell.titleLabel.text = LocalizedString(@"PlayOrStop");
    } else if ([rowEnum isEqualToString:kHoverSection_Disable]) {
        cell.titleLabel.text = LocalizedString(@"Disable");
    } else if ([rowEnum isEqualToString:kWaveSection_Title]) {
        SLPTitleTableViewCell *titleCell = (SLPTitleTableViewCell *)[SLPUtils tableView:tableView cellNibName:@"SLPTitleTableViewCell"];
        titleCell.titleLabel.text = LocalizedString(@"WaveTitleStr");
        return titleCell;
    } else if ([rowEnum isEqualToString:kHoverSection_Title]) {
        SLPTitleTableViewCell *titleCell = (SLPTitleTableViewCell *)[SLPUtils tableView:tableView   cellNibName:@"SLPTitleTableViewCell"];
        titleCell.titleLabel.text = LocalizedString(@"HoverTitleStr");
        return titleCell;
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    GestureActionMode gestureAction = [self getMatchGestureWithIndexPath:indexPath];
    return !(gestureAction == self.currentGestureAction);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.currentGestureAction = [self getMatchGestureWithIndexPath:indexPath];
    [self.tableView reloadData];
}

- (GestureActionMode)getMatchGestureWithIndexPath:(NSIndexPath *)indexPath {
    GestureActionMode gestureAction = GestureActionModeDefault;
    SLPTableSectionData *sectionData = [self.sectionDataList objectAtIndex:indexPath.section];
    NSString *rowEnum = [sectionData.rowEnumList objectAtIndex:indexPath.row];
    
    
    if ([rowEnum isEqualToString:kWaveSection_Scene]) {
        gestureAction = GestureActionModeDefault;
    } else if ([rowEnum isEqualToString:kWaveSection_Music]) {
        gestureAction = GestureActionModeChangeMusic;
    } else if ([rowEnum isEqualToString:kWaveSection_Disable]) {
        gestureAction = GestureActionModeDisable;
    } else if ([rowEnum isEqualToString:kHoverSection_PlayOrStop]) {
        gestureAction = GestureActionModePlayOrStop;
    } else if ([rowEnum isEqualToString:kHoverSection_Disable]) {
        gestureAction = GestureActionModeDisable;
    }else if ([rowEnum isEqualToString:kWaveSection_Album]){
        gestureAction = GestureActionModeChangeAlbum;
    }else if([rowEnum isEqualToString:kWaveSection_Color]){
        gestureAction = GestureActionModeChangeLight;
    }
    return gestureAction;
}

- (BOOL)isGestureChaged {
    if (self.currentGestureAction == self.orignalGestureAction) {
        return NO;
    }
    return YES;
}

- (IBAction)saveAction:(UIButton *)sender {
    
    __weak typeof(self) weakSelf = self;
    
    [self showLoadingView];
    [SLPBLESharedManager bleNox:SharedDataManager.peripheral gestureConfigSet:self.mode opt:self.currentGestureAction timeout:0 callback:^(SLPDataTransferStatus status, id data) {
        [self unshowLoadingView];
        if (status != SLPDataTransferStatus_Succeed) {
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
            return;
        }
//        if (self.mode == GestureModeWave) {
//            SharedDataManager.waveAction = weakSelf.currentGestureAction;
//        } else if (self.mode == GestureModeHover) {
//            SharedDataManager.hoverAction = weakSelf.currentGestureAction;
//        }
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}

@end
