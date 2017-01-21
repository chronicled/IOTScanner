#ifndef NSData_hexadecimalString_h
#define NSData_hexadecimalString_h

#import "NSData+hexadecimalString.h"

@implementation NSData (NSData_hexadecimalString)

- (NSString *)hexadecimalString {
    const unsigned char *dataBuffer = (const unsigned char *)[self bytes];

    if (!dataBuffer) {
        return [NSString string];
    }

    NSUInteger dataLength = [self length];
    NSMutableString *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];

    for (int i = 0; i < dataLength; ++i) {
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    }

    return [NSString stringWithString:hexString];
}

@end

#endif /* NSData_hexadecimalString_h */
