//
//  Place.h
//  TaxiFriday
//
//  Created by Valik Kuchinsky on 01.11.14.
//
//

#import <Foundation/Foundation.h>

@interface Place : NSObject

@property NSString *street;
@property NSString *building;
@property NSString *name;
@property NSString *city;
@property NSInteger addressID;
@property NSString *code;

+ (NSArray*)objectsWithArray:(NSArray*)source;
- (instancetype)initWithDictionary:(NSDictionary*)dict;

@end
