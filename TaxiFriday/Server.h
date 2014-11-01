//
//  Server.h
//  TaxiFriday
//
//  Created by Stasevich Yauhen on 10/25/14.
//
//

#import <Foundation/Foundation.h>
#import <AFHTTPRequestOperationManager.h>

@interface Server : AFHTTPRequestOperationManager

+ (Server *)sharedServer;

// Addresses
- (void)getAddressesWithText:(NSString *)text
                     success:(void (^)(NSDictionary *))success
                     failure:(void (^)(NSError *))failure;
// Order
- (void)sendOrderRequestWithParameters:(NSDictionary *)parameters
                               success:(void (^)(NSDictionary *))success
                               failure:(void (^)(NSError *))failure;


@end
