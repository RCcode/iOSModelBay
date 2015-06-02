//
//  UIImage+processing.m
//  photoprocessing
//
//  Created by wsq-wlq on 14-5-21.
//  Copyright (c) 2014年 wsq-wlq. All rights reserved.
//

#import "UIImage+processing.h"
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>


@implementation UIImage (processing)


//截图方法
- (UIImage *)subImageWithRect:(CGRect)rect
{
    CGImageRef newImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
    return newImage;
}

//压缩图片
- (UIImage *)rescaleImageToSize:(CGSize)size
{
    
    CGRect rect = (CGRect){CGPointZero, size};
    
    UIGraphicsBeginImageContext(rect.size);
    
    [self drawInRect:rect]; // scales image to rect
    
    UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resImage;
}

//UIView转化为UIImage
+ (UIImage *)getImageFromView:(UIView *)view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 *  改变前景颜色
 *
 *  @param tintColor 要改变的前景颜色
 *
 *  @return 改变前景色后的图片
 */
- (UIImage *)changeTintColor:(UIColor *)tintColor blendType:(CGBlendMode)type withCenter:(CGPoint)center
{
    if (center.x == 99999) {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(100, 100), NO, 25);
        [tintColor setFill];
        CGRect bounds = CGRectMake(0, 0, 100, 100);
        UIRectFill(bounds);
        [self drawInRect:CGRectMake(46, 46, 8, 8) blendMode:type alpha:1.0f];
    }else{
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(320, 320), NO, 0.0f);
        [tintColor setFill];
        CGRect bounds = CGRectMake(0, 0, 320, 320);
        UIRectFill(bounds);
        [self drawInRect:CGRectMake(0, 0, 320, 320) blendMode:type alpha:1.0f];
    }
        UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
  
    return tintedImage;
}

- (UIImage *)changeShapeWithColor:(UIColor *)tintColor andBlendMode:(CGBlendMode)blendMode
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(320, 320), NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, 320, 320);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}
- (UIImage *) imageWithTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeOverlay];
}

- (UIImage *) imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode
{
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    if (blendMode != kCGBlendModeDestinationIn) {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

/**
 *  改变前景图案
 *
 *  @param image 要改变的前景图案
 *
 *  @return 改变完成后的图片
 */
- (UIImage *)changeGraph:(UIImage *)image
{

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(320, 320), NO, 0.0f);
    CGRect bounds = CGRectMake(0, 0, 320, 320);
    [image drawInRect:bounds];
    
    //    [view drawViewHierarchyInRect:bounds afterScreenUpdates:YES];
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    
    UIImage *graphImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return graphImage;
}
/**
 *  转变shape的显示模式
 *
 *  @param image 当前图片的背景图
 *
 *  @return 改变模式后的图片
 */
- (UIImage *)turnShapeWithColor:(UIColor *)color
{
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(320, 320), NO, 0.0f);
    CGRect bounds = CGRectMake(0, 0, 320, 320);
    [color setFill];
    UIRectFill(bounds);
    //    [view drawViewHierarchyInRect:bounds afterScreenUpdates:YES];
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:kCGBlendModeDestinationOut alpha:1.0f];
    
    UIImage *graphImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return graphImage;
}

/**
 *  根据不同的混合模式合成形状图形
 *
 *  @param _bottomImage 合成所选底图
 *  @param _topImage    合成所选顶图
 *  @param blendMode    混合方式
 *
 *  @return 合成完成后图片
 */
+ (UIImage *)shapeMakeWithBottomImage:(UIImage *)_bottomImage andTopImage:(UIImage *)_topImage andBlendMode:(CGBlendMode)blendMode
{
    
    UIImage *bottomImage = _bottomImage;
    UIImage *topImage = _topImage;
    
    CGSize newSize =CGSizeMake(480, 480);
    
    UIGraphicsBeginImageContext( newSize );
    // Use existing opacity as is
    [bottomImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Apply supplied opacity
    [topImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:blendMode alpha:1];
    
    UIImage *newImage =UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
//    CGImageRelease(_topImage.CGImage);
//    CGImageRelease(_bottomImage.CGImage);
    
    return newImage;
}


/**
 *  为保证图片质量保存时重绘的图片
 *
 *  @param backView 屏幕显示的出来的view
 *  @param size     保存图片大小
 *
 *  @return 制做完成的图片
 */
+ (UIImage *)getEditFinishedImageWithView:(UIView *)backView andContextSize:(CGSize)size
{

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(320, 320), NO, 0.0f);
    CGSize newSize = CGSizeMake(320, 320);
//    UIGraphicsBeginImageContext( newSize );
    // Use existing opacity as is
    [backView drawViewHierarchyInRect:CGRectMake(0, 0, newSize.width, newSize.height) afterScreenUpdates:YES];

    UIImage *newImage =UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}


