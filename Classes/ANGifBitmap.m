//
//  ANGifBitmap.m
//  Giraffe
//
//  Created by Alex Nichol on 1/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ANGifBitmap.h"


@implementation ANGifBitmap

- (id)initWithImage:(UIImage *)image {
	if (self = [super init]) {
		imageBitmap = [[ANImageBitmapRep alloc] initWithImage:image];
	}
	return self;
}
- (CGSize)size {
	return [imageBitmap size];
}
- (UInt32)getPixel:(CGPoint)pt {
	UInt32 pixel = 0;
	[imageBitmap get255Pixel:(char *)(&pixel) atX:(int)(pt.x) y:(int)(pt.y)];
	return pixel;
}

- (NSData *)smallBitmapData {
	// go through and get every single pixel, 
	// then turn it into one byte/pixel
	NSMutableData * returnData = [NSMutableData data];
	CGSize s = [self size];
	int width = (int)s.width;
	int height = (int)s.height;
	for (int y = 0; y < height; y++) {
		for (int x = 0; x < width; x++) {
			// read the information
			NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
			//NSLog(@"Reading: %d, %d", x, y);
			UInt32 pixel = [self getPixel:CGPointMake(x,y)];
			//NSLog(@"Done.");
			// now we need to compress the pixel
			UInt8 small = 0;
			small |= (pixel & 255) / 64;
			small |= (((pixel >> 8) & 255) / 64) << 2;
			small |= (((pixel >> 16) & 255) / 64) << 4;
			small |= (((pixel >> 24) & 255) / 64) << 6;
			[returnData appendBytes:&small length:1];
			//NSLog(@"Size: %d", [returnData length]);
			[pool drain];
			//NSLog(@"Done freepool.");
		}
	}
	
	NSLog(@"Done conversion.");
	
	return returnData;
}

- (void)dealloc {
	[imageBitmap release];
	[super dealloc];
}

@end
