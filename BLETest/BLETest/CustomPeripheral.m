//
//  CustomPreipheral.m
//  BLE4.0Demo
//
//  Created by 刘健 on 16/6/30.
//  Copyright © 2016年 刘健. All rights reserved.
//

#import "CustomPeripheral.h"
#import <CoreBluetooth/CoreBluetooth.h>


@interface CustomPeripheral()<CBPeripheralDelegate>

@property (nonatomic, copy) characteristicValueChangeBlock lastChangeBlock;
@property (nonatomic, copy) characteristicValueChangeBlock handleValueChangeBlock;

@property (nonatomic, copy) discoverServerCompletion serverCompletion;
@property (nonatomic, copy) discoverCharacteristicCompletion characteristicCompletion;
@property (nonatomic, copy) getDeviceInfoCallback deviceInfoCallback; // 获取mac地址回调
@property (nonatomic, copy) getBatteryPowerCallback batteryPowerCallback; // 获取电量回调

@property (nonatomic, strong) CBCharacteristic *handleCharacteristic;



@end

@implementation CustomPeripheral


- (void)discoverService:(NSString *)serverUUIDString completion:(discoverServerCompletion)completion
{
    self.peripheral.delegate = self;
    
   if ([serverUUIDString isEqualToString:ServerUUID]) {
        _serverCompletion = completion;
       [self.peripheral discoverServices:@[[CBUUID UUIDWithString:ServerUUID]]];
   }else if ([serverUUIDString isEqualToString:DeviceInfomation]) {
       [self.peripheral discoverServices:nil];
   }
}

- (void)discoverCharacteristics:(NSString *)characteristicUUIDString forService:(CBService *)service completion:(discoverCharacteristicCompletion)completion
{
    self.peripheral.delegate = self;
    if ([characteristicUUIDString isEqualToString:HandleCharacteristicUUID]) {
        [self.peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:characteristicUUIDString]] forService:service];
        _characteristicCompletion = completion;
    }else{
        [self.peripheral discoverCharacteristics:nil forService:service];
    }
}

// notify
- (void)observerCharacteristicUUID:(NSString *)characteristicUUIDString whileValueChangedBlock:(characteristicValueChangeBlock)valueChangeBlock
{
    if ([characteristicUUIDString isEqualToString:HandleCharacteristicUUID]) {
        _lastChangeBlock = _handleValueChangeBlock;
        _handleValueChangeBlock = valueChangeBlock;
    }
}

- (BOOL)recoveryFromLastCharacteristicObserver {
    if (_lastChangeBlock) {
        _handleValueChangeBlock = _lastChangeBlock;
        _lastChangeBlock = NULL;
        return YES;
    }else{
        return NO;
    }
}

