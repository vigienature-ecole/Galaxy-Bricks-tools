SELECT DISTINCT
   observations.observationpk AS Numero_observation,
   observations.date AS Date_observation,
   dico_structures.zipcode AS Code_postal_etablissement,
   dico_structures.city AS Ville_etablissement,
   dico_academies.name as Academie,
   zones.latitude AS Latitude, 
   zones.longitude AS Longitude,
   CONCAT (LEFT (zones_placettes.name, 10), RIGHT (zones_placettes.name, 7)) AS Num_quadrat,
   observations_abondances.nom_espece AS sp,
   CASE  WHEN observations_abondances.abondance>0 THEN observations_abondances.abondance else 0 end as Nb,
   (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=zones.environnement
   AND t='zones'
   AND champ='environnement') AS Environnement,
   (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=zones.surface
   AND t='zones'
   AND champ='surface') AS Surface_zone,
   
   CASE WHEN zones_description_vdt.proximite_dechets_organiques = FALSE THEN 'Non'
    	WHEN zones_description_vdt.proximite_dechets_organiques = true THEN 'Oui'
       	ELSE NULL END AS Proximite_dechets_organiques, 
  (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=zones_description_vdt.usage_zone 
   AND t='zones_description_vdt'
   AND champ='usage_zone') AS Usage_zone,
   CASE WHEN zones_description_vdt.fauche_tonte = FALSE THEN 'Non'
    	WHEN zones_description_vdt.fauche_tonte = true THEN 'Oui'
       	ELSE NULL END AS Fauche_tonte, 
   CASE WHEN zones_description_vdt.paturage = false THEN 'Non'
    	WHEN zones_description_vdt.paturage = true THEN 'Oui'
       	ELSE NULL END AS Presence_paturage,
   (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=zones_description_vdt.utilisation_engrais 
   AND t='zones_description_vdt'
   AND champ='utilisation_engrais') AS Utilisation_engrais,
   (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=observations_details_vdt.pluie
   AND t='observations_details_vdt'
   AND champ='pluie') AS Pluie_lors_observation,
   (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=observations_details_vdt.vent
   AND t='observations_details_vdt'
   AND champ='vent') AS Vent_lors_observation,
   (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=observations_details_vdt.ensoleillement 
   AND t='observations_details_vdt'
   AND champ='ensoleillement') AS Ensoleillement_lors_observation,
   observations_details_vdt.temperature as Temperature_lors_observation,
   (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=observations_details_vdt.humidite_sol 
   AND t='observations_details_vdt'
   AND champ='humidite_sol') AS Humidite_sol_lors_observation,
   observations_details_vdt.date_gelee as Date_derniere_gelee,
   observations_details_vdt.date_pluie as Date_derniere_pluie,
  
   (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=observations_details_vdt.durete_sol 
   AND t='observations_details_vdt'
   AND champ='durete_sol') AS Difficulte_enfoncer_crayon,
   (SELECT label
   FROM dico_labels
   WHERE dico_labels.valeur=observations_details_vdt.taupinieres 
   AND t='observations_details_vdt'
   AND champ='taupinieres') AS Taupinieres

FROM observations
LEFT JOIN observations_abondances on observations_abondances.observationfk = observations.observationpk
left join observations_details_vdt on observations_details_vdt.observationfk = observations.observationpk
LEFT JOIN observateurs ON observateurs.observateurpk = observations.observateurfk
LEFT JOIN groupes ON groupes.groupepk = observateurs.groupefk
LEFT JOIN users ON users.userpk = groupes.userfk
left join zones_changes on zones_changes.zonechangepk = observations.zonechangefk
left join zones on zones.zonepk = zones_changes.zonefk
left join zones_placettes on zones_placettes.zonechangefk = zones_changes.zonechangepk
left join zones_description_vdt on zones_description_vdt.zonechangefk = zones_changes.zonechangepk
left join dico_structures on dico_structures.structurepk = groupes.structurefk
left join dico_academies on dico_academies.academiepk = dico_structures.academiefk

WHERE
observations.protocolefk = 4
and zones_placettes.placettepk = observations_abondances.placettefk
--and groupes.anneescol = '2019'
--AND dico_etablissements.zipcode LIKE '93%'

order by
observations.observationpk;