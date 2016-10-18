#import <Foundation/Foundation.h>

#ifndef CHBeaconScanner_h
#define CHBeaconScanner_h

@interface ChBeaconReader : NSObject
+ (NSDictionary * _Nullable) getBeaconDataFrom:(NSDictionary * _Nullable)advertisementData;
@end


#endif /* CHBeaconScanner_h */
