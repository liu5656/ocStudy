//
//  CentralManager.m
//  BLE4.0Demo
//
//  Created by 刘健 on 16/6/30.
//  Copyright © 2016年 刘健. All rights reserved.
//

#import "CentralManager.h"
#import "CustomPeripheral.h"
//#import <CoreBluetooth/CoreBluetooth.h>

#import "AppDelegate.h"



#define BluetoothError_Off 800
#define BluetoothError_Unauthorize 801

#define BLEConnectStateNotification @"BLEConnectStateNotification"
#define BLEStateChangeNotification @"BLEStateChangeNotification"


@interface CentralManager()<CBCentralManagerDelegate>



@property (nonatomic, copy) CentralScanPeripheralCompletion scanCompletion;
@property (nonatomic, copy) unwrapPeripheralCompletion unwrapCompletion;

@property (nonatomic, copy) connectPeripheralCompletion connectCompletion;

@property (nonatomic, strong) CBService *server;

@property (nonatomic, strong) CustomPeripheral *tempPeripheral;

@property (nonatomic, copy) autoConnetStatus autoConnetStatusCallback;

@end

@implementation CentralManager

+ (instancetype)sharedInstance {
    static CentralManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CentralManager alloc] init];
        sharedInstance.centralManager = [[CBCentralManager alloc] initWithDelegate:sharedInstance queue:nil options:@{CBCentralManagerOptionRestoreIdentifierKey:@"centralManagerIdentify"}];
    });
    return sharedInstance;
}

// 扫描
- (void)scanPeripheralsByServices:(NSArray<CBUUID *> *)serviceUUIDs options:(NSDictionary *)options completion:(CentralScanPeripheralCompletion)scanCompletion
{
    _scanCompletion = scanCompletion;
    if (self.centralManager.state != CBCentralManagerStatePoweredOn) {
        NSError *error = [[NSError alloc] initWithDomain:@"请打开蓝牙" code:BluetoothError_Off userInfo:nil];
        scanCompletion(nil, error);
        return;
    }
    [self.centralManager scanForPeripheralsWithServices:serviceUUIDs options:options];
    
}

- (void)stopScan
{
    [self.centralManager stopScan];
}


#pragma mark auto connect ble part
// 自动搜索
- (void)autoConnectCurrentBindPreipheral:(autoConnetStatus)autoConnetStatusCallback {
    __weak typeof(self) weakSelf = self;
    [self scanPeripheralsByServices:@[[CBUUID UUIDWithString:@"FFF0"]] options:nil completion:^(CustomPeripheral *peripheral, NSError *error) {
        NSLog(@" scaned peripheral :%@", peripheral);
        if (error) {
            if (800 == error.code) {
                //                [wekSelf showHint:@"请打开蓝牙"];
            }
            autoConnetStatusCallback(nil, BLEConnectStatusFailed);
        }else if ([peripheral.name isEqualToString:@"dudu-DB"]){
            autoConnetStatusCallback(peripheral, BLEConnectStatusConnecting);
            weakSelf.autoConnetStatusCallback = autoConnetStatusCallback;
            
            weakSelf.tempPeripheral = peripheral;
            [weakSelf stopScan];
            [weakSelf autoConnectPeripheral:peripheral];
            
        }
    }];
}

// 自动连接
- (void)autoConnectPeripheral:(CustomPeripheral *)peripheral {
    __weak typeof(self) weakSelf = self;
    [self connectPeripheralByCustomPreipheral:peripheral whichServer:[CBUUID UUIDWithString:ServerUUID] whichCharacteristic:[CBUUID UUIDWithString:HandleCharacteristicUUID] option:nil completion:^(CustomPeripheral *peripheral, CBService *server, NSError *error) {
        
        if (!error) {
//            NSLog(@" connected peripheral successful:%@", peripheral);
            weakSelf.autoConnetStatusCallback(peripheral, BLEConnectStatusSuccessful);
        }else{
//            NSLog(@" connected peripheral failure:%@", peripheral);
            weakSelf.autoConnetStatusCallback(nil, BLEConnectStatusFailed);
        }
        weakSelf.tempPeripheral = nil;
        weakSelf.autoConnetStatusCallback = NULL;
    }];
}

// 手动连接
- (void)connectPeripheralByCustomPreipheral:(CustomPeripheral *)peripheral
                                whichServer:(CBUUID *)serverUUID
                        whichCharacteristic:(CBUUID *)characteristicUUID
                                     option:(NSDictionary *)options
                                 completion:(connectPeripheralCompletion)connectCompletion
{
    _connectCompletion = connectCompletion;
    [self.centralManager connectPeripheral:peripheral.peripheral options:options];
}

