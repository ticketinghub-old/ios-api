//
//  TXHUserSpec.m
//  TicketingHub-ios
//
//  Created by Abizer Nasir on 06/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#define EXP_SHORTHAND

#import "Specta.h"
#import "Expecta.h"

#import "TXHUser.h"

SpecBegin(TXHUser)

__block NSDictionary *_parameters;

NSString * const _firstName = @"First";
NSString * const _lastName = @"Last";
NSString * const _email = @"somebody@somewhere.net";

before(^{
    _parameters = @{@"first_name" : _firstName, @"last_name" : _lastName, @"email" : _email};
});

describe(@"description method", ^{
    __block TXHUser *_user;

    before(^{
        _user = [[TXHUser alloc] init];
        [_user setValue:_firstName forKey:@"firstName"];
        [_user setValue:_lastName forKey:@"lastName"];
        [_user setValue:_email forKey:@"email"];
    });

    after(^{
        _user = nil;
    });

    it(@"provides values for all the properties", ^{
        NSString *expectedDescription = [NSString stringWithFormat:@"firstName: %@, lastName: %@, email: %@", _firstName, _lastName, _email];
        expect([_user description]).to.equal(expectedDescription);
    });
});



describe(@"Creation", ^{
    context(@"with a full set of parameters", ^{

        it(@"sets up all the properties from the parameters", ^{
            TXHUser *user = [TXHUser createWithDictionary:_parameters];
            expect(user.firstName).to.equal(_firstName);
            expect(user.lastName).to.equal(_lastName);
            expect(user.email).to.equal(_email);
        });
    });

    context(@"with an extra key/value pair", ^{
        before(^{
            NSDictionary *newParameters = [_parameters mutableCopy];
            [newParameters setValue:@"Foo" forKey:@"Bar"];
            _parameters = newParameters;
        });

        it(@"does not throw an exception", ^{
            expect(^{[TXHUser createWithDictionary:_parameters];}).toNot.raiseAny();
        });
    });
});

SpecEnd
