
//
//  GifView.h
//  GifDemo
//

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>

@interface GifView : UIView
{
    CGImageSourceRef gif;
    NSDictionary *gifProperties;
    size_t index;
    size_t count;
    NSTimer *timer;
}

- (id)initWithFrame:(CGRect)frame filePath:(NSString *)_filePath;
- (id)initWithFrame:(CGRect)frame data:(NSData *)_data;

@end

