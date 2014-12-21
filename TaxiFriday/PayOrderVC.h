//
//  PayOrderVC.h
//  TaxiFriday
//
//  Created by Sviryd Igor on 12/15/14.
//
//

#import <UIKit/UIKit.h>
@class StatusBaseVC;

@interface PayOrderVC : UIViewController
@property (weak) StatusBaseVC *statusVC;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *number;
@property (strong, nonatomic) NSString *time;
@property BOOL isPayed;
@end
