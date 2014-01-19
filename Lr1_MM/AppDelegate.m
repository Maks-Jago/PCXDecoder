//
//  AppDelegate.m
//  Lr1_MM
//
//  Created by Max Kuznetsov on 13.10.13.
//  Copyright (c) 2013 111Minutes. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[RootViewController new]];
    navController.navigationBarHidden = YES;
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
