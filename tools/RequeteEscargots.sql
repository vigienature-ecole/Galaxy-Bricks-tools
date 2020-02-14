SELECT
TAB.Num_obs,
TAB.Date_obs,
TAB.Annee_scol,
TAB.Nom_etablissement,
TAB.Code_postal_etablissement,
TAB.Ville,
--TAB.Nom_classe,
--TAB.Niveau,
--TAB.Nom_groupe,
--TAB.Nombre_eleves,
TAB.Latitude,
TAB.Longitude,
TAB.Environnement,
TAB.Type_zone,
TAB.Surface_zone,
TAB.Numero_planche,
TAB.Largeur_planche,
TAB.Longueur_planche,
TAB.Surface_planche,
MAX (CASE  TAB.Environnement_planche WHEN 'Posée sous un arbre/un buisson' THEN 1 ELSE NULL END) as "Posée sous un arbre/un buisson",
MAX (CASE  TAB.Environnement_planche WHEN 'Posée en terrain dégagé' THEN 1 ELSE NULL END) as "Posée en terrain dégagé",
MAX (CASE  TAB.Environnement_planche WHEN 'Posée contre un mur' THEN 1 ELSE NULL END) as "Posée contre un mur",
MAX (CASE  TAB.Environnement_planche WHEN 'Posée contre la terre nue' THEN 1 ELSE NULL END) as "Posée contre la terre nue",
MAX (CASE  TAB.Environnement_planche WHEN 'Posée sur le gazon' THEN 1 ELSE NULL END) as "Posée sur le gazon",
MAX (CASE  TAB.Environnement_planche WHEN 'Posée sur des feuilles mortes' THEN 1 ELSE NULL END) as "Posée sur des feuilles mortes",
MAX (CASE  TAB.Environnement_planche WHEN 'Posée sur un terrain en friche' THEN 1 ELSE NULL END) as "Posée sur un terrain en friche",
TAB.Distance_bois,
TAB.Distance_prairie,
TAB.Distance_champ,
TAB.Utilisation_engrais,
TAB.Type_engrais,
TAB.Utilisation_insecticides,
TAB.Type_insecticides,
TAB.Utilisation_herbicides,
TAB.Type_herbicides,
TAB.Utilisation_fongicides,
TAB.Type_fongicides,
TAB.Utilisation_antilimaces,
TAB.Type_antilimaces,
TAB.Utilisation_boulliebordelaise,
TAB.Type_bouilliebordelaise,
MAX (CASE  TAB.Composition_zone WHEN 'Parterre et arbustes fleuris' THEN 1 ELSE NULL END) as "Parterre et arbustes fleuris",
MAX (CASE  TAB.Composition_zone WHEN 'Haies (sauf thuyas ou laurier cerise)' THEN 1 ELSE NULL END) as "Haies",
MAX (CASE  TAB.Composition_zone WHEN 'Verger, arbres fruitiers|Verger, arbres fruitiers' THEN 1 ELSE NULL END) as "Verger, arbres fruitiers",
MAX (CASE  TAB.Composition_zone WHEN 'Espaces non entretenus (friches, espaces naturels)' THEN 1 ELSE NULL END) as "Espaces non entretenus",
MAX (CASE  TAB.Composition_zone WHEN 'Potager' THEN 1 ELSE NULL END) as "Potager",
MAX (CASE  TAB.Composition_zone WHEN 'Bassin, mare' THEN 1 ELSE NULL END) as "Bassin, mare",
MAX (CASE  TAB.Composition_zone WHEN 'Pelouse tondue' THEN 1 ELSE NULL END) as "Pelouse tondue",
MAX (CASE  TAB.Composition_zone WHEN 'Espaces pavés, gravillonnés' THEN 1 ELSE NULL END) as "Espaces pavés, gravillonnés",
MAX (CASE  TAB.Composition_zone WHEN 'Buddleïa (arbre à papillons)' THEN 1 ELSE NULL END) as "Buddleïa",
MAX (CASE  TAB.Composition_zone WHEN 'Centaurées et scabieuses (bleuets champêtres)' THEN 1 ELSE NULL END) as "Centaurées et scabieuses",
MAX (CASE  TAB.Composition_zone WHEN 'Valériane, Centranthe rouge' THEN 1 ELSE NULL END) as "Valériane, Centranthe rouge",
MAX (CASE  TAB.Composition_zone WHEN 'Géraniums et pélargoniums' THEN 1 ELSE NULL END) as "Géraniums et pélargoniums",
MAX (CASE  TAB.Composition_zone WHEN 'Lavande' THEN 1 ELSE NULL END) as "Lavande",
MAX (CASE  TAB.Composition_zone WHEN 'Crucifères (choux, cardamine, giroflée, monnaie du pape, navets)' THEN 1 ELSE NULL END) as "Crucifères",
MAX (CASE  TAB.Composition_zone WHEN 'Orties' THEN 1 ELSE NULL END) as "Orties",
MAX (CASE  TAB.Composition_zone WHEN 'Ronces' THEN 1 ELSE NULL END) as "Ronces",
MAX (CASE  TAB.Composition_zone WHEN 'Lierre' THEN 1 ELSE NULL END) as "Lierre",
MAX (CASE  TAB.Composition_zone WHEN 'Trèfles, lotiers et luzernes' THEN 1 ELSE NULL END) as "Trèfles, lotiers et luzernes",
MAX (CASE  TAB.Composition_zone WHEN 'Plantes aromatiques (thym, romarin, basilic...)' THEN 1 ELSE NULL END) as "Plantes aromatiques",
MAX (CASE  TAB.Composition_zone WHEN 'Haie de laurier' THEN 1 ELSE NULL END) as "Haie de laurier",
MAX (CASE  TAB.sp WHEN 'Autres limaces' THEN TAB.Nb_ind ELSE NULL END) as "Autres limaces",
MAX (CASE  TAB.sp WHEN 'Limace des caves' THEN TAB.Nb_ind ELSE NULL END) as "Limace des caves",
MAX (CASE  TAB.sp WHEN 'Grande loche - Forme noire' THEN TAB.Nb_ind ELSE NULL END) as "Grande loche - Forme noire",
MAX (CASE  TAB.sp WHEN 'Grande loche - Forme rouge' THEN TAB.Nb_ind ELSE NULL END) as "Grande loche - Forme rouge",
MAX (CASE  TAB.sp WHEN 'Grande limace' THEN TAB.Nb_ind ELSE NULL END) as "Grande limace",
MAX (CASE  TAB.sp WHEN 'Escargot de Bourgogne' THEN TAB.Nb_ind ELSE NULL END) as "Escargot de Bourgogne",
MAX (CASE  TAB.sp WHEN 'Petit gris' THEN TAB.Nb_ind ELSE NULL END) as "Petit gris",
MAX (CASE  TAB.sp WHEN 'Escargot de Quimper' THEN TAB.Nb_ind ELSE NULL END) as "Escargot de Quimper",
MAX (CASE  TAB.sp WHEN 'Veloutée plane' THEN TAB.Nb_ind ELSE NULL END) as "Veloutée plane",
MAX (CASE  TAB.sp WHEN 'Veloutées' THEN TAB.Nb_ind ELSE NULL END) as "Veloutées",
MAX (CASE  TAB.sp WHEN 'Zonite peson' THEN TAB.Nb_ind ELSE NULL END) as "Zonite peson",
MAX (CASE  TAB.sp WHEN 'Luisants' THEN TAB.Nb_ind ELSE NULL END) as "Luisants",
MAX (CASE  TAB.sp WHEN 'Escargot mourgeta' THEN TAB.Nb_ind ELSE NULL END) as "Escargot mourgeta",
MAX (CASE  TAB.sp WHEN 'Escargots des haies, jardins, forêts' THEN TAB.Nb_ind ELSE NULL END) as "Escargots des haies, jardins, forêts",
MAX (CASE  TAB.sp WHEN 'Boutons' THEN TAB.Nb_ind ELSE NULL END) as "Boutons",
MAX (CASE  TAB.sp WHEN 'Caragouille rosée' THEN TAB.Nb_ind ELSE NULL END) as "Caragouille rosée",
MAX (CASE  TAB.sp WHEN 'Hélicelles' THEN TAB.Nb_ind ELSE NULL END) as "Hélicelles",
MAX (CASE  TAB.sp WHEN 'Hélice grimace' THEN TAB.Nb_ind ELSE NULL END) as "Hélice grimace",
MAX (CASE  TAB.sp WHEN 'Hélice tapada' THEN TAB.Nb_ind ELSE NULL END) as "Hélice tapada",
MAX (CASE  TAB.sp WHEN 'Escargot turc' THEN TAB.Nb_ind ELSE NULL END) as "Escargot turc",
MAX (CASE  TAB.sp WHEN 'Hélice des bois' THEN TAB.Nb_ind ELSE NULL END) as "Hélice des bois",
MAX (CASE  TAB.sp WHEN 'Soucoupe commune' THEN TAB.Nb_ind ELSE NULL END) as "Soucoupe commune",
MAX (CASE  TAB.sp WHEN 'Troque élégante' THEN TAB.Nb_ind ELSE NULL END) as "Troque élégante",
MAX (CASE  TAB.sp WHEN 'Bulime tronqué' THEN TAB.Nb_ind ELSE NULL END) as "Bulime tronqué",
MAX (CASE  TAB.sp WHEN 'Bulime zébré' THEN TAB.Nb_ind ELSE NULL END) as "Bulime zébré",
MAX (CASE  TAB.sp WHEN 'Bulime inverse' THEN TAB.Nb_ind ELSE NULL END) as "Bulime inverse",
MAX (CASE  TAB.sp WHEN 'Clausilies' THEN TAB.Nb_ind ELSE NULL END) as "Clausilies",
MAX (CASE  TAB.sp WHEN 'Maillots' THEN TAB.Nb_ind ELSE NULL END) as "Maillots",
MAX (CASE  TAB.sp WHEN 'Ambrettes' THEN TAB.Nb_ind ELSE NULL END) as "Ambrettes",
MAX (CASE  TAB.sp WHEN 'Elégante striée' THEN TAB.Nb_ind ELSE NULL END) as "Elégante striée",
MAX (CASE  TAB.sp WHEN 'Cochlostomes' THEN TAB.Nb_ind ELSE NULL END) as "Cochlostomes"

 FROM (SELECT DISTINCT
   observations.observationpk AS Num_obs,
   observations.date AS Date_obs,
   users.nom AS Nom_enseignant,
   users.prenom AS Prenom_enseignant,
   classes.anneescol AS Annee_scol,
   classes.name AS Nom_classe,
   classes.niveau AS Niveau,
   classes.classepk,
   classes_groupes.name AS Nom_groupe,
   classes_groupes.effectif AS Nombre_eleves,
   dico_etablissements.name AS Nom_etablissement,
   dico_etablissements.zipcode AS Code_postal_etablissement,
   dico_etablissements.city AS Ville,
   zones.latitude AS Latitude,
   zones.longitude AS Longitude,
   observations_inventaire.nom_espece AS sp,
   observations_inventaire.population AS Nb_ind,
   zones.adresse AS "Adresse",
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
   zones_planches.planchepk AS Numero_planche,
   zones_planches.largeur AS Largeur_planche,
   zones_planches.longueur AS Longueur_planche,
   (zones_planches.largeur*zones_planches.longueur)/1000 AS Surface_planche,
   (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=zones_planches_environnement.option
   AND zones_planches_environnement.value='TRUE'
   AND t='zones_planches_environnement'
   AND champ='value') AS Environnement_planche,
   (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=zones_description_escargots_planche.distance_bois
   AND t='zones_description_escargots_planche'
   AND champ='distance_bois') AS Distance_bois,
   (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=zones_description_escargots_planche.distance_prairie
   AND t='zones_description_escargots_planche'
   AND champ='distance_prairie') AS Distance_prairie,
   (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=zones_description_escargots_planche.distance_champ_cultive
   AND t='zones_description_escargots_planche'
   AND champ='distance_champ_cultive') AS Distance_champ,
   (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=zones_description_escargots_planche.engrais
   AND t='zones_description_escargots_planche'
   AND champ='engrais') AS Utilisation_engrais,
   (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=zones_description_escargots_planche.engrais_type
   AND t='zones_description_escargots_planche'
   AND champ='engrais_type') AS Type_engrais,
   (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=zones_description_escargots_planche.insecticides
   AND t='zones_description_escargots_planche'
   AND champ='insecticides') AS Utilisation_insecticides,
   (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=zones_description_escargots_planche.insecticides_type
   AND t='zones_description_escargots_planche'
   AND champ='insecticides_type') AS Type_insecticides,
   (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=zones_description_escargots_planche.herbicides
   AND t='zones_description_escargots_planche'
   AND champ='herbicides') AS Utilisation_herbicides,
   (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=zones_description_escargots_planche.herbicides_type
   AND t='zones_description_escargots_planche'
   AND champ='herbicides_type') AS Type_herbicides,
   (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=zones_description_escargots_planche.fongicides
   AND t='zones_description_escargots_planche'
   AND champ='fongicides') AS Utilisation_fongicides,
   (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=zones_description_escargots_planche.fongicides_type
   AND t='zones_description_escargots_planche'
   AND champ='fongicides_type') AS Type_fongicides,
   (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=zones_description_escargots_planche.antilimaces
   AND t='zones_description_escargots_planche'
   AND champ='antilimaces') AS Utilisation_antilimaces,
   (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=zones_description_escargots_planche.antilimaces_type
   AND t='zones_description_escargots_planche'
   AND champ='antilimaces_type') AS Type_antilimaces,
   (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=zones_description_escargots_planche.bouilliebordelaise
   AND t='zones_description_escargots_planche'
   AND champ='bouilliebordelaise') AS Utilisation_boulliebordelaise,
   (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=zones_description_escargots_planche.bouilliebordelaise_type
   AND t='zones_description_escargots_planche'
   AND champ='bouilliebordelaise_type') AS Type_bouilliebordelaise,
   (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=zones_composition.option
   AND t='zones_composition'
   AND zones_composition.value='TRUE'
   AND champ='value') AS Composition_zone
   --observations.notes AS Notes

FROM observations
LEFT JOIN observations_inventaire on observations_inventaire.observationfk=observations.observationpk
LEFT JOIN zones_planches ON zones_planches.planchepk=observations_inventaire.planchefk
LEFT JOIN zones_planches_environnement on zones_planches_environnement.planchefk=zones_planches.planchepk
LEFT JOIN zones_annees ON zones_annees.zoneanneepk=observations.zfk
LEFT JOIN zones ON zones.zonepk=zones_annees.zonefk
LEFT JOIN zones_composition ON zones_composition.zfk=zones_annees.zoneanneepk
LEFT JOIN classes_groupes_observations ON classes_groupes_observations.observationfk=observations.observationpk
LEFT JOIN classes_groupes ON classes_groupes.groupepk=classes_groupes_observations.classegroupefk
LEFT JOIN classes ON classes.classepk=classes_groupes.classefk
LEFT JOIN users ON users.userpk=observations.userfk
LEFT JOIN dico_etablissements ON classes.etablissementfk=dico_etablissements.etablissementpk
LEFT JOIN observations_inventaire_environnement ON observations_inventaire_environnement.observationinventairefk=observations_inventaire.observationinventairepk
LEFT JOIN zones_description_escargots_planche ON zones_description_escargots_planche.zfk=zones_annees.zoneanneepk
LEFT JOIN dico_villes ON dico_villes.villepk=zones.villefk
WHERE
--classes.anneescol = '2016' AND
observations.protocolefk = 2 AND
--dico_etablissements.zipcode LIKE '93%'AND
observations_inventaire.population > 0
GROUP BY observations.observationpk, observations.date, users.nom, users.prenom, classes.anneescol, classes.name, classes.classepk, classes.niveau, classes_groupes.name, classes_groupes.effectif, dico_etablissements.name,
dico_etablissements.zipcode, dico_etablissements.city, zones.latitude, zones.longitude, zones.adresse, observations_inventaire.nom_espece, observations_inventaire.population, zones.environnement,
zones.type, zones.surface, zones_planches.planchepk, zones_planches.largeur, zones_planches.longueur, zones_description_escargots_planche.bouilliebordelaise_type,
zones_description_escargots_planche.bouilliebordelaise, zones_description_escargots_planche.antilimaces, zones_description_escargots_planche.antilimaces_type, zones_description_escargots_planche.fongicides_type, zones_description_escargots_planche.fongicides,
zones_description_escargots_planche.herbicides, zones_description_escargots_planche.herbicides_type, zones_description_escargots_planche.insecticides_type , zones_description_escargots_planche.insecticides, zones_description_escargots_planche.engrais, zones_description_escargots_planche.engrais_type,
zones_description_escargots_planche.distance_champ_cultive, zones_description_escargots_planche.distance_prairie, zones_description_escargots_planche.distance_bois, zones_composition.option, zones_composition.value, zones_planches_environnement.option, zones_planches_environnement.value) TAB
GROUP BY
TAB.Num_obs,
TAB.Date_obs,
TAB.Annee_scol,
TAB.Nom_etablissement,
TAB.Code_postal_etablissement,
TAB.Ville,
TAB.Nom_classe,
TAB.Niveau,
TAB.Nom_groupe,
TAB.Nombre_eleves,
TAB.Latitude,
TAB.Longitude,
TAB.Environnement,
TAB.Type_zone,
TAB.Surface_zone,
TAB.Numero_planche,
TAB.Largeur_planche,
TAB.Longueur_planche,
TAB.Surface_planche,
TAB.Latitude,
TAB.Longitude,
TAB.Environnement,
TAB.Type_zone,
TAB.Surface_zone,
TAB.Numero_planche,
TAB.Largeur_planche,
TAB.Longueur_planche,
TAB.Surface_planche,
TAB.Distance_bois,
TAB.Distance_prairie,
TAB.Distance_champ,
TAB.Utilisation_engrais,
TAB.Type_engrais,
TAB.Utilisation_insecticides,
TAB.Type_insecticides,
TAB.Utilisation_herbicides,
TAB.Type_herbicides,
TAB.Utilisation_fongicides,
TAB.Type_fongicides,
TAB.Utilisation_antilimaces,
TAB.Type_antilimaces,
TAB.Utilisation_boulliebordelaise,
TAB.Type_bouilliebordelaise
ORDER BY TAB.Num_obs;
