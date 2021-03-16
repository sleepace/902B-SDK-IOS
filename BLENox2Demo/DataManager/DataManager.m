//
//  DataManager.m
//  Binatone-demo
//
//  Created by Martin on 28/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import "DataManager.h"
#define kUserID @"kUserID"
@implementation DataManager

+ (DataManager *)sharedDataManager {
    static dispatch_once_t onceToken;
    static DataManager *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DataManager alloc] init];
    });
    return sharedInstance;
}

-(instancetype)init
{
    if (self = [super init]) {
        _selectItemsNum = 7;
        _assistMusicID = 30001;
        
        _aidInfo = [[BleNoxAidInfo alloc] init];
        _aidInfo.aidStopDuration = 1;
        _aidInfo.r = 255;
        _aidInfo.b = 0;
        _aidInfo.w = 0;
        _aidInfo.brightness = 0;
//        _aidInfo.aromaRate = 2;
        _volumn = 0;
        
        _nightLightInfo = [[BleNoxNightLightInfo alloc] init];
        _nightLightInfo.enable = NO;
        _nightLightInfo.brightness = 0;
        
        SLPLight *light = [[SLPLight alloc] init];
        light.r = 0;
        light.g = 0;
        light.b = 0;
        light.w = 0;
        _nightLightInfo.light = light;
        
        _nightLightInfo.startHour = 23;
        _nightLightInfo.startMinute = 0;
        _nightLightInfo.duration = 420;
        
        _alarmList = [NSMutableArray array];
        _timeMissionList = [NSMutableArray array];
    }
    
    return self;
}

- (void)reset
{
    _selectItemsNum = 7;
    _assistMusicID = 30001;
    
    _aidInfo.aidStopDuration = 1;
    _aidInfo.r = 255;
    _aidInfo.b = 0;
    _aidInfo.w = 0;
    _aidInfo.brightness = 0;
//    _aidInfo.aromaRate = 2;
    _volumn = 0;
}

- (void)toInit {
    self.peripheral = nil;
    self.deviceName = nil;
    self.deviceID = nil;
    self.inRealtime = NO;
    
}

- (NSString *)userID {
    NSString *userIDString = [[NSUserDefaults standardUserDefaults] stringForKey:kUserID];
    return userIDString;
}

- (void)setUserID:(NSString *)userID {
    [[NSUserDefaults standardUserDefaults] setValue:userID forKey:kUserID];
}
@end
