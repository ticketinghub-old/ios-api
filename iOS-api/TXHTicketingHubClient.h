//
//  TXHTicketingHubClient.h
//  iOS-api
//
//  Created by Abizer Nasir on 23/10/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

@import Foundation;

@class NSManagedObjectContext;
@class TXHUser;
@class TXHProduct;
@class TXHOrder;
@class TXHAvailability;
@class TXHTicket;

@interface TXHTicketingHubClient : NSObject

/** The main managed object context.
 
 This is meant to be the read-only context for the application that runs on the main thread. Network fetches are made on a background queues and saves are made to an import context and changes are merged to the main context within this library.
 */
@property (strong, readonly, nonatomic) NSManagedObjectContext *managedObjectContext;

/** A Boolean value indicating whether the network activity indicator is shown automatically
 
 The default value is NO.
 */
@property (assign, nonatomic) BOOL showNetworkActivityIndicatorAutomatically;

/** The designated initialiser.

 Creates a client that uses the managed object model from the iOS-api-Model bundle.

 @param storeURL The URL to use for the persistent store. Will be created if it does not exist. Pass `nil` to use an in-memory-store.

 @return An initialised TXHTicketingHubClient.
 */
- (id)initWithStoreURL:(NSURL *)storeURL;

/** Set the "Accept-Language" header for subsequent network call

 @param identifier the string identifier of the language, e.g "en-GB"
 */
- (void)setDefaultAcceptLanguage:(NSString *)identifier;

/** Returns currently logged in user. Returns nil if no user looged in.
 
 @return currently logged in user or nil
 */
- (TXHUser *)currentUser;

/** Fetches the suppliers and the associated user from the login parameters.

 On a successful login the `updateUser:completion:` method is called in the background.
 
 @param username The username
 @param password The password
 @param completion The completion block to run when the fetch is completed. This parameter cannot be nil. The block takes two parameters; an array of TXHSuppliers (in the main managed object context) and an error parameter. The error is `nil` for successful requests. On error, this contains an NSError object and the suppliers array is `nil`;
 
 @warning `username`, `password`, and `completion` must not be nil.
 */
- (void)fetchSuppliersForUsername:(NSString *)username password:(NSString *)password withCompletion:(void(^)(NSArray *suppliers, NSError *error))completion;

/** Fetches the user details for a TXHUser object.

 The basic TXHUser object is created at login with just the email address, this fetches the fields required to create the full name. It uses an access token from a random object from it's list of suppliers.
 
 @param user the partially created TXHUser object. Can be on any context as lonimportg as it has been saved.
 @param completion The completion block to run when the user object has been updated which takes a user and an error parameter. The TXHUser object is in the main managed object context.
 
 @warning `user` or `completion` must not be `nil`.
 */
- (void)updateUser:(TXHUser *)user completion:(void(^)(TXHUser *user, NSError *error))completion;

/** Update the tiers for a product.

 @param product The product for which the tiers are to be updated - can be on any managed object context. Cannot be nil
 @param completion the completion block to run with the request is completed. The block takes two parameters, an array of TXHTiers in the (main managed object context) and an error parameter. error is `nil` for successful requests. If there is an error, this containes the error object and the tiers array is not nil (it can be empty)
 
 @warning `product` or `completion` must not be `nil`.
 */
- (void)tiersForProduct:(TXHProduct *)product completion:(void(^)(NSArray *availabilities, NSError *error))completion;

/** Update the availabilities for a product for a day or a range of days.
 
 If `from` and `to` are `nil`, the generic availabilities call is made. If only `from` is given, the availbilities for that date only are provided. If only `to` is given, the range of availabilities from today to that date is given. For the options first calls, just pass the date in the from parameter.

 @param product The product for which the availibilities are to be updated - can be on any managed object context. Cannot be nil
 @param fromDate the start date of a range query.
 @param toDate the end date of a range query.
 @param coupon string .

 @param completion the completion block to run with the request is completed. The block takes two parameters, an array of TXHAvailabilities in the (main managed object context) and an error parameter. error is `nil` for successful requests. If there is an error, this containes the error object and the availabilities array is not nil (it can be empty)
 
 
 @warning `product` or `completion` must not be `nil`.
 */
- (void)availabilitiesForProduct:(TXHProduct *)product fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate coupon:(NSString *)coupon completion:(void(^)(NSArray *availabilities, NSError *error))completion;

