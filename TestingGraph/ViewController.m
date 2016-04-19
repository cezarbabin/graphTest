//
//  ViewController.m
//  TestingGraph
//
//  Created by Cezar Babin on 4/18/16.
//  Copyright © 2016 senio. All rights reserved.
//

#import "ViewController.h"
#import "Accelerometer.h"


@interface ViewController () <AccelerometerDelegate>

@property NSMutableArray *arrayOfIndices;
@property NSMutableArray *arrayOfIndices2;
@property (nonatomic) BEMSimpleLineGraphView *aGraph;
@property (nonatomic) BEMSimpleLineGraphView *bGraph;
@property (nonatomic) CATextLayer *label;
@property (nonatomic) CATextLayer *label2;
@property int counter;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    BEMSimpleLineGraphView *myGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 150)];
    BEMSimpleLineGraphView *myGraph2 = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 150)];
    
    self.arrayOfIndices = [NSMutableArray array];
    self.arrayOfIndices2 = [NSMutableArray array];
    
    Accelerometer *custom = [[Accelerometer alloc] init];
    custom.delegate = self;
    [custom connectDevice];
    
    myGraph2.dataSource = self;
    myGraph2.delegate = self;
    myGraph2.alphaTop = 0.0;
    myGraph2.alphaBottom = 0.0;
    myGraph2.colorPoint = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:1.0/255.0 alpha:1];
    myGraph2.colorLine = [UIColor colorWithRed:1.0/255.0 green:255.0/255.0 blue:100.0/255.0 alpha:1];
    
    myGraph.dataSource = self;
    myGraph.delegate = self;
    myGraph.alphaTop = 0.0;
    myGraph.alphaBottom = 0.0;
    myGraph.colorPoint = [UIColor colorWithRed:1.0/255.0 green:1.0/255.0 blue:1.0/255.0 alpha:1];
    myGraph.colorLine = [UIColor colorWithRed:255.0/255.0 green:1.0/255.0 blue:1.0/255.0 alpha:1];

    [self.view addSubview:myGraph2];
    [self.view addSubview:myGraph];
    
    [self listSubviewsOfView:self.view];
    
    for (int i = 1; i <= 20; i++){
        NSNumber *integer = [NSNumber numberWithDouble:arc4random() % 1];
        [self.arrayOfIndices addObject:integer];
    }
    
    for (int i = 1; i <= 20; i++){
        NSNumber *integer = [NSNumber numberWithDouble:arc4random() % 1];
        [self.arrayOfIndices2 addObject:integer];
    }
    
    myGraph.autoScaleYAxis = YES;
    myGraph2.autoScaleYAxis = YES;
    
    self.aGraph = myGraph;
    self.bGraph = myGraph2;
    
    self.counter = 0;
    
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
    
    self.aGraph.animationGraphStyle = BEMLineAnimationNone;
    self.bGraph.animationGraphStyle = BEMLineAnimationNone;
    
    self.aGraph.enableBezierCurve = YES;
    self.bGraph.enableBezierCurve = YES;
    
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
    
    NSNumber *integer = [NSNumber numberWithDouble:myInt];
    NSNumber *integer2 = [NSNumber numberWithDouble:myInt + 1.0];
    
    id headObject = [self.arrayOfIndices objectAtIndex:0];
    if (headObject != nil) {
        [self.arrayOfIndices removeObjectAtIndex:0];
    }
    id headObject2 = [self.arrayOfIndices2 objectAtIndex:0];
    if (headObject2 != nil) {
        [self.arrayOfIndices2 removeObjectAtIndex:0];
    }
    
    [self.arrayOfIndices addObject:integer];
    [self.arrayOfIndices2 addObject:integer2];
    
    self.counter++;
    
   
    [self.aGraph reloadGraph];
    [self.bGraph reloadGraph];
    [self.label setString:[integer stringValue]];
    [self.label2 setString:[integer2 stringValue]];
    self.counter = 0;
   
    
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
