//
//  SLPBLEManager+BleNox.h
//  BleNox
//
//  Created by Martin on 2018/3/1.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import <BluetoothManager/BluetoothManager.h>
#import "BleNoxDeviceInfo.h"
#import "BleNoxGestureInfo.h"
#import "BleNoxWorkStatus.h"
#import "BleNoxUpgradeInfo.h"
#import "BleNoxAlarmInfo.h"
#import "BleNoxNightLightInfo.h"
#import "BleNoxAidInfo.h"
#import "BleNoxLogInfo.h"
#import "BleNoxPINCode.h"
#import <SLPCommon/SLPCommon.h>

@interface SLPBLEManager (BleNox)

/*连接设备
 回调值为 BleNoxDeviceInfo
 */
- (void)bleNox:(CBPeripheral *)peripheral loginCallback:(SLPTransforCallback)handle;

/*时间校准
 timeInfo:时间信息
 timeout:超时
 */
- (void)bleNox:(CBPeripheral *)peripheral syncTimeInfo:(SLPTimeInfo*)timeInfo timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/*获取设备信息
 timeout:超时
 回调返回BleNoxDeviceInfo
 */
- (void)bleNox:(CBPeripheral *)peripheral getDeviceInfoTimeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/*设备初始化
 timeout:超时
 */
- (void)bleNox:(CBPeripheral *)peripheral deviceInitTimeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/*手势设置
 gesture:手势 0x00: 手势-左右挥手  0x01: 手势-悬停  0x02: 按键-中心键短按
 opt:操作 0x00: 默认操作 0x01: 播放/暂停 0x02: 切歌(左上右下) 0xFF: 无操作(停用)
 timeout:超时
 */
- (void)bleNox:(CBPeripheral *)peripheral gestureConfig:(UInt8)gesture opt:(UInt8)opt
       timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/*删除手势
 gesture:手势 0x00: 手势-左右挥手  0x01: 手势-悬停  0x02: 按键-中心键短按
 timeout:超时
 */
- (void)bleNox:(CBPeripheral *)peripheral delGesture:(UInt8)gesture timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/*工作状态查询
 timeout:超时
 回调返回:BleNoxWorkStatus
 */
- (void)bleNox:(CBPeripheral *)peripheral getWorkStatusTimeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/*升级
 timeout:超时
 回调返回：BleNoxUpgradeInfo
 */
- (void)bleNox:(CBPeripheral *)peripheral deviceUpgrade:(NSData *)data timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/*日志
 timeout:超时
 回调返回：BleNoxLogInfo 直到 回调里面显示已经结束或者获取失败为止
 */
- (void)bleNox:(CBPeripheral *)peripheral downloadLogTimeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/*添加或修改闹铃
 alarmInfo: 闹铃信息
 timeout:超时
 */
- (void)bleNox:(CBPeripheral *)peripheral alarmConfig:(BleNoxAlarmInfo *)alarmInfo
       timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 获取闹钟列表
 @param peripheral 蓝牙句柄
 @param timeout 超时（单位秒）
 @param handle 回调 返回 NSArray<SABAlarmInfo *>
 */
- (void)bleNox:(CBPeripheral *)peripheral getAlarmListTimeout:(CGFloat)timeout completion:(SLPTransforCallback)handle;
/*打开闹铃
 alarmID: 闹铃ID
 timeout:超时
 */
- (void)bleNox:(CBPeripheral *)peripheral turnOnAlarm:(UInt64)alarmID timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/*关闭闹铃
 alarmID: 闹铃ID
 timeout:超时
 */
- (void)bleNox:(CBPeripheral *)peripheral turnOffAlarm:(UInt64)alarmID timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/*删除闹铃
 alarmID：闹铃编号
 timeout:超时
 */
- (void)bleNox:(CBPeripheral *)peripheral delAlarm:(UInt64)alarmID timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;
/*闹铃预览
 alarmID: 闹铃ID
 volume: 音量大小 闹钟最大音量(0-16) 0:静音
 brightness: 灯光亮度 灯光最大亮度(0-100) 0:不亮
 musicID:音乐编号
 timeout:超时
 */
- (void)bleNox:(CBPeripheral *)peripheral startAlarmRreviewvolume:(UInt8)volume brightness:(UInt8)brightness musicID:(UInt16)musicID timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/*退出闹铃预览
 timeout:超时
 */
- (void)bleNox:(CBPeripheral *)peripheral stopAlarmRreviewTimeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/*启用闹铃
 只启用, 不开闹钟
 alarmID: 闹铃ID
 timeout:超时
 */
- (void)bleNox:(CBPeripheral *)peripheral enableAlarm:(UInt64)alarmID timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/*禁用闹铃
 当前该闹钟在运行，则停止
 alarmID: 闹铃ID
 timeout:超时
 */
