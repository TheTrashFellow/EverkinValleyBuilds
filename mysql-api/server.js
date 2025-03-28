require('dotenv').config();

const fs = require('fs');
const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
app.use(express.json());
app.use(cors());

//CREATE MYSQL CONNECTION
const db = mysql.createConnection({
	host: 'localhost',
	user: process.env.DB_USER,
	password: process.env.DB_PASS,
	database: process.env.DB_NAME,
//	ssl: {
//		ca: fs.readFileSync("/etc/mysql/ssl/ca-cert.pem"),
//		cert: fs.readFileSync("/etc/mysql/ssl/server-cert.pem"),
//		key: fs.readFileSync("/etc/mysql/ssl/server-key.pem"),
//	}
});

db.connect(err => {
	if (err) {
		console.error('Database connection failed:', err);
	} else {
		console.log('Connected to MySQL database');
	}
});

//TEST
app.get('/', (req, res) => {
	res.send('MySQL REST API is running!');
});

//GET ALL PLAYERS
app.get('/utilisateurs', (req, res) => {
	db.query('SELECT * FROM utilisateurs', (err, results) => {
		if (err) return res.status(500).json({ error: err.message});
		res.json(results);
	});
});

//GET SERVER INFOS
app.get('/get_serveur_infos', (req, res) => {
	db.query('SELECT ip_server FROM serveur_values', (err, results) => {
		if (err) return res.status(500).json({ error: err.message});
		res.json(results);
	});
});

//ACTIONS
app.post('/actionMainMenu', (req, res) => {
	const { action, data } = req.body;
	console.log('Action recu : ' + action)
	//ADD PLAYER
	if (action === "add_player") {
		const { courriel, mdp, nom_personnage } = data;
		console.log('Courriel : ' + courriel + ';mdp : ' + mdp + ';nom_personnage : ' + nom_personnage);

		db.query("CALL CreerUtilisateur(?,?,?)", [courriel, mdp, nom_personnage],
		(err, result) => {
			if (err) {
				if (err.code === 'ER_SIGNAL_EXCEPTION') {
					const customMessage = err.sqlMessage;
					console.log(customMessage);
					return res.status(400).json({message: customMessage, details: err});
				}

				return res.status(500).json({error: err});
			}
			res.json({ message: 'Utilisateur cree avec succes !'});
		});
	}
	else if(action === "attempt_login") {
		const {courriel} = data;
		const query = 'SELECT * FROM utilisateurs WHERE nom_utilisateur = ?';
		let totalResults = "";
		let idUtilisateur = null;
		db.query(query, courriel,
		(err, result) => {
			if (err) return res.status(500).json({ error: err.message + "login"});

			if(result.length ===0) {
				return res.status(404).json({error: err, message: "Courriel et / ou mot de passe erroné"});
			}

			res.json(result);
		});
	}
	else if(action === "verify_connected") {
		const {id_personnage} = data;
		console.log('Verifying if user already connected at id ' + id_personnage);
		db.query("CALL VerifyConnection(?)",
		[id_personnage],
		(err, result) => {
			if (err) return res.status(500).json ({error: err.message});

			res.json(results);
		});
	}

});