/** Reserves ticket for selected tiers with quantities
 
 @param tierQuantities dictionary with internaTierIds as keys and selectd quantities as values
 @param availability availability for selected tickets
 @param completion the completion block to run with the request is completed. The block takes two parameters, an order object in the (main managed object context) and an error parameter. error is `nil` for successful requests. If there is an error, this containes the error object and the order object is not nil (it can be empty)
 
 @warning `tierQuantities` or `completion` must not be `nil`.
 */
- (void)reserveTicketsWithTierQuantities:(NSDictionary *)tierQuantities availability:(TXHAvailability *)availability completion:(void(^)(TXHOrder *order, NSError *error))completion;

/** Marks provided tickets as deleted and sends the request to delete tickets from given order
 
 @param tickets array of tickets to be deleted
 @param order form which tickets should be deleted
 @param completion the completion block to run with the request is completed. The block takes two parameters, an order object in the (main managed object context) and an error parameter. error is `nil` for successful requests. If there is an error, this containes the error object and the order object is not nil (it can be empty)
 
 @warning `tickets` and `order` and completion  must not be `nil`.
 */
- (void)removeTickets:(NSArray *)tickets fromOrder:(TXHOrder *)order completion:(void(^)(TXHOrder *order, NSError *error))completion;

/** Provides an array of available upgrades for given ticket
 
 @param ticket object for which available upgrades will be fetched
 @param completion the completion block to run with the request is completed. The block takes two parameters, an upgrades array in the (main managed object context) and an error parameter. error is `nil` for successful requests. If there is an error, this containes the error object and the order object is not nil (it can be empty)
 
 @warning `ticket` or `completion` must not be `nil`.
 */
- (void)upgradesForTicket:(TXHTicket *)ticket completion:(void(^)(NSArray *upgrades, NSError *error))completion;


/** PATHes order with selected upgrades
 
 @param order object to be updated with selected upgrades
 @param upgradesInfo dictionary with ticketinfo keys and array of upgrade ids values - if in the array won appear selected before update will be deleted from its ticket
 @param completion the completion block to run with the request is completed. The block takes two parameters, an order object in the (main managed object context) and an error parameter. error is `nil` for successful requests. If there is an error, this containes the error object and the order object is not nil (it can be empty)
 
 @warning `ticket` or `completion` must not be `nil`.
 */
- (void)updateOrder:(TXHOrder *)order withUpgradesInfo:(NSDictionary *)upgradesInfo completion:(void(^)(TXHOrder *order, NSError *error))completion;

/** Provides an array of fields to fill for a given ticket
 
 @param ticket object for which available upgrades will be fetched
 @param completion the completion block to run with the request is completed. The block takes two parameters, an fields array in the (main managed object context) and an error parameter. error is `nil` for successful requests. If there is an error, this containes the error object and the firlds object is not nil (it can be empty)
 
 @warning `ticket` or `completion` must not be `nil`.
 */
- (void)fieldsForTicket:(TXHTicket *)ticket completion:(void(^)(NSArray *fields, NSError *error))completion;

/** PATHes order with provided customers info
 
 @param order object to be updated with provided info
 @param customersInfo dictionary with ticket ids as keys and customer detail dictionary as values
 @param completion the completion block to run with the request is completed. The block takes two parameters, an order object in the (main managed object context) and an error parameter. error is `nil` for successful requests. If there is an error, this containes the error object and the order object is not nil (it can be empty)
 
 @warning `order` and `customersInfo` and `completion` must not be `nil`.
 */
//customersInfo - dictionary with ticket ids as keys and customer detail dictionary as values
- (void)updateOrder:(TXHOrder *)order withCustomersInfo:(NSDictionary *)customersInfo completion:(void (^)(TXHOrder *, NSError *))completion;


/** Provides an array of reserved tickets for provided product and its availability
 
 @param product product for which tickes should be fetch
 @param availability selected availability for which tickes should be fetch
 @param query query string to search tickets  for
 @param completion the completion block to run with the request is completed. The block takes two parameters, an tickets array in the (main managed object context) and an error parameter. error is `nil` for successful requests. If there is an error, this containes the error object and the firlds object is not nil (it can be empty)
 
 @warning `product` and `availability` and `completion` must not be `nil`.
 */
- (void)ticketRecordsForProduct:(TXHProduct *)product availability:(TXHAvailability *)availability withQuery:(NSString *)query completion:(void(^)(NSArray *ricketRecords, NSError *error))completion;

@end
