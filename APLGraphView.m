#import "APLGraphView.h"

#pragma mark - Quartz Helpers

CGColorRef CreateDeviceGrayColor(CGFloat w, CGFloat a)
{
    CGColorSpaceRef gray = CGColorSpaceCreateDeviceGray();
    CGFloat comps[] = {w, a};
    CGColorRef color = CGColorCreate(gray, comps);
    CGColorSpaceRelease(gray);
    return color;
}
CGColorRef CreateDeviceRGBColor(CGFloat r, CGFloat g, CGFloat b, CGFloat a)
{
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGFloat comps[] = {r, g, b, a};
    CGColorRef color = CGColorCreate(rgb, comps);
    CGColorSpaceRelease(rgb);
    return color;
}
CGColorRef graphBackgroundColor()
{
    static CGColorRef c = NULL;
    if (c == NULL)
    {
        c = CreateDeviceGrayColor(0.6, 1.0);
    }
    return c;
}
CGColorRef graphLineColor()
{
    static CGColorRef c = NULL;
    if (c == NULL)
    {
        c = CreateDeviceGrayColor(0.5, 1.0);
    }
    return c;
}
CGColorRef graphXColor()
{
    static CGColorRef c = NULL;
    if (c == NULL)
    {
        c = CreateDeviceRGBColor(1.0, 0.0, 0.0, 1.0);
    }
    return c;
}
CGColorRef graphYColor()
{
    static CGColorRef c = NULL;
    if (c == NULL)
    {
        c = CreateDeviceRGBColor(0.0, 1.0, 0.0, 1.0);
    }
    return c;
}
CGColorRef graphZColor()
{
    static CGColorRef c = NULL;
    if (c == NULL)
    {
        c = CreateDeviceRGBColor(0.0, 0.0, 1.0, 1.0);
    }
    return c;
}
void DrawGridlines(CGContextRef context, CGFloat x, CGFloat width){}




@interface APLGraphViewSegment : NSObject

// Returns true if adding this value fills the segment, which is necessary for properly updating the segments.
-(BOOL)addX:(double)x y:(double)y z:(double)z;

/*
 When this object gets recycled (when it falls off the end of the graph) -reset is sent to clear values and prepare for reuse.
*/
-(void)reset;

// Returns true if this segment has consumed 32 values.
-(BOOL)isFull;

// Returns true if the layer for this segment is visible in the given rect.
-(BOOL)isVisibleInRect:(CGRect)r;

// The layer that this segment is drawing into.
@property(nonatomic, readonly) CALayer *layer;

@end
@implementation APLGraphViewSegment
{
    // Need 33 values to fill 32 pixel width.
    double xhistory[33];
    double yhistory[33];
    double zhistory[33];
    int index;
}

-(id)init
{
    self = [super init];
    if (self != nil)
    {
        _layer = [[CALayer alloc] init];
        /*
         The layer will call our -drawLayer:inContext: method to provide content and our -actionForLayer:forKey: for implicit animations.
         */
        _layer.delegate = self;
        /*
         This sets our coordinate system such that it has an origin of 0.0,-56 and a size of 32,112.
         This would need to be changed if you change either the number of pixel values that a segment represented, or if you changed the size of the graph view.
         */
        _layer.bounds = CGRectMake(0.0, -106.0, 32.0, 212.0);
        /*
         Disable blending as this layer consists of non-transperant content. Unlike UIView, a CALayer defaults to opaque=NO
         */
        _layer.opaque = NO;
        /*
         Index represents how many slots are left to be filled in the graph, which is also +1 compared to the array index that a new entry will be added.
         */
        index = 33;
    }
    return self;
}

-(void)reset
{
    // Clear out our components and reset the index to 33 to start filling values again.
    memset(xhistory, 0, sizeof(xhistory));
    memset(yhistory, 0, sizeof(yhistory));
    memset(zhistory, 0, sizeof(zhistory));
    index = 33;
    // Inform Core Animation that this layer needs to be redrawn.
    [self.layer setNeedsDisplay];
}

-(BOOL)isFull
{
    // The segment is full if there is no more space in the history.
    return index == 0;
}

-(BOOL)isVisibleInRect:(CGRect)r
{
    // Check if there is an intersection between the layer's frame and the given rect.
    return CGRectIntersectsRect(r, self.layer.frame);
}

-(BOOL)addX:(double)x y:(double)y z:(double)z
{
    // If this segment is not full, add a new value to the history.
    if (index > 0)
    {
        // First decrement, both to get to a zero-based index and to flag one fewer position left.
        --index;
        xhistory[index] = x;
        yhistory[index] = y;
        zhistory[index] = z;
        // And inform Core Animation to redraw the layer.
        [self.layer setNeedsDisplay];
    }
    // And return if we are now full or not (really just avoids needing to call isFull after adding a value).
    return index == 0;
}

