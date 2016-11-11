#ifndef CHScanner_h
#define CHScanner_h

#import <CoreBluetooth/CoreBluetooth.h>
#import "CHThingRangingDelegate.h"

/*! Finds Chronicled BLE Tags
    @code
        CHScanner *scanner = [[CHScanner alloc] initWithDelegate:self];
        [scanner startScanning];
        [scanner stopScanning]
    @endcode
 */
@interface CHScanner : NSObject <CBCentralManagerDelegate>
{
@private BOOL isScanning;
@private BOOL shouldStartScanning;
}

@property (strong, nonatomic, readonly) CBCentralManager *centralManager;
@property (nonatomic) BOOL shouldStartScanning;

/*! @returns whether or not IOTScanner is currently scanning for beacons */
@property (nonatomic) BOOL isScanning;
@property (nonatomic) id<CHThingRangingDelegate> rangingDelegate;
@property (strong, atomic) NSMutableDictionary *foundThings;
@property (strong, atomic) NSLock *foundThingsLock;
@property (nonatomic) NSTimer *outOfRangeTimer;

/*! Creates an instance of an IOTScanner

 */
- (instancetype)initWithDelegate:(id<CHThingRangingDelegate>)delegate;

/*! starts scanning for chronicled BLE tags */
- (void)startScanning;

/*! stops scanning and clears the `foundThings` Dictionary */
- (void)stopScanning;

@end

#endif /* CHScanner_h */
