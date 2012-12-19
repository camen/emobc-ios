/**
 *  Copyright 2012 Neurowork Consulting S.L.
 *
 *  This file is part of eMobc.
 *
 *  eMobcViewController.m
 *  eMobc IOS Framework
 *
 *  eMobc is free software: you can redistribute it and/or modify
 *  it under the terms of the Affero GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  eMobc is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the Affero GNU General Public License
 *  along with eMobc.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

#import "NwQuizController.h"
#import "AppButton.h"
#import "AppStyles.h"
#import "AppFormatsStyles.h"
#import "NwButton.h"
#import "eMobcViewController.h"
#import "NwUtil.h"


@implementation NwQuizController

@synthesize data;
@synthesize varQuestion;
@synthesize varAnswer;
@synthesize myHeaderText;
@synthesize imgView;
@synthesize myDescription;
@synthesize myText;
@synthesize myTextPoint;
@synthesize button;
@synthesize imgViewQuestion;
@synthesize background;
@synthesize a;
@synthesize myAnswer;
@synthesize but;
@synthesize score;
@synthesize questionRepeat;
@synthesize numQuestion;
@synthesize varStyles;
@synthesize varFormats;
@synthesize myLabel;

@synthesize sizeTop;
@synthesize sizeBottom;
@synthesize sizeHeaderText;

@synthesize imgSize;

/**
 * Called after the controller’s view is loaded into memory.
 */
-(void)viewDidLoad {
   	[super viewDidLoad];
	
	imgView = [[UIImageView alloc] init];
	imgSize = [[UIImageView alloc] init];
	
	sizeTop = 0;
	sizeBottom = 0;
	sizeHeaderText = 25;
	
	sizeTop = [mainController ifMenuAndAdsTop:sizeTop];
	sizeBottom = [mainController ifMenuAndAdsBottom:sizeBottom];
	
	
	varStyles = [mainController.theStyle.stylesMap objectForKey:data.levelId];
	
	if (varStyles == nil) {
		varStyles = [mainController.theStyle.stylesMap objectForKey:@"QUIZ_ACTIVITY"];
	}else if(varStyles == nil){
		varStyles = [mainController.theStyle.stylesMap objectForKey:@"DEFAULT"];
	}
	
	if(varStyles != nil) {
		[self loadThemes];
		sizeTop += 20;
	}
	
	loadContent = FALSE;
		
	
	score = [[NSMutableArray alloc] init];
	questionRepeat = [[NSMutableArray alloc] init];
	numQuestion = [[NSMutableArray alloc] init];
	

	[self createIntroduction];	
}

-(void) loadBackground{
	sizeTop = 0;
	sizeBottom = 0;
	
	sizeTop = [mainController ifMenuAndAdsTop:sizeTop];
	sizeBottom = [mainController ifMenuAndAdsBottom:sizeBottom];
	
	if(![varStyles.backgroundFileName isEqualToString:@""]) {
		
		if([eMobcViewController isIPad]){
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				background = [[UIImageView alloc] initWithFrame:CGRectMake(0, sizeTop, 1024, 768 - sizeTop - sizeBottom)];
			}else{
				background = [[UIImageView alloc] initWithFrame:CGRectMake(0, sizeTop, 768, 1024 - sizeTop - sizeBottom)];
			}				
		}else {
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				background = [[UIImageView alloc] initWithFrame:CGRectMake(0, sizeTop, 480, 320 - sizeTop - sizeBottom)];
			}else{
				background = [[UIImageView alloc] initWithFrame:CGRectMake(0, sizeTop, 320, 480 - sizeTop - sizeBottom)];
			}				
		}
		
		NSString *k = [eMobcViewController whatDevice:k];
		
		NSString *imagePath = [[NSBundle mainBundle] pathForResource:varStyles.backgroundFileName ofType:nil inDirectory:k];
		
		background.image = [UIImage imageWithContentsOfFile:imagePath];
		
		
	}else{
		if([eMobcViewController isIPad]){
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				background = [[UIImageView alloc] initWithFrame:CGRectMake(0, sizeTop, 1024, 768 - sizeTop - sizeBottom)];
			}else{
				background = [[UIImageView alloc] initWithFrame:CGRectMake(0, sizeTop, 768, 1024 - sizeTop - sizeBottom)];
			}				
		}else {
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				background = [[UIImageView alloc] initWithFrame:CGRectMake(0, sizeTop, 480, 320 - sizeTop - sizeBottom)];
			}else{
				background = [[UIImageView alloc] initWithFrame:CGRectMake(0, sizeTop, 320, 480 - sizeTop - sizeBottom)];
			}				
		}
		background.backgroundColor = [UIColor whiteColor];
		background.opaque = NO;
	}
	[self.view addSubview:background];
}

