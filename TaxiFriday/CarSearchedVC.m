//
//  CarSearchedVC.m
//  TaxiFriday
//
//  Created by Valik Kuchinsky on 26.11.14.
//
//

#import "CarSearchedVC.h"
#import "StatusBaseVC.h"

@interface CarSearchedVC ()

@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property BOOL isTimeOut;
@property NSTimer *timer;
@property NSInteger waitingTime;
@end

@implementation CarSearchedVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.nameLabel.text = self.name;
    self.numberLabel.text = self.number;
    
    // Do any additional setup after loading the view.
    _timeLabel.text = _timeString;
    _waitingTime = 60;
    [self updateTimerLabel];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                              target:self
                                            selector:@selector(updateTimerLabel)
                                            userInfo:nil
                                             repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [_timer invalidate];
}

- (void)updateTimerLabel
{
    _timerLabel.text = [NSString stringWithFormat:@"Осталось %ld сек",(long)_waitingTime];
    _waitingTime-=1;
    
    if (_waitingTime <= 0)
    {
        [self showTimeOutState];
    }
}

- (void) showTimeOutState {
    [_timer invalidate];
    self.timerLabel.text = @"Время подтверждения закончилось";
    [self.actionButton setImage:[UIImage imageNamed:@"repeatOrderButton"] forState:0];
    self.isTimeOut = YES;
}

- (IBAction)cancelButton:(id)sender
{
    [_baseVC cancelOrder];
}

- (IBAction)acceptOrder:(id)sender
{
    if(!self.isTimeOut){
        [_baseVC acceptOrder];
    } else {
        [_baseVC resendRequest];
    }
}

@end
