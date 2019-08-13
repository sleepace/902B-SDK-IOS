//
//  GestureControlViewController.h
//  BLENox2Demo
//
//  Created by jie yang on 2019/7/31.
//  Copyright © 2019 jie yang. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, GestureActionMode) {
    GestureActionModeDefault = 0x00,
    GestureActionModePlayOrStop,
    GestureActionModeChangeMusic,
    GestureActionModeChangeLight,
    GestureActionModeChangeAlbum,
    GestureActionModeDisable = 0xFF,
};

typedef NS_ENUM(NSInteger, GestureMode) {
    GestureModeWave = 0x00, //挥手
    GestureModeHover, //悬停
    GestureModeKeypad,//按键
};

NS_ASSUME_NONNULL_BEGIN

@interface GestureControlViewController : BaseViewController

@property (nonatomic, assign) GestureMode mode;

@end

NS_ASSUME_NONNULL_END
