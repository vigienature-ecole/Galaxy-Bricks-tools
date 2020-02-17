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
   (SELECT nom_espece
    FROM dico_species
    WHERE dico_species.speciepk=observations_inventaire.speciefk) AS Espece,
   observations_inventaire.population AS Nombre_individus,
   zones_planches.name AS Ref_quadrat,
   --table_photos.url AS Photo_espece,


   /* Conditions d'observations */
   (SELECT label
    FROM dico_labels
    WHERE dico_labels.valeur=observations_specifiques_vdt.pluie
    AND t='observations_specifiques_vdt'
    AND champ='pluie') AS Pluie_durant_obs,
(SELECT label
    FROM dico_labels
    WHERE dico_labels.valeur=observations_specifiques_vdt.vent
    AND t='observations_specifiques_vdt'
    AND champ='vent') AS Vent_durant_obs,
(SELECT label
    FROM dico_labels
    WHERE dico_labels.valeur=observations_specifiques_vdt.ensoleillement
    AND t='observations_specifiques_vdt'
    AND champ='ensoleillement') AS Ensoleillement_durant_obs,
observations_specifiques_vdt.temperature AS Temperature_durant_obs,
(SELECT label
    FROM dico_labels
    WHERE dico_labels.valeur=observations_specifiques_vdt.humidite_sol
    AND t='observations_specifiques_vdt'
    AND champ='humidite_sol') AS Humidite_sol,
observations_specifiques_vdt.date_pluie AS Date_derniere_pluie,
observations_specifiques_vdt.date_gelee AS Date_derniere_gelee,
(SELECT label
    FROM dico_labels
    WHERE dico_labels.valeur=observations_specifiques_vdt.taupinieres
    AND t='observations_specifiques_vdt'
    AND champ='taupinieres') AS Presence_taupiniere,
(SELECT label
    FROM dico_labels
    WHERE dico_labels.valeur=observations_specifiques_vdt.durete_sol
    AND t='observations_specifiques_vdt'
    AND champ='durete_sol') AS Difficulte_enfoncer_crayon,
observations_specifiques_vdt.distance_changement_parcelle AS Distance_limite_parcelle,
observations_specifiques_vdt.ph_sol AS pH_sol,

   /* Description de l'environnement */
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
   CASE WHEN zones_description_vdt.proximite_dechets_organiques= TRUE THEN 'Oui'
        WHEN zones_description_vdt.proximite_dechets_organiques= FALSE THEN 'Non'
        ELSE '' END AS Proximite_dechets_organiques,
   (SELECT label
    FROM dico_labels
    WHERE dico_labels.valeur=zones_description_vdt.type_dechets
    AND t='zones_description_vdt'
    AND champ='type_dechets') AS Types_dechets,
 zones_description_vdt.distance_zone_echantillonage AS Distance_compost,
   (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=zones.surface
   AND t='zones'
   AND champ='surface') AS Surface,
   (SELECT label
    FROM dico_labels
    WHERE dico_labels.valeur=zones_description_vdt.usage_zone
    AND t='zones_description_vdt'
    AND champ='usage_zone') AS Usage_zone,
    CASE WHEN zones_description_vdt.fauche_tonte= TRUE THEN 'Oui'
        WHEN zones_description_vdt.fauche_tonte= FALSE THEN 'Non'
        ELSE '' END AS Tonte,
    zones_description_vdt.frequence_fauche AS Frequence_tonte,
    (SELECT label
    FROM dico_labels
    WHERE dico_labels.valeur=zones_description_vdt.date_derniere_fauche
    AND t='zones_description_vdt'
    AND champ='date_derniere_fauche') AS Date_derniere_tonte,
    (SELECT label
    FROM dico_labels
    WHERE dico_labels.valeur=zones_description_vdt.residus
    AND t='zones_description_vdt'
    AND champ='residus') AS Residus_tonte,
    CASE WHEN zones_description_vdt.paturage= TRUE THEN 'Oui'
        WHEN zones_description_vdt.paturage= FALSE THEN 'Non'
        ELSE '' END AS Paturage,
    zones_description_vdt.type_animaux AS Type_animaux,
(SELECT label
    FROM dico_labels
    WHERE dico_labels.valeur=zones_description_vdt.travail_sol_avant
    AND t='zones_description_vdt'
    AND champ='travail_sol_avant') AS Travail_sol_avant_usage_actuel,
zones_description_vdt.frequence_interventions AS Frequence_intervention,
(SELECT label
    FROM dico_labels
    WHERE dico_labels.valeur=zones_description_vdt.date_derniere_intervention
    AND t='zones_description_vdt'
    AND champ='date_derniere_intervention') AS Date_derniere_intervention,
