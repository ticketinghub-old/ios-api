#import "TXHTier.h"
#import "TXHDefines.h"

#import "TXHUpgrade.h"
#import "TXHProduct.h"


@interface TXHTier ()

@end


@implementation TXHTier

#pragma mark - Public

+ (instancetype)updateWithDictionaryCreateIfNeeded:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)moc {
    NSParameterAssert(moc);

    if (![dict count]) {
        return nil;
    }

    NSString *internalID = [self generateInternalIdFromDictionary:dict];
    
    TXHTier *tier = [self tierWithInternalID:internalID inManagedObjectContext:moc];

    if (!tier) {
        tier = [self createWithDictionary:dict inManagedObjectContext:moc];
    } else {
        [tier updateWithDictionary:dict];
    }


    return tier;
}

+ (instancetype)tierWithID:(NSString *)tierID inManagedObjectContext:(NSManagedObjectContext *)moc {
    NSParameterAssert(tierID);
    NSParameterAssert(moc);

    static NSPredicate *formattedPredicate = nil;
    if (!formattedPredicate) {
        formattedPredicate = [NSPredicate predicateWithFormat:@"tierId == $TIER_ID"];
    }

    NSDictionary *variables = @{@"TIER_ID": tierID};

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    [request setPredicate:[formattedPredicate predicateWithSubstitutionVariables:variables]];

    NSArray *tiers = [moc executeFetchRequest:request error:NULL];

    if (!tiers) {
        return nil;
    }

    return [tiers firstObject];
}

+ (instancetype)tierWithInternalID:(NSString *)tierInternalID inManagedObjectContext:(NSManagedObjectContext *)moc
{
    NSParameterAssert(tierInternalID);
    NSParameterAssert(moc);
    
    static NSPredicate *formattedPredicate = nil;
    if (!formattedPredicate) {
        formattedPredicate = [NSPredicate predicateWithFormat:@"internalTierId == $INTERNAL_TIER_ID"];
    }
    
    NSDictionary *variables = @{@"INTERNAL_TIER_ID": tierInternalID};
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    [request setPredicate:[formattedPredicate predicateWithSubstitutionVariables:variables]];
    
    NSArray *tiers = [moc executeFetchRequest:request error:NULL];
    
    if (!tiers) {
        return nil;
    }
    
    return [tiers firstObject];
}

+ (void)deleteTiersFromManagedObjectContext:(NSManagedObjectContext *)moc
{
    NSParameterAssert(moc);
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    
    NSArray *tiers = [moc executeFetchRequest:request error:NULL];
    
    for (TXHTier *tier in tiers)
    {
        [moc deleteObject:tier];
    }
}

#pragma mark - Private

// Create the object in the managed object context from the dictionary
+ (TXHTier *)createWithDictionary:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)moc {
    NSParameterAssert(moc);

    if (![dict isKindOfClass:[NSDictionary class]] || ![dict count])
        return nil;

    NSString *internalID = [self generateInternalIdFromDictionary:dict];
    TXHTier *tier = [TXHTier insertInManagedObjectContext:moc];
    tier.internalTierId = internalID;

    [tier updateWithDictionary:dict];

    return tier;
}

// Updates the reciever with values from the dictionary
- (void)updateWithDictionary:(NSDictionary *)dict {
    
    self.tierDescription = nilIfNSNull(dict[@"description"]);
    self.discount        = nilIfNSNull(dict[@"discount"]);
    self.tierId          = nilIfNSNull(dict[@"id"]);
    self.limit           = nilIfNSNull(dict[@"limit"]);
    self.name            = nilIfNSNull(dict[@"name"]);
    self.price           = nilIfNSNull(dict[@"price"]);
    self.size            = nilIfNSNull(dict[@"size"]);

    // If there are any current upgrades, remove them and recreate them from the dictionary
    // This is brute force for now, not sure if it will need to be optimised. Profiling will tell.
    for (TXHUpgrade *upgrade in self.upgrades) {
        [upgrade removeTiersObject:self];
        [self.managedObjectContext deleteObject:upgrade];
    }

    if (dict[@"upgrades"]) {
        NSArray *upgradeDicts = dict[@"upgrades"];
        for (NSDictionary *dict in upgradeDicts) {
            TXHUpgrade *upgrade = [TXHUpgrade createWithDictionary:dict inManagedObjectContext:self.managedObjectContext];
            [upgrade addTiersObject:self];
        }
    }
}

+ (NSString *)generateInternalIdFromDictionary:(NSDictionary *)dict
{
    NSString *tierId   = dict[@"id"];
    NSString *serial   = dict[@"serial"];
    NSNumber *price    = dict[@"price"];
    NSNumber *dicsount = dict[@"discount"];
    NSNumber *limit    = dict[@"limit"];
    NSArray *upgrades  = dict[@"upgrades"];
    
    NSString *hash = [NSString stringWithFormat:@"%@%@%@%@%@%@",tierId,serial,price,dicsount,limit,[[NSNumber numberWithInteger:upgrades.hash] stringValue]];
    
    return hash;
}


@end
