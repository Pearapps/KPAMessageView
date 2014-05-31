//
//  KPAAppDelegate.m
//  KPAMessageViewDemo
//
//  Created by Kenneth Parker Ackerson on 5/30/14.
//  Copyright (c) 2014 Kenneth Parker Ackerson. All rights reserved.
//

#import "KPAAppDelegate.h"
#import "KPAViewController.h"

@implementation KPAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    [self.window setRootViewController:[[KPAViewController alloc] init]];
    return YES;
}


@end
