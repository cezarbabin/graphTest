//
//  Accelerometer.h
//  
//
//  Created by Cezar Babin on 4/5/16.
//
//

#import <Foundation/Foundation.h>
#import <MetaWear/MetaWear.h>

@class Accelerometer;

@protocol AccelerometerDelegate

-(void)deviceConnected:(Accelerometer *)accelerometer withData:(NSString *) data;
-(void)locationManager:(Accelerometer *)accelerometer didUpdateData:(MBLRMSAccelerometerData *)dataStream;

@end


@interface Accelerometer : NSObject {
    
}

@property (nonatomic, assign) id  delegate;

// define public functions
-(void)connectDevice;
-(void)startStreaming;

@end
