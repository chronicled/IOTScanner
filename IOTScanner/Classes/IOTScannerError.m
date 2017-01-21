#import "IOTScannerError.h"

enum errorCode {
    CONNECTING=1,
    DISCOVERING_SERVICES,
    DISCOVERING_CHARACTERISTICS,
    WRITING_TO_BEACON,
    READING_FROM_BEACON,
    UNKNOWN,
    UNSUPPORTED_INTERACTION
};

@implementation IOTScannerError

+ (NSError * __nonnull)connecting
{
    NSString *connecting = NSLocalizedString(@"An occured while connecting to the beacon", nil);

    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: connecting
                               };

    return [NSError errorWithDomain:@"com.chronicled.iotscanner"
                               code: CONNECTING
                           userInfo:userInfo];
}

+ (NSError * __nonnull)discoveringServices
{
    NSString *desc = NSLocalizedString(@"Unable to discover the service defined in " \
                                       "CHRegister", nil);

    NSString *sugg = NSLocalizedString(@"If you are using a custom CHRegister instance, the " \
                                       "service you've defined isn't on the beacon you are " \
                                       "interacting with", nil);

    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: desc,
                               NSLocalizedRecoverySuggestionErrorKey: sugg
                               };

    return [NSError errorWithDomain:@"com.chronicled.iotscanner"
                               code: DISCOVERING_SERVICES
                           userInfo:userInfo];
}

+ (NSError * __nonnull)discoveringCharacteristics
{
    NSString *desc = NSLocalizedString(@"Unable to discover the characteristic defined in " \
                                       "CHRegister", nil);

    NSString *sugg = NSLocalizedString(@"If you are using a custom CHRegister instance, the " \
                                       "characteristic you've defined isn't on the beacon you " \
                                       "are interacting with", nil);

    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: desc,
                               NSLocalizedRecoverySuggestionErrorKey: sugg
                               };

    return [NSError errorWithDomain:@"com.chronicled.iotscanner"
                               code: DISCOVERING_CHARACTERISTICS
                           userInfo:userInfo];
}

+ (NSError * __nonnull)writingToBeacon
{
    NSString *desc = NSLocalizedString(@"Unable to write to the beacon", nil);
    NSString *sugg = NSLocalizedString(@"Ensure the NSData you are writing to the beacon" \
                                       "is the correct size and formatted correctly", nil);

    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: desc,
                               NSLocalizedRecoverySuggestionErrorKey: sugg
                               };

    return [NSError errorWithDomain:@"com.chronicled.iotscanner"
                               code: WRITING_TO_BEACON
                           userInfo:userInfo];
}

+ (NSError * __nonnull)readingFromBeacon
{
    NSString *desc = NSLocalizedString(@"Unable to read data from the beacon", nil);
    NSString *sugg = NSLocalizedString(@"Ensure the characteristic you're attempting to " \
                                       "read from is readable", nil);

    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: desc,
                               NSLocalizedRecoverySuggestionErrorKey: sugg
                               };

    return [NSError errorWithDomain:@"com.chronicled.iotscanner"
                               code: READING_FROM_BEACON
                           userInfo:userInfo];
}

+ (NSError * __nonnull)unknownError
{
    NSString *unknown = NSLocalizedString(@"An unknown error occured", nil);

    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: unknown
                               };

    return [NSError errorWithDomain:@"com.chronicled.iotscanner"
                               code: UNKNOWN
                           userInfo:userInfo];
}

+ (NSError * __nonnull)unsupportedInteraction
{
    NSString *error = NSLocalizedString(@"The interaction you've added to the interaction " \
                                        "is not supported. Only CHReadInteraction's and " \
                                        "CHWriteInteractions are currently implemented", nil);

    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: error
                               };

    return [NSError errorWithDomain:@"com.chronicled.iotscanner"
                               code: UNKNOWN
                           userInfo:userInfo];
}

@end
