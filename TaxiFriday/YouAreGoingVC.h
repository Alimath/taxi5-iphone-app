//
//  YouAreGoingVC.h
//  TaxiFriday
//
//  Created by Valik Kuchinsky on 14.12.14.
//
//

#import <UIKit/UIKit.h>
@class StatusBaseVC;

@interface YouAreGoingVC : UIViewController
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *number;
@property (strong, nonatomic) NSString *time;
@property (weak) StatusBaseVC *statusVC;
@end
