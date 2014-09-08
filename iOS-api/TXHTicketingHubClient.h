//
//  TXHTicketingHubClient.h
//  iOS-api
//
//  Created by Abizer Nasir on 23/10/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSManagedObjectContext;
@class TXHAvailability;
@class TXHOrder;
@class TXHPayment;
@class TXHProduct;
@class TXHSupplier;
@class TXHTicket;
@class TXHTicketTemplate;
@class TXHUser;
@class TXHPartialResponsInfo;
@class UIImage;

typedef NS_ENUM(NSUInteger, TXHDocumentFormat) {
    TXHDocumentFormatPDF,
    TXHDocumentFormatPS,
    TXHDocumentFormatPNG,
    TXHDocumentFormatBMP
};

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
 @param serverURL base server url to which all endpoints will be concatenated. should be ended with '/' i.e.    
 
 @return An initialised TXHTicketingHubClient.
 */
- (id)initWithStoreURL:(NSURL *)storeURL andBaseServerURL:(NSURL *)serverURL;

/** Set the "Accept-Language" header for subsequent network call
    
 By default set to [[NSLocale preferredLanguages] firstObject]
 
 @param identifier the string identifier of the language, e.g "en-GB"
 */
- (void)setDefaultAcceptLanguage:(NSString *)identifier;

/** Set the Authorization token for all subsequent network calls
 
 If the given ssupplier is nil it clearAuthorizationHeader
 
 @param supplier for whis set the authorization token
 */
- (void)setAuthorizationTokenForSupplier:(TXHSupplier *)supplier;

/** Returns currently logged in user. Returns nil if no user looged in.
 
 @return currently logged in user or nil
 */
- (TXHUser *)currentUser;

/** Fetches the suppliers and the associated user from the login parameters.
 
 On a successful login the `updateUser:completion:` method is called in the background.
 
 @param username The username
 @param password The password
 @param completion The completion block to run when the fetch is completed. This parameter cannot be nil. The block takes two parameters; an access token and an error parameter. The error is `nil` for successful requests. On error, this contains an NSError object and cannot generate access token;
 
 @warning `username`, `password`, and `completion` must not be nil.
 */

- (void)generateAccessTokenForUsername:(NSString *)username password:(NSString *)password withCompletion:(void (^)(NSString *, NSError *))completion;

/** Fetches the suppliers and the associated user from the login parameters.

 On a successful login the `updateUser:completion:` method is called in the background.
 
 @param username The username
 @param accessToken The accessToken
 @param completion The completion block to run when the fetch is completed. This parameter cannot be nil. The block takes two parameters; an array of TXHSuppliers (in the main managed object context) and an error parameter. The error is `nil` for successful requests. On error, this contains an NSError object and the suppliers array is `nil`;
 
 @warning `username`, `accessToken`, and `completion` must not be nil.
 */
- (void)fetchSuppliersForUsername:(NSString *)username accessToken:(NSString *)accessToken withCompletion:(void (^)(NSArray *, NSError *))completion;

/** Fetches the products for a TXHSupplier object.
 
 The basic TXHUser object is created at login with just the email address, this fetches the fields required to create the full name. It uses an access token from a random object from it's list of suppliers.
 
 @param supplier the supplier for which products will be fetched
 @param completion The completion block to run when the suplier object has been updated which takes a suplier and an error parameter. The TXHUser object is in the main managed object context.
 
 @warning `supplier` or `completion` must not be `nil`.
 */

- (void)productsForSupplier:(TXHSupplier *)supplier withCompletion:(void (^)(TXHSupplier *supplier, NSError *error))completion;

/** Fetches the user details for a TXHUser object.

 The basic TXHUser object is created at login with just the email address, this fetches the fields required to create the full name. It uses an access token from a random object from it's list of suppliers.
 
 @param user the partially created TXHUser object. Can be on any context as lonimportg as it has been saved.
 @param accessToken the accessToken
 @param completion The completion block to run when the user object has been updated which takes a user and an error parameter. The TXHUser object is in the main managed object context.
 
 @warning `user`, `accessToken` or `completion` must not be `nil`.
 */

- (void)updateUser:(TXHUser *)user accessToken:(NSString *)accessToken completion:(void (^)(TXHUser *user, NSError *error))completion;

/** Update the tiers for a product.

 @param product The product for which the tiers are to be updated - can be on any managed object context. Cannot be nil
 @param coupon string indicating if tiers shlod be downloaded for given coupon code, nil means no coupon code
 @param completion the completion block to run with the request is completed. The block takes two parameters, an array of TXHTiers in the (main managed object context) and an error parameter. error is `nil` for successful requests. If there is an error, this containes the error object and the tiers array is not nil (it can be empty)
 
 @warning `product` or `completion` must not be `nil`.
 */
