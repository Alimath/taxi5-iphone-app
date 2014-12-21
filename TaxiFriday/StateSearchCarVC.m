//
//  StateSearchCarVC.m
//  TaxiFriday
//
//  Created by Valik Kuchinsky on 26.11.14.
//
//

#import "StateSearchCarVC.h"
#import "StatusBaseVC.h"

@interface StateSearchCarVC ()

@end

@implementation StateSearchCarVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButton:(id)sender
{
    [_statusBaseVC cancelOrder];
}

@end