- (void)unwrapTheCurrentConnectionCompletion:(unwrapPeripheralCompletion)completion
{
    if (self.currentConnectedPeripheral.peripheral) {
        _unwrapCompletion = completion;
        [self.centralManager cancelPeripheralConnection:self.currentConnectedPeripheral.peripheral];
    }else if (_unwrapCompletion) {
        _unwrapCompletion(nil,nil); // 解绑成功
    }
}


#pragma mark cbcentralmanager delegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    
    switch (central.state) {
        case CBCentralManagerStateUnknown:
            NSLog(@"CBCentralManagerStateUnknown");
            break;
        case CBCentralManagerStateResetting:
            NSLog(@"CBCentralManagerStateResetting");
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@"CBCentralManagerStateUnsupported");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@"CBCentralManagerStateUnauthorized");
            break;
        case CBCentralManagerStatePoweredOff:
            NSLog(@"蓝牙关闭状态--- CBCentralManagerStatePoweredOff");
            break;
        case CBCentralManagerStatePoweredOn:
            NSLog(@"开始扫描---CBCentralManagerStatePoweredOn");
        {
            NSArray *array = @[[CBUUID UUIDWithString:@"FFF0"]];
            [self scanPeripheralsByServices:array options:nil completion:_scanCompletion];
        }
            break;
            
        default:
            break;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:BLEStateChangeNotification object:@(central.state) userInfo:nil];
}

#pragma mark CBCentralManagerDelegate
// scan scope
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSString *name = [advertisementData valueForKey:@"kCBAdvDataLocalName"];
    if (![name hasPrefix:@"dudu"]) {
        return;
    }
//    NSString *mac = [[NSString alloc] initWithUTF8String:CFStringGetCStringPtr(CFUUIDCreateString(NULL, [peripheral UUID]), 0)]
    
    CustomPeripheral *customPeripheral = [[CustomPeripheral alloc] init];
    customPeripheral.name = name;
    customPeripheral.peripheral = peripheral;
    customPeripheral.RSSI = RSSI;
    customPeripheral.advertisementData = advertisementData;
    
    if (!_scanCompletion) {
        return;
    }else{
        _scanCompletion(customPeripheral, nil);
    }
}

// connect scope
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    _isConnected = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:BLEConnectStateNotification object:@(1) userInfo:nil];
    self.currentConnectedPeripheral = [[CustomPeripheral alloc] init];
    self.currentConnectedPeripheral.name = [peripheral.name stringByReplacingOccurrencesOfString:@"Leadrive" withString:@"dudu"];
    self.currentConnectedPeripheral.peripheral = peripheral;
    
//    _connectConpletion(self.currentConnectedPeripheral, nil, nil);
    __weak typeof(self) weakSelf = self;
    [weakSelf.currentConnectedPeripheral discoverService:ServerUUID completion:^(NSError *error, CBService *server) {
        if (!error) {
            [weakSelf.currentConnectedPeripheral discoverCharacteristics:HandleCharacteristicUUID forService:server completion:^(NSError *error, CBCharacteristic *characteristic) {
                if (!error) {
                    [weakSelf.currentConnectedPeripheral.peripheral setNotifyValue:YES forCharacteristic:characteristic];
                    weakSelf.connectCompletion(weakSelf.currentConnectedPeripheral, nil, nil);
                    NSLog(@"订阅特征完成");
                    
                }
            }];
        }
    }];
    
    // 连接蓝牙后设置屏幕常亮
    if (![UIApplication sharedApplication].idleTimerDisabled) {
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    _isConnected = NO;
    NSLog(@"did fail to connect peripheral:%@",error.localizedDescription);
    _connectCompletion(nil, nil, error);
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    _isConnected = NO;
    NSLog(@"已经断开连接,开始尝试恢复连接:did disconnect peripheral :%@",error.description);
    if (error) {
        [self.centralManager connectPeripheral:self.currentConnectedPeripheral.peripheral options:nil];
    }else{
        if (_unwrapCompletion){
            _unwrapCompletion(nil,nil); // 解绑成功
        }
    }
    // 断开蓝牙连接后恢复屏幕设置
    [[UIApplication sharedApplication] setIdleTimerDisabled:[[NSUserDefaults standardUserDefaults] boolForKey:@"screenAlwaysOn"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:BLEConnectStateNotification object:@(0) userInfo:nil];
}

    // reconnect scope
- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *,id> *)dict
{
    NSLog(@"will restore state:%@",dict);
}



@end
