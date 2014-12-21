//
//  PayedOrderVC.h
//  TaxiFriday
//
//  Created by Valik Kuchinsky on 14.12.14.
//
//

#import <UIKit/UIKit.h>
@class StatusBaseVC;

@interface PayedOrderVC : UIViewController
@property (weak) StatusBaseVC *statusVC;
@property (nonatomic, strong) NSString* amount;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *number;
@property (strong, nonatomic) NSString *time;
@end
