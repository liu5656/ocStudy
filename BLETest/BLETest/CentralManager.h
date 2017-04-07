//
//  CentralManager.h
//  BLE4.0Demo
//
//  Created by 刘健 on 16/6/30.
//  Copyright © 2016年 刘健. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@class CBPeripheral;
@class CBUUID;
@class CustomPeripheral;
@class CBService;

typedef enum : NSUInteger {
    BLEConnectStatusScaning,
    BLEConnectStatusConnecting,
    BLEConnectStatusSuccessful,
    BLEConnectStatusFailed,
} BLEConnectStatus;


typedef void(^CentralScanPeripheralCompletion)(CustomPeripheral *peripheral, NSError *error);
typedef void(^unwrapPeripheralCompletion)(CustomPeripheral *peripheral, NSError *error);
typedef void(^connectPeripheralCompletion)(CustomPeripheral *peripheral, CBService *server, NSError *error);
typedef void (^autoConnetStatus)(CustomPeripheral *peripheral, BLEConnectStatus status);


@interface CentralManager : NSObject
@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CustomPeripheral *currentConnectedPeripheral;
@property (nonatomic, assign) BOOL isConnected;

+ (instancetype)sharedInstance;


- (void)scanPeripheralsByServices:(NSArray<CBUUID *> *)serviceUUIDs options:(NSDictionary *)options completion:(CentralScanPeripheralCompletion)scanCompletion;
- (void)stopScan;

- (void)unwrapTheCurrentConnectionCompletion:(unwrapPeripheralCompletion)completion;
- (void)connectPeripheralByCustomPreipheral:(CustomPeripheral *)peripheral whichServer:(CBUUID *)serverUUID whichCharacteristic:(CBUUID *)characteristicUUID option:(NSDictionary *)options completion:(connectPeripheralCompletion)connectCompletion;
- (void)autoConnectCurrentBindPreipheral:(autoConnetStatus)autoConnetStatusCallback;

@end