//ACTIONS OpenWorld
app.post('/actionOpenWorld', (req, res) => {
	const { action, data } = req.body;
	console.log('Action recu : ' + action);
	//GetLatestPosition
	if (action === "getPositions") {
		const { id_personnage } = data;
		console.log('Position pour ID : ' + id_personnage);

		db.query("SELECT * FROM personnages WHERE id_personnage = ?", [id_personnage],
		(err, result) => {
			if (err) return res.status(500).json({ error: err.message});

			if(result.length === 0) {
				return res.status(404).json({error: "User not found"});
			}

			res.json(result);
		});
	}
	else if (action === "fetch_information") {
		const { id_personnage } = data;
		
		db.query("SELECT * FROM personnages WHERE id_personnage = ?",
		[id_personnage],
		(err, result) => {
			if (err) return res.status(500).json({ error: err.message});

			res.json(result);
		});
	}
	else if(action === "setPositions") {
		const { id_personnage, x, y, z} = data;
		console.log('Set Position pour ID : ' + id_personnage + " ; X, Y, Z : ", x, y, z);

		db.query("UPDATE personnages SET dernier_x = ?, dernier_y = ?, dernier_z = ? WHERE id_personnage = ?",
		[x,y,z,id_personnage],
		(err, result) => {
			if (err) return res.status(500).json({ error: err.message });

			res.json(result);
		});
	}
	else if(action === "setVillagePositions") {
		const { id_personnage, village_dernier_x, village_dernier_y, village_dernier_z } = data;
		console.log('Set Village Position pour ID : ' + id_personnage + ' ; X, Y, Z : ', village_dernier_x, village_dernier_y, village_dernier_z);

		db.query("CALL InsertVillageLocation(?,?,?,?)",
		[id_personnage, village_dernier_x, village_dernier_y, village_dernier_z],
		(err, result) => {
			if (err) return res.status(500).json({error: err});

			res.json({ message: 'village sauvegarde avec succes!'});
		});

	}
	else if(action === "resetVillagePositions") {
		const {id_personnage} = data;
		console.log("Reset Village Position pour ID : " + id_personnage);
		db.query("UPDATE personnages SET village_dernier_y = 0 WHERE id_personnage = ?",
		[id_personnage],
		(err, result) => {
			if (err) return res.status(500).json({error: err});

			res.json({message: 'Village reset avec succes!'})
		});
	}
	else if(action ==="fetch_inventory"){
		const {id_personnage} = data;
		console.log('Fetching player inventory at id : ' + id_personnage);

		db.query("SELECT * FROM personnage_ressource_inventaire WHERE id_personnage = ?",
		[id_personnage],
		(err, result) => {
			if (err) return res.status(500).json({ error: err.message });

			console.log(result);
			res.json(result);
		});
	}
	else if (action ==="fetch_chest"){
		const {id_personnage} = data;
		console.log('Fetching player chest at id : ' + id_personnage);
		db.query("SELECT * FROM personnage_ressource_coffre WHERE id_personnage = ?",
		[id_personnage],
		(err, result) => {
			if (err) return res.status(500).json({ error: err.message });

			res.json(result);
		});
	}
	else if (action ==="fetch_villages"){
		db.query("SELECT * FROM personnages WHERE village_dernier_y != 0",
		(err, result) => {
			if (err) return res.status(500).json({ error: err.message });

			return res.json(result);
		});
	}
	else if(action ==="got_ressource"){
		const {id_personnage, id_ressource, quantite} = data;
		db.query("CALL GotRessource(?, ?, ?)", [id_personnage, id_ressource, quantite],
		(err, result) => {
			if (err) {
				if (err.code === 'ER_SIGNAL_EXCEPTION') {
					const customMessage = err.sqlMessage;
					console.log(customMessage);
					return res.status(400).json({message: err.sqlMessage, details: err});
				}
				return res.status(500).json({error: err});
			}
			res.json({idPersonnage: id_personnage});
		});
	}
	//OBSOLETE ?
	else if(action ==="craft_batiment"){
		const {id_personnage, id_batiment} = data;
		db.query("INSERT INTO personnage_batiment_village(id_batiment, id_personnage) VALUES (?, ?)",
		[id_batiment, id_personnage],
		(err, result) => {
			if (err) return res.status(500).json({error: err.message});

			res.json(result);
		});
	}
	else if(action ==="craft_recette"){
		const {id_personnage, id_recette} = data;
		console.log("Trying craft" + id_recette + " for player " + id_personnage);
		db.query("CALL CraftRecettes(?,?)",
		[id_personnage, id_recette],
		(err, result) => {
			if (err) return res.status(500).json({error: err.message});

			res.json(result);
		});
	}
	else if(action ==="place_batiment"){
		const {id_personnage, id_batiment, position_x, position_y, position_z, rotation_y} = data;
		db.query("CALL PlaceBatiment(?,?,?,?,?,?)",
		[id_personnage, id_batiment, position_x, position_y, position_z, rotation_y],
		(err, result) => {
			if (err) return res.status(500).json({error: err.message});

			res.json(result);
		});
	}
	else if(action ==="fetch_playerVillage"){
		const {id_personnage} = data;
		db.query("SELECT * FROM personnage_batiment_village WHERE id_personnage = ? AND est_place = TRUE",
		[id_personnage],
		(err, result) => {
			if (err) return res.status(500).json({error: err.message});

			res.json(result);
		});
	}
	else if(action ==="fetch_player_batiments"){
		const {id_personnage} = data;
		db.query("SELECT * FROM personnage_batiment_village WHERE id_personnage = ? AND est_place = FALSE",
		[id_personnage],
		(err, result) => {
			if (err) return res.status(500).json({error: err.message});

			res.json(result);
		});
	}
	else {
		res.status(400).json({ error: "Invalid action :("});
	}
});

//ACTIONS Village
// All recipes
app.get('/recipes', (req, res) => {
	db.query('SELECT * FROM recettes', (err, results) => {
		if(err) return res.status(500).json({ error: err.message});
		res.json(results);
	});
});

// Recipe by ID
app.get('/recipes/id', (req, res) => {
	const recipeID = req.params.id;
	db.query('SELECT * FROM recettes WHERE id_recette = ?', [recipeID], (err, results) => {
		if(err) return res.status(500).json({ error: err.message });
		if(results.length === 0) return res.status(404).json({ error: "Recette non trouvee"});
		res.json(results[0]);
	});
});

// Ingredients for a recipe
app.get('/recipes/:id/ingredients', (req, res) => {
	const recipeID = req.params.id;
	const query = `
		SELECT tr.id_ressource, tr.nom_ressource, bi.quantite
		FROM bundles_ingredients bi
		JOIN types_ressources tr ON bi.id_ressource = tr.id_ressource
		WHERE bi.id_recette = ?
	`;
	db.query(query, [recipeID], (err, results) => {
		if(err) return res.status(500).json({ error: err.message });
		res.json(results);
	});
});

//START API server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
	console.log('Server running on port ' + PORT);
});
