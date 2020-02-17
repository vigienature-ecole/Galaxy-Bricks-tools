SELECT DISTINCT
   observations.observationpk AS Numero_observation,
   observations.date AS Date_obs,
   --users.nom AS Nom_enseignant,
   --users.prenom AS Prenom_enseignant,
   classes.anneescol AS Annee_scol,
   --classes.name AS Nom_classe,
   --classes.niveau AS Niveau_classe,
   --classes_groupes.name AS Nom_groupe,
   --classes_groupes.effectif AS Nombre_eleves,
   --dico_etablissements.name AS Nom_etablissement,
   dico_etablissements.zipcode AS Code_postal_etablissement,
   dico_etablissements.city AS Ville_etablissement,
   zones.latitude AS Latitude,
   zones.longitude AS Longitude,
   observations_inventaire.nom_espece AS Espece,
   observations_inventaire.population AS Nombre_individus,
   observations_specifiques_oiseaux.heure_debut AS Heure_debut,
   observations_specifiques_oiseaux.heure_fin AS Heure_fin,
   (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=zones.environnement
   AND t='zones'
   AND champ='environnement') AS Environnement,
   (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=zones.type
   AND t='zones'
   AND champ='type') AS Type_zone,
   (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=zones.surface
   AND t='zones'
   AND champ='surface') AS Surface_zone,
   (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=zones_description_oiseaux.distance_bois
   AND t='zones_description_escargots_planche'
   AND champ='distance_bois') AS Distance_bois,
   (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=zones_description_oiseaux.distance_prairie
   AND t='zones_description_escargots_planche'
   AND champ='distance_prairie') AS Distance_prairie,
   (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=zones_description_oiseaux.distance_champ_cultive
   AND t='zones_description_escargots_planche'
   AND champ='distance_champ_cultive') AS Distance_champ,
   (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=zones_description_oiseaux.engrais
   AND t='zones_description_escargots_planche'
   AND champ='engrais') AS Utilisation_engrais,
   (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=zones_description_oiseaux.engrais_type
   AND t='zones_description_escargots_planche'
   AND champ='engrais_type') AS Type_engrais,
   (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=zones_description_oiseaux.insecticides
   AND t='zones_description_escargots_planche'
   AND champ='insecticides') AS Utilisation_insecticides,
   (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=zones_description_oiseaux.insecticides_type
   AND t='zones_description_escargots_planche'
   AND champ='insecticides_type') AS Type_insecticides,
   (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=zones_description_oiseaux.herbicides
   AND t='zones_description_escargots_planche'
   AND champ='herbicides') AS Utilisation_herbicides,
   (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=zones_description_oiseaux.herbicides_type
   AND t='zones_description_escargots_planche'
   AND champ='herbicides_type') AS Type_herbicides,
   (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=zones_description_oiseaux.fongicides
   AND t='zones_description_escargots_planche'
   AND champ='fongicides') AS Utilisation_fongicides,
   (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=zones_description_oiseaux.fongicides_type
   AND t='zones_description_escargots_planche'
   AND champ='fongicides_type') AS Type_fongicides,
   (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=zones_description_oiseaux.antilimaces
   AND t='zones_description_escargots_planche'
   AND champ='antilimaces') AS Utilisation_antilimaces,
   (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=zones_description_oiseaux.antilimaces_type
   AND t='zones_description_escargots_planche'
   AND champ='antilimaces_type') AS Type_antilimaces,
   (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=zones_description_oiseaux.bouilliebordelaise
   AND t='zones_description_escargots_planche'
   AND champ='bouilliebordelaise') AS Utilisation_boulliebordelaise,
   (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=zones_description_oiseaux.bouilliebordelaise_type
   AND t='zones_description_escargots_planche'
   AND champ='bouilliebordelaise_type') AS Type_bouilliebordelaise,
   STRING_AGG((SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=zones_composition.option
   AND t='zones_composition'
   AND zones_composition.value='TRUE'
   AND champ='value'), ' | ') AS Composition_zone
   --urlphoto.url AS Photos,
   --observations.notes AS Notes

FROM observations
LEFT JOIN observations_inventaire on observations_inventaire.observationfk=observations.observationpk
LEFT JOIN observations_photos ON observations_photos.entitefk = observations.observationpk
LEFT JOIN photos ON photos.photopk = observations_photos.photofk
LEFT JOIN zones_annees ON zones_annees.zoneanneepk=observations.zfk
LEFT JOIN zones ON zones.zonepk=zones_annees.zonefk
LEFT JOIN zones_description_oiseaux ON zones_description_oiseaux.zfk=zones_annees.zoneanneepk
LEFT JOIN zones_composition ON zones_composition.zfk=zones_annees.zoneanneepk
LEFT JOIN classes_groupes_observations ON classes_groupes_observations.observationfk=observations.observationpk
LEFT JOIN classes_groupes ON classes_groupes.groupepk=classes_groupes_observations.classegroupefk
LEFT JOIN classes ON classes.classepk=classes_groupes.classefk
LEFT JOIN users ON users.userpk=observations.userfk
LEFT JOIN dico_etablissements ON classes.etablissementfk=dico_etablissements.etablissementpk
LEFT JOIN observations_specifiques_oiseaux ON observations_specifiques_oiseaux.observationfk=observations.observationpk
LEFT JOIN observations_inventaire_environnement ON observations_inventaire_environnement.observationinventairefk=observations_inventaire.observationinventairepk
LEFT JOIN dico_villes ON dico_villes.villepk=zones.villefk
LEFT JOIN ((SELECT observationpk, '' AS URL
  FROM observations
  LEFT JOIN observations_photos ON observations_photos.entitefk = observations.observationpk
  LEFT JOIN photos ON photos.photopk = observations_photos.photofk
  WHERE url IS NULL
  UNION
  SELECT observationpk, STRING_AGG(CONCAT('http://vigienature-ecole.fr/',photos.url), ' | ')
  FROM observations
  LEFT JOIN observations_photos ON observations_photos.entitefk = observations.observationpk
  LEFT JOIN photos ON photos.photopk = observations_photos.photofk
  WHERE
  url <>''
  GROUP BY observations.observationpk)) AS urlphoto ON observations.observationpk=urlphoto.observationpk

WHERE
--classes.anneescol = '2018' AND
observations.protocolefk = 1 AND
--dico_etablissements.zipcode LIKE '93%' AND
observations_inventaire.population > 0

GROUP BY observations.observationpk, observations.date, users.nom, users.prenom, classes.anneescol, classes.name, classes.niveau, classes_groupes.name, classes_groupes.effectif, dico_etablissements.name,
dico_etablissements.zipcode, dico_etablissements.city, zones.latitude, zones.longitude, zones.adresse, observations_inventaire.nom_espece, observations_inventaire.population, zones.environnement,
zones.type, zones.surface, observations_specifiques_oiseaux.heure_debut, observations_specifiques_oiseaux.heure_fin, zones_description_oiseaux.distance_bois,
zones_description_oiseaux.distance_prairie, zones_description_oiseaux.distance_champ_cultive, zones_description_oiseaux.engrais, zones_description_oiseaux.engrais_type, zones_description_oiseaux.insecticides,
zones_description_oiseaux.insecticides_type, zones_description_oiseaux.herbicides_type, zones_description_oiseaux.herbicides, zones_description_oiseaux.fongicides, zones_description_oiseaux.fongicides_type, zones_description_oiseaux.antilimaces,
zones_description_oiseaux.antilimaces_type, zones_description_oiseaux.bouilliebordelaise, zones_description_oiseaux.bouilliebordelaise_type,urlphoto.url

ORDER BY observations.observationpk ASC;
