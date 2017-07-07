//
//  GrabCutWrapper.h
//  GrabCutIOS
//
//  Created by Noah Gallant on 7/6/17.
//  Copyright © 2017 EunchulJeon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GrabCutWrapper : NSObject

-(UIImage*) doGrabcut: (UIImage*)source foregroundBound:(CGRect) rect;

@end
