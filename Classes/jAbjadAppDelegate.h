//
//  jAbjadAppDelegate.h
//  jAbjad
//
//  Created by Saif Mamat on 24/11/2011.
//  Copyright 2011 DD Multimedia Solutions Sdn. Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class jAbjadViewController;

@interface jAbjadAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    jAbjadViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet jAbjadViewController *viewController;

@end

