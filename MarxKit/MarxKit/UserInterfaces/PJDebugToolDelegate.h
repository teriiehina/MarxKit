//
//  PJDebugToolDelegate.h
//  PJDebugMode
//
//  Created by Jérémie Godon on 16/07/13.
//  Copyright (c) 2013 Alejo Berman. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 
 * Liste des différents serveurs listés et selectionnables 
 */
typedef enum _PJDMDebugTypeServer
{
  PJDMDebugTypeServerIntegration1  = 0,  // Integ-1
  PJDMDebugTypeServerIntegration2  = 1,  // Integ-2
  PJDMDebugTypeServerIntegration3  = 2,  // Integ-3
  PJDMDebugTypeServerPreProduction = 3,  // Pré-Prod
  PJDMDebugTypeServerProduction    = 4   // Prod
} PJDMDebugTypeServer;



@protocol PJDebugToolDelegate <NSObject>

@required

/**
 * @brief Indique au delegate quel serveur a été sélectionné
 * @param PJDMDebugTypeServer : Type du seveur choisit (integ2, pre-prod, prod, etc...)
 */
- (void)didChooseServer:(PJDMDebugTypeServer)pServer;


@optional


/**
 * @brief Indique au delegate qu'on souhaite activer ou désactiver dynatrace
 * @param Booléen d'activation ou non
 */
- (void)didActivateDynatrace:(BOOL)pActivate;


@end
