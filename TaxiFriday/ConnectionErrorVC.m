//
//  ConnectionErrorVC.m
//  TaxiFriday
//
//  Created by Valik Kuchinsky on 26.11.14.
//
//

#import "ConnectionErrorVC.h"
#import "StatusBaseVC.h"

@interface ConnectionErrorVC ()

@end

@implementation ConnectionErrorVC

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

- (IBAction)callButton:(id)sender
{
    [_statusBaseVC callTaxi];
}

- (IBAction)cancel:(id)sender
{
    [_statusBaseVC cancelButton];
}

@end
