#import <Foundation/Foundation.h>
#import "CHScanner.h"
#import "CHThingRangingDelegate.h"
#import "CHBeaconReader.h"
#import "CHReadCache.h"
#import "CHReadInteraction.h"
#import "CHWriteInteraction.h"
#import "CHInteraction.h"
#import "IOTScannerError.h"

static NSString *serviceUUID = @"FEAA";
static NSDictionary *options = nil;
static const int advertisementInterval = 5;
static const int intervalsBeforeRemoval = 12;

static NSString* const txPowerKey = @"txPower";
static NSString* const deviceIDKey = @"deviceID";

@implementation CHScanner

@synthesize isScanning;
@synthesize shouldStartScanning;

+ (CHScanner *)sharedInstance {
    static CHScanner *sharedScanner = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedScanner = [[self alloc] init];
    });

    return sharedScanner;
}

- (instancetype)init;
{
    self = [super init];

    if (self) {
        _foundThings = [[NSMutableDictionary alloc] init];
        _foundThingsLock = [[NSLock alloc] init];
        _foundPeripherals = [[NSMutableArray alloc] init];
        _currentInteractions = [[NSMutableDictionary alloc] init];

        dispatch_queue_t concurrent;
        concurrent = dispatch_queue_create("bluetooth", DISPATCH_QUEUE_CONCURRENT);

        options = @{CBCentralManagerScanOptionAllowDuplicatesKey: [NSNumber numberWithBool:YES]};

        _centralManager = [[CBCentralManager alloc] initWithDelegate:self
                                                               queue:concurrent];
    }

    return self;
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state == CBCentralManagerStatePoweredOn && shouldStartScanning) {
        _centralManager = central;
        [self scanForPeripherals];
        shouldStartScanning = false;
    }
}

- (void)checkIfItemShouldBeRemoved
{
    NSDate *now = [[NSDate alloc] init];
    double timeUntilOutOfRange = advertisementInterval * intervalsBeforeRemoval;

    [_foundThings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        CHThing *thing = key;
        NSDate *date = obj;

        double diff = [now timeIntervalSinceDate:date];

        if (_rangingDelegate != nil) {
            if (diff > timeUntilOutOfRange) {
                [_foundThings removeObjectForKey:thing];
            }
        }
    }];
}

- (void) addInteraction:(NSObject<CHInteraction> * __nonnull)interaction
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSUUID *identifier = interaction.peripheralUUID;
        NSArray *identifiers = @[identifier];

        NSArray *peripherals = [self.centralManager retrievePeripheralsWithIdentifiers:identifiers];

        if ([peripherals count] > 0) {
            CBPeripheral *peripheral = [peripherals firstObject];
            [self.centralManager connectPeripheral:peripheral options:nil];
        }

        @synchronized (_currentInteractions) {
            [_currentInteractions setObject:interaction forKey:identifier];
        }
    });
}

- (void)startScanning
{
    if (!isScanning) {
        if (self.centralManager.state != CBCentralManagerStatePoweredOn) {
            self->shouldStartScanning = true;
            return;
        }

        [self scanForPeripherals];
    }
}

- (void)stopScanning
{
    if (isScanning) {
        [self.centralManager stopScan];
        [_foundThings removeAllObjects];
        isScanning = false;

    }
}

- (void)scanForPeripherals
{
    isScanning = true;
    [self.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:serviceUUID]]
                                                options:options];
}

- (NSObject<CHInteraction> * _Nullable) interactionFor:(CBPeripheral * __nonnull) peripheral
{
    return [_currentInteractions objectForKey:peripheral.identifier];
}

#pragma MARK BLE Success / Failure Callbacks
- (void) interactionSuccessful:(NSData * __nonnull)data
                      for:(CBPeripheral * __nonnull)peripheral
{
    CHReadInteraction *interaction = (CHReadInteraction *)[self interactionFor:peripheral];

    if (interaction) {
        interaction.callback(data, nil);

        @synchronized (_currentInteractions) {
            [_currentInteractions removeObjectForKey:peripheral.identifier];
        }
    }
}

- (void) interactionFailedWith:(NSError * __nullable)error
                       for:(CBPeripheral * __nonnull)peripheral
{
    NSObject<CHInteraction> * interaction = [self interactionFor:peripheral];

    if (interaction) {
        interaction.callback(nil, error);

        @synchronized (_currentInteractions) {
            [_currentInteractions removeObjectForKey:peripheral.identifier];
        }
    }
}


