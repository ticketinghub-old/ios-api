//
//  TestsHelper.h
//  iOS-api
//
//  Created by Abizer Nasir on 21/11/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//
//  Convenience methods for using CorData with the tests

@import Foundation;
@import CoreData;

@interface TestsHelper : NSObject

/** A managed object context for running tests

 @return An in-memory managed object context
 */
+ (NSManagedObjectContext *)managedObjectContextForTests;

/** Gets a collection from a json file in the tests bundle

 @param fileNamewithoutExtension The name of the file in the test bundle. Expected to have .json as the extension

 @return A collection object from the JSON or nil if it couldn't be loaded
 */
+ (id)objectFromJSONFile:(NSString *)fileNameWithoutExtension;

@end
