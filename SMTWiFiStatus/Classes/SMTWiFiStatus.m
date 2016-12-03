#import <Foundation/Foundation.h>

#import <ifaddrs.h>
#import <net/if.h>
#import <SystemConfiguration/CaptiveNetwork.h>

@interface SMTWiFiStatus : NSObject


@end

@implementation SMTWiFiStatus

+ (BOOL) isWiFiEnabled {
    
    NSCountedSet * cset = [NSCountedSet new];
    
    struct ifaddrs *interfaces;
    
    if( ! getifaddrs(&interfaces) ) {
        for( struct ifaddrs *interface = interfaces; interface; interface = interface->ifa_next) {
            if ( (interface->ifa_flags & IFF_UP) == IFF_UP ) {
                [cset addObject:[NSString stringWithUTF8String:interface->ifa_name]];
            }
        }
    }
    freeifaddrs(interfaces);
    
    return [cset countForObject:@"awdl0"] > 1 ? YES : NO;
}

+ (NSDictionary *) wifiDetails {
#ifndef TARGET_OS_SIMULATOR
    return
    (__bridge NSDictionary *)

    CNCopyCurrentNetworkInfo(
                             CFArrayGetValueAtIndex( CNCopySupportedInterfaces(), 0)
                             );
#endif
}

+ (BOOL) isWiFiConnected {
    return [SMTWiFiStatus wifiDetails] == nil ? NO : YES;
}

+ (NSString *) BSSID {
    return [SMTWiFiStatus wifiDetails][@"BSSID"];
}

+ (NSString *) SSID {
#ifndef TARGET_OS_SIMULATOR
    return [SMTWiFiStatus wifiDetails][@"SSID"];
#endif
}

@end
