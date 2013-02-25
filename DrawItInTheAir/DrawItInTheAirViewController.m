//
//  DrawItInTheAirViewController.m
//  DrawItInTheAir
//
//  Created by Sung Jik Cha on 11/24/12.
//  Copyright (c) 2012 Sung Jik Cha. All rights reserved.
//

#import "DrawItInTheAirViewController.h"
#import "DrawItInTheAirAppDelegate.h"

@interface DrawItInTheAirViewController ()

@end

@implementation DrawItInTheAirViewController
@synthesize resultLabel = _resultLabel;
@synthesize tagTextField = _tagTextField;
@synthesize modeControl = _modeControl;


- (void)viewDidLoad
{
    if (self) {
        _ourModel = [[DrawItInTheAirModel alloc] init];
        _motionManager = [[CMMotionManager alloc] init];
        _timeSeriesX = [[NSMutableArray alloc] init];
        _timeSeriesY = [[NSMutableArray alloc] init];
        _timeSeriesZ = [[NSMutableArray alloc] init];
        [super viewDidLoad];
        _resultLabel.text = @"Empty Database";
    }
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)dealloc {
    [_ourModel release];
    [_timeSeriesX release];
    [_timeSeriesY release];
    [_timeSeriesZ release];
    [_resultLabel release];
    [_tagTextField release];
    [_modeControl release];
    [_motionManager release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addDataPointX:(NSMutableArray*)ts : (double)x {
    NSNumber* N = [NSNumber numberWithDouble:x];
    [ts addObject:N];
}

-(void)addDataPointY:(NSMutableArray*)ts : (double)y {
    NSNumber* N = [NSNumber numberWithDouble:y];
    [ts addObject:N];
}

-(void)addDataPointZ:(NSMutableArray*)ts : (double)z {
    NSNumber* N = [NSNumber numberWithDouble:z];
    [ts addObject:N];
}

-(IBAction)startButtonPressed:(UIButton*)sender {

    if([_motionManager isMagnetometerAvailable] == YES) {
        [_timeSeriesX removeAllObjects];
        [_timeSeriesY removeAllObjects];
        [_timeSeriesZ removeAllObjects];

        NSTimeInterval updateInterval = 0.1;
        [_motionManager setMagnetometerUpdateInterval:updateInterval];
        [_motionManager startMagnetometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMMagnetometerData *magnetometerData, NSError *error) {
            [self addDataPointX:_timeSeriesX :magnetometerData.magneticField.x];
            [self addDataPointY:_timeSeriesY :magnetometerData.magneticField.y];
            [self addDataPointZ:_timeSeriesZ :magnetometerData.magneticField.z];
        }];
    }
}

-(IBAction)stopButtonPressed:(UIButton*)sender {
    if([_motionManager isMagnetometerActive] == YES) {
        [_motionManager stopMagnetometerUpdates];
        if([_modeControl selectedSegmentIndex] == 0) { //train mode
            NSMutableArray* tempX = [[NSMutableArray alloc] initWithCapacity:[_timeSeriesX count]];
            NSMutableArray* tempY = [[NSMutableArray alloc] initWithCapacity:[_timeSeriesX count]];
            NSMutableArray* tempZ = [[NSMutableArray alloc] initWithCapacity:[_timeSeriesX count]];
            for(int i = 0; i< [_timeSeriesX count]; i++) {
                [tempX addObject:[_timeSeriesX objectAtIndex:i]];
                [tempY addObject:[_timeSeriesY objectAtIndex:i]];
                [tempZ addObject:[_timeSeriesZ objectAtIndex:i]];
            }
            [_ourModel addTimeSeriesX:tempX :_tagTextField.text];
            [_ourModel addTimeSeriesY:tempY :_tagTextField.text];
            [_ourModel addTimeSeriesZ:tempZ :_tagTextField.text];
            
            [_timeSeriesX removeAllObjects];
            [_timeSeriesY removeAllObjects];
            [_timeSeriesZ removeAllObjects];
            
          //  [_ourModel printDatabaseKeys];
            NSString* message = @"Database : ";
            for(int i = 0; i < [[_ourModel databaseKeys] count]; i++) {
                message = [message stringByAppendingString: (NSString*)[[_ourModel databaseKeys] objectAtIndex:i]];
                message = [message stringByAppendingString:@", "];
            }
            _resultLabel.text = message;
        }
        else  {//test mode
            [_ourModel printDatabaseKeys];
            NSString* message2 = @"Best Match : ";
            _resultLabel.text = [message2 stringByAppendingString:[_ourModel findBestMatch:_timeSeriesX :_timeSeriesY :_timeSeriesZ]];
        }
    }
}

-(IBAction)resetButtonPressed:(UIButton *)sender {
    [_ourModel reset];
    _resultLabel.text = @"Empty Database";
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField {
    if (textField == _tagTextField) {
        [_tagTextField resignFirstResponder];
    }
    return NO;
}

-(IBAction)backgroundTouched:(id)sender {
    [_tagTextField resignFirstResponder];
}



@end
