#ifndef CHThing_h
#define CHThing_h

@interface CHThing : NSObject<NSCopying>

/*! The Unique ID associated with the Chronicled BLE board. */
@property (strong, nonnull) NSString *deviceID;

/*! The power at which the beacon transmits */
@property int txPower;

/*! The received signal strength indicator (RSSI) of the Thing, in decibels
    when the device was found 
 
    @note The value of this property will vary due to RF interference. */
@property int foundRSSI;

- (instancetype __nonnull)initWithDeviceID:(NSString * __nonnull)deviceID
                                 foundRSSI:(double)rssi
                                andTxPower:(int)tx;

@end

#endif /* CHThing_h */