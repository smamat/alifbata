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
@synthesize aplayer;

- (IBAction) prevButtonTapped {
	NSLog( @"prev button tapped" );
	
	--abjadNo;
	abjadNo = abjadNo % 5;
	if (abjadNo < 0)
		abjadNo += 5;
	
	[self updateMedia:abjadNo];
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
		// mirror in upper panel
		//int tag2 = tag+PANEL_SIZE;
		[((UIImageView*)[self.view viewWithTag:tag+PANEL_SIZE]) setImage:img];
		
	}
	
	// calculate where letter starts
	int nLetters = [[spellSet objectForKey:LETTER_KEY] count];
	firstPanelTag = (PANEL_SIZE-nLetters)/2 + 1;
	
	// shift/unshift depending on odd/even number of letters
	if (1 == nLetters%2) { // odd number
		if (!isPanelShifted) {
			for (int i=1; i<PANEL_SIZE; ++i) {
				[((UIImageView*)[self.view viewWithTag:i]) shiftPanel];
				[((UIImageView*)[self.view viewWithTag:i+PANEL_SIZE]) shiftPanel];
			}
			isPanelShifted = YES;
		}
	}
	else { // even number
		if (isPanelShifted) {
			for (int i=1; i<PANEL_SIZE; ++i) {
				[((UIImageView*)[self.view viewWithTag:i]) unshiftPanel];
				[((UIImageView*)[self.view viewWithTag:i+PANEL_SIZE]) unshiftPanel];
			}
			isPanelShifted = NO;
		}
	}


	
	// get each letter in dictionary and display on panel
	tag = firstPanelTag;
	for (NSString * letter in [spellSet objectForKey:LETTER_KEY])
	{
		// get letter filename
		NSString * letterName = [NSString stringWithFormat:@"%@", letter];
		NSString * letterFilename = [[NSBundle mainBundle] pathForResource:letterName ofType:@"png"];
		// set letter in panel
		UIImage * img = [UIImage imageWithContentsOfFile:letterFilename];
		[((UIImageView*)[self.view viewWithTag:tag]) setImage:img];
		
		// mirror in upper panel
		NSRange stringRange = {0,([letterName length]-1)};
		NSString *shortString = [letter substringWithRange:stringRange];
		letterName = [NSString stringWithFormat:@"%@0", shortString];
		letterFilename = [[NSBundle mainBundle] pathForResource:letterName ofType:@"png"];
		img = [UIImage imageWithContentsOfFile:letterFilename];
		[((UIImageView*)[self.view viewWithTag:tag+PANEL_SIZE]) setImage:img];
		
		
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

/*
 AUDIO HANDLING
 */

- (void) audioPlayerEndInterruption:(AVAudioPlayer *)player
{
	NSLog(@"audioPlayerEndInterruption");
}

- (void) audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
	NSLog(@"audioPlayerBeginInterruption");
}

- (IBAction) playLetter : (id) sender
{
	NSLog( @"playLetter: tag %d", [sender tag] );
}

/*
 END AUDIO HANDLING
 */

/*
 GESTURE TOUCH SETUP
 */

- (void) setPictureGesture
{
	ivPicture.userInteractionEnabled = YES;

	// swipe picture left
	UISwipeGestureRecognizer * swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
	swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
	[ivPicture addGestureRecognizer:swipeLeft];
	[swipeLeft release];
	
	// swipe picture right
	UISwipeGestureRecognizer * swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
	swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
	[ivPicture addGestureRecognizer:swipeRight];
	[swipeRight release];
}

- (void) handleSwipe : (id) sender
{
	NSLog( @"swipe gesture detected yo!" );

	switch ([(UISwipeGestureRecognizer*)sender direction]) {
		case UISwipeGestureRecognizerDirectionRight:
			[self prevButtonTapped];
			break;
		case UISwipeGestureRecognizerDirectionLeft:
			[self nextButtonTapped];
			break;
		default:
			break;
	}
	
/*	if (UISwipeGestureRecognizerDirectionRight == [(UISwipeGestureRecognizer*)sender direction])
		[self prevButtonTapped];
	else if
		NSLog(@"blah");
	}
*/
	
}

/*
 END GESTURE TOUCH SETUP
 */

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	abjadNo = 0;
	isPanelShifted = NO;
	spellingMode = 0;
	
	// get dictionary
	NSString * path = [[NSBundle mainBundle] pathForResource:@"AbjadSpell" ofType:@"plist"];
	NSMutableArray * tmpArray = [[NSMutableArray alloc] initWithContentsOfFile:path];
	self.abjadList = tmpArray;
	[tmpArray release];
	
	// set first object
	[self updateMedia:abjadNo];
	
	// configure ivPicture with gesture touch handler
	[self setPictureGesture];
	
	/*ivPicture.userInteractionEnabled = YES;
	
	UISwipeGestureRecognizer * swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
	swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
	[ivPicture addGestureRecognizer:swipeRight];
	[swipeRight release];*/
											 
	
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
	[aplayer release];
    [super dealloc];
}

@end
