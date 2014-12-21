//
//  CarIsGoingVC.m
//  TaxiFriday
//
//  Created by Valik Kuchinsky on 26.11.14.
//
//

#import "CarIsGoingVC.h"
#import "StatusBaseVC.h"

@interface CarIsGoingVC ()
@property (nonatomic, weak) IBOutlet UILabel* waitTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property NSTimer *timer;

@end


@implementation CarIsGoingVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.nameLabel.text = self.name;
    self.numberLabel.text = self.number;
    
    // Do any additional setup after loading the view.
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButton:(id)sender
{
    [_statusVC cancelButton];
}

- (IBAction)researchCar:(id)sender
{
    [_statusVC callTaxi];
}

- (void)updateTimerLabel
{
    int timeToWait = abs((int)_waitingTime);
    NSInteger seconds = timeToWait % 60;
    NSInteger minutes = (timeToWait / 60) % 60;
    NSInteger hours = timeToWait / 3600;
    _timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hours, (long)minutes, (long)seconds];
    _waitingTime-=1;
    if (_waitingTime < 0)
    {
        self.waitTitleLabel.text = @"Опаздывает";
    } else {
        self.waitTitleLabel.text = @"Время ожидания";
    }
}

@end
