//
//  BleNoxDeviceInfo.h
//  SDK
//
//  Created by Martin on 2018/3/1.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BleNoxDeviceInfo : NSObject
@property (nonatomic, copy) NSString *deviceID;//设备ID
@property (nonatomic, assign) NSString *firmwareVersion;//固件版本
@end