- (void)tiersForProduct:(TXHProduct *)product couponCode:(NSString *)coupon completion:(void(^)(NSArray *availabilities, NSError *error))completion;

/** List of available Coupon Codes for a given product
 
 @param product The product for which the tiers are to be updated - can be on any managed object context. Cannot be nil
 @param completion the completion block to run with the request is completed. The block takes two parameters, an array of TXHCoupon objects and an error parameter. error is `nil` for successful requests. If there is an error, this containes the error object and the coupons array is not nil (it can be empty)
 
 @warning `product` or `completion` must not be `nil`.
 */
- (void)couponCodesForPoduct:(TXHProduct *)product completion:(void(^)(NSArray *coupons, NSError *error))completion;


- (void)availableDatesForProduct:(TXHProduct *)product startDate:(NSDate *)startDate endDate:(NSDate *)endDate completion:(void(^)(NSArray *availableDates, NSError *error))completion;

- (void)availabilitiesForProduct:(TXHProduct *)product dateString:(NSString *)dateString tickets:(NSArray *)tickets completion:(void(^)(NSArray *availabilities, NSError *error))completion;
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
 @param latitude current user latitude
 @param longitude current user longitude
 @param group 'true' means you don't have to add customer details for individual tickets
 @param notify 'false" means you plan on printing the tickets and giving them to the customer directly, therefore an email/phone isn't necessary as we don't need to send the tickets to them.
 @param completion the completion block to run with the request is completed. The block takes two parameters, an order object in the (main managed object context) and an error parameter. error is `nil` for successful requests. If there is an error, this containes the error object and the order object is not nil (it can be empty)
 
 @warning `tierQuantities` or `completion` must not be `nil`.
 */
- (void)reserveTicketsWithTierQuantities:(NSDictionary *)tierQuantities availability:(TXHAvailability *)availability latitude:(float)latitude longitude:(float)longitude isGroup:(BOOL)group shouldNotify:(BOOL)notify completion:(void(^)(TXHOrder *order, NSError *error))completion;

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
- (void)availableUpgradesForTicket:(TXHTicket *)ticket completion:(void(^)(NSArray *upgrades, NSError *error))completion;

/** Provides an array of upgrades for given ticket
 
 @param ticket object for which upgrades will be fetched
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

/** PATHes order with provided payment method
 
 @param order object to be updated with provided info
 @param payment payment object
 @param completion the completion block to run with the request is completed. The block takes two parameters, an order object in the (main managed object context) and an error parameter. error is `nil` for successful requests. If there is an error, this containes the error object and the order object is not nil (it can be empty)
 
 @warning `order` and `completion` must not be `nil`.
 */
- (void)updateOrder:(TXHOrder *)order withPayment:(TXHPayment *)payment completion:(void (^)(TXHOrder *order, NSError *error))completion;

/** Provides an array of customer info fields to fill for a given order
 
 @param order object for which required customer fields will be fetched
 @param completion the completion block to run with the request is completed. The block takes two parameters, an fields array and an error parameter. error is `nil` for successful requests. If there is an error, this containes the error object and the fields object is not nil (it can be empty)
 
 @warning `order` and `completion` must not be `nil`.
 */
- (void)fieldsForOrderOwner:(TXHOrder *)order completion:(void(^)(NSArray *fields, NSError *error))completion;

/** PATHes order with provided customer (owner) info
 
 @param order object to be updated with provided info
 @param customerInfo dictionary with order owner (customer) details
 @param completion the completion block to run with the request is completed. The block takes two parameters, an order object in the (main managed object context) and an error parameter. error is `nil` for successful requests. If there is an error, this containes the error object and the order object is not nil (it can be empty)
 
 @warning `order` and `customerInfo` and `completion` must not be `nil`.
 */
//customersInfo - dictionary with ticket ids as keys and customer detail dictionary as values
- (void)updateOrder:(TXHOrder *)order withOwnerInfo:(NSDictionary *)customerInfo completion:(void (^)(TXHOrder *order, NSError *error))completion;

/** GETs a full order object to veryfi before confirmation
 
 @param order object to be updated with server data (only the orderID value is neccesary)
 @param completion the completion block to run with the request is completed. The block takes two parameters, an order object in the (main managed object context) and an error parameter. error is `nil` for successful requests. If there is an error, this containes the error object and the order object is not nil (it can be empty)
 
 @warning `order` and `completion` must not be `nil`.
 */
- (void)getOrderUpdated:(TXHOrder *)order completion:(void (^)(TXHOrder *order, NSError *error))completion;

