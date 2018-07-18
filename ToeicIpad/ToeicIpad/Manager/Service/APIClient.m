//
//  APIClient.m
//  Test
//
//  Created by DungLM3 on 4/6/18.
//  Copyright © 2018 DungLM3. All rights reserved.
//

#import "APIClient.h"
#import "Global.h"

@implementation APIClient

+ (instancetype)sharedClient {
    static APIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[APIClient alloc] initWithBaseURL:kBaseURL_VOF];
    });
    return _sharedClient;
}

- (id)initWithBaseURL:(NSString *)url {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.baseUrl = url;
    return self;
}

- (void)callMethod:(NSString *)method withParams:(NSDictionary *)params handler:(APICompletedHandler)completion {
    NSError *error;
    
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", self.baseUrl,method]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithDictionary:params];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (error) {
                completion(nil, error);
            } else {
                completion(dictionary, nil);
            }
        } else {
            completion(nil, error);
        }
    }];
    [postDataTask resume];
}



@end
