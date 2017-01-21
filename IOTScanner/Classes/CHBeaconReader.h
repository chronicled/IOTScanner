#import <Foundation/Foundation.h>

#ifndef CHBeaconScanner_h
#define CHBeaconScanner_h

@interface ChBeaconReader : NSObject

/**
 * Parse advertisement data provided by the BLE beacon and retrieve the beacon's Device 
 * ID and Transmission Power
 *
 * @return A @a Nullable Dictionary containing the @b Device @b ID and @b Transmission 
 * @b Power
 *
 * @attention The return value is @p Nullable. If Null is returned, the beacon's 
 * advertisement does not conform to Chronicled's BLE Scan Response protocol
 */
+ (NSDictionary * _Nullable) getBeaconDataFrom:(NSDictionary * _Nullable)advertisementData;
@end


#endif /* CHBeaconScanner_h */
