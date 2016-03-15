//
//  ViewController.m
//  EVENT DEMO
//
//  Created by Sagar Shirbhate on 05/06/15.
//  Copyright (c) 2015 Sagar Shirbhate. All rights reserved.
//

#import "ViewController.h"
#import <EventKit/EventKit.h>

@interface ViewController ()
{
    NSString * eventId;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
// To add event in Calender App
    
    EKEventStore *store = [EKEventStore new];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted) { return; }
        EKEvent *event = [EKEvent eventWithEventStore:store];
        event.title = @"To meet Chandu.";
        event.startDate = [NSDate date]; //today
        event.endDate = [event.startDate dateByAddingTimeInterval:60*60];  //set 1 hour meeting
        event.calendar = [store defaultCalendarForNewEvents];
        event.location=@"Sandriver Technologies";
        NSError *err = nil;
        [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
        NSLog(@"%@",event.eventIdentifier);  //save the event id if you want to access this later
        eventId=event.eventIdentifier;
    }];
    
    
    
    //to remove event from app
    
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted) { return; }
        EKEvent* eventToRemove = [store eventWithIdentifier:eventId];
        if (eventToRemove) {
            NSError* error = nil;
            [store removeEvent:eventToRemove span:EKSpanThisEvent commit:YES error:&error];
        }
    }];
    
    
    
// Note: Get all event list
    
  //To get Appropriate calender
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    
    if ([store respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        /* iOS Settings > Privacy > Calendars > MY APP > ENABLE | DISABLE */
        [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
         {
             if ( granted )
             {
                 NSLog(@"User has granted permission!");
                 // Create the start date components
                 NSDateComponents *oneDayAgoComponents = [[NSDateComponents alloc] init];
                 oneDayAgoComponents.day = -1;
                 NSDate *oneDayAgo = [calendar dateByAddingComponents:oneDayAgoComponents
                                                               toDate:[NSDate date]
                                                              options:0];
                 
                 // Create the end date components
                 NSDateComponents *oneYearFromNowComponents = [[NSDateComponents alloc] init];
                 oneYearFromNowComponents.year = 1;
                 NSDate *oneYearFromNow = [calendar dateByAddingComponents:oneYearFromNowComponents
                                                                    toDate:[NSDate date]
                                                                   options:0];
                 
                 // Create the predicate from the event store's instance method
                 NSPredicate *predicate = [store predicateForEventsWithStartDate:oneDayAgo
                                                                         endDate:oneYearFromNow
                                                                       calendars:nil];
                 
                 // Fetch all events that match the predicate
                 NSArray *events = [store eventsMatchingPredicate:predicate];
                 NSLog(@"The content of array is%@",events);
             }
             else
             {
                 NSLog(@"User has not granted permission!");
             }
         }];
    }
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
