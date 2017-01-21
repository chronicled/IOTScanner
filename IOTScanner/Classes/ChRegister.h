#ifndef ChInteractions_h
#define ChInteractions_h

#import "foundation/foundation.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface CHRegister : NSObject

@property(strong, nonnull) CBUUID* serviceUUID;
@property(strong, nonnull) CBUUID* characteristicUUID;

+ (CHRegister * _Nonnull) publicKey;
+ (CHRegister * _Nonnull) lockState;

@end

#endif /* ChInteractions_h */
