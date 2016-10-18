#ifndef ChInteractions_h
#define ChInteractions_h

#import "foundation/foundation.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface CHRegister : NSObject

@property(strong, nonnull) CBUUID* serviceUUID;
@property(strong, nonnull) CBUUID* characteristicUUID;

+ (instancetype __nonnull) publicKey;
+ (instancetype __nonnull) lockState;

@end

#endif /* ChInteractions_h */
