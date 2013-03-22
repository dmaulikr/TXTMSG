//
//  NSObject+DelayedBlock.h
//  MWFSlideNavigationViewControllerDemo
//
//  Created by Meiwin Fu on 24/1/12.
//  Copyright (c) 2012 Meiwin Fu (blockthirty). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DelayedBlock)

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;

@end
