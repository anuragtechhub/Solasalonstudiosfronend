SELECT l.name AS location_name, l.city, l.state, 
(SELECT COUNT(*) FROM stylists WHERE stylists.location_id = l.id AND stylists.status = 'open') AS "Stylists on Website", 
(SELECT COUNT(*) FROM stylists WHERE stylists.location_id = l.id AND stylists.status = 'open' AND stylists.encrypted_password != '') AS "Has Sola Pro Account", 
(SELECT COUNT(*) FROM stylists WHERE stylists.location_id = l.id AND stylists.status = 'open' AND stylists.has_sola_genius_account = true) AS "Has SolaGenius Account" 
FROM locations AS l WHERE l.status = 'open' ORDER BY l.name ASC