SELECT s.name, s.email_address, s.phone_number, l.name AS location_name, l.city, l.state FROM stylists AS s, locations AS l WHERE s.location_id = l.id