-(void) createIntroduction{
	if(![data.headerImageFile isEqualToString:@""]){
		
		NSString *k = [eMobcViewController whatDevice:k];
		
		NSString *imagePath = [[NSBundle mainBundle] pathForResource:data.headerImageFile ofType:nil inDirectory:k];
		
		imgView.image = [UIImage imageWithContentsOfFile:imagePath];
		
		int width = imgView.image.size.width;
		int height = imgView.image.size.height;
		
		if([eMobcViewController isIPad]){
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				if(width > 1024 || height > 300){
					imgView.frame = CGRectMake(0, sizeTop, 1024, 300);
					sizeTop += 300;
				}else{
					imgView.frame = CGRectMake((1024 - width)/2, sizeTop, width, height);
					sizeTop += height;
				}
			}else{
				if(width > 768 || height > 400){
					imgView.frame = CGRectMake(0, sizeTop, 768, 400);
					sizeTop += 400;
				}else{
					imgView.frame = CGRectMake((768 - width)/2, sizeTop, width, height);
					sizeTop += height;
				}
			}				
		}else {
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				if(width > 320 || height > 90){
					imgView.frame = CGRectMake(80, sizeTop, 320, 90);
					sizeTop += 90;
				}else{
					imgView.frame = CGRectMake((480 - width)/2, sizeTop, width, height);
					sizeTop += height;
				}
			}else{
				if(width > 320 || height > 120){
					imgView.frame = CGRectMake(0, sizeTop, 320, 120);
					sizeTop += 120;
				}else{
					imgView.frame = CGRectMake((320 - width)/2, sizeTop, width, height);
					sizeTop += height;
				}
			}				
		}
		
		imgView.contentMode = UIViewContentModeScaleAspectFit;
		
		[self.view addSubview:imgView];
	}
	
	[self startButton];
	
	
	if(![data.description isEqualToString:@""]){
		
		if([eMobcViewController isIPad]){
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				myDescription = [[UITextView alloc] initWithFrame:CGRectMake(0, sizeTop, 1024, 768 - sizeTop - sizeBottom)];	
			}else{
				myDescription = [[UITextView alloc] initWithFrame:CGRectMake(0, sizeTop, 768, 1024 - sizeTop - sizeBottom)];
			}				
		}else {
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				myDescription = [[UITextView alloc] initWithFrame:CGRectMake(0, sizeTop, 480, 320 - sizeTop - sizeBottom)];	
			}else{
				myDescription = [[UITextView alloc] initWithFrame:CGRectMake(0, sizeTop, 320, 480 - sizeTop - sizeBottom)];
			}				
		}
		myDescription.text = data.description;
		
		/*Estilos
		 
		 int varSize = [varFormats.textSize intValue];
		 
		 myDescription.font = [UIFont fontWithName:varFormats.typeFace size:varSize];*/
		myDescription.backgroundColor = [UIColor clearColor];
		
		//Hay que convertirlo a hexadecimal.
		//	varFormats.textColor*/
		myDescription.textColor = [UIColor blackColor];
		myDescription.textAlignment = UITextAlignmentCenter;
		[myDescription setUserInteractionEnabled:NO];
		
		[self.view addSubview:myDescription];
		[myDescription release];
	}
	
}

