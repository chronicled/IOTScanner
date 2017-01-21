#import <Foundation/Foundation.h>
#import "ChBeaconReader.h"

static const UInt8 eddystoneLength = 20;
static const UInt8 deviceIdLocation = 12;
static const UInt8 deviceIdLength = 6;
static const UInt8 txPowerLocation = 1;
static const UInt8 txPowerLength = 1;

static const NSString* eddystoneKey = @"kCBAdvDataServiceData";

@implementation ChBeaconReader : NSObject

+ (NSDictionary * _Nullable) getBeaconDataFrom:(NSDictionary * _Nullable)advertisementData
{
    if (!advertisementData) {
        return nil;
    }

    NSData *eddystone = [self parseEddystoneBeacon:advertisementData];

    if (!eddystone) {
        return nil;
    }

    UInt8 txPower = [self getTxPowerFrom:eddystone];
    NSString *deviceID = [self getDeviceIdFrom:eddystone];

    if (!txPower || !deviceID) {
        return nil;
    }

    return @{ @"deviceID": deviceID, @"txPower": [[NSNumber alloc] initWithInt:txPower] };
}

+ (NSData * _Nullable) parseEddystoneBeacon:(NSDictionary * _Nullable)advertisementData
{
    NSDictionary *eddystone = advertisementData[eddystoneKey];

    if (!eddystone) {
        return nil;
    }

    NSData *eddystoneAsData = eddystone.allValues.firstObject;

    if (eddystoneAsData.length != eddystoneLength) {
        return nil;
    }

    return eddystoneAsData;
}

+ (UInt8) getTxPowerFrom:(NSData *)eddystoneData
{
    NSRange txPowerRange = NSMakeRange(txPowerLocation, txPowerLength);
    NSData *txPowerData = [eddystoneData subdataWithRange:txPowerRange];

    UInt8 power = 0;
    [txPowerData getBytes:&power length:sizeof(UInt8)];
    return power;
}

+ (NSString *) getDeviceIdFrom:(NSData *)eddystoneData
{
    NSRange deviceIdRange = NSMakeRange(deviceIdLocation, deviceIdLength);
    NSData *data = [eddystoneData subdataWithRange:deviceIdRange];
    return [[self nsDataToHex:data] lowercaseString];
}

+ (NSString * _Nullable) nsDataToHex:(NSData * _Nullable)data_
{
    NSData *data = data_;
    NSUInteger capacity = data.length * 2;
    NSMutableString *stringBuffer = [NSMutableString stringWithCapacity:capacity];

    const unsigned char *buffer = data.bytes;

    for (int i = 0; i < data.length; ++i) {
        [stringBuffer appendFormat:@"%02X", (UInt8)buffer[i]];
    }
    
    return stringBuffer;
}

@end
