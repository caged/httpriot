//
//  iPhoneSampleAppDelegate.h
//  iPhoneSampleApp
//
//  Created by Justin Palmer on 6/24/09.
//  Copyright LabratRevenge LLC. 2009. All rights reserved.
//

@interface iPhoneSampleAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

