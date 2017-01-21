#import <Foundation/Foundation.h>

#ifndef IOTScannerError_h
#define IOTScannerError_h

@interface IOTScannerError : NSObject

+ (NSError * __nonnull)connecting;
+ (NSError * __nonnull)discoveringCharacteristics;
+ (NSError * __nonnull)discoveringServices;
+ (NSError * __nonnull)writingToBeacon;
+ (NSError * __nonnull)readingFromBeacon;
+ (NSError * __nonnull)unknownError;
+ (NSError * __nonnull)unsupportedInteraction;

@end

#endif /* IOTScannerError_h */

