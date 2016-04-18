//
//  ViewController.m
//  TestingGraph
//
//  Created by Cezar Babin on 4/18/16.
//  Copyright © 2016 senio. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

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
    
    
    
    
    //[self.arrayOfIndices insertObject:integer atIndex:0];
    
    //NSLog([integer stringValue]);
    //NSLog([self.arrayOfIndices[0] stringValue]);
    
    
    //NSLog(self.arrayOfIndices);
    
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
    //myGraph.colorBottom = [UIColor colorWithRed:0 green:122.0/255.0 blue:255/255 alpha:1];
    myGraph.enableBezierCurve = YES;
    
    
    
    [self.view addSubview:myGraph2];
    [self.view addSubview:myGraph];
    
    [self listSubviewsOfView:self.view];
    
    for (int i = 1; i <= 64; i++){
        NSNumber *integer = [NSNumber numberWithDouble:arc4random() % 100];
        [self.arrayOfIndices addObject:integer];
    }
    
    for (int i = 1; i <= 64; i++){
        NSNumber *integer = [NSNumber numberWithDouble:arc4random() % 100];
        [self.arrayOfIndices2 addObject:integer];
    }
    
    self.aGraph = myGraph;
    self.bGraph = myGraph2;
    //[self timedEvent];
    
    self.counter = 0;
    
    [NSTimer scheduledTimerWithTimeInterval:0.1
                                     target:self
                                   selector:@selector(timedEvent)
                                   userInfo:nil
                                    repeats:YES];
    
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

- (void)timedEvent{
    self.counter++;
    //for (int i = 1; i <= 64; i++)
    //if (self.counter <= 64){
        self.aGraph.animationGraphStyle = BEMLineAnimationNone;
        
        NSNumber *integer = [NSNumber numberWithInt:arc4random() % 100];
        [self.label setString:[integer stringValue]];
    
        //[NSThread sleepForTimeInterval:1.0f];
        
        id headObject = [self.arrayOfIndices objectAtIndex:0];
        if (headObject != nil) {
            //[[headObject retain] autorelease]; // so it isn't dealloc'ed on remove
            [self.arrayOfIndices removeObjectAtIndex:0];
        }
        
        [self.arrayOfIndices addObject:integer];
        [self.aGraph reloadGraph];
    
    self.bGraph.animationGraphStyle = BEMLineAnimationNone;
    
    NSNumber *integer2 = [NSNumber numberWithInt:arc4random() % 100];
    [self.label2 setString:[integer2 stringValue]];
    
    //[NSThread sleepForTimeInterval:1.0f];
    
    id headObject2 = [self.arrayOfIndices2 objectAtIndex:0];
    if (headObject2 != nil) {
        //[[headObject retain] autorelease]; // so it isn't dealloc'ed on remove
        [self.arrayOfIndices2 removeObjectAtIndex:0];
    }
    
    [self.arrayOfIndices2 addObject:integer2];
    [self.bGraph reloadGraph];
    //}

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
        return 64;
    } else {
        return 32;
    }
     // Number of points in the graph.
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    if (graph == self.aGraph){
        return [self.arrayOfIndices[index] integerValue]; // The value of the point on the Y-Axis for the index.
    } else {
        return [self.arrayOfIndices2[index] integerValue];
    }
    //return 3;
}


@end
