SELECT
TOB.Num_obs,
TOB.date,
TOB.Annee_scol,
--TOB.Nom_etab,
TOB.Code_postal_etab,
TOB.Ville_etab,
--TOB.Nom_classe,
--TOB.Niveau_classe,
--TOB.Nom_groupe,
--TOB.Nombre_eleves,
TOB.Latitude_debut,
TOB.Longitude_debut,
TOB.Latitude_fin,
TOB.Longitude_fin,
TOB.Especes,
MAX (CASE  TOB.Environnement WHEN 'Chemin' THEN 1 ELSE NULL END) as "Chemin",
MAX (CASE  TOB.Environnement WHEN 'Fissure' THEN 1 ELSE NULL END) as "Fissure",
MAX (CASE  TOB.Environnement WHEN 'Pelouse' THEN 1 ELSE NULL END) as "Pelouse",
MAX (CASE  TOB.Environnement WHEN 'Pied d''arbre' THEN 1 ELSE NULL END) as "Pied_arbre",
MAX (CASE TOB.Environnement WHEN 'Haie' THEN 1 ELSE NULL END) as "Haie",
MAX (CASE  TOB.Environnement WHEN 'Platebande' THEN 1 ELSE NULL END) as "Platebande",
MAX (CASE  TOB.Environnement WHEN 'Mur' THEN 1 ELSE NULL END) as "Mur",
TOB.Adresse,
TOB.Cote_rue
--TOB.Notes,
--TOB.Photos

FROM (SELECT DISTINCT
  observations.observationpk AS Num_obs,
  observations.date AS date,
  users.nom AS Nom_enseignant,
  users.prenom AS Prenom_enseignant,
  classes.anneescol AS Annee_scol,
  classes.name AS Nom_classe,
  classes.niveau AS Niveau_classe,
  classes_groupes.name AS Nom_groupe,
  classes_groupes.effectif AS Nombre_eleves,
  dico_etablissements.name AS Nom_etab,
  dico_etablissements.zipcode AS Code_postal_etab,
  dico_etablissements.city AS Ville_etab,
  (SELECT nom_espece
    FROM dico_species
    WHERE dico_species.speciepk=observations_inventaire.speciefk) AS Especes,
  (SELECT label
    FROM dico_labels
    WHERE dico_labels.valeur=observations_inventaire_environnement.option
    AND t='observations_inventaire_environnement'
    AND champ='option') AS Environnement,
  zones.adresse AS Adresse,
  (SELECT label
    FROM dico_labels
    WHERE dico_labels.valeur=zones_description_fleurs.cote_rue
    AND t='zones_description_fleurs'
    AND champ='cote_rue') AS Cote_rue,
  zones.latitude AS Latitude_debut,
  zones.longitude AS Longitude_debut,
  zones_description_fleurs.latitude_fin AS Latitude_fin,
  zones_description_fleurs.longitude_fin AS Longitude_fin,
  observations.notes AS Notes,
  urlphoto.url AS Photos

FROM observations
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
LEFT JOIN observations_inventaire ON observations_inventaire.observationfk=observations.observationpk
LEFT JOIN observations_photos ON observations_photos.entitefk = observations.observationpk
LEFT JOIN photos ON photos.photopk = observations_photos.photofk
LEFT JOIN observations_inventaire_environnement ON observations_inventaire_environnement.observationinventairefk=observations_inventaire.observationinventairepk
LEFT JOIN zones_annees ON zones_annees.zoneanneepk=observations.zfk
LEFT JOIN zones_description_fleurs ON zones_description_fleurs.zfk=zones_annees.zoneanneepk
LEFT JOIN zones ON zones.zonepk=zones_annees.zonefk
LEFT JOIN users ON users.userpk=observations.userfk
LEFT JOIN classes_groupes_observations ON classes_groupes_observations.observationfk=observations.observationpk
LEFT JOIN classes_groupes ON classes_groupes.groupepk = classes_groupes_observations.classegroupefk
LEFT JOIN classes ON classes.classepk = classes_groupes.classefk
LEFT JOIN dico_etablissements ON classes.etablissementfk=dico_etablissements.etablissementpk
LEFT JOIN dico_villes ON dico_villes.villepk=dico_etablissements.villefk

WHERE
observations.protocolefk = 5
--AND classes.anneescol = '2018'
--AND dico_etablissements.zipcode LIKE '47%'
AND observations_inventaire_environnement.value='t'

GROUP BY observations.observationpk, observations.date, users.nom, users.prenom, classes.anneescol, classes.name, classes.niveau, classes_groupes.name,
classes_groupes.effectif, dico_etablissements.name,observations_inventaire_environnement.option, zones_description_fleurs.cote_rue, dico_etablissements.zipcode,
dico_etablissements.city, zones.latitude, zones.longitude, zones_description_fleurs.latitude_fin, zones_description_fleurs.longitude_fin, observations_inventaire.speciefk,
zones.adresse, urlphoto.url) TOB

GROUP BY TOB.Num_obs,
TOB.date,
TOB.Nom_enseignant,
TOB.Prenom_enseignant,
TOB.Annee_scol,
TOB.Nom_classe,
TOB.Niveau_classe,
TOB.Nom_groupe,
TOB.Nombre_eleves,
TOB.Nom_etab,
TOB.Code_postal_etab,
TOB.Ville_etab,
TOB.Especes,
TOB.Adresse,
TOB.Cote_rue,
TOB.Latitude_debut,
TOB.Longitude_debut,
TOB.Latitude_fin,
TOB.Longitude_fin,
TOB.Notes,
TOB.Photos
ORDER BY TOB.Num_obs ASC;
