//
//  DrawItInTheAirModel.m
//  DrawItInTheAir
//
//  Created by Sung Jik Cha on 11/24/12.
//  Copyright (c) 2012 Sung Jik Cha. All rights reserved.
//

#import "DrawItInTheAirModel.h"

@implementation DrawItInTheAirModel

-(id)init {
    self = [super init];
    if (self) {
        _databaseX = [[NSMutableDictionary alloc] init];
        _databaseY = [[NSMutableDictionary alloc] init];
        _databaseZ = [[NSMutableDictionary alloc] init];

    }
    return self;
}

-(void)discreteNormalization:(NSMutableArray*)ts {
    double min = INFINITY;
    double max = -INFINITY;
    double diff = 0;
    double value = 0;
    int length = [ts count];
    NSNumber* oldValue;
    
    NSEnumerator* enumerator = [ts objectEnumerator];
    id obj;
    
    while(obj = [enumerator nextObject]) {
        value = [(NSNumber *)obj doubleValue];
        if ( value < min)
            min = value;
        if ( value > max)
            max = value;
    }
    
    diff = max - min;
    if (diff == 0) diff = 1;
    
    for (int i = 0; i<length; i++) {
        oldValue = (NSNumber *)[ts objectAtIndex:i];
        value = [oldValue doubleValue];
        NSNumber* newValue = [NSNumber numberWithDouble:round((value - min)/diff * 127)];
        [ts replaceObjectAtIndex:i withObject:newValue];
    }
}

-(NSMutableArray*)uniformScaling:(NSMutableArray*) ts1: (NSMutableArray*)ts2 {
    int length1 = [ts1 count];
    int length2 = [ts2 count];
    NSMutableArray* scaledTS;
    
    if(length1 > length2) {
        scaledTS = [[NSMutableArray alloc] init];
        for(int i = 0; i<length2; i++) {
            [scaledTS addObject: [ts1 objectAtIndex:i*length1/length2]];
        }
    }
    
    if(length2 > length1) {
        scaledTS = [[NSMutableArray alloc] init];
        for(int i = 0; i<length1; i++) {
            [scaledTS addObject: [ts2 objectAtIndex:i*length2/length1]];
        }
    }
    return scaledTS;
}

-(double)euclideanDistance:(NSMutableArray*)ts1 :(NSMutableArray*)ts2 {
    int length = [ts1 count];
    double distance = 0;
    for(int i = 0; i<length; i++) {
        distance += ([(NSNumber *) [ts2 objectAtIndex:i] doubleValue] - [(NSNumber *) [ts1 objectAtIndex:i] doubleValue]) * ([(NSNumber *) [ts2 objectAtIndex:i] doubleValue] - [(NSNumber *) [ts1 objectAtIndex:i] doubleValue]);
    }
    distance = sqrt(distance);
    return distance;
}

-(void)addTimeSeriesX:(NSMutableArray*)ts :(NSString*)key{
    [self discreteNormalization:ts];
    [_databaseX setObject:ts forKey:key];
}

-(void)addTimeSeriesY:(NSMutableArray*)ts :(NSString*)key{
    [self discreteNormalization:ts];
    [_databaseY setObject:ts forKey:key];
}

-(void)addTimeSeriesZ:(NSMutableArray*)ts :(NSString*)key{
    [self discreteNormalization:ts];
    [_databaseZ setObject:ts forKey:key];
}

-(void)printDatabaseKeys {
    NSEnumerator* enumeratorX = [_databaseX keyEnumerator];
    id k;
    while(k = [enumeratorX nextObject]) {
        NSLog(@"key : %s   length : %d\n", [(NSString *)k UTF8String], [[_databaseX objectForKey:k] count]);
        NSLog(@"Time Series X : ");
        [self printTimeSeries:[_databaseX objectForKey:k]];
        NSLog(@"Time Series Y : ");
        [self printTimeSeries:[_databaseY objectForKey:k]];
        NSLog(@"Time Series Z : ");
        [self printTimeSeries:[_databaseZ objectForKey:k]];
    }
}

