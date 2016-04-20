//
//  Accelerometer.m
//  
//
//  Created by Cezar Babin on 4/5/16.
//
//

#import "Accelerometer.h"
#import <MetaWear/MetaWear.h>

@interface Accelerometer()
@property (nonatomic) NSArray *devices;
@end

@implementation Accelerometer


@synthesize delegate;

-(id)init {
    self = [super init];
    return self;
}

-(void)connectDevice {
    [[MBLMetaWearManager sharedManager] startScanForMetaWearsWithHandler:^(NSArray *array) {
        NSLog(@"An accelerometer was connected");
        [[MBLMetaWearManager sharedManager] stopScanForMetaWears];
        MBLMetaWear *device = [array firstObject];
        self.devices = array;
        [device connectWithHandler:^(NSError *error) {
            if (!error) {
                NSLog(@"%d", [self.devices count]);
                [delegate deviceConnected:self withData:@"Connection established"];
                [self startStreaming];
                
            }
        }];
    }];
    
}

-(void)startStreaming {
    MBLMetaWear *device = [self.devices firstObject];
    NSLog(@"Streaming");
    if (device.isGuestConnection) {
        NSLog(@"WARNING - guest app, are you sure you want to continue?  Call [device setConfiguration:nil handler:nil] if you wish to take ownership.");
        [device setConfiguration:nil handler:nil];
    } else {
        NSLog(@"Not a guest");
    }
    
    [device.accelerometer.rmsDataReadyEvent startNotificationsWithHandlerAsync:^(MBLRMSAccelerometerData *obj, NSError *error) {
        NSLog(@"yes");
        [delegate locationManager:self didUpdateData:obj];
    }];
    
}


@end
