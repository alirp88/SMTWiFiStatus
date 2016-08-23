//
//  SMTViewController.m
//  SMTWiFiStatus
//
//  Created by Ali Rp on 08/23/2016.
//  Copyright (c) 2016 Ali Rp. All rights reserved.
//

#import "SMTViewController.h"
#import <SMTWiFiStatus/SMTWiFiStatus.h>

@interface SMTViewController ()

@end

@implementation SMTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%@", [SMTWiFiStatus isWiFiEnabled] ? @"Yes" : @"No");
    NSLog(@"%@", [SMTWiFiStatus isWiFiConnected] ? @"Yes" : @"No");
    NSLog(@"%@", [SMTWiFiStatus BSSID]);
    NSLog(@"%@", [SMTWiFiStatus SSID]);
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