-(NSString*)findBestMatch:(NSMutableArray*)queryX :(NSMutableArray*)queryY :(NSMutableArray*)queryZ {
   // [self printDatabaseKeys];
    
    [self discreteNormalization:queryX];
    [self discreteNormalization:queryY];
    [self discreteNormalization:queryZ];

    NSLog(@"Query X : ");
    [self printTimeSeries:queryX];
    NSLog(@"Query Y : ");
    [self printTimeSeries:queryY];
    NSLog(@"Query Z : ");
    [self printTimeSeries:queryZ];
    
    NSEnumerator* enumeratorX = [_databaseX keyEnumerator];
    NSMutableArray* tsX;
    NSMutableArray* tsY;
    NSMutableArray* tsZ;
    id k;
    
    double distanceX = 0;
    double distanceY = 0;
    double distanceZ = 0;
    double distanceTotal = 0;
    double bestDistance = INFINITY;
    NSString* bestKey = @"N/A";
    
    while (k = [enumeratorX nextObject]) {
        tsX = (NSMutableArray*) [_databaseX objectForKey:k];
        tsY = (NSMutableArray*) [_databaseY objectForKey:k];
        tsZ = (NSMutableArray*) [_databaseZ objectForKey:k];
        
        [self printDatabaseKeys];
        if ([tsX count] > [queryX count]) {
            NSMutableArray* scaledX = [self uniformScaling:tsX :queryX];
            NSMutableArray* scaledY = [self uniformScaling:tsY :queryY];
            NSMutableArray* scaledZ = [self uniformScaling:tsZ :queryZ];
            
            distanceX = [self euclideanDistance:scaledX :queryX];
            distanceY = [self euclideanDistance:scaledY :queryY];
            distanceZ = [self euclideanDistance:scaledZ :queryZ];
            
            [scaledX release];
            [scaledY release];
            [scaledZ release];
        }
        
        else if ([tsX count] < [queryX count]) {
            NSMutableArray* scaledX = [self uniformScaling:tsX :queryX];
            NSMutableArray* scaledY = [self uniformScaling:tsY :queryY];
            NSMutableArray* scaledZ = [self uniformScaling:tsZ :queryZ];
            
            distanceX = [self euclideanDistance:tsX :scaledX];
            distanceY = [self euclideanDistance:tsY :scaledY];
            distanceZ = [self euclideanDistance:tsZ :scaledZ];
            
            [scaledX release];
            [scaledY release];
            [scaledZ release];
        }
        
        else {
            distanceX = [self euclideanDistance:tsX :queryX];
            distanceY = [self euclideanDistance:tsY :queryY];
            distanceZ = [self euclideanDistance:tsZ :queryZ];
        }
        
        distanceTotal = distanceX + distanceY + distanceZ;
        if(distanceTotal < bestDistance) {
            bestDistance = distanceTotal;
            bestKey = (NSString*)k;
        }

    }

    return bestKey;
}

-(NSArray *)databaseKeys {
    return [_databaseX allKeys];
}


-(void)printTimeSeries:(NSMutableArray*)ts {
    NSString* s = @"";
    for (int i = 0; i < [ts count]; i++) {
        s = [s stringByAppendingString:[(NSNumber *)[ts objectAtIndex:i] stringValue]];
    }
    NSLog(@"%s\n", [s UTF8String]);
}

-(void)reset {
    NSEnumerator* enumeratorX = [_databaseX keyEnumerator];
    id k;
    while (k = [enumeratorX nextObject]) {
        NSMutableArray* tsX = (NSMutableArray*) [_databaseX objectForKey:k];
        NSMutableArray* tsY = (NSMutableArray*) [_databaseY objectForKey:k];
        NSMutableArray* tsZ = (NSMutableArray*) [_databaseZ objectForKey:k];
        [tsX release];
        [tsY release];
        [tsZ release];
    }
    [_databaseX removeAllObjects];
    [_databaseY removeAllObjects];
    [_databaseZ removeAllObjects];
}

- (void)dealloc {
    NSEnumerator* enumeratorX = [_databaseX keyEnumerator];
    id k;
    while (k = [enumeratorX nextObject]) {
        NSMutableArray* tsX = (NSMutableArray*) [_databaseX objectForKey:k];
        NSMutableArray* tsY = (NSMutableArray*) [_databaseY objectForKey:k];
        NSMutableArray* tsZ = (NSMutableArray*) [_databaseZ objectForKey:k];
        [tsX release];
        [tsY release];
        [tsZ release];
    }
    [_databaseX removeAllObjects];
    [_databaseY removeAllObjects];
    [_databaseZ removeAllObjects];
    
    [_databaseX release];
    [_databaseY release];
    [_databaseZ release];
    [super dealloc];
}

@end
