//
//  jAbjadViewController.m
//  jAbjad
//
//  Created by Saif Mamat on 24/11/2011.
//  Copyright 2011 DD Multimedia Solutions Sdn. Bhd. All rights reserved.
//

#import "jAbjadViewController.h"
#import "AbjadConstants.h"

@implementation jAbjadViewController

@synthesize ivPicture;
@synthesize bPrev, bHome, bNext;
@synthesize ivLetters;
@synthesize abjadList;

- (IBAction) prevButtonTapped {
	NSLog( @"prev button tapped" );
	
	--abjadNo;
	abjadNo = abjadNo % 5;
	if (abjadNo < 0)
		abjadNo += 5;
	
	[self updateMedia:abjadNo];
	//--abjadNo;
	//if (abjadNo < 0)
	//	abjadNo += 5;
}

- (IBAction) homeButtonTapped {
	NSLog( @"home button tapped" );	
}

- (IBAction) nextButtonTapped {
	NSLog( @"next button tapped" );
	++abjadNo;
	abjadNo = abjadNo % 5;
	
	[self updateMedia:abjadNo];
	//++abjadNo;
}

- (void) updateMedia : (int) newAbjadNo {
	
	// get filename and set image
	NSLog( @"enter updateMedia" );
	NSDictionary * spellSet = [abjadList objectAtIndex:newAbjadNo];
	NSString * objectName = [spellSet objectForKey:NAME_KEY];
	// -- improve file loading using NSBundle
	NSString * picFilename = [NSString stringWithFormat:@"%@.png", objectName];
	//NSString * picFilename = [[NSBundle mainBundle] pathForResource:objectName ofType:@"png" inDirectory:@""];
	UIImage * image = [UIImage imageNamed:picFilename];
	NSLog( @"objectName: %@, picFilename: %@", objectName, picFilename );
	
	// update letters on spelling sheet
	if (isPanelShifted)
		[self resetPanelPosition];
	[self updateLetters:spellSet];
	[ivPicture setImage:image];
	
}

- (void) updateLetters : (NSDictionary *) spellSet {
	NSLog( @"object name: %@", [spellSet objectForKey:NAME_KEY] );
	NSLog( @"letter count: %d", [[spellSet objectForKey:LETTER_KEY] count] );
	
	// blank panel
	int tag = 1;
	for (; tag<=PANEL_SIZE; ++tag) {
		UIImage * img = [UIImage imageNamed:@"blank.png"];
		[((UIImageView*)[self.view viewWithTag:tag]) setImage:img];	
	}
	
	// calculate where letter starts
	int nLetters = [[spellSet objectForKey:LETTER_KEY] count];
	firstPanelTag = (PANEL_SIZE-nLetters)/2 + 1;
	
	// get each letter in dictionary and display on panel
	tag = firstPanelTag;
	for (NSString * letter in [spellSet objectForKey:LETTER_KEY]) {
		NSString * letterName = [NSString stringWithFormat:@"%@", letter];
		NSString * letterFilename = [[NSBundle mainBundle] pathForResource:letterName ofType:@"png"];
		NSLog( @"letter: %@", letterName);
		UIImage * img = [UIImage imageWithContentsOfFile:letterFilename];
		[((UIImageView*)[self.view viewWithTag:tag]) setImage:img];
		
		//NSLog( @"x: %f", ((UIImageView*)[self.view viewWithTag:tag]).center.x );
		//if (nLetters%2==1) { // shift by half if odd count
		//	float x = ((UIImageView*)[self.view viewWithTag:tag]).center.x;
		//	float y = ((UIImageView*)[self.view viewWithTag:tag]).center.y;
		//	((UIImageView*)[self.view viewWithTag:tag]).center = CGPointMake(x-25,y);
		//}
		
		CGRect frame = ((UIImageView*)[self.view viewWithTag:tag]).frame;
		if (nLetters%2 == 1) { // shift by half if odd number of letters
			((UIImageView*)[self.view viewWithTag:tag]).frame = CGRectOffset(frame, -25.0, 0.0);
			isPanelShifted = YES;
			
		}
		
		//(UIImageView*)[self.view viewWithTag:tag
//		[(UIImageView*)[self.view viewWithTag:tag] setImage:img];
		++tag;

	}
}

- (void) resetPanelPosition {
}

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	abjadNo = 0;
	isPanelShifted = NO;
	
	// get dictionary
	NSString * path = [[NSBundle mainBundle] pathForResource:@"AbjadSpell" ofType:@"plist"];
	NSMutableArray * tmpArray = [[NSMutableArray alloc] initWithContentsOfFile:path];
	self.abjadList = tmpArray;
	[tmpArray release];
	
	[self updateMedia:abjadNo];
	//++abjadNo;
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[ivPicture release];
	[bPrev release];
	[bHome release];
	[bNext release];
	[ivLetters release];
	[abjadList release];
    [super dealloc];
}

@end
