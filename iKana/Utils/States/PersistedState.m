#import "PersistedState.h"
#import "UIColor-Expanded.h"

@implementation PersistedState

- (NSDictionary *)getDefaults
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (void)registerDefaults
{
    NSMutableDictionary *newDefaults = [NSMutableDictionary dictionary];
    NSDictionary *defaults = [self getDefaults];
    for (NSString *key in defaults)
    {
        NSAssert([defaults[key] count] == 2, @"Missing default state value.");
        id value = defaults[key][1];
        if (value != (id)[NSNull null]) [newDefaults setValue:value forKey:key]; // don't register defaults that are nil (that's the default anyway)
    }
    [[NSUserDefaults standardUserDefaults] registerDefaults:newDefaults];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadState
{
    [self registerDefaults];
    
    NSDictionary *defaults = [self getDefaults];
    for (NSString *key in defaults)
    {
        NSAssert([defaults[key] count] == 2, @"Missing default state value.");
        NSString *type = defaults[key][0];
        id value = nil;
        if ([type isEqualToString:PS_TYPE_ARRAY])
        {
            value = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:key]];
        }
        else if ([type isEqualToString:PS_TYPE_BOOL])
        {
            value = @([[NSUserDefaults standardUserDefaults] boolForKey:key]);
        }
        else if ([type isEqualToString:PS_TYPE_COLOR])
        {
            value = [UIColor colorWithString:[[NSUserDefaults standardUserDefaults] stringForKey:key]];
        }
        else if ([type isEqualToString:PS_TYPE_DATA])
        {
            value = [[NSUserDefaults standardUserDefaults] dataForKey:key];
        }
        else if ([type isEqualToString:PS_TYPE_DATE])
        {
            value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
        }
        else if ([type isEqualToString:PS_TYPE_DICTIONARY])
        {
            value = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:key]];
        }
        else if ([type isEqualToString:PS_TYPE_FLOAT])
        {
            value = @([[NSUserDefaults standardUserDefaults] floatForKey:key]);
        }
        else if ([type isEqualToString:PS_TYPE_INTEGER])
        {
            value = @([[NSUserDefaults standardUserDefaults] integerForKey:key]);
        }
        else if ([type isEqualToString:PS_TYPE_STRING])
        {
            value = [[NSUserDefaults standardUserDefaults] stringForKey:key];
        }
        else
        {
            [NSException raise:NSInternalInconsistencyException format:@"A default state value has an unknown type."];
        }
        [self setValue:value forKey:key];
    }
}

- (void)saveState
{
    NSDictionary *defaults = [self getDefaults];
    for (NSString *key in defaults)
    {
        NSAssert([defaults[key] count] == 2, @"Missing default state value.");
        NSString *type = defaults[key][0];
        id value = [self valueForKey:key];
        if ([type isEqualToString:PS_TYPE_ARRAY])
        {
            NSAssert(!value || [value isKindOfClass:[NSArray class]], @"State value for %@ should be an NSArray, was %@", key, [value class]);
            [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
        }
        else if ([type isEqualToString:PS_TYPE_BOOL])
        {
            NSAssert(!value || [value isKindOfClass:[NSNumber class]], @"State value for %@ should be an NSNumber, was %@", key, [value class]);
            [[NSUserDefaults standardUserDefaults] setBool:[value boolValue] forKey:key];
        }
        else if ([type isEqualToString:PS_TYPE_COLOR])
        {
            NSAssert(!value || [value isKindOfClass:[UIColor class]], @"State value for %@ should be a UIColor, was %@", key, [value class]);
            [[NSUserDefaults standardUserDefaults] setObject:[value stringFromColor] forKey:key];
        }
        else if ([type isEqualToString:PS_TYPE_DATA])
        {
            NSAssert(!value || [value isKindOfClass:[NSData class]], @"State value for %@ should be NSData, was %@", key, [value class]);
            [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
        }
        else if ([type isEqualToString:PS_TYPE_DATE])
        {
            NSAssert(!value || [value isKindOfClass:[NSDate class]], @"State value for %@ should be an NSDate, was %@", key, [value class]);
            [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
        }
        else if ([type isEqualToString:PS_TYPE_DICTIONARY])
        {
            NSAssert(!value || [value isKindOfClass:[NSDictionary class]], @"State value for %@ should be an NSDictionary, was %@", key, [value class]);
            [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
        }
        else if ([type isEqualToString:PS_TYPE_FLOAT])
        {
            NSAssert(!value || [value isKindOfClass:[NSNumber class]], @"State value for %@ should be an NSNumber, was %@", key, [value class]);
            [[NSUserDefaults standardUserDefaults] setFloat:[value floatValue] forKey:key];
        }
        else if ([type isEqualToString:PS_TYPE_INTEGER])
        {
            NSAssert(!value || [value isKindOfClass:[NSNumber class]], @"State value for %@ should be an NSNumber, was %@", key, [value class]);
            [[NSUserDefaults standardUserDefaults] setInteger:[value integerValue] forKey:key];
        }
        else if ([type isEqualToString:PS_TYPE_STRING])
        {
            NSAssert(!value || [value isKindOfClass:[NSString class]], @"State value for %@ should be an NSString, was %@", key, [value class]);
            [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
        }
        else
        {
            [NSException raise:NSInternalInconsistencyException format:@"A default state value has an unknown type."];
        }
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end