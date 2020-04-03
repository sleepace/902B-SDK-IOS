//
//  BleNoxAlarmInfo.h
//  SDK
//
//  Created by Martin on 2018/3/1.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BleNoxAlarmInfo : NSObject
@property (nonatomic, assign) UInt64 alarmID;//闹钟编号 唯一编号 一般由服务器提供
@property (nonatomic, assign) BOOL isOpen;//闹钟开关
@property (nonatomic, assign) UInt8 hour;//时
@property (nonatomic, assign) UInt8 minute;//分
/*重复
 周1-7 开关(0-6位) 0:关， 1:开
 全0表示单次闹钟,设置时间戳作为过期标准
 */
@property (nonatomic, assign) UInt8 repeat;
@property (nonatomic, assign) UInt8 snoozeTime;//贪睡次数
@property (nonatomic, assign) UInt8 snoozeLength;//贪睡时长
@property (nonatomic, assign) UInt8 volume;//音量大小 0-16
@property (nonatomic, assign) UInt8 brightness;//亮度 0-100
@property (nonatomic, assign) BOOL shake;//震动是否打开
@property (nonatomic, assign) UInt16 musicID;//音乐ID
@property (nonatomic, assign) UInt32 timestamp;//时间戳 设置/修改闹钟时的标准时间戳（用于单次闹钟）
@end
