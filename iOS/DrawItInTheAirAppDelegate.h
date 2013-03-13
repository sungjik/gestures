//
//  DrawItInTheAirAppDelegate.h
//  DrawItInTheAir
//
//  Created by Sung Jik Cha on 11/24/12.
//  Copyright (c) 2012 Sung Jik Cha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@class DrawItInTheAirViewController;

@interface DrawItInTheAirAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) DrawItInTheAirViewController *viewController;
@end