/** confirmin th order
 
 @param order object to be confirmed (only the orderID value is neccesary)
 @param completion the completion block to run with the request is completed. The block takes two parameters, an order object in the (main managed object context) and an error parameter. error is `nil` for successful requests. If there is an error, this containes the error object and the order object is not nil (it can be empty)
 
 @warning `order` and `completion` must not be `nil`.
 */
- (void)confirmOrder:(TXHOrder *)order completion:(void (^)(TXHOrder *order, NSError *error))completion;


- (void)ticketRecordsForProduct:(TXHProduct *)product validFromDate:(NSDate *)date includingAttended:(BOOL)attended query:(NSString *)query paginationInfo:(TXHPartialResponsInfo *)info completion:(void(^)(TXHPartialResponsInfo *info, NSArray *ticketRecords, NSError *error))completion;

/** Provides an array of reserved tickets for provided product and its availability
 
 @param product product for which tickes should be fetch
 @param availability selected availability for which tickes should be fetch
 @param query query string to search tickets  for
 @param completion the completion block to run with the request is completed. The block takes two parameters, an tickets array in the (main managed object context) and an error parameter. error is `nil` for successful requests. If there is an error, this containes the error object and the firlds object is not nil (it can be empty)
 
 @warning `product` and `availability` and `completion` must not be `nil`.
 */
- (void)ticketRecordsForProduct:(TXHProduct *)product availability:(TXHAvailability *)availability withQuery:(NSString *)query completion:(void(^)(NSArray *ricketRecords, NSError *error))completion;

/** Provides tickets count for given valid date and product
 
 @param date date for which tickets count should be fetch
 @param product product for which tickets count should be fetch
 @param attendees value saying if should be returned only attendes or total count
 @param completion the completion block to run with the request is completed. The block takes two parameters, tickets count and an error parameter. error is `nil` for successful requests. If there is an error, this containes the error object and the firlds object is not nil (it can be empty)
 
 @warning `date` and `product` and `completion` must not be `nil`.
 */
- (void)getTicketsCountFromValidDate:(NSDate *)date forProduct:(TXHProduct *)product onlyAttendees:(BOOL)attendees completion:(void(^)(NSNumber *count, NSError *error))completion;

/** Provides tickets count for given order
 
 @param order order for which tickets count should be fetch
 @param completion the completion block to run with the request is completed. The block takes two parameters, an tickets count and an error parameter. error is `nil` for successful requests. If there is an error, this containes the error object and the firlds object is not nil (it can be empty)
 
 @warning `order` and `completion` must not be `nil`.
 */
- (void)getTicketsCountForOrder:(TXHOrder *)order completion:(void(^)(NSNumber *count, NSError *error))completion;

/** Provides attendees count for given order
 
 @param order order for which tickets count should be fetch
 @param completion the completion block to run with the request is completed. The block takes two parameters, an tickets count and an error parameter. error is `nil` for successful requests. If there is an error, this containes the error object and the firlds object is not nil (it can be empty)
 
 @warning `order` and `completion` must not be `nil`.
 */
- (void)getAttendeesCountForOrder:(TXHOrder *)order completion:(void(^)(NSNumber *count, NSError *error))completion;

/** Marks givent ticket as attended
 
 @param ticket that should be marked as atteneded
 @param attended value saying if ticket should be market as atteneded or unmarked
 @param product on whichc the ticket should be updated
 @param completion the completion block to run with the request is completed. The block takes two parameters, a ticket in the (main managed object context) and an error parameter. error is `nil` for successful requests. If there is an error, this containes the error object and the ticket object is nil
 
 @warning `ticket` and `product` and `completion` must not be `nil`.
 */
- (void)setTicket:(TXHTicket *)ticket attended:(BOOL)attended withProduct:(TXHProduct *)product completion:(void(^)(TXHTicket *ticket, NSError *error))completion;
- (void)setAllTicketsAttendedForOrder:(TXHOrder *)order completion:(void(^)(TXHOrder *order, NSError *error))completion;

/** Searching server db with provided ticket serial and product
 
 @param seqID ticket serial (interchange between the serial and the uuid)
 @param product on whichc the ticket should be updated
 @param completion the completion block to run with the request is completed. The block takes two parameters, a ticket in the (main managed object context) and an error parameter. error is `nil` for successful requests. If there is an error, this containes the error object and the ticket object is nil
 
 @warning `seqID` and `product` and `completion` must not be `nil`.
 */
- (void)searchForTicketWithSeqId:(NSNumber *)seqID withProduct:(TXHProduct *)product completion:(void(^)(TXHTicket *ticket, NSError *error))completion;