(SELECT label
    FROM dico_labels
    WHERE dico_labels.valeur=zones_description_vdt.utilisation_engrais
    AND t='zones_description_vdt'
    AND champ='utilisation_engrais') AS Utilisation_engrais,
zones_description_vdt.frequence_engrais AS Frequence_utilisation_engrais,
(SELECT label
    FROM dico_labels
    WHERE dico_labels.valeur=zones_description_vdt.mode_production
    AND t='zones_description_vdt'
    AND champ='mode_production') AS Mode_production,
zones_description_vdt.mode_production_autre AS Mode_production_autre,
(SELECT label
    FROM dico_labels
    WHERE dico_labels.valeur=zones_description_vdt.type_culture
    AND t='zones_description_vdt'
    AND champ='type_culture') AS Type_culture,
zones_description_vdt.date_mep_prairie AS Date_mise_prairie,
(SELECT label
    FROM dico_labels
    WHERE dico_labels.valeur=zones_description_vdt.prelevement_rang
    AND t='zones_description_vdt'
    AND champ='prelevement_rang') AS Prelevement_rang
  --CASE
  --    WHEN (SELECT photos.url
  --          FROM photos
  --          WHERE observations_specifiques_vdt.photo_zone_environnement=photos.photopk)!='' THEN CONCAT('http://vigienature-ecole.fr/',(SELECT photos.url
  --          FROM photos
  --          WHERE observations_specifiques_vdt.photo_zone_environnement=photos.photopk))
  --    ELSE '' END AS URL_photo_environnement,
  --CASE
  --    WHEN (SELECT photos.url
  --          FROM photos
  --          WHERE observations_specifiques_vdt.photo_sol_avant_tonte=photos.photopk)!='' THEN CONCAT('http://vigienature-ecole.fr/',(SELECT photos.url
  --          FROM photos
  --          WHERE observations_specifiques_vdt.photo_sol_avant_tonte=photos.photopk))
  --    ELSE '' END AS URL_photo_sol_avant_tonte,
  --CASE
  --    WHEN (SELECT photos.url
  --          FROM photos
  --          WHERE observations_specifiques_vdt.photo_sol_apres_tonte=photos.photopk)!='' THEN CONCAT('http://vigienature-ecole.fr/',(SELECT photos.url
  --          FROM photos
  --          WHERE observations_specifiques_vdt.photo_sol_apres_tonte=photos.photopk))
  --    ELSE '' END AS URL_photo_sol_apres_tonte,
  --observations.notes AS Notes

FROM observations
LEFT JOIN observations_inventaire on observations_inventaire.observationfk=observations.observationpk
LEFT JOIN observations_photos ON observations_photos.entitefk = observations.observationpk
LEFT JOIN photos ON photos.photopk = observations_photos.photofk
LEFT JOIN observations_specifiques_vdt ON observations_specifiques_vdt.observationfk=observations.observationpk
LEFT JOIN zones_planches ON zones_planches.planchepk=observations_inventaire.planchefk
LEFT JOIN zones_annees ON zones_annees.zoneanneepk=observations.zfk
LEFT JOIN zones ON zones.zonepk=zones_annees.zonefk
LEFT JOIN zones_description_vdt ON zones_description_vdt.zfk=zones_annees.zoneanneepk
LEFT JOIN classes_groupes_observations ON classes_groupes_observations.observationfk=observations.observationpk
LEFT JOIN classes_groupes ON classes_groupes.groupepk=classes_groupes_observations.classegroupefk
LEFT JOIN classes ON classes.classepk=classes_groupes.classefk
LEFT JOIN users ON users.userpk=observations.userfk
LEFT JOIN dico_etablissements ON classes.etablissementfk=dico_etablissements.etablissementpk
LEFT JOIN dico_villes ON dico_villes.villepk=zones.villefk
LEFT JOIN (SELECT CONCAT('http://vigienature-ecole.fr/',photos.url) AS url, observations.observationpk, observations_inventaire.observationinventairepk
   from observations, observations_inventaire, observations_photos, photos
   where  observations_inventaire.observationfk = observations.observationpk
   and observations_photos.entitefk = observations_inventaire.observationinventairepk
   and observations_photos.entitetype = 'inventaire'
   and photos.photopk = observations_photos.photofk
   and observations.protocolefk = 4) AS table_photos ON table_photos.observationinventairepk=observations_inventaire.observationinventairepk

WHERE observations.protocolefk = 4
--AND classes.anneescol = '2017'
--AND dico_etablissements.zipcode LIKE '81%'


ORDER BY observations.observationpk ASC;
