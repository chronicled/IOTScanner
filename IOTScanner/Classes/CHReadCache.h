#ifndef CHReadCache_h
#define CHReadCache_h

@interface CHReadCache : NSObject

@property(strong, nonnull) NSMutableDictionary* readCache;

+ (instancetype __nonnull)sharedInstance;

- (NSString * __nullable)readValueAtService:(NSString* __nonnull)service
                             characteristic:(NSString* __nonnull)charecteristic
                                    andUUID:(NSString* __nonnull)uuid;

- (void)setValueAtService:(NSString* __nonnull)service
           characteristic:(NSString* __nonnull)characteristic
                     UUID:(NSString* __nonnull)uuid
                 andValue:(NSString* __nonnull)value;

- (void)clearCache;

@end

#endif /* CHReadCache_h */
