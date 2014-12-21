//
//  TPSMasterViewController.m
//  Sample-UISearchController
//
//  Created by James Dempsey on 7/4/14.
//  Copyright (c) 2014 Tapas Software. All rights reserved.
//
//  Based on Apple sample code TableSearch version 2.0
//

#import "SearchPlaceVC.h"
#import "AddressCell.h"

static NSString *cellReuseIdentifier = @"CellReuseIdentifier";

@interface SearchPlaceVC () <UISearchResultsUpdating>

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults; // Filtered search results
@property MBProgressHUD *progress;
@property UIActivityIndicatorView *spinner;
@property NSInteger requestsCountQueue;

@end

#pragma mark -

@implementation SearchPlaceVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _requestsCountQueue = 0;
    
    // Create a mutable array to contain products for the search results table.
    
    self.searchResults = [NSMutableArray arrayWithCapacity:[_places count]];

    UITableViewController *searchResultsController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    searchResultsController.tableView.dataSource = self;
    searchResultsController.tableView.delegate = self;

    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];

    self.searchController.searchResultsUpdater = self;

    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);

    self.tableView.tableHeaderView = self.searchController.searchBar;

    self.definesPresentationContext = YES;
    
      
    self.tableView.rowHeight = 44;
    [self.tableView registerNib:[UINib nibWithNibName:@"AddressCell" bundle:nil] forCellReuseIdentifier:cellReuseIdentifier];
    
    self.tableView.tableFooterView = [UIView new];
    
//    self.tableView.backgroundColor = [UIColor blackColor];
    
    self.searchController.searchBar.barTintColor = [UIColor colorWithColorCode:@"F6F6F6"];
    
    self.searchController.searchBar.tintColor = [UIColor colorWithColorCode:@"5F3286"];
    self.searchController.searchBar.placeholder = @"Улица или объект";
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithColorCode:@"5F3286"];
    
    UITableView *searchTableView = ((UITableViewController*)self.searchController.searchResultsController).tableView;
    searchTableView.rowHeight = 44;
    [searchTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    searchTableView.backgroundColor = [UIColor blackColor];
    
    
//    self.searchController.searchBar.backgroundColor = [UIColor blackColor];
    
//    self.view.backgroundColor = [UIColor blackColor];
    
    CGRect frame = self.tableView.bounds;
    frame.origin.y = -frame.size.height;
    UIView* grayView = [[UIView alloc] initWithFrame:frame];
//  grayView.backgroundColor = [UIColor blackColor];
    [self.tableView addSubview:grayView];
    
    [self loadStreets];
    
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_spinner setColor:[UIColor grayColor]];
    _spinner.hidden = YES;
    [((UITableViewController *)self.searchController.searchResultsController).tableView addSubview:_spinner];
}

- (void)viewWillAppear:(BOOL)animated
{
    _spinner.center = CGPointMake(self.tableView.frame.size.width/2.0, self.tableView.frame.size.height/4.0);
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [_delegate setActiveHouseTextfield];
}

- (void)loadStreets
{
    _progress = [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    _progress.labelText = @"Загрузка";
    [SERVER getAddressesWithText:@"" success:^(NSDictionary *result)
     {
         _places = [Place objectsWithArray:(NSArray*)result];
         [self.tableView reloadData];
         [_progress hide:YES];
     }
     failure:^(NSError *error)
     {
         NSLog(@"Ошибка сервера");
         [_progress hide:YES];
     }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    /*  If the requesting table view is the search controller's table view, return the count of
        the filtered list, otherwise return the count of the main list.
     */
    if (tableView == ((UITableViewController *)self.searchController.searchResultsController).tableView) {
        return [self.searchResults count];
    } else {
        return [_places count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Dequeue a cell from self's table view.
    AddressCell *cell = (AddressCell*)[self.tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (cell == nil)
    {
        cell = (AddressCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellReuseIdentifier];
    }

    Place *place;

    if (tableView == ((UITableViewController *)self.searchController.searchResultsController).tableView)
    {
        place = [self.searchResults objectAtIndex:indexPath.row];
    }
    else
    {
        place = [_places objectAtIndex:indexPath.row];
    }

    NSString *address = place.street;
    if (place.building)
    {
        address = [address stringByAppendingString:@" "];
        address = [address stringByAppendingString:place.building];
    }
    
    if (!place.name)
    {
        place.name = @"";
    }
    
    NSMutableAttributedString *attributedAddress = [[NSMutableAttributedString alloc] initWithString:address];
    NSMutableAttributedString *attributedName = [[NSMutableAttributedString alloc] initWithString:place.name];
    
    if (place.name.length)
    {
        [attributedAddress addAttribute:NSFontAttributeName
                                  value:[UIFont boldSystemFontOfSize:13.0]
                                  range:[address rangeOfString:[self.searchController.searchBar text] options:NSCaseInsensitiveSearch]];
        [attributedName addAttribute:NSFontAttributeName
                               value:[UIFont boldSystemFontOfSize:17.0]
                               range:[place.name rangeOfString:[self.searchController.searchBar text] options:NSCaseInsensitiveSearch]];
        
        cell.titleLabel.attributedText = attributedName;
        cell.detailLabel.attributedText = attributedAddress;
//        cell.imageView.image = [UIImage imageNamed:@"place"];
    }
    else
    {
        [attributedAddress addAttribute:NSFontAttributeName
                                  value:[UIFont boldSystemFontOfSize:17.0]
                                  range:[address rangeOfString:[self.searchController.searchBar text] options:NSCaseInsensitiveSearch]];
        [attributedName addAttribute:NSFontAttributeName
                               value:[UIFont boldSystemFontOfSize:13.0]
                               range:[place.name rangeOfString:[self.searchController.searchBar text] options:NSCaseInsensitiveSearch]];
        
        cell.titleLabel.attributedText = attributedAddress;
        cell.detailLabel.attributedText = attributedName;
        cell.imageView.image = nil;
    }
//    cell.backgroundColor = [UIColor blackColor];
//    cell.textLabel.textColor = [UIColor whiteColor];
//    cell.detailTextLabel.textColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Place *place;
    if (tableView == ((UITableViewController *)self.searchController.searchResultsController).tableView)
    {
         place = self.searchResults[indexPath.row];
    }
    else
    {
        place = _places[indexPath.row];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([_delegate respondsToSelector:@selector(updateWithPlace:)])
    {
        [_delegate updateWithPlace:place];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UISearchResultsUpdating

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = [self.searchController.searchBar text];

    _spinner.hidden = NO;
    [_spinner startAnimating];
    _requestsCountQueue += 1;
    [SERVER getAddressesWithText:searchString success:^(NSDictionary *result)
    {
        _requestsCountQueue -= 1;
        
        if (!_requestsCountQueue)
        {
            self.searchResults = [[Place objectsWithArray:(NSArray*)result] mutableCopy];
            [((UITableViewController *)self.searchController.searchResultsController).tableView reloadData];
            [_spinner stopAnimating];
            _spinner.hidden = YES;
        }
    }
    failure:^(NSError *error)
    {
        NSLog(@"Ошибка сервера");
    }];
}

@end
