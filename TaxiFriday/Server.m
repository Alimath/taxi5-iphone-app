//
//  Server.m
//  TaxiFriday
//
//  Created by Stasevich Yauhen on 10/25/14.
//
//

#import "Server.h"

NSString *const ServerAddress = @"http://taxi5.by";

static BOOL kTestMode = YES;

@implementation Server

+ (Server *)sharedServer
{
    static Server *server;
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken, ^{
        server = [[Server alloc] initWithBaseURL:[NSURL URLWithString:ServerAddress]];
        server.responseSerializer = [AFJSONResponseSerializer serializer];
        [server.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        
        [requestSerializer setValue:uuid forHTTPHeaderField:@"x-device-uuid"];
        [requestSerializer setValue:@"cHuOTtDRIKROUwREEW9JuTphOYPShLOF" forHTTPHeaderField:@"x-api-token"];
        
        server.requestSerializer = requestSerializer;
    });
    return server;
}

#pragma mark - Get Addresses

- (void)getAddressesWithText:(NSString *)text
                     success:(void (^)(NSDictionary *))success
                     failure:(void (^)(NSError *))failure
{
    NSDictionary *parameters = @{
                                 @"q" : text,
                                 @"options": @{
//                                         @"escort": @(true),
//                                         @"animals": @(true),
//                                         @"test_orders": @(true)
                                         }};
    
    [self GET:@"/api/locator/search" parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *JSON) {
        success(JSON);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

#pragma mark - GetOrder

- (void)sendOrderRequestWithParameters:(NSDictionary *)parameters
                     success:(void (^)(NSDictionary *))success
                     failure:(void (^)(NSError *))failure
{
    NSString *comment;
    if ([parameters[@"porch"] length])
    {
        comment = [NSString stringWithFormat:@"Подъезд %@; %@", parameters[@"porch"], parameters[@"comment"]];
    }
    else
    {
        comment = parameters[@"comment"];
    }
    
    NSMutableDictionary *location = [@{
                               @"id" : parameters[@"addressID"],
                               @"street" : parameters[@"street"],
                               @"city" : parameters[@"city"],
                               @"code" : parameters[@"code"],
                               @"type" : @"address",
                               @"building" : parameters[@"building"],
                               @"comment" : comment
                               } mutableCopy];
    if ([parameters objectForKey:@"section"])
    {
        [location setObject:parameters[@"section"] forKey:@"section"];
    }
    
    if ([parameters objectForKey:@"porch"])
    {
        [location setObject:parameters[@"porch"] forKey:@"porch"];
    }
    
    NSArray *routeArray = @[
                            @{
                                @"name" : parameters[@"street"],
                                @"type" : @"address",
                                @"location" : location,
                                @"comment" : comment
                              },
                            @{
                                @"location" : @{}
                              }
                            ];
    

    NSDictionary *clientDictionary = @{
                                        @"phone" : parameters[@"phone"],
                                        @"name" : parameters[@"name"]
                                       };
    

    NSDictionary *requestParameters = @{
                                        @"route" : routeArray,
                                        @"client" : clientDictionary,
                                        @"owner" : @"",
                                        
                                        @"options": @{
//                                            @"escort": @(true),
//                                            @"animals": @(true),
//                                            @"test_orders": @(true)
                                            }
                                       };
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestParameters
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString;
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSLog(@"%@",jsonString);
    
    [self POST:@"/api/order" parameters:requestParameters success:^(AFHTTPRequestOperation *operation, NSDictionary *JSON)
    {
        success(JSON);
        [self saveCookies];
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        failure(error);
    }];
}

#pragma mark - approve request with parameters

- (void)approveRequestWithParameters:(NSDictionary *)parameters
                             success:(void (^)(NSDictionary *))success
                             failure:(void (^)(NSError *))failure
{
    [self loadCookies];
    NSString *address = [NSString stringWithFormat:@"/api/order/%@/%@", parameters[@"id"], parameters[@"answer"]];
    
    parameters = @{@"options": @{
//                               @"escort": @(true),
//                               @"animals": @(true),
//                               @"test_orders": @(true)
                               }};
    
    [self POST:address parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *JSON)
     {
         success(JSON);
     }
      failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         failure(error);
     }];
}

#pragma mark - get status
- (void)getStatusRequestWithParameters:(NSDictionary *)parameters
                                success:(void (^)(NSDictionary *))success
                                failure:(void (^)(NSError *))failure
{
    [self loadCookies];
//    parameters = @{@"options": @{
//                           @"escort": @(true),
//                           @"animals": @(true),
//                           @"test_orders": @(true)
//                           }};
    NSString *address = [NSString stringWithFormat:@"/api/order/%@", parameters[@"id"]];
    [self GET:address parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *JSON)
    {
        success(JSON);
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        failure(error);
    }];
}

- (void)saveCookies
{
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: cookiesData forKey: @"sessionCookies"];
    [defaults synchronize];
    
}

- (void)loadCookies
{
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey: @"sessionCookies"]];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie *cookie in cookies){
        [cookieStorage setCookie: cookie];
    }
    
}

@end