#pragma mark CBPeripheralDelegate
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    
    for (CBService *service in peripheral.services) {
        if ([service.UUID.description isEqualToString:ServerUUID]) {
            _serverCompletion(error, service);
        }else if ([service.UUID.description isEqualToString:DeviceInfomation]) {
            [self discoverCharacteristics:nil forService:service completion:nil];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if ([service.UUID.description isEqualToString:ServerUUID]) {
        self.handleCharacteristic = service.characteristics.firstObject;
        _characteristicCompletion(error, service.characteristics.firstObject);
    }else if ([service.UUID.description isEqualToString:DeviceInfomation]) {
        for (CBCharacteristic *characteristic in service.characteristics) {
            [self.peripheral readValueForCharacteristic:characteristic];
//            NSLog(@"begin read characteristic:%@",characteristic.UUID.description);
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSString *characteristicUUIDStr = characteristic.UUID.description;
    
    
    NSLog(@"收到遥控器的回复:%@---%@--%@",characteristic.value, [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding], characteristic.UUID.description);
    
    
    if ([characteristicUUIDStr isEqualToString:HandleCharacteristicUUID]) {
        NSData *data = characteristic.value;
        NSString *value4 = [self hexStringFromData:data];
        NSInteger num = value4.integerValue;
        bluetoothButtonType type = bluetoothButtonTypeUnknown;
        switch (num) {
            case bluetoothButtonTypeSingleUp:
            case bluetoothButtonTypeSingleDown:
            case bluetoothButtonTypeSingleLeft:
            case bluetoothButtonTypeSingleRight:
            case bluetoothButtonTypeSingleOK:
                type = num;
                break;
                
            case bluetoothButtonTypeLongPressUp:
            case bluetoothButtonTypeLongPressDown:
            case bluetoothButtonTypeLongPressLeft:
            case bluetoothButtonTypeLongPressRight:
                type = num;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"IndexSwitchNoti" object:@(type)];
                return;
                
            case bluetoothButtonTypeLongPressOKStart:
                if (!self.robotAudio) {
                }
                type = num;
                break;
            case bluetoothButtonTypeLongPressOKStop:
                if (!self.robotAudio) {
                }
                type = num;
                break;
            default:
                if(_batteryPowerCallback){
                    NSString *newValue = [NSString stringWithFormat:@"%ld",strtoul([value4 UTF8String], 0, 16)];
                    int powerInt = newValue.intValue - 96;
                    NSString *powerStr = [NSString stringWithFormat:@"%d%%",powerInt];
                    _batteryPowerCallback(powerStr);
                }
                
                break;
        }
        if (!_handleValueChangeBlock) {
            return;
        }
        _handleValueChangeBlock(error, type, characteristic);
    }else if ([characteristicUUIDStr isEqualToString:HardwareRevisionString] ||   // 硬件版本
              //              [characteristicUUIDStr isEqualToString:SoftwareRevisionString] ||   // 软件版本
              [characteristicUUIDStr isEqualToString:SystemID]) {   // 串码
        
        NSString *value = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
        //        if ([characteristicUUIDStr isEqualToString:SoftwareRevisionString]) {
        //            self.softwareVersion = value;
        //        }else
        if ([characteristicUUIDStr isEqualToString:HardwareRevisionString]) {
            self.hardwareVersion = value;
        }else if ([characteristicUUIDStr isEqualToString:SystemID]) {
            
            NSString *systemid = [self dataTransfromBigOrSmall:characteristic.value];
            self.systemid = systemid;
        }
        if (self.hardwareVersion.length && self.systemid.length) {
            //        if (self.softwareVersion.length && self.hardwareVersion.length && self.serialNumber.length) {
            //            NSDictionary *deviceInfo = [NSDictionary dictionaryWithObjectsAndKeys:self.hardwareVersion, @"固件版本号", self.softwareVersion, @"软件版本号", self.serialNumber, @"序列号", nil];
            NSDictionary *deviceInfo = [NSDictionary dictionaryWithObjectsAndKeys:self.hardwareVersion, @"softVersion", self.systemid, @"systemid", nil];
            _deviceInfoCallback(deviceInfo);
        }
    }
}

- (NSString *)dataTransfromBigOrSmall:(NSData *)data{
    NSString *tmpStr = [self hexStringFromData:data];
    NSMutableString *result = [NSMutableString string];
    for (int i = 0 ;i<tmpStr.length ;i+=2) {
        NSString *temp = [tmpStr substringWithRange:NSMakeRange(i, 2)];
        [result insertString:temp atIndex:0];
    }
    return [result stringByReplacingOccurrencesOfString:@"0000" withString:@""];
}


- (NSString *)hexStringFromData:(NSData*)data{
    return [[[[NSString stringWithFormat:@"%@",data]
              stringByReplacingOccurrencesOfString: @"<" withString: @""]
             stringByReplacingOccurrencesOfString: @">" withString: @""]
            stringByReplacingOccurrencesOfString: @" " withString: @""];
}

#pragma mark 遥控器控制对讲
- (void)sendAudioDataRecodingData:(NSData *)data andTime:(NSInteger)time
{
    
}

- (NSNumber *)addNewMessageWithAudioData:(NSData *)newData andIsSelf:(BOOL)isSelf andOtherInfo:(NSDictionary *)info
{
        return @(1);
}

#pragma mark 设备信息
- (void)getDeviceInfomationCompletion:(getDeviceInfoCallback)deviceInfoCallback
{
    
    if (deviceInfoCallback) {
        _deviceInfoCallback = deviceInfoCallback;
    }else{
        return;
    }
    [self discoverService:DeviceInfomation completion:nil];
}

#pragma mark 获取电量
- (void)getBatteryPowerCompletion:(getBatteryPowerCallback)batteryPowerCallback
{
    Byte xx = 0xcc;
    NSData *data = [NSData dataWithBytes:&xx length:sizeof(xx)];
    [self.peripheral writeValue:data forCharacteristic:self.handleCharacteristic type:CBCharacteristicWriteWithResponse];
    self.batteryPowerCallback = batteryPowerCallback;
}

#pragma mark get
- (NSString *)name
{
    if (!_name.length) {
        return @"";
    }
    return _name;
}

@end
