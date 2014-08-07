//
//  NSError+TXHPrinters.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 28/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "NSError+TXHAPIClient.h"

NSString * const TXHAPIClientErrorDomain = @"TXHAPIClientErrorDomain";

@implementation NSError (TXHAPIClient)

+ (NSError *)clientErrorWithCode:(TXHAPIClientErrorCode)errorCode;
{
    NSDictionary *userInfo = [self userInfoWithCode:errorCode];
    return [NSError errorWithDomain:TXHAPIClientErrorDomain
                               code:errorCode
                           userInfo:userInfo];
}

+ (NSDictionary *)userInfoWithCode:(TXHAPIClientErrorCode)errorCode
{
    return @{NSLocalizedDescriptionKey:             [self localizedDescriptionForErrorCode:errorCode],
             NSLocalizedFailureReasonErrorKey:      [self localizedFailureReasonErrorCode:errorCode],
             NSLocalizedRecoverySuggestionErrorKey: [self localizedRecoverySuggestionForErrorCode:errorCode]
             };
}

+ (NSString *)localizedDescriptionForErrorCode:(TXHAPIClientErrorCode)errorCode
{
    switch (errorCode)
    {
        case kTXHAPIClientArgsInconsistencyError:
            return @"kTXHPrinterArgsInconsistencyError";
            
    }
    
    return NSLocalizedString(@"PRINTER_ERROR_UNKNOWN_DESC", nil);
}

+ (NSString *)localizedFailureReasonErrorCode:(TXHAPIClientErrorCode)errorCode
{
    switch (errorCode)
    {
        case kTXHAPIClientArgsInconsistencyError:
            return @"kTXHPrinterArgsInconsistencyError";
            
    }
    
    return NSLocalizedString(@"PRINTER_ERROR_UNKNOWN_REASON", nil);
}

+ (NSString *)localizedRecoverySuggestionForErrorCode:(TXHAPIClientErrorCode)errorCode
{
    switch (errorCode)
    {
        case kTXHAPIClientArgsInconsistencyError:
            return @"kTXHPrinterArgsInconsistencyError";
            
    }
    
    return NSLocalizedString(@"PRINTER_ERROR_UNKNOWN_RECOVERY", nil);
}

@end
