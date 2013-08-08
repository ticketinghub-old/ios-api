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

/*! Whether or not the activity indicator is shown and hidden automatically for network requests
 *  By default this is turned turned off.
 */
@property (assign, nonatomic) BOOL showActivityIndicatorAutomatically;

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
 *  \param successBlock a block to perform on success. It has no return and takes three parameters, the NSURLRequest, and the NSHTTPURLResponse returned by the server. The dictionary is not returned as the token and refresh token are kept internally.
 *  \param failureBlock a block to perform on failure. It has no return and takes three parameters, the NSHTTPURLResponse, an NSError describing the error, and the JSON object returned by the server (which could be an NSArray or a NSDictionary)
 */
- (void)configureWithUsername:(NSString *)username
                     password:(NSString *)password
                     clientId:(NSString *)clientId
                 clientSecret:(NSString *)clientSecret
                      success:(void(^)(NSURLRequest *request, NSHTTPURLResponse *response))successBlock
                        failure:(void(^)(NSHTTPURLResponse *response, NSError *error, id JSON))failureBlock;

- (void)userInformationSuccess:(void(^)(TXHUser *user))successBlock failure:(void(^)(NSHTTPURLResponse *response, NSError *error, id JSON))failureBlock;

- (void)venuesWithSuccess:(void(^)(NSArray *venues))successBlock failure:(void(^)(NSHTTPURLResponse *response, NSError *error, id JSON))failureBlock;
@end