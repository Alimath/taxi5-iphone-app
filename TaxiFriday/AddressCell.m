//
//  AddressCell.m
//  TaxiFriday
//
//  Created by Stasevich Yauhen on 10/25/14.
//
//

#import "AddressCell.h"

@implementation AddressCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configureCell];
    }
    return self;
}

- (void)configureCell
{
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Street label.
    self.streetLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 5.0, self.size.width - 30.0, 17)];
    self.streetLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.streetLabel.font = [UIFont fontWithName:@"HelveticaNeueCyr-Roman" size:17];
    self.streetLabel.textAlignment = NSTextAlignmentLeft;
    self.streetLabel.textColor = [UIColor colorWithColorCode:@"000000"];
    [self addSubview:self.streetLabel];
    
    // Info label.
    self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 25, self.size.width - 30.0, 15)];
    self.infoLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.infoLabel.font = [UIFont fontWithName:@"HelveticaNeueCyr-Roman" size:15];
    self.infoLabel.textAlignment = NSTextAlignmentLeft;
    self.infoLabel.textColor = [UIColor colorWithColorCode:@"8e8a8a"];
    [self addSubview:self.infoLabel];
    
}

+ (CGFloat)height
{
    return 44.0;
}

@end
