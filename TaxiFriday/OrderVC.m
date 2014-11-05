//
//  OrderVCTableViewController.m
//  TaxiFriday
//
//  Created by Valik Kuchinsky on 03.11.14.
//
//

#import "OrderVC.h"

@interface OrderVC ()

@property MBProgressHUD *progress;
@property NSTimer *timer;
@property NSInteger waitingTime;

@end

@implementation OrderVC

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    _progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _progress.labelText = @"Пожалуйста, подождите";
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                              target:self
                                            selector:@selector(sendRequest)
                                            userInfo:nil
                                             repeats:YES];
}

- (void)sendRequest
{
    [SERVER getStatusRequestWithParameters:@{@"id":_idOrder} success:^(NSDictionary *dict)
     {
         NSLog(@"%@",dict);
         if ([dict[@"status"] isEqualToString:@"car_found"])
         {
             [_progress hide:YES];
             
             [_timer invalidate];
             
             _approveOrderView.hidden = NO;
             NSDictionary *eta = dict[@"eta"];
             _averageTimeLabel.text = [NSString stringWithFormat:@"около %ld мин.",(long)[eta[@"minutes"] integerValue]+1];
             
             _waitingLabel.hidden = YES;
             _statusLabel.hidden = YES;
             _waitTimerLabel.hidden = YES;
             
         }
         if ([dict[@"status"] isEqualToString:@"car_search"])
         {
             _statusLabel.text = @"Поиск автомобиля...";
         }
         if ([dict[@"status"] isEqualToString:@"car_not_founded"])
         {
             _statusLabel.text = @"Извините, в данный момент нет свободных автомобилей...";
             _statusLabel.hidden = NO;
             _backButton.hidden = NO;
             [_progress hide:YES];
             [_timer invalidate];
         }
     }
     failure:^(NSError *error)
     {
//       NSLog(@"%@",error);
     }];
}

- (void)updateTimerLabel
{
    NSInteger seconds = _waitingTime % 60;
    NSInteger minutes = (_waitingTime / 60) % 60;
    NSInteger hours = _waitingTime / 3600;
    _waitTimerLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hours, (long)minutes, (long)seconds];
    _waitingTime-=1;
    if (_waitingTime == 0)
    {
        [_timer invalidate];
    }
}

- (IBAction)approve:(id)sender
{
    [_progress show:YES];
    [SERVER approveRequestWithParameters:@{@"id":_idOrder, @"answer":@"approve"} success:^(NSDictionary *dict)
     {
         [_progress hide:YES];
         if ([dict[@"status"] isEqualToString:@"car_approved"])
         {
             _approveOrderView.hidden = YES;
             
             NSDictionary *eta = dict[@"eta"];
             _waitingTime = [eta[@"minutes"] integerValue]*60;
             _waitingTime += [eta[@"seconds"] integerValue];
         
             _waitTimerLabel.hidden = NO;
             _waitingLabel.hidden = NO;
//           _statusLabel.text = @"Автомобиль найден!";
             
             [self updateTimerLabel];
         
             _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                target:self
                                              selector:@selector(updateTimerLabel)
                                              userInfo:nil
                                               repeats:YES];
         }
     }
     failure:^(NSError *error)
     {
         [_progress hide:YES];
         ALERT(@"Извините, произошла ошибка...");
     }];
}

- (IBAction)cancel:(id)sender
{
    [_progress show:YES];
    [SERVER approveRequestWithParameters:@{@"id":_idOrder, @"answer":@"cancel"} success:^(NSDictionary *dict)
     {
         [_progress hide:YES];
             _approveOrderView.hidden = YES;
             
//             NSDictionary *eta = dict[@"eta"];
//             _waitingTime = [eta[@"minutes"] integerValue]*60;
//             _waitingTime += [eta[@"seconds"] integerValue];
         
//             _waitTimerLabel.hidden = NO;
//             _waitingLabel.hidden = NO;
              _statusLabel.text = @"Заказ отменен!";
              _statusLabel.hidden = NO;
             [self updateTimerLabel];
             _backButton.hidden = NO;
//             _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
//                                                       target:self
//                                                     selector:@selector(updateTimerLabel)
//                                                     userInfo:nil
//                                                      repeats:YES];
        
     }
     failure:^(NSError *error)
     {
         [_progress hide:YES];
         ALERT(@"Извините, произошла ошибка...");
     }];
}

- (IBAction)close:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
