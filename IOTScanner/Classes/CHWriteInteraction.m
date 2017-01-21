#import <Foundation/Foundation.h>
#import "CHWriteInteraction.h"

@implementation CHWriteInteraction : NSObject

- (id) initWithRegister:(CHRegister * __nonnull)reg
         peripheralUUID:(NSUUID * __nonnull)uuid
            dataToWrite:(NSData * __nonnull)data
                     cb:(ThingResponseCallback)cb
{
    self = [super init];

    if (self) {
        self.reg = reg;
        self.peripheralUUID = uuid;
        self.callback = cb;
        self.dataToWrite = data;
    }

    return self;
}

@end
