//
//  PJDebugToolSettingsViewer.m
//  PagesJaunes
//
//  Created by Jérémie Godon on 7/05/13.
//  Copyright (c) 2013 PagesJaunes. All rights reserved.
//

#import "PJDebugToolSettingsViewer.h"
#import "PJDMMacros.h"


#define BAR_BUTTON_ITEM_LOGS_TAG       111
#define BAR_BUTTON_ITEM_SETTINGS_TAG   112
#define BAR_BUTTON_ITEM_SHARE_TAG      113


/**
 * Etat du debug mode : Affichage des logs ou configuration de l'appli
 */
typedef enum _PJDebugViewerState
{
  PJDebugViewerStateLogs     = 0,
  PJDebugViewerStateSettings = 1
} PJDebugViewerState;



@implementation PJDebugToolSettingsViewer
{
  /** Etat actuel du controller (Logs / Config) */
  PJDebugViewerState selectedState_;
  
  /** Tableau regroupant les serveurs à lister dans le pickerView et chargé à partir du pList */
  NSMutableArray *serversArray_;
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self)
  {
    // par défault on arrive sur les Logs
    selectedState_ = PJDebugViewerStateLogs;
  }
  return self;
}


- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // initilisation de la liste des servers
  [self initServersList];
  
  [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
}


- (void)viewDidUnload
{
  [super viewDidUnload];
  [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}


- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  // on commence par afficher les logs quand on arrive sur la vue
  [self changeViewToLogs];
}


#pragma mark - Rotation stuffs


- (void)orientationChanged:(NSNotification *)notification
{
  // là on rotte et on resize le textview
  UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
  if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
    _logsView.frame      = CGRectMake(_logsView.frame.origin.x, _logsView.frame.origin.y, self.view.frame.size.height, _logsView.frame.size.height);
    _topToolBar.frame    = CGRectMake(_topToolBar.frame.origin.x, _topToolBar.frame.origin.y, self.view.frame.size.height, _topToolBar.frame.size.height);
    _logsTextView.frame  = CGRectMake(_logsTextView.frame.origin.x, _logsTextView.frame.origin.y, self.view.frame.size.height, self.view.frame.size.width-(_topToolBar.frame.size.height+_searchBar.frame.size.height+_bottomToolBar.frame.size.height));
    _bottomToolBar.frame = CGRectMake(_bottomToolBar.frame.origin.x, _logsTextView.frame.origin.y+_logsTextView.frame.size.height, self.view.frame.size.height, _bottomToolBar.frame.size.height);
  }
  else {
    if (UIDeviceOrientationIsPortrait(deviceOrientation)) {
      _logsView.frame      = CGRectMake(_logsView.frame.origin.x, _logsView.frame.origin.y, self.view.frame.size.width, _logsView.frame.size.height);
      _topToolBar.frame    = CGRectMake(_topToolBar.frame.origin.x, _topToolBar.frame.origin.y, self.view.frame.size.width, _topToolBar.frame.size.height);
      _logsTextView.frame  = CGRectMake(_logsTextView.frame.origin.x, _logsTextView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-(_topToolBar.frame.size.height+_searchBar.frame.size.height+_bottomToolBar.frame.size.height));
      _bottomToolBar.frame = CGRectMake(_bottomToolBar.frame.origin.x, _logsTextView.frame.origin.y+_logsTextView.frame.size.height, self.view.frame.size.width, _bottomToolBar.frame.size.height);
    }
  }
}

    

/**
 * @brief Return a string that contains Log file content
 */
- (NSString *)getLogsFileContentString
{
  NSError *aError       = nil;
  NSString *aLogContent = [NSString stringWithContentsOfFile:[PJDMOutputWriter getFullPathForLogsFile] encoding:NSUTF8StringEncoding error:&aError];
  
  if (aError) {
    PJLog(@"Error: %@", aError);
    return nil;
  }
  
  return aLogContent;
}



#pragma mark - Change Views between Logs / Settings
#pragma mark -

