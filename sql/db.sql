
-- CREATE DATABASE cowork;
--
-- -- Connexion à la base de données
-- \c cowork;

-- Création des tables


-- Table users
CREATE TABLE users (
                       id_user SERIAL PRIMARY KEY,
                       nom VARCHAR(255) NOT NULL,
                       prenom VARCHAR(255) NOT NULL,
                       email VARCHAR(255) UNIQUE NOT NULL,
                       password VARCHAR(255) NOT NULL,
                       entreprise VARCHAR(255) NOT NULL,
                       secteur_activite VARCHAR(255) NOT NULL
);

-- Table salles
CREATE TABLE salles (
                        id_salle SERIAL PRIMARY KEY,
                        label VARCHAR(255) NOT NULL,
                        type_espace VARCHAR(255),
                        description Text NOT NULL,
                        capacite INTEGER,
                        image_url VARCHAR(255) NOT NULL
);

-- Table equipements
CREATE TABLE equipements (
                             id_equipement SERIAL PRIMARY KEY,
                             label VARCHAR(255) NOT NULL
);

-- Table salles_equipements (association entre salles et equipements)
CREATE TABLE salles_equipements (
                         id_salle INTEGER NOT NULL REFERENCES salles(id_salle) ON DELETE CASCADE,
                         id_equipement INTEGER NOT NULL REFERENCES equipements(id_equipement) ON DELETE CASCADE,
                         PRIMARY KEY (id_salle, id_equipement)
);

-- Table forfaits
CREATE TABLE forfaits (
                          id_forfait SERIAL PRIMARY KEY,
                          label VARCHAR(255) NOT NULL,
                          description TEXT,
                          heure_deb TIME,
                          heure_fin TIME,
                          type_espace VARCHAR(255),
                          image_url VARCHAR(255) NOT NULL,
                          prix INT NOT NULL
);

-- Table posts
CREATE TABLE posts (
                       id_post SERIAL PRIMARY KEY,
                       content TEXT NOT NULL,
                       created_at TIMESTAMP DEFAULT current_timestamp,
                       id_parent INTEGER REFERENCES posts(id_post) ON DELETE SET NULL,
                       id_user INTEGER NOT NULL REFERENCES users(id_user) ON DELETE CASCADE
);

-- Table users_salles (association entre users et salles)
CREATE TABLE users_salles (
                          id_user INTEGER NOT NULL REFERENCES users(id_user) ON DELETE CASCADE,
                          id_salle INTEGER NOT NULL REFERENCES salles(id_salle) ON DELETE CASCADE,
                          timestamp_deb TIMESTAMP,
                          timestamp_fin TIMESTAMP,
                          code varchar(255) NOT NULL,
                          PRIMARY KEY (id_user, id_salle, timestamp_deb)
);

-- Table users_forfaits (relation entre users et forfaits)
CREATE TABLE users_forfaits (
                          id_user INTEGER NOT NULL REFERENCES users(id_user) ON DELETE CASCADE,
                          id_forfait INTEGER NOT NULL REFERENCES forfaits(id_forfait) ON DELETE CASCADE,
                          subscribed_at TIMESTAMP DEFAULT current_timestamp,
                          PRIMARY KEY (id_user, id_forfait)
);


-- Index supplémentaires
CREATE INDEX idx_posts_id_parent ON posts(id_parent);
CREATE INDEX idx_users_email ON users(email);