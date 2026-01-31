/*******************************************************************************
 * Project Work: Governance degli asset, dei servizi informatici e profili di 
 * responsabilità - Base di dati relazionale per l'adempimento degli obblighi 
 * delle direttive ACN in ambito NIS2 
 * FILE: 01_schema_tabelle.sql
 * DESCRIZIONE: Definizione dello schema fisico del database. 
 * Include le tabelle anagrafiche, gli asset, i servizi e le dipendenze.
 * ORDINE ESECUZIONE: 01
 *******************************************************************************/

-- 1. Tabella IMPIEGATO: Personale dipendente dell'organizzazione 
 CREATE TABLE IMPIEGATO (
    Matricola VARCHAR(30) NOT NULL PRIMARY KEY,
	Nome VARCHAR(50) NOT NULL,
    Cognome VARCHAR(50) NOT NULL,
    ContattoEmail VARCHAR(100) NOT NULL,
    ContattoTelefonico VARCHAR(100),
    DataAssunzione DATE NOT NULL,
    DataFineRapporto DATE
);

-- 2. Tabella RUOLO: Definisce i ruoli di responsabilità (Tecnico o di Gestione)
CREATE TABLE RUOLO (
    RuoloID SERIAL PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
	Descrizione TEXT,
	Tipologia VARCHAR (30) NOT NULL CHECK (Tipologia IN ('Tecnico', 'Gestione'))
);

-- 3. Tabella INCARICO: Tabella Ponte Relazione tra Impiegato e Ruolo
CREATE TABLE INCARICO (
	RuoloID INT NOT NULL, 
	Matricola VARCHAR(30) NOT NULL,
    DataAssegnazione DATE NOT NULL,
	DataConclusione DATE,
    Stato VARCHAR(50) NOT NULL CHECK (Stato IN ('Attivo', 'Cessato')), 
    
    PRIMARY KEY (RuoloID, Matricola, DataAssegnazione),
    FOREIGN KEY (RuoloID) REFERENCES RUOLO (RuoloID),
    FOREIGN KEY (Matricola) REFERENCES IMPIEGATO (Matricola)
);

-- 4. Tabella SERVIZIO: Definizione dei Servizi erogati dall'organizzazione
CREATE TABLE SERVIZIO (
    ServizioID SERIAL PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Descrizione TEXT NOT NULL,
	Tipologia VARCHAR(20) NOT NULL CHECK (Tipologia IN ('Interno', 'Esterno', 'Supporto')),
	LivelloCriticita VARCHAR(20) NOT NULL CHECK (LivelloCriticita IN ('Alto', 'Medio', 'Basso')),
	ResponsabileGestioneID INT NOT NULL,
	
	FOREIGN KEY (ResponsabileGestioneID) REFERENCES RUOLO (RuoloID)
);

-- 5. Tabella AZIENDA_EXT: Anagrafica fornitori, produttori hardware e software
CREATE TABLE AZIENDA_EXT (
    AziendaExtID SERIAL PRIMARY KEY,
	RagioneSociale VARCHAR(50) NOT NULL,
	PartitaIva VARCHAR(20),
	CodiceFiscale VARCHAR(20),
	Nazione VARCHAR(30) NOT NULL,
	Citta VARCHAR(30),
    Indirizzo VARCHAR(30),
	Telefono VARCHAR(30),
    Email VARCHAR(50) NOT NULL,
    Pec VARCHAR(50)
);

-- 6. Tabella ASSET (Tabella Padre): Informazioni comuni a tutti gli asset
CREATE TABLE ASSET (
    AssetID SERIAL PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Descrizione TEXT NOT NULL,
	LivelloCriticita VARCHAR(20) NOT NULL CHECK (LivelloCriticita IN ('Alto', 'Medio', 'Basso')),
	ResponsabileTecnicoID INT NOT NULL,
	
	FOREIGN KEY (ResponsabileTecnicoID) REFERENCES RUOLO (RuoloID)
);

