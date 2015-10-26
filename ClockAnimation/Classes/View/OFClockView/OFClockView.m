//
//  OFClockView.m
//  ClockAnimation
//
//  Created by Admin on 24.10.15.
//  Copyright (c) 2015 OlhaF. All rights reserved.
//

#import "OFClockView.h"

@interface OFClockView ()

@property (strong, nonatomic) NSCalendar * calendar;
@property (strong, nonatomic) NSDate * currentDate;
@property (strong, nonatomic) NSTimer * timer;

@end

@implementation OFClockView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGRect imageViewFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        
        _clockFaceImageView = [[UIImageView alloc] initWithFrame: imageViewFrame];
        _hourHandImageView = [[UIImageView alloc] initWithFrame: imageViewFrame];
        _minuteHandImageView = [[UIImageView alloc] initWithFrame: imageViewFrame];
        _secondsHandImageView = [[UIImageView alloc] initWithFrame: imageViewFrame];
        
        [self addSubview: _clockFaceImageView];
        [self addSubview: _hourHandImageView];
        [self addSubview: _minuteHandImageView];
        [self addSubview: _secondsHandImageView];
    }
    
    _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    return  self;
}

- (void)start
{

    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                 target:self
                                               selector:@selector(updateTime)
                                               userInfo:nil
                                                repeats:YES];
}

- (void)updateTime
{
   self.currentDate = [NSDate date];

    [UIView animateWithDuration:1.0f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^ {
                         [self updateHoursHand];
                         [self updateMinutesHand];
                         [self updateSecondsHand];
                     }
                     completion:nil];  
}

- (void)updateHoursHand
{
    NSInteger degreesPerHour   = 30;
    NSInteger degreesPerMinute = 6;
    
    double degreesForHours = ([self hours] % 12) * degreesPerHour;
    double degreesForMinutes = ([self minutes] / 12) * degreesPerMinute;
    double totalDegrees = degreesForHours + degreesForMinutes;
    
    double hourRadianAngle = totalDegrees * M_PI / 180;
    
    self.hourHandImageView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, hourRadianAngle);
}

- (void)updateMinutesHand
{
    NSInteger degreesPerMinute = 6;
    double degreesPerSecond = 1.2f;
    
    double degreesForMinutes = [self minutes] * degreesPerMinute;
    double degreesForSeconds = ([self seconds] / 12) * degreesPerSecond;
    double totalDegrees = degreesForMinutes+degreesForSeconds;

    double minutesRadianAngle = totalDegrees * M_PI / 180;
    
    self.minuteHandImageView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, minutesRadianAngle);
}

- (void)updateSecondsHand
{
    NSInteger degreesPerSecond = 6;
    
    double secondsRadianAngle = ([self seconds] * degreesPerSecond)* M_PI / 180;
    
    self.secondsHandImageView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, secondsRadianAngle);
}


- (NSInteger) hours
{
    return [self.calendar component:NSCalendarUnitHour fromDate:self.currentDate];
}

- (NSInteger) minutes
{
    return [self.calendar component:NSCalendarUnitMinute fromDate:self.currentDate];
}

- (NSInteger) seconds
{
    return [self.calendar component:NSCalendarUnitSecond fromDate:self.currentDate];
}


@end
