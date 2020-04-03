//
//  BleNoxWorkStatus.h
//  SDK
//
//  Created by Martin on 2018/3/1.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BluetoothManager/BluetoothManager.h>

@interface BleNoxWorkStatus : NSObject
@property (nonatomic, assign) UInt8 alarmStatus;//闹钟状态 0x00: 未运行 0x01: 运行中 0x02：贪睡中 0x03: 预览中
@property (nonatomic, assign) UInt64 alarmID;//闹钟编号 (闹钟响时有效)
@property (nonatomic, assign) BOOL isLightOn;//灯状态
@property (nonatomic, assign) UInt8 brightness;//灯亮度
@property (nonatomic, assign) UInt8 lightMode;//灯光模式 0: 白光 1: 色彩光(助眠，闹钟运行状态下均为色彩光) 2: 固定流光
@property (nonatomic, strong) SLPLight *light;//灯光 固定流光此项为nil
@property (nonatomic, assign) UInt8 musicStatus;//音乐状态 0: 停止 1:播放 2:暂停
@property (nonatomic, assign) UInt8 volume;//音量
@property (nonatomic, assign) UInt16 musicID;//音乐ID
@property (nonatomic, assign) UInt8 playMode;//播放模式 0：顺序播放 1: 随机播放 2: 单曲播放
@end
