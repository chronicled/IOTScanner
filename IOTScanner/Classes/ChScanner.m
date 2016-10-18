#import <Foundation/Foundation.h>
#import "CHScanner.h"
#import "CHThingRangingDelegate.h"
#import "CHBeaconReader.h"
#import "CHReadCache.h"

static NSString *serviceUUID = @"FEAA";
static NSDictionary *options = nil;
static const int advertisementInterval = 5;
static const int intervalsBeforeRemoval = 12;

static NSString* const txPowerKey = @"txPower";
static NSString* const deviceIDKey = @"deviceID";

@implementation CHScanner

@synthesize isScanning;
@synthesize shouldStartScanning;

- (instancetype)initWithDelegate:(id<CHThingRangingDelegate> __nonnull)delegate
{
    self = [super init];

    if (self) {
        _foundThings = [[NSMutableDictionary alloc] init];
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
        _rangingDelegate = delegate;

        options = @{CBCentralManagerScanOptionAllowDuplicatesKey: [NSNumber numberWithBool:YES]};
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

- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
    NSDictionary *properties = [ChBeaconReader getBeaconDataFrom:advertisementData];

    if ([properties count] == 2) {
        CHThing *foundThing = [[CHThing alloc ] initWithDeviceID:[properties valueForKey:deviceIDKey]
                                                       foundRSSI:[RSSI doubleValue]
                                                      andTxPower:(int)[properties valueForKey:txPowerKey]];

        if (_outOfRangeTimer == nil) {
            _outOfRangeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                                target:self
                                                              selector:@selector(checkIfItemShouldBeRemoved)
                                                              userInfo:nil
                                                               repeats:YES];
        }

        if (![[_foundThings allKeys] containsObject:foundThing]) {
            [_rangingDelegate foundThing:foundThing];
        }

        [_foundThings setObject:[[NSDate alloc] init] forKey: foundThing];
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

        if (diff > timeUntilOutOfRange) {
            [_foundThings removeObjectForKey:thing];
            [_rangingDelegate thingOutOfRange:thing];
        }
    }];

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

@end