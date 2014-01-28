//
//  TXHUserSpec.m
//  iOS-api
//
//  Created by Abizer Nasir on 25/11/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHUser.h"

#define EXP_SHORTHAND
#import "Specta.h"
#import "Expecta.h"

#import "TestsHelper.h"

SpecBegin(TXHUser)

__block NSManagedObjectContext *_moc;
__block NSDictionary *_userDictionary;
__block NSDictionary *_userDictionaryEmailOnly;

beforeAll(^{
    _userDictionary = @{@"email" : @"abc@gmail.com",
                        @"first_name" : @"firstName",
                        @"last_name" : @"lastName",
                        @"id" : @"11"};
    _userDictionaryEmailOnly = @{@"email" : @"cde@gmail.com"};
});

beforeEach(^{
    _moc = [TestsHelper managedObjectContextForTests];
});

afterAll(^{
    _userDictionary = nil;
    _userDictionaryEmailOnly = nil;
});

afterEach(^{
    _moc = nil;
});

describe(@"updateWithDictionaryCreateIfNeeded:inManagedObjectContext:", ^{
    context(@"without there being an existing user with the same email address", ^{
        context(@"with a complete dictionary", ^{
            it(@"returns a valid object", ^{
                TXHUser *user = [TXHUser updateWithDictionaryCreateIfNeeded:_userDictionary inManagedObjectContext:_moc];
                expect(user).to.beKindOf([TXHUser class]);
                expect(user.userId).to.equal(@"11");
                expect(user.email).to.equal(@"abc@gmail.com");
                expect(user.firstName).to.equal(@"firstName");
                expect(user.lastName).to.equal(@"lastName");
            });
        });

        context(@"with just an email address", ^{
            it(@"returns a valid object", ^{
                TXHUser *user = [TXHUser updateWithDictionaryCreateIfNeeded:_userDictionaryEmailOnly inManagedObjectContext:_moc];
                expect(user.email).to.equal(@"cde@gmail.com");
                expect(user.userId).to.beNil();
                expect(user.firstName).to.beNil();
                expect(user.lastName).to.beNil();
            });
        });

        context(@"with an empty dictionary", ^{
            it(@"returns a nil", ^{
                TXHUser *user = [TXHUser updateWithDictionaryCreateIfNeeded:@{} inManagedObjectContext:_moc];
                expect(user).to.beNil();
            });
        });
    });

    context(@"with an existing user with the same email address", ^{
        __block TXHUser *_user;

        before(^{
            _user = [TXHUser updateWithDictionaryCreateIfNeeded:@{@"email": @"abc@gmail.com"} inManagedObjectContext:_moc];
        });
        it(@"Updates the current user", ^{
            TXHUser *newUser = [TXHUser updateWithDictionaryCreateIfNeeded:_userDictionary inManagedObjectContext:_moc];
            expect(newUser).to.equal(_user);
        });
    });

});

describe(@"fullName", ^{
    __block TXHUser *_user;

    afterEach(^{
        _user = nil;
    });

    context(@"with first name only", ^{
        before(^{
            NSMutableDictionary *dict = [_userDictionaryEmailOnly mutableCopy];
            [dict addEntriesFromDictionary:@{@"first_name": @"first"}];
            _user = [TXHUser updateWithDictionaryCreateIfNeeded:[dict copy] inManagedObjectContext:_moc];
        });

        it(@"returns the first name", ^{
            expect([_user fullName]).to.equal(@"first");
        });
    });

    context(@"with last name only", ^{
        before(^{
            NSMutableDictionary *dict = [_userDictionaryEmailOnly mutableCopy];
            [dict addEntriesFromDictionary:@{@"last_name": @"last"}];
            _user = [TXHUser updateWithDictionaryCreateIfNeeded:[dict copy] inManagedObjectContext:_moc];
        });

        it(@"returns the last name", ^{
            expect(_user.fullName).to.equal(@"last");
        });
    });

    context(@"with first and last name", ^{
        before(^{
            NSMutableDictionary *dict = [_userDictionaryEmailOnly mutableCopy];
            [dict addEntriesFromDictionary:@{@"first_name": @"first", @"last_name": @"last"}];
            _user = [TXHUser updateWithDictionaryCreateIfNeeded:[dict copy] inManagedObjectContext:_moc];
        });

        it(@"returns the full name", ^{
            expect(_user.fullName).to.equal(@"first last");
        });
    });

    context(@"with no first or last name", ^{
        beforeEach(^{
            _user = [TXHUser updateWithDictionaryCreateIfNeeded:_userDictionaryEmailOnly inManagedObjectContext:_moc];
        });

        it(@"returns the email", ^{
            expect(_user.fullName).to.equal(_userDictionaryEmailOnly[@"email"]);
        });
    });
});


SpecEnd
