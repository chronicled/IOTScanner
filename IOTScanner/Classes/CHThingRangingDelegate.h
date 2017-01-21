#import <Foundation/Foundation.h>
#import "CHThing.h"

/**
 * The delegate of `IOTRangingDelegate` uses this protocol's methods to monitor
 * the discovery and loss of Chronicled beacons.
 * 
 * @code
 *  // interface
 *  @interface Controller: ViewController <IOTRangingDelegate>
 *
 *  // implementation
 *  @implementation ThingsTableViewController
 *  - (void)foundThing(CHThing *)thing
 *  {
 *      NSLog(@"%@", thing);
 *  }
 *  - (void)lostThing(CHThing *)thing
 *  {
 *      NSLog(@"%@", thing);
 *  }
 *
 * @endcode
 */
@protocol CHThingRangingDelegate <NSObject>

/**
 * Will be called when a Chronicled Beacon comes in range
 *
 * @param thing: An immutable representation of a `Thing` as it was found.
 */
- (void)foundThing:(CHThing * __nonnull)thing;

/**
 * Will be called when a Chronicled Beacon is no longer in range
 *  
 * @param thing: An immutable representation of a `Thing`
 */
- (void)lostThing:(CHThing * __nonnull)thing;
@end
