//
//  PJDebugTool.h
//  PagesJaunes
//
//  Created by Jérémie Godon on 7/05/13.
//  Copyright (c) 2013 PagesJaunes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "PJDebugToolDelegate.h"


/**
 * Cette classe permet d'initialiser un (joli) bouton qui, une fois qu'on a cliqué dessus,
 * présente le controller de vues PJDebugToolSettingsViewer de manière (un peu) stylisée
 * avec une roulette "genre settings" qui tourne sur elle-même...
 *
 * Remarque: Vous pouvez utiliser directement PJDebugToolSettingsViewer si vous préférez.
 */




@interface PJDebugTool : NSObject

/** Delegate averti lorsqu'on modifie la config serveur par exemple */
@property (nonatomic, unsafe_unretained) id<PJDebugToolDelegate> delegate;


/** Bouton permettant de lancer l'outil de debug */
@property (nonatomic, strong) UIButton *debugButton;


/** Initialise le bouton avec une petite roulette qui tourne par dessus afin que ça soit un peu joli... */
- (id)initWithParentViewer:(UIViewController *)pParentViewer;


/** Set la frame du bouton roulette */
- (void)setButtonFrame:(CGRect)pFrame;

@end