/**
 * @brief Click sur le bouton "OK" de la barre du haut
 */
- (IBAction)didClickOnDismissButton:(id)sender
{
  [self dismissModalViewControllerAnimated:YES];
}



/**
 * @brief Click sur un des deux boutons de la bar du haut autre que "OK" et affiche alternativement l'écran de log ou de filtres
 */
- (IBAction)didClickOnItemBarButton:(id)sender
{
  UIBarButtonItem *clickedButton = (UIBarButtonItem *)sender;
  
  switch (clickedButton.tag)
  {
      // click sur Logs
    case BAR_BUTTON_ITEM_LOGS_TAG:
      // si on est sur les filtres, on affiche les logs
      if (selectedState_ != PJDebugViewerStateLogs) {
        [self changeViewToLogs];
      }
      break;
      
      // click sur le bouton Config
    case BAR_BUTTON_ITEM_SETTINGS_TAG:
      [self changeViewToSettings];
      break;
      
      // click sur le bouton Partage
    case BAR_BUTTON_ITEM_SHARE_TAG:
      [self showShareActionSheet];
      break;
      
    default:
      break;
  }
}



/**
 * @brief Changement vers l'écran de Logs
 */
- (void)changeViewToLogs
{
  selectedState_       = PJDebugViewerStateLogs;
  
  // remplissage du textView avec le contenue du fichier de log
  _logsTextView.text   = [self getLogsFileContentString];
  
  _logsTextView.hidden = NO;
  _settingsView.hidden = YES;
  
  // activation du bouton de partage
  [self desableShareButton:NO];
}


/**
 * @brief Changement vers l'écran de configuration
 */
- (void)changeViewToSettings
{
  [_searchBar resignFirstResponder];
  
  selectedState_       = PJDebugViewerStateSettings;
  _settingsView.hidden = NO;
  _logsTextView.hidden = YES;
  
  // désactivation du bouton de partage
  [self desableShareButton:YES];
}


/**
 * @brief Active ou désactive le bouton de partage suivant le bouléen passé en paramètre
 */
- (void)desableShareButton:(BOOL)pDesable
{
  // on récupère le bouton de partage parmi tout ceux de la toolbar du haut
  for (UIBarButtonItem *btnItem in _topToolBar.items) {
    if (btnItem.tag == BAR_BUTTON_ITEM_SHARE_TAG) {
      btnItem.enabled = !pDesable;
      return;
    }
  }
}



#pragma mark - Filter Logs
#pragma mark -

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
  _searchBar.text    = @"";
  
  // remplissage du textView avec le contenue du fichier de log
  _logsTextView.text = [self getLogsFileContentString];
  
  [_searchBar resignFirstResponder];
}


/**
 * @brief Si click sur "Rechercher", filtre les logs contenant le mot engtré dans la searchbar
 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
  // on restreint l'affichage des logs aux lignes contenant le mot clef...
  [self filterLogsForKey:searchBar.text];
  
  [_searchBar resignFirstResponder];
}


/**
 * @brief Affiche dans le textview des logs les lignes contenant la string passée en paramètre
 */
- (void)filterLogsForKey:(NSString *)pFilter
{
  NSString *aFilteredLogs = @"";
  
  // on découpe les logs en lignes dans un tableau
  NSArray *aLogLinesArray = [_logsTextView.text componentsSeparatedByString:@"\n"];
  
  // pour chacune des lignes, on regarde si elles possèdent la string a filtrer
  for (NSString *lines in aLogLinesArray ) {
    if ([lines rangeOfString:pFilter options:NSCaseInsensitiveSearch].location != NSNotFound) {
      aFilteredLogs = [aFilteredLogs stringByAppendingFormat:@"%@\n", lines];
    }
  }
  // on rafraichit le text si c'est pas vide
  if (aFilteredLogs.length > 1) {
    _logsTextView.text = aFilteredLogs;
  }
  else {
    _logsTextView.text = @"Aucune ligne des logs ne contient ce mot clé";
  }
}



