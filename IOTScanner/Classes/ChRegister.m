#import <Foundation/Foundation.h>
#import "CHRegister.h"

#pragma MARK Services
static CBUUID *authService = nil;
static CBUUID *settingsService = nil;

#pragma MARK Characteristics
static CBUUID *publicKeyChar = nil;
static CBUUID *lockStateChar = nil;

@implementation CHRegister

@synthesize serviceUUID;
@synthesize characteristicUUID;

+ (void)initialize {
    authService = [CBUUID UUIDWithString:@"B275CE22-FE42-4D6D-AED9-8C72855D1BD9"];
    settingsService = [CBUUID UUIDWithString:@"A3C87500-8ED3-4BDF-8A39-A01BEBEDE295"];

    publicKeyChar = [CBUUID UUIDWithString:@"6D61B943-C354-42C6-BCA8-2B56BD2473EA"];
    lockStateChar = [CBUUID UUIDWithString:@"A3C87506-8ED3-4BDF-8A39-A01BEBEDE295"];
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

+ (CHRegister *) publicKey
{
    return [[CHRegister alloc] initWithService:authService
                             andCharacteristic:publicKeyChar];
}

+ (CHRegister *) lockState
{
    return [[CHRegister alloc] initWithService:settingsService
                             andCharacteristic:lockStateChar];
}

@end
