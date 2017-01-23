#ifndef CHScanner_h
#define CHScanner_h

#import <CoreBluetooth/CoreBluetooth.h>
#import "CHThingRangingDelegate.h"
#import "CHInteraction.h"

/**
 * CHScanner is used to find Chronicled Beacons (CHThings)
 *  @code
 *    [CHScanner sharedInstance].rangingDelegate = self;
 *    [[CHScanner sharedInstance] startScanning];
 *    [[CHScanner sharedInstance] stopScanning];
 *  @endcode
 */
@interface CHScanner : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>
{
@private BOOL shouldStartScanning;
}

/**
 * The singleton instance of the CHScanner. All Chronicled Beacon interactions occur
 * using this instance.
 */
+ (CHScanner * __nonnull)sharedInstance;

- (instancetype __nonnull) init __attribute__((unavailable("use sharedInstance()")));

/**
 * Adds an interaction to the internal interaction queue of the CHScanner. When the corresponding
 * Chronicled Beacon is found again, the added interaction will be performed
 */
- (void) addInteraction:(NSObject<CHInteraction> * __nonnull)interaction;

/**
 * Start scanning for Chronicled Beacons.
 *
 * @code
 *   [[CHScanner sharedInstance] startScanning]
 * @endcode
 * 
 * @note When a beacon is found, @a foundThing will be called
 * with a CHThing as its argument. If that Beacon is not found again with 1 minute, 
 * @a thingOutOfRange will be called on the delegate
 */
- (void)startScanning;

/**
 * Stop scanning for Chronicled Beacons
 *
 * @note @p stopScanning will remove the current found things from the CHScanner
 *
 * @code
 *   [[CHScanner sharedInstance] stopScanning];
 * @endcode
 */
- (void)stopScanning;

/** whether or not IOTScanner is currently scanning for Chronicled Beacons */
@property (nonatomic) BOOL isScanning;

/** the currently assigned ranging delegate */
@property (nonatomic) NSObject<CHThingRangingDelegate> * __nonnull rangingDelegate;

@property (strong, nonatomic, readonly) CBCentralManager * _Nonnull centralManager;

@property (strong, atomic) NSMutableDictionary * _Nonnull foundThings;
@property (strong, atomic) NSLock * _Nonnull foundThingsLock;
@property (nonatomic) NSTimer * _Nonnull outOfRangeTimer;

@property (nonatomic, strong) NSMutableArray * _Nonnull foundPeripherals;
@property (nonatomic) BOOL shouldStartScanning;
@property (nonatomic) NSMutableDictionary * _Nonnull currentInteractions;

@end

#endif /* CHScanner_h */