+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur
{
    
    if ((blur < 0.05f) || (blur > 2.0f)) {
        return image;
    }
    
    //boxSize必须大于0
    int boxSize = (int)(blur * 50);
    boxSize -= (boxSize % 2) + 1;
    //图像处理
    CGImageRef img = image.CGImage;
    //需要引入#import <Accelerate/Accelerate.h>
    /*
     This document describes the Accelerate Framework, which contains C APIs for vector and matrix math, digital signal processing, large number handling, and image processing.
     本文档介绍了Accelerate Framework，其中包含C语言应用程序接口（API）的向量和矩阵数学，数字信号处理，大量处理和图像处理。
     */
    
    //图像缓存,输入缓存，输出缓存
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    //像素缓存
    void *pixelBuffer;
    
    //数据源提供者，Defines an opaque type that supplies Quartz with data.
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    // provider’s data.
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    //宽，高，字节/行，data
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //像数缓存，字节行*图片高
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    
    // 第三个中间的缓存区,抗锯齿的效果
    void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    vImage_Buffer outBuffer2;
    outBuffer2.data = pixelBuffer2;
    outBuffer2.width = CGImageGetWidth(img);
    outBuffer2.height = CGImageGetHeight(img);
    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
    
    //Convolves a region of interest within an ARGB8888 source image by an implicit M x N kernel that has the effect of a box filter.
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    //    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    //    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    //
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    //    NSLog(@"字节组成部分：%zu",CGImageGetBitsPerComponent(img));
    //颜色空间DeviceRGB
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //用图片创建上下文,CGImageGetBitsPerComponent(img),7,8
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(image.CGImage));
    
    //根据上下文，处理过的图片，重新组件
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    //    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    free(pixelBuffer2);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}
//取一点的RGB色值
- (UIColor *)getPixelColorAtLocation:(CGPoint)point andImage:(UIImage *)image;
{
    //	UIColor* color = nil;
    UIColor *color = nil;
	CGImageRef inImage = image.CGImage;
    
	// Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpa, Red, Green, Blue
	CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];
	if (cgctx == NULL) { return nil; /* error */ }
    
	size_t w = CGImageGetWidth(inImage);
	size_t h = CGImageGetHeight(inImage);
    CGSize s = CGSizeMake(w, h);
	CGRect rect = {{0,0},s};
    
	// Draw the image to the bitmap context. Once we draw, the memory
	// allocated for the context for rendering will then contain the
	// raw image data in the specified color space.
	CGContextDrawImage(cgctx, rect, inImage);
    
	// Now we can get a pointer to the image data associated with the bitmap
	// context.
	unsigned char* data = (unsigned char* )CGBitmapContextGetData (cgctx);
	if (data != NULL) {
        
        int offset = -1;
		//offset locates the pixel in the data from x,y.
		//4 for 4 bytes of data per pixel, w is width of one row of data.
		@try {
			offset = 4*((w*round(point.y))+round(point.x));
            //			NSLog(@"offset: %d", offset);
			int alpha =  data[offset];
			int red = data[offset+1];
			int green = data[offset+2];
			int blue = data[offset+3];
            
            
            //            color.red = red;
            //            color.green = green;
            //            color.blue = blue;
            //            color.alpha = alpha;
            //            NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
            color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
		}
		@catch (NSException * e)
        {
            NSLog(@"offset === %d",offset);
			NSLog(@"%@",[e reason]);
		}
		@finally {
            
		}
        
	}
    
	// When finished, release the context
	CGContextRelease(cgctx);
	// Free image data memory for the context
	if (data) { free(data); }
    
	return color;
}
//
- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage {
    
	CGContextRef    context = NULL;
	CGColorSpaceRef colorSpace;
	void *          bitmapData;
	int             bitmapByteCount;
	int             bitmapBytesPerRow;
    
	// Get image width, height. We'll use the entire image.
	size_t pixelsWide = CGImageGetWidth(inImage);
	size_t pixelsHigh = CGImageGetHeight(inImage);
    
	// Declare the number of bytes per row. Each pixel in the bitmap in this
	// example is represented by 4 bytes; 8 bits each of red, green, blue, and
	// alpha.
	bitmapBytesPerRow   = (pixelsWide * 4);
	bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
	// Use the generic RGB color space.
	colorSpace = CGColorSpaceCreateDeviceRGB();
    
	if (colorSpace == NULL)
	{
		fprintf(stderr, "Error allocating color space\n");
		return NULL;
	}
    
	// Allocate memory for image data. This is the destination in memory
	// where any drawing to the bitmap context will be rendered.
	bitmapData = malloc( bitmapByteCount );
	if (bitmapData == NULL)
	{
		fprintf (stderr, "Memory not allocated!");
		CGColorSpaceRelease( colorSpace );
		return NULL;
	}
    
	// Create the bitmap context. We want pre-multiplied ARGB, 8-bits
	// per component. Regardless of what the source image format is
	// (CMYK, Grayscale, and so on) it will be converted over to the format
	// specified here by CGBitmapContextCreate.
	context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
	if (context == NULL)
	{
		free (bitmapData);
		fprintf (stderr, "Context not created!");
	}
    
	// Make sure and release colorspace before returning
	CGColorSpaceRelease( colorSpace );
    
	return context;
}

@end
