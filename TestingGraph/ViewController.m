//
//  ViewController.m
//  TestingGraph
//
//  Created by Cezar Babin on 4/18/16.
//  Copyright © 2016 senio. All rights reserved.
//

#import "ViewController.h"
#import "Accelerometer.h"
#import "APLGraphView.h"


@interface ViewController () <AccelerometerDelegate>

@property NSMutableArray *arrayOfIndices;
@property NSMutableArray *arrayOfIndices2;
@property (nonatomic) BEMSimpleLineGraphView *aGraph;
@property (nonatomic) BEMSimpleLineGraphView *bGraph;
@property (nonatomic) CATextLayer *label;
@property (nonatomic) CATextLayer *label2;
@property (weak, nonatomic) IBOutlet APLGraphView *accelerometerGraph;

@property int counter;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.arrayOfIndices = [NSMutableArray array];
    self.arrayOfIndices2 = [NSMutableArray array];
    
    Accelerometer *custom = [[Accelerometer alloc] init];
    custom.delegate = self;
    [custom connectDevice];
    
    [self.accelerometerGraph setFrame:CGRectMake(0, 0, 320, 112)];
    
    
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    [circleLayer setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(20, [[UIScreen mainScreen] bounds].size.height - 150, 100, 100)] CGPath]];
    [[self.view layer] addSublayer:circleLayer];
    [circleLayer setStrokeColor:[[UIColor redColor] CGColor]];
    [circleLayer setFillColor:[[UIColor clearColor] CGColor]];
    
    CAShapeLayer *circleLayer2 = [CAShapeLayer layer];
    [circleLayer2 setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake([[UIScreen mainScreen] bounds].size.width -120, [[UIScreen mainScreen] bounds].size.height - 150, 100, 100)] CGPath]];
    [[self.view layer] addSublayer:circleLayer2];
    [circleLayer2 setStrokeColor:[[UIColor greenColor] CGColor]];
    [circleLayer2 setFillColor:[[UIColor clearColor] CGColor]];
    
    CATextLayer *label = [[CATextLayer alloc] init];
    [label setFont:@"Helvetica-Bold"];
    [label setFontSize:30];
    [label setFrame:CGRectMake(20, [[UIScreen mainScreen] bounds].size.height - 120, 100, 100)];
    [label setString:@"23"];
    [label setAlignmentMode:kCAAlignmentCenter];
    [label setForegroundColor:[[UIColor blackColor] CGColor]];
    [circleLayer addSublayer:label];
    self.label = label;
    
    CATextLayer *label2 = [[CATextLayer alloc] init];
    [label2 setFont:@"Helvetica-Bold"];
    [label2 setFontSize:30];
    [label2 setFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width -120, [[UIScreen mainScreen] bounds].size.height - 120, 100, 100)];
    [label2 setString:@"23"];
    [label2 setAlignmentMode:kCAAlignmentCenter];
    [label2 setForegroundColor:[[UIColor blackColor] CGColor]];
    [circleLayer2 addSublayer:label2];
    self.label2 = label2;
    
    
    
    //[label release];

}

- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 1;
}

-(void)deviceConnected:(Accelerometer *)accelerometer withData:(NSString *)data
{
    NSLog(data);
    NSLog([self title]);
}

- (void)locationManager:(Accelerometer *)accelerometer didUpdateData:(MBLRMSAccelerometerData *)dataStream{
    
    double myInt = dataStream.rms * 10;
    
    [self.accelerometerGraph addX:myInt y:myInt z:myInt];
   
    
}

- (void)listSubviewsOfView:(UIView *)view {
    
    // Get the subviews of the view
    NSArray *subviews = [view subviews];
    
    // Return if there are no subviews
    if ([subviews count] == 0) return; // COUNT CHECK LINE
    
    for (UIView *subview in subviews) {
        
        // Do what you want to do with the subview
        NSLog(@"%@", subview);
        
        // List the subviews of subview
        [self listSubviewsOfView:subview];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    if (graph == self.aGraph){
        return 20;
    } else {
        return 20;
    }
     // Number of points in the graph.
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    if (graph == self.aGraph){
        return [self.arrayOfIndices[index] intValue]; // The value of the point on the Y-Axis for the index.
    } else {
        return [self.arrayOfIndices2[index] intValue];
    }
    //return 3;
}

- (CGFloat)maxValueForLineGraph:(BEMSimpleLineGraphView *)graph {
    return 20;
}

- (CGFloat)minValueForLineGraph:(BEMSimpleLineGraphView *)graph {
    return 0;
}

@end
