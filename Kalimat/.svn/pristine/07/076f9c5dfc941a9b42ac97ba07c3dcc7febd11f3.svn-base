//
//  TransitionConstants.h
//  AePubReader
//
//  Created by Ahmed Aly on 11/11/12.
//
//

#ifndef AePubReader_TransitionConstants_h
#define AePubReader_TransitionConstants_h


#define NO_INTERNET_ALERT  UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No internet connections" message:@"Please,check you internet connection to be able to proceed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; \
[alert show]; \
[alert release]; \

#define  TRAN_PUSH_RIGHT  CATransition *transition = [CATransition animation];\
transition.duration = 0.8;\
transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];\
transition.type = kCATransitionPush;\
transition.delegate = self;\
transition.subtype = kCATransitionFromRight;\
[self.webView.layer addAnimation:transition forKey:nil];\

#define  TRAN_PUSH_LEFT  CATransition *transition = [CATransition animation];\
transition.duration = 0.8;\
transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];\
transition.type = kCATransitionPush;\
transition.delegate = self;\
transition.subtype = kCATransitionFromLeft;\
[self.webView.layer addAnimation:transition forKey:nil];\

/////////////////////////////
#define  TRAN_MOVE_RIGHT  CATransition *transition = [CATransition animation];\
transition.duration = 0.8;\
transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];\
transition.type = kCATransitionMoveIn;\
transition.delegate = self;\
transition.subtype = kCATransitionFromRight;\
[self.webView.layer addAnimation:transition forKey:nil];\

#define  TRAN_MOVE_LEFT  CATransition *transition = [CATransition animation];\
transition.duration = 0.8;\
transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];\
transition.type = kCATransitionMoveIn;\
transition.delegate = self;\
transition.subtype = kCATransitionFromLeft;\
[self.webView.layer addAnimation:transition forKey:nil];\
////////////////////////

#define  TRAN_FADE CATransition *transition = [CATransition animation];\
transition.duration = 0.8;\
transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];\
transition.type = kCATransitionFade;\
transition.delegate = self;\
transition.subtype = kCATransitionFromRight;\
[self.webView.layer addAnimation:transition forKey:nil];\

///////////////////////
#define  TRAN_REVEAL_RIGHT  CATransition *transition = [CATransition animation];\
transition.duration = 0.8;\
transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];\
transition.type = kCATransitionReveal;\
transition.delegate = self;\
transition.subtype = kCATransitionFromRight;\
[self.webView.layer addAnimation:transition forKey:nil];\

#define  TRAN_REVEAL_LEFT  CATransition *transition = [CATransition animation];\
transition.duration = 0.8;\
transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];\
transition.type = kCATransitionMoveIn;\
transition.delegate = self;\
transition.subtype = kCATransitionFromLeft;\
[self.webView.layer addAnimation:transition forKey:nil];\
////////////////////
#define TRAN_CUPE_RIGHT CATransition *transition = [CATransition animation];\
transition.duration = 0.8;\
transition.type = @"cube";\
transition.delegate = self;\
transition.subtype = kCATransitionFromRight;\
[self.webView.layer addAnimation:transition forKey:nil];\

#define TRAN_CUPE_LEFT CATransition *transition = [CATransition animation];\
transition.duration = 0.8;\
transition.type = @"cube";\
transition.delegate = self;\
transition.subtype = kCATransitionFromLeft;\
[self.webView.layer addAnimation:transition forKey:nil];\
//////////////////////
#define TRAN_FLIP_RIGHT CATransition *transition = [CATransition animation];\
transition.duration = 0.8;\
transition.type = @"flip";\
transition.delegate = self;\
transition.subtype = kCATransitionFromRight;\
[self.webView.layer addAnimation:transition forKey:nil];\

#define TRAN_FLIP_LEFT CATransition *transition = [CATransition animation];\
transition.duration = 0.8;\
transition.type = @"flip";\
transition.delegate = self;\
transition.subtype = kCATransitionFromLeft;\
[self.webView.layer addAnimation:transition forKey:nil];\
//////////////////////
#define TRAN_ROTATE_RIGHT CATransition *transition = [CATransition animation];\
transition.duration = 0.8;\
transition.type = @"rotate";\
transition.delegate = self;\
transition.subtype = kCATransitionFromRight;\
[self.webView.layer addAnimation:transition forKey:nil];\

#define TRAN_ROTATE_LEFT CATransition *transition = [CATransition animation];\
transition.duration = 0.8;\
transition.type = @"rotate";\
transition.delegate = self;\
transition.subtype = kCATransitionFromLeft;\
[self.webView.layer addAnimation:transition forKey:nil];\
///////////////////
#define TRAN_Ripple_RIGHT CATransition *transition = [CATransition animation];\
transition.duration = 0.8;\
transition.type = @"zoomyIn";\
transition.delegate = self;\
transition.subtype = kCATransitionFromRight;\
[self.webView.layer addAnimation:transition forKey:nil];\

#define TRAN_Ripple_LEFT CATransition *transition = [CATransition animation];\
transition.duration = 0.8;\
transition.type = @"zoomyIn";\
transition.delegate = self;\
transition.subtype = kCATransitionFromLeft;\
[self.webView.layer addAnimation:transition forKey:nil];\


#endif
