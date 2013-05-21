#import <Foundation/Foundation.h>

#define PS_TYPE_ARRAY @"array"
#define PS_TYPE_BOOL @"bool"
#define PS_TYPE_COLOR @"color"
#define PS_TYPE_DATA @"data"
#define PS_TYPE_DATE @"date"
#define PS_TYPE_DICTIONARY @"dictionary"
#define PS_TYPE_FLOAT @"float"
#define PS_TYPE_INTEGER @"integer"
#define PS_TYPE_STRING @"string"

/**
 `PersistedState` is a wrapper for `NSUserDefaults`. It is intended to be subclassed to group together related values that need to be persisted between sessions.
 
 Because we're using `NSUserDefaults`, not all types can be persisted. See the `PS_TYPE_X` constants in this file for which types are supported.
 
 Subclasses must implement `getDefaults` to define the keys that make up the class and their default values.
 
 To add a property, one must simply declare it in the .h file and add it to the dictionary returned by `getDefaults`.
 
 Subclasses should be singletons.
 */
@interface PersistedState : NSObject

/**
 An abstract method that defines (in the form of a dictionary that is returned) the properties that need to be persisted, and their defaults.
 
 The keys in the dictionary returned are the names of the properties (strings, must match the property names exactly). The values are arrays
 where the first element is the type of the property (one of the `PS_TYPE_X` constants in this file) and the second element is the default value
 for the property.
 
 @return `NSDictionary` of strings to arrays.
 */
- (NSDictionary *)getDefaults;
- (void)registerDefaults;
- (void)loadState;
- (void)saveState;

@end