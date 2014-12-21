//
//  StatusBaseVC.m
//  TaxiFriday
//
//  Created by Valik Kuchinsky on 26.11.14.
//
//

#import "StatusBaseVC.h"
#import "ConnectionErrorVC.h"
#import "CarNotFoundVC.h"
#import "CarFinishedVC.h"
#import "CarIsGoingVC.h"
#import "CarSearchedVC.h"
#import "StateSearchCarVC.h"
#import "OrderTimeOutVC.h"
#import "OrderRejectedVC.h"
#import "YouAreGoingVC.h"
#import "PayedOrderVC.h"
#import "PayOrderVC.h"
#import <AudioToolbox/AudioServices.h>

typedef NS_ENUM(NSUInteger, OrderStatus)
{
    OrderStatusCarSearch,
    OrderStatusCarSearched,
    OrderStatusWaitApproval,
    OrderStatusCarApproved,
    OrderStatusCarApproveTimeOut,
    OrderStatusApproveRejected,
    OrderStatusCarIsGoing,
    OrderStatusCarFinished,
    OrderStatusInProgress,
    OrderStatusCompleted,
    OrderStatusNotPaid,
    OrderStatusPaid,
    OrderStatusClosed,
    OrderStatusCanceled,
    OrderStatusForceCanceled,
    OrderStatusCarNotFound,
    OrderStatusClientNotFound,
    OrderStatusConnectionError,
    OrderStatusCount
};

@interface StatusBaseVC ()

@property NSTimer *requestTimer;
@property OrderStatus currentStatus;
@property UIViewController *currentStatusVC;

@end

@implementation StatusBaseVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _currentStatus = -1;
    
    _requestTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                     target:self
                                                   selector:@selector(sendRequest)
                                                   userInfo:nil
                                                    repeats:YES];
    
    [self changeStatus:OrderStatusCarSearch dict:nil];
}