-(void) startButton{
	//create the button
	button = [UIButton buttonWithType:UIButtonTypeCustom];
	
	NSString *k = [eMobcViewController whatDevice:k];
	
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:data.startImage ofType:nil inDirectory:k];
	
	[button setImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateNormal];
	
	int width, height;
	
	if(![data.startImage isEqualToString:@""] && data.startImage != nil){
		width = button.imageView.image.size.width;
		height = button.imageView.image.size.height;
	}else{
		width = 120;
		height = 30;
	}
	
	//set the position of the button
	if([eMobcViewController isIPad]){
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			if(width > 240 || height > 50){
				button.frame = CGRectMake(392, 768 - sizeBottom - 55, 240, 50);
				sizeBottom += 50;
			}else{
				button.frame = CGRectMake((1024 - width)/2, 768 - sizeBottom - height, width, height);
				sizeBottom += height + 5;
			}
		}else{
			if(width > 240 || height > 60){
				button.frame = CGRectMake(264, 1024 - sizeBottom - 60, 240, 60);
				sizeBottom += 65;
			}else{
				button.frame = CGRectMake((768 - width)/2, 1024 - sizeBottom - height, width, height);
				sizeBottom += height + 5;
			}
		}				
	}else {
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			if(width > 120 || height > 30){
				button.frame = CGRectMake(320, 320 - sizeBottom - 35, 120, 30);
				sizeBottom += 35;
			}else{
				button.frame = CGRectMake((480 - width)/2, 320 - sizeBottom - height, width, height);
				sizeBottom += height + 5;
			}
		}else{
			if(width > 120 || height > 30){
				button.frame = CGRectMake(100, 480 - sizeBottom - 35, 120, 30);
				sizeBottom += 35;
			}else{
				button.frame = CGRectMake((320 - width)/2, 480 - sizeBottom - height, width, height);
				sizeBottom += height + 5;
			}
		}				
	}
	
	if([data.startImage isEqualToString:@""] || data.startImage == nil){
		//set the button's title
		[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[button setTitle:@"Start" forState:UIControlStateNormal];
		
	}
	
	button.imageView.contentMode = UIViewContentModeScaleAspectFit;
	button.adjustsImageWhenHighlighted = NO;

	//listen for clicks
	[button addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
	
	//add the button to the view
	[self.view addSubview:button];
}

-(void) buttonPressed{
	[myLabel removeFromSuperview];
	[imgView removeFromSuperview];
	[myDescription removeFromSuperview];
	[button removeFromSuperview];
	
	if(![data.first isEqualToString:@""]){
		[self question: data.first];
	}else{
		[self randomQuestion];
	}
}

-(void) question:(NSString*) next{
	[imgViewQuestion removeFromSuperview];
	[myText removeFromSuperview];
	[myAnswer removeFromSuperview];
	
	[but removeFromSuperview];
	[but release];
	
	sizeTop = 0;
	sizeBottom = 0;
	
	sizeTop = [mainController ifMenuAndAdsTop:sizeTop];
	sizeBottom = [mainController ifMenuAndAdsBottom:sizeBottom];
	
	[self loadBackground];	
	
	varQuestion = [data.questionsMap objectForKey:next];
	
	if(![varQuestion.imageFile isEqualToString:@""]){
		imgViewQuestion = [[UIImageView alloc] init];
		
		NSString *k = [eMobcViewController whatDevice:k];
		
		NSString *imagePath = [[NSBundle mainBundle] pathForResource:varQuestion.imageFile ofType:nil inDirectory:k];
		
		imgViewQuestion.image = [UIImage imageWithContentsOfFile:imagePath];
		
		int width = imgViewQuestion.image.size.width;
		int heigth = imgViewQuestion.image.size.height;
		
		if([eMobcViewController isIPad]){
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				if(width > 1024 || heigth > 300){
					imgViewQuestion.frame = CGRectMake(100, sizeTop, 1024, 300);
					sizeTop += 300;
				}else{
					imgViewQuestion.frame = CGRectMake((1024 - width)/2, sizeTop, width, heigth);
					sizeTop += heigth + 5;
				}
			}else{
				if(width > 768 || heigth > 300){
					imgViewQuestion.frame = CGRectMake(0, sizeTop, 768, 300);
					sizeTop += 300;
				}else{
					imgViewQuestion.frame = CGRectMake((768 - width)/2, sizeTop, width, heigth);
					sizeTop += heigth + 5;
				}
			}				
		}else {
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				if(width > 280 || heigth > 70){
					imgViewQuestion.frame = CGRectMake(100, sizeTop, 280, 70);
					sizeTop += 70;
				}else{
					imgViewQuestion.frame = CGRectMake((480 - width)/2, sizeTop, width, heigth);
					sizeTop += heigth + 5;
				}
			}else{
				if(width > 320 || heigth > 120){
					imgViewQuestion.frame = CGRectMake(0, sizeTop, 320, 120);
					sizeTop += 120;
				}else{
					imgViewQuestion.frame = CGRectMake((320 - width)/2, sizeTop, width, heigth);
					sizeTop += heigth + 5;
				}
			}				
		}
				
		imgViewQuestion.contentMode = UIViewContentModeScaleAspectFit;
		
		[self.view addSubview:imgViewQuestion];
		[imgViewQuestion release];		
	}
	
	if(![varQuestion.text isEqualToString:@""]){
		
		if([eMobcViewController isIPad]){
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				myText = [[UILabel alloc] initWithFrame:CGRectMake(0, sizeTop, 1024, 30)];
				sizeTop += 50;
			}else{
				myText = [[UILabel alloc] initWithFrame:CGRectMake(0, sizeTop, 768, 50)];
				sizeTop += 70;
			}				
		}else {
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				myText = [[UILabel alloc] initWithFrame:CGRectMake(0, sizeTop, 480, 45)];	
				sizeTop += 45;
			}else{
				myText = [[UILabel alloc] initWithFrame:CGRectMake(0, sizeTop, 320, 60)];
				sizeTop += 60;
			}				
		}
		myText.text = varQuestion.text;
		myText.lineBreakMode = UILineBreakModeWordWrap;
		myText.numberOfLines = 0;
		
		/*Estilos
		 
		 int varSize = [varFormats.textSize intValue];
		 
		 myText.font = [UIFont fontWithName:varFormats.typeFace size:varSize];*/
		myText.backgroundColor = [UIColor clearColor];
		
		//Hay que convertirlo a hexadecimal.
		//	varFormats.textColor*/
		myText.textColor = [UIColor blackColor];
		myText.textAlignment = UITextAlignmentCenter;
		
		[self.view addSubview:myText];
		[myText release];
	}
	
	
	//cuantas respuestas
	int count = [varQuestion.answers count];
	
	for(int i = 0; i < count; i++){
		varAnswer = [varQuestion.answers objectAtIndex:i];
		
		but = [UIButton buttonWithType:UIButtonTypeCustom];
		
		if([eMobcViewController isIPad]){
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				[but setFrame:CGRectMake(0, sizeTop, 320, 40)];
				sizeTop += 45;
			}else{
				[but setFrame:CGRectMake(0, sizeTop, 320, 40)];
				sizeTop += 45;
			}				
		}else {
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				[but setFrame:CGRectMake(0, sizeTop, 320, 30)];
				sizeTop += 35;
			}else{
				[but setFrame:CGRectMake(0, sizeTop, 320, 40)];
				sizeTop += 45;
			}				
		}
		
		NSString *k = [eMobcViewController whatDevice:k];
		
		NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"images/answerButtonOff.png" ofType:nil inDirectory:k];
		NSString *imagePath1 = [[NSBundle mainBundle] pathForResource:@"images/answerButtonOn.png" ofType:nil inDirectory:k];
		
		[but setImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateNormal];
		[but setImage:[UIImage imageWithContentsOfFile:imagePath1] forState:UIControlStateSelected];
		
		[but setTitle:varAnswer.answerText forState:UIControlStateNormal];
		[but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		
		[but setTag:i];
		[but addTarget:self action:@selector(checkboxButton:) forControlEvents:UIControlEventTouchUpInside];
		
		[self.view addSubview:but];
	}	
}

