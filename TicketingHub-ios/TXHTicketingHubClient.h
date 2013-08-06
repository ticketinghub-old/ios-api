//
//  TXHTicketingHubClient.h
//  TicketingHub-ios
//
//  Created by Abizer Nasir on 01/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

@import Foundation;

@class TXHUser;

@interface TXHTicketingHubClient : NSObject

/*! Singleton initialiser
 *  \returns the singleton instance of the client
 */
+ (instancetype)sharedClient;

/*! Set the "Accept-Language" header for subsequent network callso
 *  \param identifier the string identifier of the language, e.g "en-GB"
 */
- (void)setDefaultAcceptLanguage:(NSString *)identifier;

/*! Configure the client with the access token and the refresh token, which performs the server request.
 *  \param username the username
 *  \param password the password
 *  \param clientId the clientId
 *  \param clientSecret clientSecret
 *  \param success a block to perform on success. It has no return and takes three parameters, the NSURLRequest, and the NSHTTPURLResponse returned by the server. The dictionary is not returned as the token and refresh token are kept internally.
 *  \param error a block to perform on failure. It has no return and takes three parameters, the NSHTTPURLResponse, an NSError describing the error, and the JSON object returned by the server (which could be an NSArray or a NSDictionary)
 */
- (void)configureWithUsername:(NSString *)username
                     password:(NSString *)password
                     clientId:(NSString *)clientId
                 clientSecret:(NSString *)clientSecret
                      success:(void(^)(NSURLRequest *request, NSHTTPURLResponse *response))successBlock
                        error:(void(^)(NSHTTPURLResponse *response, NSError *error, id JSON))errorBlock;

- (void)userInformationSuccess:(void(^)(TXHUser *user))successBlock error:(void(^)(NSHTTPURLResponse *response, NSError *error, id JSON))errorBlock;

@end