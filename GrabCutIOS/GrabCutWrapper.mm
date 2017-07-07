//
//  GrabCutWrapper.m
//  GrabCutIOS
//
//  Created by Noah Gallant on 7/6/17.
//  Copyright © 2017 EunchulJeon. All rights reserved.
//

#import "GrabCutWrapper.h"
#import "GrabCutManager.h"

@implementation GrabCutWrapper

static inline double radians (double degrees) {return degrees * M_PI/180;}
const static int MAX_IMAGE_LENGTH = 450;

-(UIImage*) doGrabcut: (UIImage*)source foregroundBound:(CGRect) rect{
    GrabCutManager* grabcut = [[GrabCutManager alloc] init];
    UIImage* originalImage = [self resizeWithRotation:source size:source.size];
    UIImage* resizedImage = [self getProperResizedImage:originalImage];
    UIImage* resultImage = [grabcut doGrabCut:resizedImage foregroundBound:rect iterationCount:5];
    return resultImage;
}

-(UIImage *) getProperResizedImage:(UIImage*)original{
    float ratio = original.size.width/original.size.height;
    
    if(original.size.width > original.size.height){
        if(original.size.width > MAX_IMAGE_LENGTH){
            return [self resizeWithRotation:original size:CGSizeMake(MAX_IMAGE_LENGTH, MAX_IMAGE_LENGTH/ratio)];
        }
    }else{
        if(original.size.height > MAX_IMAGE_LENGTH){
            return [self resizeWithRotation:original size:CGSizeMake(MAX_IMAGE_LENGTH*ratio, MAX_IMAGE_LENGTH)];
        }
    }
    
    return original;
}

-(UIImage*) resizeImage:(UIImage*)image size:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextDrawImage(context, CGRectMake(0.0, 0.0, size.width, size.height), [image CGImage]);
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

-(UIImage*) resizeWithRotation:(UIImage *) sourceImage size:(CGSize) targetSize
{
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGImageRef imageRef = [sourceImage CGImage];
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
    
    CGContextRef bitmap;
    
    if (sourceImage.imageOrientation == UIImageOrientationUp || sourceImage.imageOrientation == UIImageOrientationDown) {
        bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    } else {
        bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    }
    
    if (sourceImage.imageOrientation == UIImageOrientationLeft) {
        CGContextRotateCTM (bitmap, radians(90));
        CGContextTranslateCTM (bitmap, 0, -targetHeight);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationRight) {
        CGContextRotateCTM (bitmap, radians(-90));
        CGContextTranslateCTM (bitmap, -targetWidth, 0);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationUp) {
        // NOTHING
    } else if (sourceImage.imageOrientation == UIImageOrientationDown) {
        CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
        CGContextRotateCTM (bitmap, radians(-180.));
    }
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, targetWidth, targetHeight), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return newImage;
}

-(UIImage *) masking:(UIImage*)sourceImage mask:(UIImage*) maskImage{
    //Mask Image
    CGImageRef maskRef = maskImage.CGImage;
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef masked = CGImageCreateWithMask([sourceImage CGImage], mask);
    CGImageRelease(mask);
    
    UIImage *maskedImage = [UIImage imageWithCGImage:masked];
    
    CGImageRelease(masked);
    
    return maskedImage;
}

-(CGSize) getResizeForTimeReduce:(UIImage*) image{
    CGFloat ratio = image.size.width/ image.size.height;
    
    if([image size].width > [image size].height){
        
        
        if(image.size.width > 400){
            return CGSizeMake(400, 400/ratio);
        }else{
            return image.size;
        }
        
    }else{
        if(image.size.height > 400){
            return CGSizeMake(ratio/400, 400);
        }else{
            return image.size;
        }
    }
}



@end
