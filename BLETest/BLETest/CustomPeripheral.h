//
//  CustomPreipheral.h
//  BLE4.0Demo
//
//  Created by 刘健 on 16/6/30.
//  Copyright © 2016年 刘健. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ServerUUID @"FFF0" // 按键服务
#define HandleCharacteristicUUID @"FFF1"

#define DeviceInfomation @"Device Information" // 设备信息服务
#define SystemID @"System ID"
#define ModelNumberString @"Model Number String"
#define SerialNumberString @"Serial Number String"
#define FirmwareRevisionString @"Firmware Revision String"
#define HardwareRevisionString @"Hardware Revision String"
#define SoftwareRevisionString @"Software Revision String"
#define ManufacturerNameString @"Manufacturer Name String"
#define IEEERegulatoryCertification @"IEEE Regulatory Certification"
#define PnPID @"PnP ID"

@class CBPeripheral;
@class CBUUID;
@class CBService;
@class CBCharacteristic;

typedef NS_ENUM(NSInteger, bluetoothButtonType) {
    bluetoothButtonTypeUnknown = -1,
    bluetoothButtonTypeSingleUp = 11,
    bluetoothButtonTypeSingleDown = 21,
    bluetoothButtonTypeSingleLeft = 31,
    bluetoothButtonTypeSingleRight = 41,
    bluetoothButtonTypeSingleOK = 51,
    
    bluetoothButtonTypeLongPressUp = 13,
    bluetoothButtonTypeLongPressDown = 23,
    bluetoothButtonTypeLongPressLeft = 33,
    bluetoothButtonTypeLongPressRight = 43,
    bluetoothButtonTypeLongPressOKStart = 53,
    bluetoothButtonTypeLongPressOKStop = 54,
    
    bluetoothButtonTypeSingleBack = 91, // 被bluetoothButtonTypeSingleLeft代替
    bluetoothButtonTypeLongPressTalkStart = 430, // 被bluetoothButtonTypeLongPressOKStart代替
    bluetoothButtonTypeLongPressTalkEnd = 440, // 被bluetoothButtonTypeLongPressOKStop代替
    
};

struct Command {
    int index;
    int level;
    struct Command *head;
    struct Command *next;
};

typedef void(^characteristicValueChangeBlock)(NSError *error, bluetoothButtonType type,CBCharacteristic *characteristic);
typedef void(^discoverServerCompletion)(NSError *error, CBService *server);
typedef void(^discoverCharacteristicCompletion)(NSError *error, CBCharacteristic *characteristic);

typedef void (^getDeviceInfoCallback)(NSDictionary *deviceInfo); // 获取设备信息回调
typedef void (^getBatteryPowerCallback)(NSString *power);

@interface CustomPeripheral : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *RSSI;
@property (nonatomic, strong) NSDictionary *advertisementData;
@property (nonatomic, strong) CBPeripheral *peripheral;

@property (nonatomic, copy) NSString *hardwareVersion;
@property (nonatomic, copy) NSString *softwareVersion;
@property (nonatomic, copy) NSString *systemid;

@property (nonatomic, assign) BOOL robotAudio;


// 扫描服务和特征
- (void)discoverService:(NSString *)serverUUIDString completion:(discoverServerCompletion)completion;
- (void)discoverCharacteristics:(NSString *)serverUUIDString forService:(CBService *)service completion:(discoverCharacteristicCompletion)completion;

// 监听
- (void)observerCharacteristicUUID:(NSString *)characteristicUUIDString whileValueChangedBlock:(characteristicValueChangeBlock)valueChangeBlock;

// 遥控器对讲时,语音回调
- (void)sendAudioDataRecodingData:(NSData *)data andTime:(NSInteger)time;
// 获取设备信息
- (void)getDeviceInfomationCompletion:(getDeviceInfoCallback)macAddressCallback;

// 获取电量
- (void)getBatteryPowerCompletion:(getBatteryPowerCallback)batteryPowerCallback;
// 恢复到上一个observer
- (BOOL)recoveryFromLastCharacteristicObserver;

@end
