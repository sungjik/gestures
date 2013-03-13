//
//  DrawItInTheAirViewController.h
//  DrawItInTheAir
//
//  Created by Sung Jik Cha on 11/24/12.
//  Copyright (c) 2012 Sung Jik Cha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import "DrawItInTheAirModel.h"

@interface DrawItInTheAirViewController : UIViewController <UITextFieldDelegate>

{
    @private
    DrawItInTheAirModel* _ourModel;
    NSMutableArray* _timeSeriesX;
    NSMutableArray* _timeSeriesY;
    NSMutableArray* _timeSeriesZ;
    CMMotionManager* _motionManager;

}

@property (retain, nonatomic) IBOutlet UITextField *tagTextField;
@property (retain, nonatomic) IBOutlet UILabel *resultLabel;
@property (retain, nonatomic) IBOutlet UISegmentedControl *modeControl;

-(void)addDataPointX:(NSMutableArray*)ts : (double)x;
-(void)addDataPointY:(NSMutableArray*)ts : (double)y;
-(void)addDataPointZ:(NSMutableArray*)ts : (double)z;
-(BOOL)textFieldShouldReturn:(UITextField*)textField;
-(IBAction)backgroundTouched:(id)sender;
-(IBAction)startButtonPressed:(UIButton*)sender;
-(IBAction)stopButtonPressed:(UIButton*)sender;
-(IBAction)resetButtonPressed:(UIButton*)sender;
@end