-- 7. Tabella ASSET_HW: Dettagli specifici per gil asset di tipo hardware
CREATE TABLE ASSET_HW (
    AssetID INT PRIMARY KEY,
    CodiceInventario VARCHAR(30) NOT NULL,
	ProduttoreId INT NOT NULL,
	Modello VARCHAR(50) NOT NULL,
	NumeroSeriale VARCHAR(30) NOT NULL,
	Locazione VARCHAR(50) NOT NULL,
	DataAcquisto DATE NOT NULL,
	FornitoreId INT NOT NULL,
	Stato VARCHAR(30) NOT NULL CHECK (Stato IN ('Attivo', 'Dismesso', 'In manutenzione')),
	
	FOREIGN KEY (AssetID) REFERENCES ASSET (AssetID),
	FOREIGN KEY (ProduttoreId) REFERENCES AZIENDA_EXT (AziendaExtID),
	FOREIGN KEY (FornitoreId) REFERENCES AZIENDA_EXT (AziendaExtID)
);

-- 8. Tabella ASSET_SW: Dettagli specifici per gli Asset di tipo software
CREATE TABLE ASSET_SW (
    AssetID INT PRIMARY KEY,
    Versione VARCHAR(30),
	SviluppatoreId INT NOT NULL,
	TipoLicenza VARCHAR(50) NOT NULL,
	DataScadenzaLicenza DATE,
	DataAcquisto DATE NOT NULL,
	FornitoreId INT NOT NULL,
	Stato VARCHAR(30) NOT NULL CHECK (Stato IN ('Attivo', 'Dismesso', 'In manutenzione')),
	
	FOREIGN KEY (AssetID) REFERENCES ASSET (AssetID),
	FOREIGN KEY (SviluppatoreId) REFERENCES AZIENDA_EXT (AziendaExtID),
	FOREIGN KEY (FornitoreId) REFERENCES AZIENDA_EXT (AziendaExtID)
);

-- 9. Tabella ASSET_FLOW: Dettagli specifici per gli Asset di tipo flussi di rete 
CREATE TABLE ASSET_FLOW (
    AssetID INT PRIMARY KEY,
    Sorgente VARCHAR(50) NOT NULL,
	Destinazione VARCHAR(50) NOT NULL,
	Protocollo VARCHAR(50) NOT NULL,
	Porta VARCHAR(50) NOT NULL,
	Direzione VARCHAR(30) NOT NULL CHECK (Direzione IN ('Inbound', 'Outbound', 'Lateral', 'Bidirezionale')),
	CrittografiaTrasporto VARCHAR(50) NOT NULL,
	Frequenza VARCHAR(50) NOT NULL,
	Stato VARCHAR(30) NOT NULL CHECK (Stato IN ('Attivo', 'Dismesso', 'In manutenzione')),

	FOREIGN KEY (AssetID) REFERENCES ASSET (AssetID)
);

-- 10. Tabella ASSET_SERVIZIO_ESTERNO: Dettagli specifici Asset servizi esterni
CREATE TABLE ASSET_SERVIZIO_ESTERNO (
    AssetID INT PRIMARY KEY,
	FornitoreId INT NOT NULL,
    TipoServizio VARCHAR(30),
	DataInizioContratto DATE NOT NULL,
	DataConclusioneContratto DATE,
	ContattoEmergenza VARCHAR(50) NOT NULL,
	Stato VARCHAR(30) NOT NULL CHECK (Stato IN ('Attivo', 'Dismesso', 'In manutenzione', 'Scaduto')),

	FOREIGN KEY (AssetID) REFERENCES ASSET (AssetID),
	FOREIGN KEY (FornitoreId) REFERENCES AZIENDA_EXT (AziendaExtID)
);

-- 11. Tabella DIPENDENZA (Tabella Ponte): Relazione tra Servizi e Asset
CREATE TABLE DIPENDENZA (
    ServizioID INT NOT NULL, 
	AssetID INT NOT NULL,
	DataInizio DATE NOT NULL,
	DataFine DATE,
	    
    PRIMARY KEY (ServizioID, AssetID, DataInizio),
    FOREIGN KEY (ServizioID) REFERENCES SERVIZIO (ServizioID),
    FOREIGN KEY (AssetID) REFERENCES ASSET (AssetID)
);

