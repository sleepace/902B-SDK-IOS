//
//  BleNoxAidInfo.h
//  SDK
//
//  Created by Martin on 2018/3/1.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BleNoxAidInfo : NSObject
@property (nonatomic,assign) UInt8 volume;//音量 音量(0-16) 0:静音
@property (nonatomic,assign) UInt8 brightness;//灯光亮度 (0-100)
@property (nonatomic, assign) UInt8 r;//灯光颜色r分量 0-255
@property (nonatomic, assign) UInt8 g;//灯光颜色g分量 0-255
@property (nonatomic, assign) UInt8 b;//灯光颜色b分量 0-255
@property (nonatomic, assign) UInt8 w;//灯光颜色W分量 0-255  (目前W分量为0)
@property (nonatomic, assign) UInt8 aidStopDuration;//辅助停止时长 单位：分钟

@end