-(void) checkboxButton:(UIButton*) buttons{
	int idAnswer = [buttons tag];
	for(but in [self.view subviews]){
		if([but isKindOfClass:[UIButton class]] && ![but isEqual:buttons]){
			[but setSelected:NO];
		}
	}
	if(!buttons.selected){
		buttons.selected = !buttons.selected;
	}
	
	
	varAnswer = [varQuestion.answers objectAtIndex:idAnswer];
	a = varAnswer.next;
	
	/*if(![a isEqualToString:@""]){
	 //Sin los button radio
	 [self question:a];
	 
	 }else{
	 [self quizFinish];
	 }*/
	
	
	//Para utilizar el quiz con los button radios
	if(![a isEqualToString:@""]){
		//Sin los button radio
		[self nextButton];
	}else{
		[self quizFinish];
	}
	
}

-(void) nextButton {
	//create the button
	button = [UIButton buttonWithType:UIButtonTypeCustom];
	
	NSString *k = [eMobcViewController whatDevice:k];
	
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:data.nextImage ofType:nil inDirectory:k];
		
	[button setImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateNormal];
	
	int width, height;
	
	if(![data.nextImage isEqualToString:@""] && data.nextImage != nil) {
		width = button.imageView.image.size.width;
		height = button.imageView.image.size.height;
	}else{
		width = 120;
		height = 30;
	}
	
	//set the position of the button
	if([eMobcViewController isIPad]){
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			if(width > 240 || height > 50){
				button.frame = CGRectMake(400, 768 - sizeBottom - 55, 240, 50);
			}else{
				button.frame = CGRectMake(((1024 - width)/2), 768 - sizeBottom - 55, width, height);
			}
		}else{
			if(width > 240 || height > 50){
				button.frame = CGRectMake(500, 1024 - sizeBottom - 55, 240, 50);
			}else{
				button.frame = CGRectMake(((768 - width)/2), 1024 - sizeBottom - 35, width, height);
			}
		}				
	}else {
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			if(width > 120 || height > 30){
				button.frame = CGRectMake(340, 320 - sizeBottom - 35, 120, 30);
			}else{
				button.frame = CGRectMake(((480 - width)/2) + 120, 320 - sizeBottom - 35, width, height);
			}
		}else{
			if(width > 120 || height > 30){
				button.frame = CGRectMake(180, 480 - sizeBottom - 35, 120, 30);
			}else{
				button.frame = CGRectMake(((320 - width)/2) + 80, 480 - sizeBottom - 35, width, height);
			}
		}				
	}
	
	if([data.nextImage isEqualToString:@""] || data.nextImage == nil){
		//set the button's title
		[button setTitle:@"Next" forState:UIControlStateNormal];
		[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	}
	
	button.imageView.contentMode = UIViewContentModeScaleAspectFit;
	button.adjustsImageWhenHighlighted = NO;
		
	//listen for clicks
	[button addTarget:self action:@selector(upgradeQuestion) forControlEvents:UIControlEventTouchUpInside];
	
	//add the button to the view
	[self.view addSubview:button];
}

