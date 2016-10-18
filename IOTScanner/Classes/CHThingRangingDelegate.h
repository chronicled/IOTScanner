#import <Foundation/Foundation.h>
#import "CHThing.h"

/*! The delegate of `IOTRangingDelegate` uses this protocol's methods to monitor
    the discovery and loss of Chronicled beacons. */
@protocol CHThingRangingDelegate <NSObject>

/*! Will be called when a `Thing` `Peripheral` comes in range

    @param thing: An immutable representation of a `Thing` as it was
    found. */
- (void)foundThing:(CHThing * __nonnull)thing;

/*! Will be called when a `Thing` `Peripheral` is no longer in range

    @param thing: An immutable representation of a `Thing`*/
- (void)thingOutOfRange:(CHThing * __nonnull)thing;
@end