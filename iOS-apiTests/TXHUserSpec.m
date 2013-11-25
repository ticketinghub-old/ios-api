//
//  TXHUserSpec.m
//  iOS-api
//
//  Created by Abizer Nasir on 25/11/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHUser.h"
#import "CoreDataTestsHelper.h"

SpecBegin(TXHUser)

__block NSManagedObjectContext *_moc;
__block NSDictionary *_userDictionary;

beforeAll(^{
    _moc = [CoreDataTestsHelper managedObjectContextForTests];
    _userDictionary = @{@"email" : @"abc@gmail.com",
                        @"first_name" : @"firstName",
                        @"last_name" : @"lastName",
                        @"id" : @"11"};
});

afterAll(^{
    _userDictionary = nil;
    _moc = nil;
});

describe(@"createWithDictionary:inManagedObjectContext:", ^{
    context(@"with a complete dictionary", ^{
        it(@"returns a valid object", ^{
            TXHUser *user = [TXHUser createWithDictionary:_userDictionary inManagedObjectContext:_moc];
            expect(user).to.beKindOf([TXHUser class]);
            expect(user.userId).to.equal(@"11");
            expect(user.email).to.equal(@"abc@gmail.com");
            expect(user.firstName).to.equal(@"firstName");
            expect(user.lastName).to.equal(@"lastName");
        });
    });

    context(@"with just an email address", ^{
        it(@"returns a valid object", ^{
            TXHUser *user = [TXHUser createWithDictionary:@{@"email" : @"cde@gmail.com"} inManagedObjectContext:_moc];
            expect(user.email).to.equal(@"cde@gmail.com");
            expect(user.userId).to.beNil();
            expect(user.firstName).to.beNil();
            expect(user.lastName).to.beNil();
        });
    });

    context(@"with an empty dictionary", ^{
        it(@"returns a nil", ^{
            TXHUser *user = [TXHUser createWithDictionary:@{} inManagedObjectContext:_moc];
            expect(user).to.beNil();
        });
    });

});



SpecEnd