-(void) upgradeQuestion{
	//El parametro selecionado sera guadado en una varible local y se le mandara el next a la funcion question por parametro.
	[self question:a];
}


//----------------------------------------------------

-(void) randomQuestion {
	if([varAnswer.correct isEqualToString:@"true"]){
		[self scorePoints];
	}
	
	sizeTop = 0;
	sizeBottom = 0;
	
	sizeTop = [mainController ifMenuAndAdsTop:sizeTop];
	sizeBottom = [mainController ifMenuAndAdsBottom:sizeBottom];
	
	[self loadBackground];
	
	int count = [data.question count];
	
	if(count == [numQuestion count]){
		[self quizFinish];
	}else{
		int fromNumber = 0;
		int toNumber = count;
		int randomNumber = (arc4random()%(toNumber - fromNumber)) + fromNumber;
		
		int p = [questionRepeat count];
		int r;
		int sw = 0;
		
		NSString *bString = [NSString stringWithFormat:@"%d", randomNumber];
		
		[questionRepeat addObject:bString];
		
		for(int j = 0; j < p; j++){
			r =[[questionRepeat objectAtIndex:j] intValue];
			
			if(randomNumber == r){
				sw = 1;
			}
		}
		
		if(sw == 0){
			//El numero de preguntas para que no se repitan y se acabe el quiz.
			[numQuestion addObject:bString];
			
			varQuestion = [data.question objectAtIndex:randomNumber];
			
			if(![varQuestion.imageFile isEqualToString:@""]){
				imgViewQuestion = [[UIImageView alloc] init];
				
				NSString *k = [eMobcViewController whatDevice:k];
				
				NSString *imagePath = [[NSBundle mainBundle] pathForResource:varQuestion.imageFile ofType:nil inDirectory:k];
				
				imgViewQuestion.image = [UIImage imageWithContentsOfFile:imagePath];
				
				int width = imgViewQuestion.image.size.width;
				int heigth = imgViewQuestion.image.size.height;
				
				if([eMobcViewController isIPad]){
					if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
						if(width > 1024 || heigth > 300){
							imgViewQuestion.frame = CGRectMake(100, sizeTop, 1024, 300);
							sizeTop += 300;
						}else{
							imgViewQuestion.frame = CGRectMake((1024 - width)/2, sizeTop, width, heigth);
							sizeTop += heigth + 5;
						}
					}else{
						if(width > 768 || heigth > 300){
							imgViewQuestion.frame = CGRectMake(0, sizeTop, 768, 300);
							sizeTop += 300;
						}else{
							imgViewQuestion.frame = CGRectMake((768 - width)/2, sizeTop, width, heigth);
							sizeTop += heigth + 5;
						}
					}				
				}else {
					if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
						if(width > 280 || heigth > 70){
							imgViewQuestion.frame = CGRectMake(100, sizeTop, 280, 70);
							sizeTop += 70;
						}else{
							imgViewQuestion.frame = CGRectMake((480 - width)/2, sizeTop, width, heigth);
							sizeTop += heigth + 5;
						}
					}else{
						if(width > 320 || heigth > 120){
							imgViewQuestion.frame = CGRectMake(0, sizeTop, 320, 120);
							sizeTop += 120;
						}else{
							imgViewQuestion.frame = CGRectMake((320 - width)/2, sizeTop, width, heigth);
							sizeTop += heigth + 5;
						}
					}				
				}
				
				imgViewQuestion.contentMode = UIViewContentModeScaleAspectFit;
				
				[self.view addSubview:imgViewQuestion];
			}
			
			if(![varQuestion.text isEqualToString:@""]){
				
				if([eMobcViewController isIPad]){
					if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
						myText = [[UILabel alloc] initWithFrame:CGRectMake(0, sizeTop, 1024, 50)];
						sizeTop += 50;
					}else{
						myText = [[UILabel alloc] initWithFrame:CGRectMake(0, sizeTop, 768, 50)];
						sizeTop += 50;
					}				
				}else {
					if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
						myText = [[UILabel alloc] initWithFrame:CGRectMake(0, sizeTop, 480, 65)];	
						sizeTop += 65;
					}else{
						myText = [[UILabel alloc] initWithFrame:CGRectMake(0, sizeTop, 320, 65)];
						sizeTop += 65;
					}				
				}
				myText.text = varQuestion.text;
				myText.lineBreakMode = UILineBreakModeWordWrap;
				myText.numberOfLines = 0;
				
				/*Estilos
				 
				 int varSize = [varFormats.textSize intValue];
				 
				 myText.font = [UIFont fontWithName:varFormats.typeFace size:varSize];*/
				myText.backgroundColor = [UIColor clearColor];
				
				//Hay que convertirlo a hexadecimal.
				//	varFormats.textColor*/
				myText.textColor = [UIColor blackColor];
				myText.textAlignment = UITextAlignmentCenter;
				
				[self.view addSubview:myText];
			}
			
			
			//how many answers
			int count1 = [varQuestion.answers count];
			
			for(int i = 0; i < count1; i++){
				varAnswer = [varQuestion.answers objectAtIndex:i];
				
				but = [UIButton buttonWithType:UIButtonTypeCustom];
				if([eMobcViewController isIPad]){
					if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
						[but setFrame:CGRectMake(0, sizeTop, 1024, 50)];
						sizeTop += 55;
					}else{
						[but setFrame:CGRectMake(0, sizeTop, 768, 50)];
						sizeTop += 55;
					}				
				}else {
					if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
						[but setFrame:CGRectMake(0, sizeTop, 320, 30)];
						sizeTop += 35;
					}else{
						[but setFrame:CGRectMake(0, sizeTop, 320, 40)];
						sizeTop += 45;
					}				
				}
				
				NSString *k = [eMobcViewController whatDevice:k];
				
				NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"images/answerButtonOff.png" ofType:nil inDirectory:k];
				NSString *imagePath1 = [[NSBundle mainBundle] pathForResource:@"images/answerButtonOn.png" ofType:nil inDirectory:k];
				
				[but setImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateNormal];
				[but setImage:[UIImage imageWithContentsOfFile:imagePath1] forState:UIControlStateSelected];
				
				[but setTitle:varAnswer.answerText forState:UIControlStateNormal];
				[but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
				
				[but setTag:i];
				[but addTarget:self action:@selector(checkboxButtonRandom:) forControlEvents:UIControlEventTouchUpInside];
				
				[self.view addSubview:but];
			}	
			
		}else{
			[self randomQuestion];
		}
	}
}

