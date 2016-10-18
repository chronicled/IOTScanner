#import <Foundation/Foundation.h>
#import "CHReadCache.h"

@implementation CHReadCache

@synthesize readCache;

+ (instancetype __nonnull)sharedInstance
{
    static CHReadCache *sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[CHReadCache alloc] init];
        sharedInstance.readCache = [[NSMutableDictionary alloc ] init];
    });

    return sharedInstance;
}
- (NSString * __nullable)readValueAtService:(NSString* __nonnull)service
                             characteristic:(NSString* __nonnull)characteristic
                                    andUUID:(NSString* __nonnull)uuid
{

    NSString *path = [NSString stringWithFormat:@"%@.%@.%@", uuid, service, characteristic];
    return [readCache valueForKeyPath:path];
}

- (void)setValueAtService:(NSString* __nonnull)service
           characteristic:(NSString* __nonnull)characteristic
                     UUID:(NSString* __nonnull)uuid
                 andValue:(NSString* __nonnull)value
{

    if (readCache[uuid]) {
        if (readCache[uuid][service]) {
            if (readCache[uuid][service][characteristic]) {
                readCache[uuid][service][characteristic] = value;
            } else {
                NSMutableDictionary *ch = [[NSMutableDictionary alloc] init];
                [ch setObject:value forKey:characteristic];
                [readCache[uuid][service] setObject:ch forKey:characteristic];
            }
        } else {
            NSMutableDictionary *ch = [[NSMutableDictionary alloc] init];
            [ch setObject:value forKey:characteristic];

            NSMutableDictionary *sv = [[NSMutableDictionary alloc] init];
            [sv setObject:ch forKey:service];

            [readCache[uuid] setObject:sv forKey:service];
        }
    } else {
        NSMutableDictionary *ch = [[NSMutableDictionary alloc] init];
        [ch setObject:value forKey:characteristic];

        NSMutableDictionary *sv = [[NSMutableDictionary alloc] init];
        [sv setObject:ch forKey:service];

        readCache[uuid] = sv;
    }
}

- (void)clearCache
{
    [[self readCache] removeAllObjects];
}

@end
