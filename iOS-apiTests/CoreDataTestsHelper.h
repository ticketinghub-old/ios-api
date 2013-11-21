//
//  CoreDataTestsHelper.h
//  iOS-api
//
//  Created by Abizer Nasir on 21/11/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//
//  Convenience methods for using CorData with the tests

@import Foundation;
@import CoreData;

@interface CoreDataTestsHelper : NSObject

+ (NSManagedObjectContext *)managedObjectContextForTests;

@end