-(void) checkboxButtonRandom:(UIButton*) buttons{
	int idAnswer = [buttons tag];
	for(but in [self.view subviews]){
		if([but isKindOfClass:[UIButton class]] && ![but isEqual:buttons]){
			[but setSelected:NO];
		}
	}
	if(!buttons.selected){
		buttons.selected = !buttons.selected;
		
	}
	
	varAnswer = [varQuestion.answers objectAtIndex:idAnswer];
	
	
	//[self randomQuestion];
	
	//Para utilizar el quiz con los button radios
	[self nextButtonRandom];
}

-(void) nextButtonRandom{
	//create the button
	button = [UIButton buttonWithType:UIButtonTypeCustom];
	
	NSString *k = [eMobcViewController whatDevice:k];
	
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:data.nextImage ofType:nil inDirectory:k];
	
	//set the button's title
	[button setImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateNormal];
	
	int width, height;
	
	if(![data.nextImage isEqualToString:@""] && data.nextImage != nil) {
		width = button.imageView.image.size.width;
		height = button.imageView.image.size.height;
	}else{
		width = 120;
		height = 30;
	}
	
	//set the position of the button
	if([eMobcViewController isIPad]){
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			if(width > 240 || height > 50){
				button.frame = CGRectMake(400, 768 - sizeBottom - 55, 240, 50);
			}else{
				button.frame = CGRectMake(((1024 - width)/2), 768 - sizeBottom - 55, width, height);
			}
		}else{
			if(width > 240 || height > 50){
				button.frame = CGRectMake(500, 1024 - sizeBottom - 55, 240, 50);
			}else{
				button.frame = CGRectMake(((768 - width)/2), 1024 - sizeBottom - 35, width, height);
			}
		}				
	}else {
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			if(width > 120 || height > 30){
				button.frame = CGRectMake(340, 320 - sizeBottom - 35, 120, 30);
			}else{
				button.frame = CGRectMake(((480 - width)/2) + 120, 320 - sizeBottom - 35, width, height);
			}
		}else{
			if(width > 120 || height > 30){
				button.frame = CGRectMake(180, 480 - sizeBottom - 35, 120, 30);
			}else{
				button.frame = CGRectMake(((320 - width)/2) + 80, 480 - sizeBottom - 35, width, height);
			}
		}				
	}
	
	if([data.nextImage isEqualToString:@""] || data.nextImage == nil){
		//set the button's title
		[button setTitle:@"Next" forState:UIControlStateNormal];
		[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	}
	
	button.imageView.contentMode = UIViewContentModeScaleAspectFit;
	button.adjustsImageWhenHighlighted = NO;
		
	//listen for clicks
	[button addTarget:self action:@selector(randomQuestion) forControlEvents:UIControlEventTouchUpInside];
	
	//add the button to the view
	[self.view addSubview:button];
}