- (void)dealloc {
    [_requestTimer invalidate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendRequest
{
    [SERVER getStatusRequestWithParameters:@{@"id":_idOrder} success:^(NSDictionary *dict)
     {
         NSLog(@"%@",dict);
         
         if ([dict[@"status"] isEqualToString:@"car_search"]) //search
         {
             [self changeStatus:OrderStatusCarSearch dict:dict];
         }
         if ([dict[@"status"] isEqualToString:@"car_found"]) // CAR FOUND
         {
             [self changeStatus:OrderStatusCarSearched dict:dict];
         }
         if ([dict[@"status"] isEqualToString:@"car_wait_approval"] ) // wait approve
         {
             [self changeStatus:OrderStatusWaitApproval dict:dict];
         }
         if ([dict[@"status"] isEqualToString:@"car_approved"]) // approved
         {
             [self changeStatus:OrderStatusCarIsGoing dict:dict];
         }
         if ([dict[@"status"] isEqualToString:@"client_approve_timeout"]) // time out
         {
             [self changeStatus:OrderStatusCarApproveTimeOut dict:dict];
         }
         if ([dict[@"status"] isEqualToString:@"client_approve_reject"]) // client reject
         {
             [self changeStatus:OrderStatusApproveRejected dict:dict];
         }
         if ([dict[@"status"] isEqualToString:@"client_not_found"]) // client is late
         {
             [self changeStatus:OrderStatusClientNotFound dict:dict];
         }
         if ([dict[@"status"] isEqualToString:@"car_not_founded"]) // car not found
         {
             [self changeStatus:OrderStatusCarNotFound dict:dict];
         }
         if ([dict[@"status"] isEqualToString:@"car_delivering"]) // is delivering
         {
             [self changeStatus:OrderStatusCarIsGoing dict:dict];
         }
         if ([dict[@"status"] isEqualToString:@"car_delivered"]) // waiting for client
         {
             [self changeStatus:OrderStatusCarFinished dict:dict];
         }
         if ([dict[@"status"] isEqualToString:@"order_in_progress"]) // in progress
         {
             [self changeStatus:OrderStatusInProgress dict:dict];
         }
         if ([dict[@"status"] isEqualToString:@"order_completed"]) // finished
         {
             [self changeStatus:OrderStatusCompleted dict:dict];
         }
         if ([dict[@"status"] isEqualToString:@"order_paid"]) // paid
         {
             [self changeStatus:OrderStatusPaid dict:dict];
         }
         if ([dict[@"status"] isEqualToString:@"order_not_paid"]) // not paid
         {
             [self changeStatus:OrderStatusNotPaid dict:dict];
         }
         if ([dict[@"status"] isEqualToString:@"order_closed"]) // closed
         {
             [self changeStatus:OrderStatusClosed dict:dict];
         }
         if ([dict[@"status"] isEqualToString:@"canceled"]) // canceled
         {
             [self changeStatus:OrderStatusCanceled dict:dict];
         }
         if ([dict[@"status"] isEqualToString:@"force_canceled"]) // force canceled
         {
             [self changeStatus:OrderStatusForceCanceled dict:dict];
         }
     }
     failure:^(NSError *error)
     {
         [self changeStatus:OrderStatusConnectionError dict:nil];
     }];
}

- (void)changeStatus:(OrderStatus)status dict:(NSDictionary*)dict
{
    if (_currentStatus == status)
    {
        return;
    }
    
    NSDictionary* autoDic = [dict objectForKey:@"vehicle_meta"];
    NSString* color = [autoDic valueForKey:@"color_rus"];
    NSString* model = [autoDic valueForKey:@"model"];
    NSString* driver = [autoDic valueForKeyPath:@"driver.firstname"];
    NSString* infoAuto = [NSString stringWithFormat:@"%@ %@",model,color];
    
    UIViewController *newViewController;
    switch (status)
    {
        case OrderStatusCarSearch:
            {
                StateSearchCarVC *viewController = [StateSearchCarVC storyboardVC];
                viewController.statusBaseVC = self;
                newViewController = viewController;
            }
            break;
            
        case OrderStatusCarSearched:
            {
                NSDictionary *eta = dict[@"eta"];
                CarSearchedVC *viewController = [CarSearchedVC storyboardVC];
                NSString *timeMessage = [NSString stringWithFormat:@"%ld мин.",(long)[eta[@"minutes"] integerValue]+1];
                viewController.timeString = timeMessage;
                viewController.baseVC = self;
                viewController.name = driver;
                viewController.number = infoAuto;
                newViewController = viewController;
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
            }
            break;
            
        case OrderStatusWaitApproval:
            {
                return;
            }
            break;
            
        case OrderStatusCarApproveTimeOut:
            {
                if([_currentStatusVC isKindOfClass:[CarSearchedVC class]])
                {
                    [(CarSearchedVC*)_currentStatusVC showTimeOutState];
                }
                return;
            }
            break;
            
        case OrderStatusApproveRejected:
            {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            break;
            
            
        case OrderStatusClientNotFound:
        {
            OrderRejectedVC* rejectOrderVC = [OrderRejectedVC storyboardVC];
            rejectOrderVC.reasonMessage = @"Вы опаздали к ожидающей Вас машине";
            newViewController = rejectOrderVC;
        }
            break;
            
        case OrderStatusCarIsGoing:
            {
                CarIsGoingVC *viewController = [CarIsGoingVC storyboardVC];
                NSDictionary *eta = dict[@"eta"];
                viewController.waitingTime = [eta[@"minutes"] integerValue]*60;
                viewController.waitingTime += [eta[@"seconds"] integerValue];
                viewController.name = driver;
                viewController.number = infoAuto;
                viewController.statusVC = self;
                newViewController = viewController;
            }
            break;
            
        case OrderStatusCarFinished:
            {
                CarFinishedVC *viewController = [CarFinishedVC storyboardVC];
                NSDictionary *eta = dict[@"eta"];
                viewController.waitingTime = [eta[@"minutes"] integerValue]*60;
                viewController.waitingTime += [eta[@"seconds"] integerValue];
                viewController.statusVC = self;
                viewController.name = driver;
                viewController.number = infoAuto;
                newViewController = viewController;
            }
            break;
            
        case OrderStatusInProgress:
            {
                YouAreGoingVC* inProgressVc = [YouAreGoingVC storyboardVC];
                inProgressVc.name = driver;
                inProgressVc.number = infoAuto;
                newViewController = inProgressVc;
            }
            break;
            
        case OrderStatusCompleted:
            {
                PayOrderVC* viewController = [PayOrderVC storyboardVC];
                viewController.name = driver;
                viewController.number = infoAuto;
                viewController.statusVC = self;
                newViewController = viewController;
            }
            break;
            
        case OrderStatusPaid:
        {
            PayedOrderVC* viewController = [PayedOrderVC storyboardVC];
            viewController.statusVC = self;
            viewController.name = driver;
            viewController.number = infoAuto;
            viewController.amount = [[dict objectForKey:@"amount"] stringValue];
            newViewController = viewController;
        }
            break;
            
        case OrderStatusClosed:
        {
            return;
        }
            break;
            
        case OrderStatusNotPaid:
        {
            PayOrderVC* viewController = [PayOrderVC storyboardVC];
            viewController.name = driver;
            viewController.number = infoAuto;
            viewController.statusVC = self;
            viewController.isPayed = NO;
            newViewController = viewController;
        }
            break;
            
        case OrderStatusCanceled:
        {
            OrderRejectedVC* rejectOrderVC = [OrderRejectedVC storyboardVC];
            rejectOrderVC.reasonMessage = nil;
            newViewController = rejectOrderVC;
        }
            break;
            
        case OrderStatusForceCanceled:
        {
            OrderRejectedVC* rejectOrderVC = [OrderRejectedVC storyboardVC];
            rejectOrderVC.reasonMessage = nil;
            newViewController = rejectOrderVC;
        }
            break;
            
        case OrderStatusCarNotFound:
            {
                CarNotFoundVC *viewController = [CarNotFoundVC storyboardVC];
                viewController.statusBaseVC = self;
                newViewController = viewController;
            }
            break;
            
        case OrderStatusConnectionError:
            {
                ConnectionErrorVC *viewController = [ConnectionErrorVC storyboardVC];
                viewController.statusBaseVC = self;
                newViewController = viewController;
            }
            break;
            
        default:
            
            break;
    }
    
    [UIView animateWithDuration:0.5 animations:^
    {
        _currentStatusVC.view.alpha = 0;
    }
    completion:^(BOOL finished)
    {
        [_currentStatusVC.view removeFromSuperview];
        [_currentStatusVC removeFromParentViewController];
        
        newViewController.view.frame = self.view.bounds;
        [self.view addSubview:newViewController.view];
        [newViewController didMoveToParentViewController:self];
        [self addChildViewController:newViewController];
        newViewController.view.alpha = 0;
        
        _currentStatusVC = newViewController;
        
        [UIView animateWithDuration:0.5 animations:^
        {
             _currentStatusVC.view.alpha = 1;
        }];
    }];
     _currentStatus = status;
}

- (void)cancelButton
{
    [_requestTimer invalidate];
    _requestTimer = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) resendRequest {
    if(self.resendRequestBlock){
        self.resendRequestBlock();
    }
}

- (void)acceptOrder
{
    [SERVER approveRequestWithParameters:@{@"id":_idOrder, @"answer":@"approve"} success:^(NSDictionary *dict)
     {
         if ([dict[@"status"] isEqualToString:@"car_approved"])
         {
             [self sendRequest];
         }
     }
     failure:^(NSError *error)
     {
         ALERT(@"Извините, произошла ошибка...");
     }];
}

- (void)cancelOrder
{
    [_requestTimer invalidate];
    _requestTimer = nil;
    [self.navigationController popViewControllerAnimated:YES];
    [SERVER approveRequestWithParameters:@{@"id":_idOrder, @"answer":@"cancel"} success:^(NSDictionary *dict)
     {
//       [self.navigationController popViewControllerAnimated:YES];
     }
    failure:^(NSError *error)
     {
         ALERT(@"Извините, произошла ошибка...");
     }];
}

- (void)callButton
{
    NSString *phoneNumber = [@"tel://" stringByAppendingString:@"7500"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

- (void)callTaxi
{
    [[Server sharedServer]sendOrderRequestWithParameters:_orderParameters success:^(id response)
     {
         _idOrder = response[@"id"];
         [self changeStatus:OrderStatusCarSearch dict:nil];
         [_requestTimer invalidate];
         [self sendRequest];
         _requestTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                          target:self
                                                        selector:@selector(sendRequest)
                                                        userInfo:nil
                                                         repeats:YES];
         
     }
     failure:^(NSError *error)
     {
         ALERT(@"Извините, произошла ошибка! Попробуйте еще раз.");
     }];
}

@end
