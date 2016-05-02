//
//  GifView.m
//  GifDemo
//

#import "GifView.h"
#import <QuartzCore/QuartzCore.h>

@implementation GifView


- (id)initWithFrame:(CGRect)frame filePath:(NSString *)_filePath
{
    self = [super initWithFrame:frame];
    if (self) {
        gifProperties = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount]forKey:(NSString *)kCGImagePropertyGIFDictionary];
        gif = CGImageSourceCreateWithURL((__bridge CFURLRef)[NSURL fileURLWithPath:_filePath], (__bridge CFDictionaryRef)gifProperties);
        count =CGImageSourceGetCount(gif);
        timer = [NSTimer scheduledTimerWithTimeInterval:0.12 target:self selector:@selector(play) userInfo:nil repeats:YES];
        [timer fire];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame data:(NSData *)_data
{
    self = [super initWithFrame:frame];
    if (self) {
        gifProperties = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount]forKey:(NSString *)kCGImagePropertyGIFDictionary];
        gif = CGImageSourceCreateWithData((__bridge CFDataRef)_data, (__bridge CFDictionaryRef)gifProperties);
        count =CGImageSourceGetCount(gif);
        timer = [NSTimer scheduledTimerWithTimeInterval:0.12 target:self selector:@selector(play) userInfo:nil repeats:YES];
        [timer fire];
    }
    return self;
}

-(void)play
{
    index ++;
    index = index%count;
    CGImageRef ref = CGImageSourceCreateImageAtIndex(gif, index, (__bridge CFDictionaryRef)gifProperties);
    self.layer.contents = (__bridge id)ref;
    CFRelease(ref);
}

-(void)removeFromSuperview
{
    NSLog(@"removeFromSuperview");
    [timer invalidate];
    timer = nil;
    [super removeFromSuperview];
}

- (void)dealloc
{
    NSLog(@"dealloc");
    CFRelease(gif);
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end