-(void) scorePoints {
	[score addObject:varQuestion.weight];
}

//----------------------------------------------------

-(void) quizFinish{
	[self loadBackground];
	
	NSString *k = [eMobcViewController whatDevice:k];
		
	if([eMobcViewController isIPad]){
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			myTextPoint = [[UILabel alloc] initWithFrame:CGRectMake(0, 520, 1024, 30)];
		}else{
			myTextPoint = [[UILabel alloc] initWithFrame:CGRectMake(0, 800, 768, 70)];
		}				
	}else {
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			myTextPoint = [[UILabel alloc] initWithFrame:CGRectMake(0, 230, 300, 40)];
		}else{
			myTextPoint = [[UILabel alloc] initWithFrame:CGRectMake(0, 285, 320, 110)];
		}				
	}
	
	int valor = [score count];
	int point = 0;
	int n;
		
	for(int k = 0; k < valor; k++){
		n = [[score objectAtIndex:k] intValue];
		point = point + n;
	}
	
	NSString *aString = [NSString stringWithFormat:@"Score point : %d", point];
	myTextPoint.text = aString;
	
	myTextPoint.backgroundColor = [UIColor clearColor];
	myTextPoint.textAlignment = UITextAlignmentCenter;
	myTextPoint.textColor = [UIColor blackColor];
	
	
	
	//create the button
	button = [UIButton buttonWithType:UIButtonTypeCustom];
	
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:data.finishImage ofType:nil inDirectory:k];
	
	//set the button's title
	[button setImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateNormal];
	
	int width, height;
	
	if(![data.finishImage isEqualToString:@""] && data.finishImage != nil) {
		width = button.imageView.image.size.width;
		height = button.imageView.image.size.height;
	}else{
		width = 120;
		height = 30;
	}
	
	//set the position of the button
	if([eMobcViewController isIPad]){
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			if(width > 240 || height > 50){
				button.frame = CGRectMake(400, 768 - sizeBottom - 55, 240, 50);
			}else{
				button.frame = CGRectMake(((1024 - width)/2), 768 - sizeBottom - 55, width, height);
			}
		}else{
			if(width > 240 || height > 50){
				button.frame = CGRectMake(500, 1024 - sizeBottom - 55, 240, 50);
			}else{
				button.frame = CGRectMake(((768 - width)/2), 1024 - sizeBottom - 35, width, height);
			}
		}				
	}else {
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			if(width > 120 || height > 30){
				button.frame = CGRectMake(340, 320 - sizeBottom - 35, 120, 30);
			}else{
				button.frame = CGRectMake(((480 - width)/2) + 120, 320 - sizeBottom - 35, width, height);
			}
		}else{
			if(width > 120 || height > 30){
				button.frame = CGRectMake(180, 480 - sizeBottom - 35, 120, 30);
			}else{
				button.frame = CGRectMake(((320 - width)/2) + 80, 480 - sizeBottom - 35, width, height);
			}
		}				
	}
	
	if([data.finishImage isEqualToString:@""] || data.finishImage == nil){
		//set the button's title
		[button setTitle:@"Close" forState:UIControlStateNormal];
		[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	}
	
	button.imageView.contentMode = UIViewContentModeScaleAspectFit;
	button.adjustsImageWhenHighlighted = NO;
	
	//listen for clicks
	[button addTarget:self action:@selector(backButtonPress:) forControlEvents:UIControlEventTouchUpInside];
	
	//add the button to the view
	[self.view addSubview:button];
	
	[self.view addSubview:myTextPoint];	
	[myTextPoint release];
}


