//
//  SMTWiFiStatus.h
//  testWiFi
//
//  Created by Ali Riahipour on 8/23/16.
//  Copyright © 2016 Snapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMTWiFiStatus : NSObject
+ (BOOL)       isWiFiEnabled;
+ (BOOL)       isWiFiConnected;
+ (NSString *) BSSID;
+ (NSString *) SSID;
@end
