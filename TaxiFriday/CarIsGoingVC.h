//
//  CarIsGoingVC.h
//  TaxiFriday
//
//  Created by Valik Kuchinsky on 26.11.14.
//
//

#import <UIKit/UIKit.h>
@class StatusBaseVC;

@interface CarIsGoingVC : UIViewController

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *number;
@property (strong, nonatomic) NSString *time;
@property NSInteger waitingTime;
@property (weak) StatusBaseVC *statusVC;

@end