- (void)bleNox:(CBPeripheral *)peripheral disableAlarm:(UInt64)alarmID timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/*设置小夜灯
 info: 小夜灯信息
 timeout:超时
 */
- (void)bleNox:(CBPeripheral *)peripheral nigthLightConfig:(BleNoxNightLightInfo *)info timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/*打开白光
 light: 灯光结构
 brightness: 灯光亮度(0-100) 0:不亮
 timeout:超时
 */
- (void)bleNox:(CBPeripheral *)peripheral turnOnWhiteLight:(SLPLight *)light brightness:(UInt8)brightness
       timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/*打开彩光
 light: 灯光结构
 brightness: 灯光亮度(0-100) 0:不亮
 timeout:超时
 */
- (void)bleNox:(CBPeripheral *)peripheral turnOnColorLight:(SLPLight *)light brightness:(UInt8)brightness
       timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;
/*打开流光
 timeout:超时
 */
- (void)bleNox:(CBPeripheral *)peripheral turnOnStreamerBrightness:(UInt8)brightness
       timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/*灯光亮度调节
 brightness: 灯光亮度(0-100) 0:不亮
 timeout:超时
 */
- (void)bleNox:(CBPeripheral *)peripheral lightBrightness:(UInt8)brightness
       timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/*关灯
 timeout:超时
 */
- (void)bleNox:(CBPeripheral *)peripheral turnOffLightTimeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/*打开音乐
 musicID: 音乐ID
 volume: 音量 音量(0-16) 0:静音
 playMode: //播放模式 0：顺序播放 1: 随机播放 2: 单曲播放
 timeout:超时
 */
- (void)bleNox:(CBPeripheral *)peripheral turnOnMusic:(UInt16)musicID volume:(UInt8)volume playMode:(UInt8)playMode
       timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;


/*停止音乐
 timeout:超时
 */
- (void)bleNox:(CBPeripheral *)peripheral turnOffMusicTimeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/*暂停音乐
 timeout:超时
 */
- (void)bleNox:(CBPeripheral *)peripheral pauseMusicTimeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/*设置音量
 volume:音量(0-16) 0:静音
 timeout:超时
 */
- (void)bleNox:(CBPeripheral *)peripheral setMusicVolume:(UInt8)volume
       timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/*设置播放模式
 playMode: 播放模式 0：顺序播放 1: 随机播放 2: 单曲播放
 musicID: 音乐ID
 volume: 音量
 timeout:超时
 */
- (void)bleNox:(CBPeripheral *)peripheral setPlayMode:(UInt8)playMode  musicID:(UInt16)musicID volume:(UInt8)volume
        timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/*打开助眠灯
 light：灯
 brightness：亮度
 timeout:超时
 */
- (void)bleNox:(CBPeripheral *)peripheral turnOnSleepAidLight:(SLPLight *)light brightness:(UInt8)brightness
       timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/*助眠灯亮度调节
 brightness: 灯光亮度(0-100) 0:不亮
 timeout:超时
 */
- (void)bleNox:(CBPeripheral *)peripheral setSleepAidLightBrightness:(UInt8)brightness
       timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/*打开助眠音乐
 playMode: //播放模式 0：顺序播放 1: 随机播放 2: 单曲播放
 timeout:超时
 */
- (void)bleNox:(CBPeripheral *)peripheral turnOnsleepAidMusic:(UInt16)musicID volume:(UInt8)volume playMode:(UInt8)playMode
       timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/*停止助眠音乐
 timeout:超时
 */
- (void)bleNox:(CBPeripheral *)peripheral turnOffSleepAidMusic:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/*助眠音量调节
 volume:音量(0-16) 0:静音
 timeout:超时
 */
- (void)bleNox:(CBPeripheral *)peripheral setSleepAidMusicVolume:(UInt8)volume timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/*保存助眠配置信息
 info: 助眠信息
 timeout:超时
 */
- (void)bleNox:(CBPeripheral *)peripheral sleepAidConfig:(BleNoxAidInfo *)info timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/*获取PIN code
 timeout:超时
 */
- (void)bleNox:(CBPeripheral *)peripheral getPINCodeTimeout:(CGFloat)timeout completion:(SLPTransforCallback)handle;
/**
 设置PIN码功能
 @param peripheral 蓝牙句柄
 @param enable 是否开启PIN码功能
 @param timeout 超时时间（单位秒)
 @param handle 回调
 */
- (void)bleNox:(CBPeripheral *)peripheral configurePINWithEnable:(UInt8)enable timeout:(CGFloat)timeout completion:(SLPTransforCallback)handle;
@end
