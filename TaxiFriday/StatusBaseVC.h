//
//  StatusBaseVC.h
//  TaxiFriday
//
//  Created by Valik Kuchinsky on 26.11.14.
//
//

#import <UIKit/UIKit.h>

@interface StatusBaseVC : UIViewController

@property NSString *idOrder;
@property NSDictionary *orderParameters;
@property (nonatomic, strong) void(^resendRequestBlock)();

- (void)cancelButton;
- (void)acceptOrder;
- (void)cancelOrder;
- (void)callButton;
- (void)callTaxi;
- (void)resendRequest;
@end
