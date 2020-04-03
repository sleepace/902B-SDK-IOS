//
//  BleNoxGestureInfo.h
//  BleNox
//
//  Created by Martin on 2018/3/1.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BleNoxGestureInfo : NSObject
@property (nonatomic, assign) UInt8 gesture;//手势 0x00: 手势-左右挥手  0x01: 手势-悬停  0x02: 按键-中心键短按
@property (nonatomic, assign) UInt8 opt;//操作 0x00: 默认操作 0x01: 播放/暂停 0x02: 切歌(左上右下) 0xFF: 无操作(停用)
@end
