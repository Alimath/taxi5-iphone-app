//
//  NSObject+PerformBlockAfterDelay.m
//  Elevator
//
//  Created by Igor Khmurets on 27.11.12.
//  Copyright (c) 2012 Igor Khmurets/Alexander Lednik. All rights reserved.
//

#import "Categories.h"

@implementation NSObject (PerformBlockAfterDelay)

- (void)performAfterDelay:(NSTimeInterval)delay block:(void (^)(void))block
{
    block = [block copy];
    [self performSelector:@selector(fireBlockAfterDelay:) withObject:block afterDelay:delay];
}

- (void)fireBlockAfterDelay:(void (^)(void))block
{
    block();
}

@end

@implementation UIColor (HexColor)

+ (UIColor *)colorWithColorCode:(NSString *)hexString {
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if (cleanString.length == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)], [cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)], [cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)], [cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if (cleanString.length == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF) / 255.f;
    float green = ((baseValue >> 16) & 0xFF) / 255.f;
    float blue = ((baseValue >> 8) & 0xFF) / 255.f;
    float alpha = ((baseValue >> 0) & 0xFF) / 255.f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end


@implementation UIView (Coordinates)

- (void)setCenterX:(CGFloat)centerX
{
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setOrigin:(CGPoint)origin
{
    self.frame = CGRectMake(origin.x, origin.y, self.frame.size.width, self.frame.size.height);
}

- (CGPoint)origin
{
    return CGPointMake(self.frame.origin.x, self.frame.origin.y);
}

- (void)setOriginX:(CGFloat)originX
{
    self.frame = CGRectMake(originX, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (CGFloat)originX
{
    return self.frame.origin.x;
}

- (void)setOriginY:(CGFloat)originY
{
    self.frame = CGRectMake(self.frame.origin.x, originY, self.frame.size.width, self.frame.size.height);
}

- (CGFloat)originY
{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGSize)size
{
    return CGSizeMake(self.frame.size.width, self.frame.size.height);
}

- (void)setSize:(CGSize)size
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
}

@end


@implementation UIViewController (Storyboard)

+ (id)storyboardVC
{
    UIStoryboard *storyboard;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        storyboard = [UIStoryboard storyboardWithName:@"Main-iPad" bundle:nil];
    } else {
        storyboard = [UIStoryboard storyboardWithName:@"Main-iPhone" bundle:nil];
    }
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(self.class)];
}

@end

@implementation UINavigationItem (Additions)

- (void)addLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        // Add a negative spacer on iOS >= 7.0
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                        target:nil action:nil];
        negativeSpacer.width = -10;
        [self setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, leftBarButtonItem, nil]];
    } else {
        // Just set the UIBarButtonItem as you would normally
        [self setLeftBarButtonItem:leftBarButtonItem];
    }
}

- (void)addRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        // Add a negative spacer on iOS >= 7.0
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -10;
        [self setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, rightBarButtonItem, nil]];
    } else {
        // Just set the UIBarButtonItem as you would normally
        [self setRightBarButtonItem:rightBarButtonItem];
    }
}

- (UIBarButtonItem *)styledRightBarButtonItem
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        return self.rightBarButtonItems[1];
    } else {
        return self.rightBarButtonItem;
    }
}

- (UIBarButtonItem *)styledLeftBarButtonItem
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        return self.leftBarButtonItems[1];
    } else {
        return self.leftBarButtonItem;
    }
}

@end

@implementation NSDictionary (NonNULLObject)

- (id)nonNullObjectForKey:(id)key
{
    id value = [self objectForKey:key];
    if (value && [value isKindOfClass:[NSNull class]]) {
        value = nil;
    }
    return value;
}

@end

@implementation UIImage (ImageColor)

+ (UIImage *)changeImageColor:(NSString *)name withColor:(UIColor *)color
{
    UIImage *image = [UIImage imageNamed:name];
    
    // begin a new image context, to draw our colored image onto
    UIGraphicsBeginImageContextWithOptions(image.size, FALSE, 2.0);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill color
    [color setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // set the blend mode to color burn, and the original image
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);

    // set a mask that matches the shape of the image, then draw (color burn) a colored rectangle
    CGContextClipToMask(context, rect, image.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context, kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return coloredImg;
}


@end

//
@implementation UITableViewCell (SeparatorInset)

- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}

@end
