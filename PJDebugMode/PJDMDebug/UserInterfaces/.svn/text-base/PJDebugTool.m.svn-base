//
//  PJDebugTool.m
//  PagesJaunes
//
//  Created by Jérémie Godon on 7/05/13.
//  Copyright (c) 2013 PagesJaunes. All rights reserved.
//

#import "PJDebugTool.h"
#import "PJDebugToolSettingsViewer.h"

@implementation PJDebugTool
{
  UIViewController        *parentViewer_;     //!< Controller de vue parent
  UIImageView             *wheelImageView_;   //!< ImageView animé de la roulette qui tourne
}


/**
 * @brief Initialise le bouton avec une petite roulette qui tourne par dessus afin que ça soit un peu joli...
 *
 * @param le controlleur de vues parent qui présentera le modal view controller contenant la vue du debugTool
 */
- (id)initWithParentViewer:(UIViewController *)pParentViewer
{
  if ((self = [super init]))
  {
    UIImage *aImgBtn                  = [UIImage imageNamed:@"bouton-option.png"];
    
    // le bouton en lui-même
    _debugButton                      = [UIButton buttonWithType:UIButtonTypeCustom];
    _debugButton.backgroundColor      = [UIColor clearColor];
    _debugButton.frame                = CGRectMake(0., 0., aImgBtn.size.width, aImgBtn.size.height);
    [_debugButton addTarget:self action:@selector(startButtonAnimation:) forControlEvents:UIControlEventTouchUpInside];
    
    // la roulette qui tourne pour que ce soit joli
    wheelImageView_                   = [[UIImageView alloc] initWithImage:aImgBtn];
    wheelImageView_.frame             = CGRectMake(0., 0., aImgBtn.size.width, aImgBtn.size.height);
    wheelImageView_.animationImages   = [NSArray arrayWithObjects:[UIImage imageNamed:@"bouton-option3.png"], [UIImage imageNamed:@"bouton-option2.png"], [UIImage imageNamed:@"bouton-option.png"], nil];
    wheelImageView_.animationDuration = 0.3;
    
    [_debugButton addSubview:wheelImageView_];
    
    // le controller de vue parent
    parentViewer_ = pParentViewer;
  }
  return self;
}



#pragma mark - Action

/**
 * @brief Construit et affiche le controller de l'outil de débug
 */
- (void)launchDebugViewer
{
  PJDebugToolSettingsViewer *aDebugViewer = [[PJDebugToolSettingsViewer alloc] initWithNibName:([self isIphone5Screen] ? @"PJDebugToolSettingsViewer_iPhone5" : @"PJDebugToolSettingsViewer") bundle:nil];
  aDebugViewer.delegate                   = _delegate;
  
  [parentViewer_.navigationController presentModalViewController:aDebugViewer animated:YES];
}



#pragma mark - Wheel button animation

/**
 * @brief Lance l'animation de la roulette du bouton et présente le controller modal lié à l'outil de debug
 *
 * @note On a laissé un petit laps de temps avant de présenter le modal afin d'avoir le temps de voir la roulette tourner (coqueterie rules !)
 */
- (void)startButtonAnimation:(id)sender
{
  [wheelImageView_ startAnimating];
  
  // là on décale le lancement juste pour le style... histoire qu'on voit cette belle roulette tournée
  [self performSelector:@selector(launchDebugViewer) withObject:nil afterDelay:0.5];
  
  // et là on l'arrête parce que bon, juste pour le style, ça va deux secondes mais le but c'est pas de faire une roulette qui tourne...
  [self performSelector:@selector(stopButtonAnimation) withObject:nil afterDelay:1.];
}


/**
 * @brief Arrête l'animation de la roulette
 */
- (void)stopButtonAnimation
{
  [wheelImageView_ stopAnimating];
}


/**
 * @brief Set la frame du bouton roulette
 * @param Frame à setter
 */
- (void)setButtonFrame:(CGRect)pFrame
{
  _debugButton.frame = pFrame;
}



/**
 * @brief L'écran de cet iPhone est-il iPhone 5 ou pas ?
 */
- (BOOL)isIphone5Screen
{
  CGFloat height = [UIScreen mainScreen].bounds.size.height;
  CGFloat scale  = 1;
  if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
    scale = [[UIScreen mainScreen] scale];
  }
  return ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && ((height * scale) >= 1136));
}
@end