#pragma MARK CBCentralManagerDelegate

- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSDictionary *properties = [ChBeaconReader getBeaconDataFrom:advertisementData];

        if ([properties count] == 2) {
            peripheral.delegate = self;

            [_foundPeripherals addObject:peripheral];

            CHThing *foundThing = [[CHThing alloc ] initWithDeviceID:[properties valueForKey:deviceIDKey]
                                                           foundRSSI:[RSSI doubleValue]
                                                      peripheralUUID:peripheral.identifier
                                                          andTxPower:(int)[properties valueForKey:txPowerKey]];

            if (_outOfRangeTimer == nil) {
                _outOfRangeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                                    target:self
                                                                  selector:@selector(checkIfItemShouldBeRemoved)
                                                                  userInfo:nil
                                                                   repeats:YES];
            }

            [self.foundThingsLock lock];

            if (![[_foundThings allKeys] containsObject:foundThing]) {
                if (_rangingDelegate != nil) {
                    [_rangingDelegate foundThing:foundThing];
                }
            }

            [_foundThings setObject:[[NSDate alloc] init] forKey: foundThing];

            [self.foundThingsLock unlock];
        }
    });
}

- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSObject<CHInteraction> *interaction = [self interactionFor:peripheral];

        if (!interaction) {
            return;
        }

        [peripheral discoverServices:@[interaction.reg.serviceUUID]];
    });
}

- (void) centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSObject<CHInteraction> *interaction = [self interactionFor:peripheral];

        if (!interaction) {
            return;
        }

        [self interactionFailedWith:[IOTScannerError connecting] for:peripheral];
        return;
    });
}

#pragma MARK CBPeripheralDelegate

- (void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSObject<CHInteraction> *interaction = [self interactionFor:peripheral];

        if (!interaction) { return; } // no interaction found for peripheral

        CBService *service = [self retrieve:interaction.reg.serviceUUID
                               fromServices:peripheral.services];

        if (!service) {
            [self interactionFailedWith:[IOTScannerError discoveringServices] for:peripheral];
            return;
        }

        [peripheral discoverCharacteristics:@[interaction.reg.characteristicUUID]
                                 forService:service];

    });
}

- (void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSObject<CHInteraction> *interaction = [self interactionFor:peripheral];

        if (!interaction) { return; } // no interaction found for peripheral

        CBCharacteristic *charecteristic = [self retrieve:interaction.reg.characteristicUUID
                                                fromChars:service.characteristics];

        if (!charecteristic || error) {
            [self interactionFailedWith:[IOTScannerError discoveringCharacteristics] for:peripheral];
            return;
        }

        if ([interaction isKindOfClass:[CHReadInteraction class]]) {
            [peripheral readValueForCharacteristic:charecteristic];
            return;
        } else if ([interaction isKindOfClass:[CHWriteInteraction class]]){
            [peripheral writeValue:interaction.dataToWrite
                 forCharacteristic:charecteristic
                              type:CBCharacteristicWriteWithResponse];
            return;
        } else {
            [self interactionFailedWith:[IOTScannerError unsupportedInteraction] for:peripheral];
            return;
        }
    });
}

- (void) peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        if (error) {
            [self interactionFailedWith:[IOTScannerError writingToBeacon] for:peripheral];
            return;
        }

        [self interactionSuccessful:characteristic.value for:peripheral];
    });
}

- (void) peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        if (error) {
            [self interactionFailedWith:[IOTScannerError readingFromBeacon] for:peripheral];
            return;
        }

        [self interactionSuccessful:characteristic.value for:peripheral];
    });
}

# pragma MARK Help

- (CBCharacteristic * __nullable) retrieve:(CBUUID * __nonnull)uuid fromChars:(NSArray<CBCharacteristic *> *)chars
{
    if ([chars count] == 0) {
        return nil;
    }

    NSArray *filteredArray = [chars filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(CBCharacteristic* object, NSDictionary *bindings) {
        return [uuid.UUIDString isEqualToString:object.UUID.UUIDString];
    }]];

    return [filteredArray firstObject];
}

- (CBService * __nullable) retrieve:(CBUUID * __nonnull)uuid fromServices:(NSArray<CBService *> *)services
{
    if ([services count] == 0) {
        return nil;
    }
    
    NSArray *filteredArray = [services filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(CBService* object, NSDictionary *bindings) {
        return [uuid.UUIDString isEqualToString:object.UUID.UUIDString];
    }]];
    
    return [filteredArray firstObject];
}

@end
