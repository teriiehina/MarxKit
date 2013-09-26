//
//  PJDebugToolSettingsViewer.h
//  PagesJaunes
//
//  Created by Jérémie Godon on 7/05/13.
//  Copyright (c) 2013 PagesJaunes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#import "PJDebugToolDelegate.h"


/**
 *  Cette classe est un view controller permettant :
 *
 *        - d'afficher, de filtrer et d'envoyer par mail les logs générés l'appli
 *        - de selectionner un serveur et d'en avertir le delegate
 *        - d'activer dynatrace (pas fonctionnel pour l'instant)
 *
 *  Remarque: Il faut avoir activé l'enregistrement des logs (par exemple [PJDMOutputWriter activatePrintingLogs])
 */




#define SERVERS_LIST_FILE_PLIST @"PJDMServersList"



@interface PJDebugToolSettingsViewer : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate, UISearchBarDelegate>
{
  // Toolbars
  IBOutlet UIToolbar       *_topToolBar;             //!< ToolBar du haut contenant les boutons de Logs / Partage / Config et OK.
  IBOutlet UIToolbar       *_bottomToolBar;          //!< ToolBar du bas de la vue des logs pour reset le fichier
  
  // Logs
  IBOutlet UIView          *_logsView;               //!< Vue contenant les logs et la barre de recherche
  IBOutlet UITextView      *_logsTextView;           //!< TextView affichant les logs
  IBOutlet UISearchBar     *_searchBar;              //!< Barre de recherche permettant de filtrer les logs
  
  // Config
  IBOutlet UIView          *_settingsView;           //!< Vue de configuration
  IBOutlet UIPickerView    *_pickerView;             //!< Roulette de choix du serveur
  
  // Dynatrace
  IBOutlet UISwitch        *_dynaSwitch;             //!< Switch qui active ou desactive Dynatrace
}


@property (nonatomic, unsafe_unretained) id<PJDebugToolDelegate> delegate;


/** Click sur un des deux boutons de la bar du haut (autre que "OK") et affiche alternativement l'écran de log ou de filtres */
- (IBAction)didClickOnItemBarButton:(id)sender;


/** Click sur le bouton "OK" de la barre du haut */
- (IBAction)didClickOnDismissButton:(id)sender;


/** Click sur le bouton "Sélectionner ce server" */
- (IBAction)didClickOnValidateServer:(id)sender;


/** Click sur le bouton Resetet le fichier de logs */
- (IBAction)didClickOnClearLogButton:(id)sender;


/** Swich for activate/desactivate dynatrace */
- (IBAction)didSwitchDynatrace:(id)sender;

@end
