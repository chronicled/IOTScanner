#import <Foundation/Foundation.h>
#import "CHRegister.h"

#pragma MARK Services
static CBUUID *auth = nil;
static CBUUID *settings = nil;

#pragma MARK Characteristics
static CBUUID *publicKey = nil;
static CBUUID *lockState = nil;

@implementation CHRegister

@synthesize serviceUUID;
@synthesize characteristicUUID;

+ (void)initialize {
    auth = [CBUUID UUIDWithString:@"B275CE22-FE42-4D6D-AED9-8C72855D1BD9"];
    settings = [CBUUID UUIDWithString:@"A3C87500-8ED3-4BDF-8A39-A01BEBEDE295"];

    publicKey = [CBUUID UUIDWithString:@"6D61B943-C354-42C6-BCA8-2B56BD2473EA"];
    lockState = [CBUUID UUIDWithString:@"A3C87506-8ED3-4BDF-8A39-A01BEBEDE295"];
}

- (instancetype __nonnull)initWithService:(CBUUID*)service andCharacteristic:(CBUUID*)ch
{
    self = [super init];
    if (self) {
        self.serviceUUID = service;
        self.characteristicUUID = ch;
    }
    return self;
}

+ (instancetype __nonnull)publicKey
{
    return [[CHRegister alloc] initWithService:auth
                             andCharacteristic:publicKey];
}

+ (instancetype __nonnull)lockState
{
    return [[CHRegister alloc] initWithService:settings
                             andCharacteristic:lockState];
}

@end
