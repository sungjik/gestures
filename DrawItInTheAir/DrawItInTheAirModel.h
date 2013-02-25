//
//  DrawItInTheAirModel.h
//  DrawItInTheAir
//
//  Created by Sung Jik Cha on 11/24/12.
//  Copyright (c) 2012 Sung Jik Cha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrawItInTheAirModel : NSObject {
    @private
    NSMutableDictionary* _databaseX;
    NSMutableDictionary* _databaseY;
    NSMutableDictionary* _databaseZ;

}

-(id)init;
-(void)discreteNormalization:(NSMutableArray*)ts;
-(NSMutableArray*)uniformScaling:(NSMutableArray*) ts1: (NSMutableArray*)ts2;
-(void)addTimeSeriesX:(NSMutableArray*)ts :(NSString*)key;
-(void)addTimeSeriesY:(NSMutableArray*)ts :(NSString*)key;
-(void)addTimeSeriesZ:(NSMutableArray*)ts :(NSString*)key;
-(NSString*)findBestMatch:(NSMutableArray*)queryX :(NSMutableArray*)queryY :(NSMutableArray*)queryZ;
-(void)reset;
-(void)printDatabaseKeys;
-(NSArray *)databaseKeys;
-(void)printTimeSeries:(NSMutableArray*)ts;
-(double)euclideanDistance:(NSMutableArray*)ts1 :(NSMutableArray*)ts2;

@end
