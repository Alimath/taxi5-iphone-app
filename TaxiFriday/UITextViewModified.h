//
//  UITextViewModified.h
//  Business diary
//
//  Created by Admin on 6/21/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextViewModified : UITextView

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;
@end
