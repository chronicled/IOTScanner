#import <Foundation/Foundation.h>
#import "CHReadInteraction.h"

@implementation CHReadInteraction : NSObject

- (id) initWithRegister:(CHRegister * __nonnull)reg
         peripheralUUID:(NSUUID * __nonnull)uuid
                     cb:(ThingResponseCallback)cb
{
    self = [super init];

    if (self) {
        self.reg = reg;
        self.peripheralUUID = uuid;
        self.callback = cb;
    }

    return self;
}

@end