-(void)drawLayer:(CALayer*)l inContext:(CGContextRef)context
{
    // Fill in the background.
    CGContextSetFillColorWithColor(context, [ [ UIColor clearColor ] CGColor ]);
    CGContextFillRect(context, self.layer.bounds);

    // Draw the graph.
    CGPoint lines[64];
    int i;

    // X
    for (i = 0; i < 32; ++i)
    {
        lines[i*2].x = i;
        lines[i*2].y = -xhistory[i] * 10.0;
        lines[i*2+1].x = i + 1;
        lines[i*2+1].y = -xhistory[i+1] * 10.0;
    }
    CGContextSetStrokeColorWithColor(context, graphXColor());
    CGContextStrokeLineSegments(context, lines, 64);

    // Y
    for (i = 0; i < 32; ++i)
    {
        lines[i*2].y = -yhistory[i] * 10.0;
        lines[i*2+1].y = -yhistory[i+1] * 10.0;
    }
    CGContextSetStrokeColorWithColor(context, graphYColor());
    CGContextStrokeLineSegments(context, lines, 64);

    // Z
    for (i = 0; i < 32; ++i)
    {
        lines[i*2].y = -zhistory[i] * 10.0;
        lines[i*2+1].y = -zhistory[i+1] * 10.0;
    }
    CGContextSetStrokeColorWithColor(context, graphZColor());
    CGContextStrokeLineSegments(context, lines, 64);
}

-(id)actionForLayer:(CALayer *)layer forKey :(NSString *)key
{
    // We disable all actions for the layer, so no content cross fades, no implicit animation on moves, etc.
    return [NSNull null];
}

// The accessibilityValue of this segment should be the x,y,z values last added.
- (NSString *)accessibilityValue
{
    return [NSString stringWithFormat:NSLocalizedString(@"graphSegmentFormat", @"Format string for accessibility text for last x, y, z values added"), xhistory[index], yhistory[index], zhistory[index]];
}

@end
#pragma mark - GraphTextView
@interface APLGraphTextView : UIView
@end



@implementation APLGraphTextView
-(void)drawRect:(CGRect)rect{}
@end



@interface APLGraphView()
@property (nonatomic) NSMutableArray *segments;
@property (nonatomic, weak) APLGraphViewSegment *current;
@property (nonatomic, weak) APLGraphTextView *textView;
@end
@implementation APLGraphView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        [self commonInit];
    }
    return self;
}

-(id)initWithCoder:(NSCoder*)decoder
{
    self = [super initWithCoder:decoder];
    if (self != nil)
    {
        [self commonInit];
    }
    return self;
}

-(void)commonInit
{
    // Create a mutable array to store segments, which is required by -addSegment.
    _segments = [[NSMutableArray alloc] init];
    _current = [self addSegment];
}

-(void)addX:(double)x y:(double)y z:(double)z
{
    // First, add the new value to the current segment.
    if ([self.current addX:x y:y z:z])
    {
        /*
         If after doing that we've filled up the current segment, then we need to determine the next current segment.
         */
        [self recycleSegment];
        // To keep the graph looking continuous, add the value to the new segment as well.
        [self.current addX:x y:y z:z];
    }
    /*
     After adding a new data point, advance the x-position of all the segment layers by 1 to create the illusion that the graph is advancing.
    */
    for (APLGraphViewSegment *segment in self.segments)
    {
        CGPoint position = segment.layer.position;
        position.x += 1.0;
        segment.layer.position = position;
    }
}

#define kSegmentInitialPosition CGPointMake(-17.0, 56.0);

-(APLGraphViewSegment*)addSegment
{
    // Create a new segment and add it to the segments array.
    APLGraphViewSegment * segment = [[APLGraphViewSegment alloc] init];
    
    /*
     Add the new segment at the front of the array because -recycleSegment expects the oldest segment to be at the end of the array. As long as we always insert the youngest segment at the front this will be true.
     */
    [self.segments insertObject:segment atIndex:0];

    /* Ensure that newly added segment layers are placed after the text view's layer so that the text view always renders above the segment layer.
     */
    [self.layer insertSublayer:segment.layer below:self.textView.layer];
    
    // Position the segment properly (see the comment for kSegmentInitialPosition).
    segment.layer.position = kSegmentInitialPosition;

    return segment;
}

-(void)recycleSegment
{
    /*
     Start with the last object in the segments array, because it should either be visible onscreen (which indicates that we need more segments) or pushed offscreen (which makes it eligible for recycling).
     */
    APLGraphViewSegment * last = [self.segments lastObject];
    if ([last isVisibleInRect:self.layer.bounds])
    {
        // The last segment is still visible, so create a new segment, which is now the current segment.
        self.current = [self addSegment];
    }
    else
    {
        // The last segment is no longer visible, so reset it in preperation for being recycled.
        [last reset];
        // Position the segment properly (see the comment for kSegmentInitialPosition).
        last.layer.position = kSegmentInitialPosition;
        /*
         Move the segment from the last position in the array to the first position in the array because it is now the youngest segment,
         */
        [self.segments insertObject:last atIndex:0];
        [self.segments removeLastObject];
        // and make it the current segment.
        self.current = last;
    }
}

-(void)drawRect:(CGRect)rect
{}

- (NSString *)accessibilityValue
{
    if (self.segments.count == 0)
    {
        return nil;
    }

    // Let the GraphViewSegment handle its own accessibilityValue.
    APLGraphViewSegment *graphViewSegment = [self.segments objectAtIndex:0];
    return [graphViewSegment accessibilityValue];
}


@end

