#import <Foundation/Foundation.h>
#import "CHThing.h"
#import "ChReadCache.h"
#import "CHRegister.h"

@implementation CHThing : NSObject

@synthesize deviceID;
@synthesize txPower;
@synthesize foundRSSI;

- (instancetype __nonnull)initWithDeviceID:(NSString *)ID foundRSSI:(double)rssi andTxPower:(int)tx
{
    self = [super init];

    if (self) {
        self.deviceID = ID;
        self.txPower = tx;
        self.foundRSSI = rssi;
    }

    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    CHThing *copy = [[[self class] allocWithZone:zone] init];

    [copy setDeviceID:self.deviceID];
    [copy setTxPower:self.txPower];
    [copy setFoundRSSI:self.foundRSSI];

    return copy;
}

- (BOOL)isEqualToCHThing:(CHThing *)thing
{
    if (!thing) {
        return NO;
    }

    return [self.deviceID isEqualToString:thing.deviceID];
}

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }

    if (![object isKindOfClass:[CHThing class]]) {
        return NO;
    }

    return [self isEqualToCHThing:(CHThing *)object];
}

- (NSUInteger)hash
{
    return [self.deviceID hash];
}

@end
