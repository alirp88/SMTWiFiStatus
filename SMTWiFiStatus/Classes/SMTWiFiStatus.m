#import "SMTWiFiStatus.h"

#import <ifaddrs.h>
#import <net/if.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <SystemConfiguration/CaptiveNetwork.h>

@interface SMTWiFiStatus ()


@end

@implementation SMTWiFiStatus

#pragma mark - WiFi powered
+ (SMTWiFiPoweredState) wifiPoweredState {
    
    NSCountedSet * cset = [NSCountedSet new];
    
    struct ifaddrs *interfaces;
    
    if (!getifaddrs(&interfaces)) {
        for (struct ifaddrs *interface = interfaces; interface; interface = interface->ifa_next) {
            if ((interface->ifa_flags & IFF_UP) == IFF_UP) {
                [cset addObject:[NSString stringWithUTF8String:interface->ifa_name]];
            }
        }
    }
    freeifaddrs(interfaces);
    
    if ([cset countForObject:@"awdl0"] == 0) {
        return SMTWiFiPoweredStateUnknown;
    }
    return [cset countForObject:@"awdl0"] == 1 && ![[self class] hotspotEnabled] ? SMTWiFiPoweredStateOff : SMTWiFiPoweredStateOn;
}

+ (BOOL) isWiFiEnabled {
    return [[self class] wifiPoweredState] == SMTWiFiPoweredStateOn;
}

+ (NSDictionary *) wifiDetails {
#ifdef TARGET_OS_SIMULATOR
    return NULL;
#else
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
#ifdef TARGET_OS_SIMULATOR
    return NULL;
#else
    return [SMTWiFiStatus wifiDetails][@"SSID"];
#endif
}


#pragma mark - Hotspot
+ (BOOL) hotspotEnabled {
    for (NSString *key in [[self class] getIPAddresses].allKeys) {
        if ([key containsString:@"bridge"]) {
            return YES;
        }
    }
    return NO;
}

+ (NSDictionary *) getIPAddresses {
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = @"ipv4";
                    }
                }
                else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = @"ipv6";
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

@end