/** Gets a order for a given ticket
 
 @param ticket for which the order wil be fetched
 @param completion the completion block to run with the request is completed. The block takes two parameters, an order in the (main managed object context) and an error parameter. error is `nil` for successful requests. If there is an error, this containes the error object and the order object is nil
 
 @warning `ticket` and `completion` must not be `nil`.
 */
- (void)getOrderForTicket:(TXHTicket *)ticket completion:(void(^)(TXHOrder *order, NSError *error))completion;


/** Gets list of orders connected to given credit card info (msr trac from the card)
 
 @param msrInfo card msr track data string
 @param completion the completion block to run with the request is completed. The block takes two parameters, an orders array in the main managed object context and an error parameter. error is `nil` for successful requests. If there is an error, this containes the error object and the orders object is nil
 
 @warning `msrInfo` and `completion` must not be `nil`.
 */
- (void)getOrdersForCardMSRString:(NSString *)msrInfo paginationInfo:(TXHPartialResponsInfo *)info completion:(void(^)(TXHPartialResponsInfo *info, NSArray *orders, NSError *error))completion;
- (void)getOrdersForQuery:(NSString *)query paginationInfo:(TXHPartialResponsInfo *)info completion:(void(^)(TXHPartialResponsInfo *info,NSArray *orders, NSError *error))completion;

- (void)cancelOrder:(TXHOrder *)order completion:(void(^)(TXHOrder *order,NSError *error))completion;
/** Gets a receipt for given order
 
 @param order for which the receipt wil be fetched
 @param format for the receipt (pdf, png, ps)
 @param completion the completion block to run with the request is completed. The block takes two parameters, an loacl disk url to the receipt file and an error parameter. error is `nil` for successful requests. If there is an error, this containes the error object and the url object is nil
 
 @warning `order` and `completion` must not be `nil`.
 */
- (void)getReciptForOrder:(TXHOrder *)order format:(TXHDocumentFormat)format width:(NSUInteger)width dpi:(NSUInteger)dpi completion:(void(^)(NSURL *url,NSError *error))completion;

/** Gets list of available ticket templates to download
 
 @warning `completion` must not be `nil`.
 */
- (void)getTicketTemplatesCompletion:(void(^)(NSArray *templates,NSError *error))completion;


/** Gets ticket to print for given order, templet and format
 
 @param order for which the ticket wil be fetched
 @param templat in wich the ticket will be returned
 @param format for the ticket (pdf, png, ps)
 @param completion the completion block to run with the request is completed. The block takes two parameters, an loacl disk url to the tivket file and an error parameter. error is `nil` for successful requests. If there is an error, this containes the error object and the url object is nil

 @warning `order`, `template` and `completion` must not be `nil`.
 */
- (void)getTicketToPrintForOrder:(TXHOrder *)order withTemplet:(TXHTicketTemplate *)templat format:(TXHDocumentFormat)format completion:(void(^)(NSURL *url,NSError *error))completion;

/** Gets ticket image to print for given ticket, templet and format
 
 @param ticket for which the ticket image wil be fetched
 @param templat in wich the ticket will be returned
 @param format for the ticket (pdf, png, ps)
 @param completion the completion block to run with the request is completed. The block takes two parameters, a ticket image and an error parameter. error is `nil` for successful requests. If there is an error, this containes the error object and the url object is nil
 
 @warning `ticket`, `template` and `completion` must not be `nil`.
 */
- (void)getTicketImageToPrintForTicket:(TXHTicket *)ticket withTemplet:(TXHTicketTemplate *)templat dpi:(NSUInteger)dpi format:(TXHDocumentFormat)format completion:(void(^)(NSURL *url,NSError *error))completion;

/** Gets available payment gaytways
 
 @param completion the completion block to run with the request is completed. The block takes two parameters, gateways array in main managed object context and an error parameter. error is `nil` for successful requests. If there is an error, this containes the error object and the gateways object is nil
 
 @warning `completion` must not be `nil`.
 */
- (void)getPaymentGatewaysWithCompletion:(void(^)(NSArray *gateways,NSError *error))completion;

/** Gets a summary for a given user with selected format, width and dpi
 
 @param user for which the summary wil be fetched
 @param format for the summary (pdf, png, ps)
 @param width width of the summary
 @param completion the completion block to run with the request is completed. The block takes two parameters, an loacl disk url to the receipt file and an error parameter. error is `nil` for successful requests. If there is an error, this containes the error object and the url object is nil
 
 @warning `user` and `completion` must not be `nil`.
 */
- (void)getSummaryForUser:(TXHUser *)user format:(TXHDocumentFormat)format width:(NSUInteger)width dpi:(NSUInteger)dpi completion:(void(^)(NSURL *url,NSError *error))completion;

@end
