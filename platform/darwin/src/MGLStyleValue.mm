#import "MGLStyleValue_Private.h"

@implementation MGLStyleValue

+ (instancetype)valueWithRawValue:(id)rawValue {
    return [MGLStyleConstantValue valueWithRawValue:rawValue];
}

+ (instancetype)valueWithBase:(CGFloat)base stops:(NSDictionary *)stops {
    return [MGLStyleFunction functionWithBase:base stops:stops];
}

+ (instancetype)valueWithStops:(NSDictionary *)stops {
    return [MGLStyleFunction functionWithStops:stops];
}

+ (instancetype)valueWithIntervalStops:(NSDictionary *)stops {
    return [MGLStyleIntervalFunction functionWithIntervalStops:stops];
}

+ (instancetype)valueWithAttributeName:(NSString *)attributeName categoricalStops:(NSDictionary *)categoricalStops defaultValue:(id)defaultValue {
    return [MGLStyleSourceFunction functionWithAttributeName:attributeName categoricalStops:categoricalStops defaultValue:defaultValue];
}

@end

@implementation MGLStyleConstantValue

+ (instancetype)valueWithRawValue:(id)rawValue {
    return [[self alloc] initWithRawValue:rawValue];
}

- (instancetype)initWithRawValue:(id)rawValue {
    if (self = [super init]) {
        _rawValue = rawValue;
    }
    return self;
}

- (NSString *)description {
    return [self.rawValue description];
}

- (NSString *)debugDescription {
    return [self.rawValue debugDescription];
}

- (BOOL)isEqual:(MGLStyleConstantValue *)other {
    return [other isKindOfClass:[self class]] && [other.rawValue isEqual:self.rawValue];
}

- (NSUInteger)hash {
    return [self.rawValue hash];
}

@end

@implementation MGLStyleFunction

+ (instancetype)functionWithBase:(CGFloat)base stops:(NSDictionary *)stops {
    return [[self alloc] initWithBase:base stops:stops];
}

+ (instancetype)functionWithStops:(NSDictionary *)stops {
    return [[self alloc] initWithBase:1 stops:stops];
}

- (instancetype)init {
    return [self initWithBase:1 stops:@{}];
}

- (instancetype)initWithBase:(CGFloat)base stops:(NSDictionary *)stops {
    if (self = [super init]) {
        if (!stops.count)
        {
            [NSException raise:NSInvalidArgumentException format:@"%@ requires at least one stop.", self];
        }
        _base = base;
        _stops = stops;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, base = %f; stops = %@>",
            NSStringFromClass([self class]), (void *)self,
            self.base,
            self.stops];
}

- (BOOL)isEqual:(MGLStyleFunction *)other {
    return ([other isKindOfClass:[self class]] && other.base == self.base
            && [other.stops isEqualToDictionary:self.stops]);
}

- (NSUInteger)hash {
    return self.base + self.stops.hash;
}

@end

@implementation MGLStyleIntervalFunction

#pragma mark Creating a Style Interval Function

+ (instancetype)functionWithIntervalStops:(NSDictionary *)stops {
    return [[self alloc] initWithIntervalStops:stops];
}

#pragma mark Initializing a Style Interval Function

- (instancetype)init {
    return [self initWithIntervalStops:@{}];
}

- (instancetype)initWithIntervalStops:(NSDictionary *)stops {
    if (self == [super init]) {
        _stops = stops;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, stops = %@>", NSStringFromClass([self class]), (void *)self, self.stops];
}

- (BOOL)isEqual:(MGLStyleIntervalFunction *)other {
    return ([other isKindOfClass:[self class]] && [other.stops isEqualToDictionary:self.stops]);
}

- (NSUInteger)hash {
    return self.stops.hash;
}

@end

@implementation MGLStyleSourceFunction

#pragma mark Creating a Style Interval Function

+ (instancetype)functionWithAttributeName:(NSString *)attributeName categoricalStops:(NSDictionary *)categoricalStops defaultValue:(id)defaultValue {
    return [[self alloc] initWithAttributeName:attributeName categoricalStops:categoricalStops defaultValue:defaultValue];
}

#pragma mark Initializing a Style Interval Function

- (instancetype)init {
    return [self initWithAttributeName:@"" categoricalStops:@{} defaultValue:nil];
}

- (instancetype)initWithAttributeName:(NSString *)attributeName categoricalStops:(NSDictionary *)categoricalStops defaultValue:(id)defaultValue {
    if (self == [super init]) {
        _attributeName = attributeName;
        _categoricalStops = categoricalStops;
        _defaultValue = defaultValue;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, attributeName = %@, \
                                                 categoricalStops = %@ \
                                                 defaultValue = %@>",
            NSStringFromClass([self class]),
            (void *)self, self.attributeName, self.categoricalStops, self.defaultValue];
}

- (BOOL)isEqual:(MGLStyleSourceFunction *)other {
    return ([other isKindOfClass:[self class]] &&
            [other.attributeName isEqual:self.attributeName] &&
            [other.categoricalStops isEqualToDictionary:self.categoricalStops] &&
            [other.defaultValue isEqual:self.defaultValue]);
}

- (NSUInteger)hash {
    return self.attributeName.hash + self.categoricalStops.hash + self.defaultValue.hash;
}

@end
