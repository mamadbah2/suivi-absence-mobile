// Fonction pour vérifier si l'API Google Maps est prête
function _jsCheckGoogleMapsApiReady() {
  console.log('_jsCheckGoogleMapsApiReady appelé, état: ' + (window.googleMapsApiReady === true ? 'prêt' : 'non prêt'));
  return window.googleMapsApiReady === true;
}

// Fonction pour recharger la page
function _jsReloadPage() {
  console.log('_jsReloadPage appelé, rechargement de la page...');
  window.location.reload();
}

// Fonction d'initialisation exécutée au chargement
(function() {
  console.log('maps_utils.js chargé');
  console.log('État initial de googleMapsApiReady:', window.googleMapsApiReady);
  
  // Vérifier périodiquement l'état de l'API Google Maps
  const checkInterval = setInterval(function() {
    console.log('Vérification périodique de Google Maps:', window.googleMapsApiReady);
    if (window.googleMapsApiReady === true) {
      console.log('Google Maps API est maintenant prête!');
      clearInterval(checkInterval);
    }
  }, 1000);
})();