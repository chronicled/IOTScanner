#import <Foundation/Foundation.h>
#import "CHRegister.h"
#import "CHThing.h"

/**
 * @p Interaction 's are used when you want to @p read or @p write to a Chronicled Beacon.
 * An Interaction is queued in CHScanner and will occur after the IOTScanner library is
 * able to connect to the CBPeripheral.
 */
@protocol CHInteraction <NSObject>

@required

/** The interaction will occur on this Register */
@property (nonatomic, retain) CHRegister * reg;

/** The interaction will be performed on the peripheral matching this NSUUID */
@property (nonatomic, retain) NSUUID * peripheralUUID;

/**
 * This will be fired when the data has been read or written to the Chronicled Beacon.
 * If an error occured, the @p data argument will be null and @p error will contain
 * the relavant @p NSError
 *
 * @note the data read from the @p CBCharacteristic can potentially be @p nil. Be sure
 * to check if @p error is nil.
 */
@property (nonatomic, copy) ThingResponseCallback callback;

@optional

/** This data will be written to the Register during a write Interaction */
@property (nonatomic, retain) NSData * dataToWrite;

@end
