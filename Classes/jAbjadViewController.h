//
//  jAbjadViewController.h
//  jAbjad
//
//  Created by Saif Mamat on 24/11/2011.
//  Copyright 2011 DD Multimedia Solutions Sdn. Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "jUIImageView.h"

@interface jAbjadViewController : UIViewController {

	UIImageView * ivPicture;
	UIButton * bPrev, * bHome, * bNext;
	NSArray * ivLetters;
	
	int abjadNo;
	
	bool isPanelShifted;
	int firstPanelTag;
	
	int spellingMode;
	
	NSMutableArray * abjadList; // objects to be spelled
}

@property (nonatomic, retain) IBOutlet UIImageView * ivPicture;
@property (nonatomic, retain) IBOutlet UIButton * bPrev, * bHome, * bNext;
@property (nonatomic, retain) IBOutletCollection(UIImageView) NSArray * ivLetters;

@property (nonatomic, retain) NSMutableArray * abjadList;



- (IBAction) prevButtonTapped;
- (IBAction) nextButtonTapped;
- (IBAction) homeButtonTapped;
- (void) updateMedia : (int) newAbjadNo;
- (void) updateLetters : (NSDictionary *) spellSet;
- (void) resetPanelPosition;
@end

