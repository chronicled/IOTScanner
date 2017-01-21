#import <Foundation/Foundation.h>
#import "CHThing.h"
#import "ChReadCache.h"
#import "CHRegister.h"
#import "CHScanner.h"
#import "CHReadInteraction.h"
#import "CHWriteInteraction.h"

@implementation CHThing : NSObject

@synthesize deviceID;
@synthesize txPower;
@synthesize foundRSSI;
@synthesize peripheralUUID;

- (instancetype __nonnull)initWithDeviceID:(NSString *)ID
                                 foundRSSI:(double)rssi
                            peripheralUUID:(NSUUID *)uuid
                                andTxPower:(int)tx
{
    self = [super init];

    if (self) {
        self.deviceID = ID;
        self.txPower = tx;
        self.foundRSSI = rssi;
        self.peripheralUUID = uuid;
    }

    return self;
}

- (void)read:(CHRegister *__nonnull)reg cb:(_Nonnull ThingResponseCallback)cb
{
    CHReadInteraction *interaction = [[CHReadInteraction alloc] initWithRegister:reg
                                                                  peripheralUUID:self.peripheralUUID
                                                                              cb:cb];
    [[CHScanner sharedInstance] addInteraction:interaction];
}

- (void)write:(CHRegister * __nonnull)reg
  dataToWrite:(NSData * __nonnull)data
           cb:(_Nonnull ThingResponseCallback)cb
{
    CHWriteInteraction *interaction = [[CHWriteInteraction alloc] initWithRegister:reg
                                                                    peripheralUUID:self.peripheralUUID
                                                                       dataToWrite:data
                                                                                cb:cb];
    [[CHScanner sharedInstance] addInteraction:interaction];
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
