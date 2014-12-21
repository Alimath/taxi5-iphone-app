//
//  OrderVCTableViewController.h
//  TaxiFriday
//
//  Created by Valik Kuchinsky on 03.11.14.
//
//

#import <UIKit/UIKit.h>

@interface OrderVC : UIViewController

@property NSString *idOrder;
@property (weak, nonatomic) IBOutlet UIImageView *noCarsImageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *waitingLabel;
@property (weak, nonatomic) IBOutlet UILabel *waitTimerLabel;

@property (weak, nonatomic) IBOutlet UIView *approveOrderView;
@property (weak, nonatomic) IBOutlet UILabel *averageTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *payedImageView;


@end
