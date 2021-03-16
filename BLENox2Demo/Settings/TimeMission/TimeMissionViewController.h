//
//  AlarmViewController.h
//  SA1001-2-demo
//
//  Created by jie yang on 2018/11/14.
//  Copyright © 2018年 jie yang. All rights reserved.
//

#import "BaseViewController.h"

#import <BleNox/BleNoxAlarmInfo.h>

typedef NS_ENUM(NSInteger, TimeMissionPageType) {
    TimeMissionPageType_edit,
    TimeMissionPageType_Add,
};

@protocol TimeMissionControllerDelegate <NSObject>

@optional
- (void)editAlarmInfoAndShouldReload;
@end
NS_ASSUME_NONNULL_BEGIN

@interface TimeMissionViewController : BaseViewController

@property (strong, nonatomic) BleNoxAlarmInfo *orignalAlarmData;

@property (nonatomic, assign) NSInteger addAlarmID;

@property (nonatomic, assign) TimeMissionPageType timeMissionPageType;

@property (nonatomic, weak) id<TimeMissionControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
