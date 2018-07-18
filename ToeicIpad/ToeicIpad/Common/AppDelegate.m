//
//  AppDelegate.m
//  ToeicIpad
//
//  Created by DungLM3 on 7/18/18.
//  Copyright © 2018 DungLM3. All rights reserved.
//

#import "AppDelegate.h"
#import "Global.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    HomeViewController *rootVC = NEW_VC(HomeViewController);
    UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:rootVC];
    [self.window setRootViewController:rootNav];
    [self.window makeKeyAndVisible];
    return YES;
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}


@end
