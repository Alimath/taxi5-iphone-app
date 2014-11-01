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

@end

@interface RequestVC : UITableViewController <RequestVCDelegate>

- (void)updateWithPlace:(Place *)place;

@end
