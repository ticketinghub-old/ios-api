//
//  TXHTicketingHubClient.h
//  iOS-api
//
//  Created by Abizer Nasir on 23/10/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

@import Foundation;

#import "TXHAPIError.h"

@class NSManagedObjectContext;
@class TXHUser;

@interface TXHTicketingHubClient : NSObject

/** The main managed object context.
 
 This is meant to be the read-only context for the application that runs on the main thread. Network fetches are made on a background queues and saves are made to an import context and changes are merged to the main context within this library.
 */
@property (strong, readonly, nonatomic) NSManagedObjectContext *managedObjectContext;

/** A Boolean value indicating whether the network activity indicator is shown automatically
 
 The default value is NO.
 */
@property (assign, nonatomic) BOOL showNetworkActivityIndicatorAutomatically;

/** The designated initialiser

 Creates a client that uses the managed object model from the iOS-api-Model bundle
 
 @param storeURL The URL to use for the persistent store. Will be created if it does not exist.
        Pass `nil` to use an in-memory-store.
 @returns An initialised TXHTicketingHubClient.
 */
- (id)initWithStoreURL:(NSURL *)storeURL;

/** Set the "Accept-Language" header for subsequent network call
 *  @param identifier the string identifier of the language, e.g "en-GB"
 */
- (void)setDefaultAcceptLanguage:(NSString *)identifier;

/** Fetches the suppliers and the associated user from the login parameters

 On a successful login the `updateUser:completion:` method is called in the background.
 
 @param username The username
 @param password The password
 @param completion The completion block to run when the fetch is completed. This parameter cannot be nil.
        The completion block takes two parameters; an array of TXHSuppliers (in the main managed object context) and an error parameter. The error is `nil` for successful requests, On error, this contains an NSError object and the suppliers array is `nil`;
 */

- (void)fetchSuppliersForUsername:(NSString *)username password:(NSString *)password withCompletion:(void(^)(NSArray *suppliers, NSError *error))completion __attribute__((nonnull));

/** Fetches the user details for a TXHUser object

 The basic TXHUser object is created at login with just the email address, this fetches the fields required to create the full name. It uses an access token from a random object from it's list of suppliers.
 
 @param user the partially created TXHUser object
 */
- (void)updateUser:(TXHUser *)user completion:(void(^)(TXHUser *user, NSError *error))completion __attribute__((nonnull));


@end
