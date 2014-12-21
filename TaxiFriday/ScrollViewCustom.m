//
//  ScrollViewCustom.m
//  GoLive
//
//  Created by Valik Kuchinsky on 05.11.14.
//  Copyright (c) 2014 Valik Kuchinsky. All rights reserved.
//

#import "ScrollViewCustom.h"

@interface ScrollViewCustom ()

@end

@implementation ScrollViewCustom

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    NSLog(@"touchesShouldCancelInContentView");
    
    if (view.tag >= 50)
        return NO;
    else
        return YES;
}

@end
