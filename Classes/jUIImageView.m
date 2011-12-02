#import "jUIImageView.h"

@implementation UIImageView (jUIImageView) 

- (void) shiftPanel {
	//NSLog( @"shifting panel" );
	self.frame = CGRectOffset(self.frame, -25.0, 0.0);
}

- (void) unshiftPanel {
	//NSLog( @"unshifting panel" );
	self.frame = CGRectOffset(self.frame, 25.0, 0.0);

}

@end

