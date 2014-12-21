//
//  UIViewRounded.m
//  TaxiFriday
//
//  Created by Valik Kuchinsky on 23.11.14.
//
//

#import "UIViewRounded.h"

@implementation UIViewRounded

- (void)layoutSubviews
{
    self.layer.cornerRadius = 5;
    [self clipsToBounds];
}

@end
