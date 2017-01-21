#import "ChRegister.h"

#ifndef CHThing_h
#define CHThing_h

typedef void(^ThingResponseCallback)(NSData *_Nullable data, NSError *_Nullable error);

@interface CHThing : NSObject<NSCopying>

/** 6 Byte unqique ID supplied by the Chronicled Beacon */
@property (strong, nonnull) NSString *deviceID;

/**
 * The power in @p dBm at which the beacon transmits
 *
 * @note Ranges from -26dBm (low) to 14dBm (high)
 **/
@property int txPower;

/**
 * The received signal strength indicator (RSSI) of the Thing, in decibels
 * when the device was found
 *
 * @note The value of this property will vary due to RF interference.
 */
@property int foundRSSI;

@property (strong, nonnull) NSUUID * peripheralUUID;

/**
 * Used to create instances of Chronicled Beacons (Things)
 *
 * @param deviceID Unique 6 Byte identifier of the Chronicled Beacon
 * @param foundRSSI The RSSI value at the time the Beacon was first ranged
 * @param txPower The configured power of the Chronicled Beacon
 */
- (instancetype __nonnull)initWithDeviceID:(NSString * __nonnull)deviceID
                                 foundRSSI:(double)rssi
                            peripheralUUID:(NSUUID * __nonnull)peripheralUUID
                                andTxPower:(int)tx;

/**
 * Used to read data from Chronicled Beacons
 *
 * @code
 *  //...
 *  - (void) foundThing(CHThing* thing)
 *  {
 *    [thing read: CHRegister.publicKey cb:^(NSData *response, NSError *error) {
 *      if (error == nil) {
 *        //handle error
 *      }
 *      NSLog(@"%@", response);
 *    }]
 *  }
 *  //...
 * @endcode
 *
 * @note CHRegister has predefined registers available to use. If a register isn't present,
 *       you may create one: [[CHRegister alloc] initWithService:<CBUUID> andCharacteristic:<CBUUID>]
 */
- (void)read:(CHRegister *__nonnull)reg
          cb:(_Nonnull ThingResponseCallback)cb;

/**
 * Used to write data from Chronicled Beacons
 *
 * @code
 *  //...
 *  - (void) foundThing(CHThing* thing)
 *  {
 *    [thing write: CHRegister.writable 
 *             data:NSData() 
 *               cb:^(NSData *response, NSError *error) {
 *
 *      if (error == nil) {
 *        //handle error
 *      }
 *      NSLog(@"%@", response);
 *    }]
 *  }
 *  //...
 * @endcode
 *
 * @note CHRegister has predefined registers available to use. If a register isn't present,
 *       you may create one: [[CHRegister alloc] initWithService:<CBUUID> andCharacteristic:<CBUUID>]
 */
- (void)write:(CHRegister * __nonnull)reg
  dataToWrite:(NSData * __nonnull)data
           cb:(_Nonnull ThingResponseCallback)cb;
@end

#endif /* CHThing_h */
