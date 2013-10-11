//
//  CalculatorAppDelegate.m
//  Calculator
//
//  Created by Jesse Nelson on 10/10/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import "CalculatorAppDelegate.h"

@implementation CalculatorAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation     {
    NSLog(@"Open application called in calculator");
    return [ self application:application handleOpenURL:url ] ;
}

// Depracted
- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url {
    NSLog(@"The query is %@", [url query]);
    NSLog(@"Handling URL in calculator");
    NSString *query = [url query];
    NSArray *parts = [query componentsSeparatedByString:@"&"];
    NSMutableArray *values = [NSMutableArray array];
    for (NSString *part in parts) {
        NSRange equal = [part rangeOfString:@"="];
        NSLog(@"The part is %@", part);
        NSString *value = [part substringFromIndex:equal.location + equal.length];
        NSLog(@"The value is %@", part);
        //[values addObject:value]; // If you want the value as a string
        [values addObject:[NSNumber numberWithInt:[value intValue]]]; // If you want the value as a number
    }
    
    for ( NSString *value in values ) {
        NSLog(@"%@", value);
    }
    //NSLog(@"There were %d values passed in ", values.count );
    return YES;
}
@end
