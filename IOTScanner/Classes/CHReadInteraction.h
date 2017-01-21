#import "CHInteraction.h"

#ifndef CHReadInteraction_h
#define CHReadInteraction_h

@interface CHReadInteraction : NSObject <CHInteraction>

@property (strong, nonatomic) CHRegister *_Nonnull reg;

@property (nonatomic, retain) NSUUID *_Nonnull peripheralUUID;

@property (nonatomic, copy) _Nonnull ThingResponseCallback callback;

- (id __nonnull) initWithRegister:(CHRegister * __nonnull)reg
                   peripheralUUID:(NSUUID * __nonnull)uuid
                               cb:(ThingResponseCallback __nonnull)cb;

@end

#endif /* CHReadInteraction_h */
