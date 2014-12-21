//
//  AppDelegate.m
//  TaxiFriday
//
//  Created by Stasevich Yauhen on 10/25/14.
//
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"screenBackgroundTop"] forBarMetrics:UIBarMetricsDefault];
//    [[UITextField appearance] setTintColor:[UIColor colorWithColorCode:@"5F3286"]];

    return YES;
}

@end
