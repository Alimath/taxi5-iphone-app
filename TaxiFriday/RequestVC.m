//
//  RequestVC.m
//  TaxiFriday
//
//  Created by Stasevich Yauhen on 10/25/14.
//
//

#import "RequestVC.h"
#import "SearchAddressVC.h"

typedef NS_ENUM(NSUInteger, RequestVCSectionType) {
    RequestVCSectionTypeClientInfo,
    RequestVCSectionTypeAddress,
    RequestVCSectionTypeComment,
    RequestVCSectionTypeAction,
    RequestVCSectionTypesCount
};

@interface RequestVC () <UITableViewDataSource, UITableViewDelegate, SearchAddressVCDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UILabel *streetLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseLabel;
@property (weak, nonatomic) IBOutlet UILabel *stairCaseLabel;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

@end

@implementation RequestVC

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == RequestVCSectionTypeAddress) {
        if (indexPath.row == 0) {
            SearchAddressVC *destinationVC = [SearchAddressVC storyboardVC];
            destinationVC.delegate = self;
            [self.navigationController pushViewController:destinationVC animated:YES];
        }
    }
}

- (void)searchAddressVC:(SearchAddressVC *)controller didChooseAddress:(NSDictionary *)address
{
    self.streetLabel.text = address[@"street"];
    self.houseLabel.text = address[@"building"];
    self.stairCaseLabel.text = address[@"staircase"];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
