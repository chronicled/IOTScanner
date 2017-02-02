#ifndef CHWriteInteraction_h
#define CHWriteInteraction_h

#import "CHInteraction.h"

@interface CHWriteInteraction : NSObject <CHInteraction>

@property (strong, nonatomic) CHRegister *_Nonnull reg;

@property (nonatomic, retain) NSUUID *_Nonnull peripheralUUID;

@property (nonatomic, retain) NSData *_Nonnull dataToWrite;

@property (nonatomic, copy) _Nonnull ThingResponseCallback callback;

- (id __nonnull) initWithRegister:(CHRegister * __nonnull)reg
                   peripheralUUID:(NSUUID * __nonnull)uuid
                      dataToWrite:(NSData * __nonnull)data
                               cb:(ThingResponseCallback __nonnull)cb;

@end

#endif /* CHWriteInteraction_h */
