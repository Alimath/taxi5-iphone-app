//
//  RequestVC.h
//  TaxiFriday
//
//  Created by Stasevich Yauhen on 10/25/14.
//
//

#import <UIKit/UIKit.h>

@protocol RequestVCDelegate <NSObject>

- (void)updateWithPlace:(Place*)place;
- (void)setActiveHouseTextfield;

@end

@interface RequestVC : UIViewController <RequestVCDelegate>

- (void)updateWithPlace:(Place *)place;
- (void)setActiveHouseTextfield;

@end