/**
 * Show a level back when backButton is pressed
 */
-(void)backButtonPress:(id)sender {
	[mainController goBack];	
}


/**
 * Show differents views depending on orientation
 *
 * @param object
 */
-(void) orientationChanged:(NSNotification *)object{
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	
	if(orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationUnknown || currentOrientation == orientation ){
		return;
	}
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(relayoutLayers) object: nil];
	
	currentOrientation = orientation;
	
	[self performSelector:@selector(orientationChangedMethod) withObject: nil afterDelay: 0];
}

-(void) orientationChangedMethod{
	
	if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
		self.view = self.landscapeView;
	}else{
		self.view = self.portraitView;
	}
	
	if(loadContent == FALSE){
		loadContent = TRUE;
		
		if(![mainController.appData.backgroundMenu isEqualToString:@""]){
			[self loadBackgroundMenu];
		}
		
		if(![mainController.appData.topMenu isEqualToString:@""]){
			[self callTopMenu];
		}
		if(![mainController.appData.bottomMenu isEqualToString:@""]){
			[self callBottomMenu];
		}
		
		//publicity
		if([mainController.appData.banner isEqualToString:@"admob"]){
			[self createAdmobBanner];
		}else if([mainController.appData.banner isEqualToString:@"yoc"]){
			[self createYocBanner];
		}
		
		[self viewDidLoad];	
	}
}


/**
 * Load themes from xml into components
 */
-(void)loadThemesComponents {
	for(int x = 0; x < varStyles.listComponents.count; x++){
		NSString *var = [varStyles.listComponents objectAtIndex:x];
		
		NSString *type = [varStyles.mapFormatComponents objectForKey:var];
		
		varFormats = [mainController.theFormat.formatsMap objectForKey:type];
		
		
		if([var isEqualToString:@"header"]){
			if([eMobcViewController isIPad]){
				if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
					myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, sizeTop, 1024, 20)];	
				}else{
					myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, sizeTop, 768, 20)];
				}				
			}else {
				if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
					myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, sizeTop, 480, 20)];	
				}else{
					myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, sizeTop, 320, 20)];
				}				
			}
			
			myLabel.text = data.headerText;
			
			int varSize = [varFormats.textSize intValue];
			
			myLabel.font = [UIFont fontWithName:varFormats.typeFace size:varSize];
			myLabel.backgroundColor = [UIColor clearColor];
			
			//Hay que convertirlo a hexadecimal.
			//	varFormats.textColor
			
			//myLabel.textColor =  [UIColor colorWithRed:100 green:20 blue:10 alpha:1];
			
			myLabel.textColor = [UIColor blackColor];
			myLabel.textAlignment = UITextAlignmentCenter;
			
			[self.view addSubview:myLabel];
			[myLabel release];
		}
	}
}


/**
 * Load themes
 */
-(void) loadThemes {
	if(![varStyles.components isEqualToString:@""]) {
		NSArray *separarComponents = [varStyles.components componentsSeparatedByString:@";"];
		NSArray *assignment;
		NSString *component;
		
		for(int i = 0; i < separarComponents.count - 1; i++){
			assignment = [[separarComponents objectAtIndex:i] componentsSeparatedByString:@"="];
			
			component = [assignment objectAtIndex:0];
			NSString *format = [assignment objectAtIndex:1];
			
			[varStyles.mapFormatComponents setObject:format forKey:component];
			
			if(![component isEqual:@"selection_list"]){
				[varStyles.listComponents addObject:component];
			}else{
				varStyles.selectionList = format;
			}
		}
		[self loadThemesComponents];
	}
}


/**
 * Sent to the view controller when the application receives a memory warning
 */
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


/**
 * Called when the controller’s view is released from memory.
 */
- (void)viewDidUnload {
    [super viewDidUnload];
	
	// Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end