#pragma mark - Sharing Logs
#pragma mark -

- (void)showShareActionSheet
{
  UIActionSheet *aSheet = [[UIActionSheet alloc] initWithTitle:@"Que voulez-vous faire avec ces Logs ?" delegate:self cancelButtonTitle:@"Annuler" destructiveButtonTitle:nil otherButtonTitles:@"Envoyer par mail", nil];
  [aSheet showInView:_logsView];
}


/**
 * @brief Click sur un bouton de l'actionSheet, pour envoyer un mail par exemple...
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
  switch (buttonIndex) {
      // click sur le bouton de partage par mail
    case 0:
      // si on peut envoyer un mail avec ce device
      if ([MFMailComposeViewController canSendMail])
      {
        // on envoie les logs par mail
        [self sendMailWithMessage:_logsTextView.text];
      }
      // sinon popup d'erreur
      else {
        UIAlertView *aAlertView = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Vous ne pouvez pas envoyer de mail avec ce device !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [aAlertView show];
      }
      break;
      
    default:
      break;
  }
}


/**
 * @brief Envoie un mail contenant le message passé en paramètre, après avoir mis comme 'Object' le nom de l'appli et son numéro de version
 */
- (void)sendMailWithMessage:(NSString *)pMessage
{
  NSString *aAppName    = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
  NSString *aAppVersion = [NSString stringWithFormat:@"%@.%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"], [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
  
  MFMailComposeViewController *aMailer = [[MFMailComposeViewController alloc] init];
  aMailer.mailComposeDelegate = self;
  [aMailer setSubject:[NSString stringWithFormat:@"[%@ %@] - LOGS", aAppName, aAppVersion]];
  [aMailer setMessageBody:pMessage isHTML:NO];
  [self presentModalViewController:aMailer animated:YES];
}


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
  [self dismissModalViewControllerAnimated:YES];
}


#pragma mark - Configuration stuffs
#pragma mark -

/**
 * @brief Click sur le bouton "Sélectionner ce server"
 */
- (IBAction)didClickOnValidateServer:(id)sender
{
  // ligne du pickerView sélectionnée
  NSInteger selectedRow = [_pickerView selectedRowInComponent:0];
  
  // on dit à l'appli quel server elle doit utiliser
  if ([_delegate respondsToSelector:@selector(didChooseServer:)]) {
    [_delegate didChooseServer:selectedRow];
  }
}


/** 
 * @brief Click sur le bouton Resetet le fichier de logs
 */
- (IBAction)didClickOnClearLogButton:(id)sender
{
  // nettoyage du ficheir de logs
  [PJDMOutputWriter clearDefaultLogFile];
  
  // refresh de la vue...
  [self changeViewToLogs];
}



/**
 * @brief Initilisation de la liste de servers de base
 */
- (void)initServersList
{
  // commençons par un peu de ménage (pour éviter les doublons... lors du rechargement)
  [serversArray_ removeAllObjects];
  serversArray_ = nil;
  
  // importons la liste des sevreurs avec leur identifiants et leurs adresses depuis le fichier pList
  NSString *pListPath = [[NSBundle mainBundle] pathForResource:SERVERS_LIST_FILE_PLIST ofType:@"plist"];
  
  serversArray_       = [NSMutableArray arrayWithContentsOfFile:pListPath];
}


#pragma mark - UIPickerView for server settings
#pragma mark -

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
  return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
  return serversArray_.count;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  NSDictionary *aSelectedServer = [serversArray_ objectAtIndex:row];
  
  return [aSelectedServer objectForKey:@"name"];
}



#pragma mark -
#pragma mark - Dynatrace

- (IBAction)didSwitchDynatrace:(id)sender
{
  PJLog(@"Dynatrace %@", _dynaSwitch.isOn ? @"ON" : @"OFF");
  
  if ([_delegate respondsToSelector:@selector(didActivateDynatrace:)]) {
    [_delegate didActivateDynatrace:_dynaSwitch.isOn];
  }
}

@end
