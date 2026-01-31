/*******************************************************************************
 * Project Work: Governance degli asset, dei servizi informatici e profili di 
 * responsabilità - Base di dati relazionale per l'adempimento degli obblighi 
 * delle direttive ACN in ambito NIS2 
 * FILE: 02_storicizzazione.sql
 * DESCRIZIONE: Creazione delle tabelle di storicizzazione, delle funzioni e
 * dei trigger per la tracciabilità delle modifiche (Inserimento/Modifica).
 * ORDINE ESECUZIONE: 2
 *******************************************************************************/

---------------------------------------------------------------------------------
-- 1. TABELLE PER STORICIZZAZIONE
---------------------------------------------------------------------------------

-- 1.1 Tabella ASSET_HW_STORICO: Storicizzazione delle modifiche per gli asset hardware
CREATE TABLE ASSET_HW_STORICO (
	AssetHwStoricoID SERIAL PRIMARY KEY, 
	DataModifica TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	TipoModifica VARCHAR(20) NOT NULL CHECK (TipoModifica IN ('Inserimento','Modifica')),
    AssetID INT NOT NULL,
    CodiceInventario VARCHAR(30) NOT NULL,
	ProduttoreId INT NOT NULL,
	Modello VARCHAR(50) NOT NULL,
	NumeroSeriale VARCHAR(30) NOT NULL,
	Locazione VARCHAR(50) NOT NULL,
	DataAcquisto DATE NOT NULL,
	FornitoreId INT NOT NULL,
	Stato VARCHAR(30) NOT NULL,
	
	FOREIGN KEY (AssetID) REFERENCES ASSET (AssetID),
	FOREIGN KEY (ProduttoreId) REFERENCES AZIENDA_EXT (AziendaExtID),
	FOREIGN KEY (FornitoreId) REFERENCES AZIENDA_EXT (AziendaExtID)
);

-- 1.2 Tabella ASSET_SW_STORICO: Storicizzazione delle modifiche per gli asset software
CREATE TABLE ASSET_SW_STORICO (
	AssetSwStoricoID SERIAL PRIMARY KEY, 
	DataModifica TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	TipoModifica VARCHAR(20) NOT NULL CHECK (TipoModifica IN ('Inserimento','Modifica')),
    AssetID INT NOT NULL,
    Versione VARCHAR(30),
	SviluppatoreId INT NOT NULL,
	TipoLicenza VARCHAR(50) NOT NULL,
	DataScadenzaLicenza DATE,
	DataAcquisto DATE NOT NULL,
	FornitoreId INT NOT NULL,
	Stato VARCHAR(30) NOT NULL,
	
	FOREIGN KEY (AssetID) REFERENCES ASSET (AssetID),
	FOREIGN KEY (SviluppatoreId) REFERENCES AZIENDA_EXT (AziendaExtID),
	FOREIGN KEY (FornitoreId) REFERENCES AZIENDA_EXT (AziendaExtID)
);

-- 1.3 Tabella ASSET_FLOW_STORICO: Storicizzazione delle modifiche per gli asset flow
CREATE TABLE ASSET_FLOW_STORICO (
	AssetFlowStoricoID SERIAL PRIMARY KEY, 
	DataModifica TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	TipoModifica VARCHAR(20) NOT NULL CHECK (TipoModifica IN ('Inserimento','Modifica')),
    AssetID INT NOT NULL,
    Sorgente VARCHAR(50) NOT NULL,
	Destinazione VARCHAR(50) NOT NULL,
	Protocollo VARCHAR(50) NOT NULL,
	Porta VARCHAR(50) NOT NULL,
	Direzione VARCHAR(30) NOT NULL,
	CrittografiaTrasporto VARCHAR(50) NOT NULL,
	Frequenza VARCHAR(50) NOT NULL,
	Stato VARCHAR(30) NOT NULL,

	FOREIGN KEY (AssetID) REFERENCES ASSET (AssetID)
);

-- 1.4 Tabella ASSET_SERVIZIO_ESTERNO_STORICO: Storicizzazione modifiche asset servizi esterni
CREATE TABLE ASSET_SERVIZIO_ESTERNO_STORICO (
	AssetServizioEsternoStoricoID SERIAL PRIMARY KEY, 
	DataModifica TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	TipoModifica VARCHAR(20) NOT NULL CHECK (TipoModifica IN ('Inserimento','Modifica')),
    AssetID INT NOT NULL,
	FornitoreId INT NOT NULL,
    TipoServizio VARCHAR(30),
	DataInizioContratto DATE NOT NULL,
	DataConclusioneContratto DATE,
	ContattoEmergenza VARCHAR(50) NOT NULL,
	Stato VARCHAR(30) NOT NULL,

	FOREIGN KEY (AssetID) REFERENCES ASSET (AssetID),
	FOREIGN KEY (FornitoreId) REFERENCES AZIENDA_EXT (AziendaExtID)
);

-- 1.5 Tabella SERVIZIO_STORICO: Storicizzazione delle modifiche ai servizi
CREATE TABLE SERVIZIO_STORICO (
	ServizioStoricoID SERIAL PRIMARY KEY, 
	DataModifica TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	TipoModifica VARCHAR(20) NOT NULL CHECK (TipoModifica IN ('Inserimento','Modifica')),
    ServizioID INT NOT NULL,
    Nome VARCHAR(100) NOT NULL,
    Descrizione TEXT NOT NULL,
	Tipologia VARCHAR(20) NOT NULL,
	LivelloCriticita VARCHAR(20) NOT NULL,
	ResponsabileGestioneID INT NOT NULL,
	
	FOREIGN KEY (ResponsabileGestioneID) REFERENCES RUOLO (RuoloID)
);

---------------------------------------------------------------------------------
-- 2. FUNZIONI PER STORICIZZAZIONE
---------------------------------------------------------------------------------

-- 2.1 Funzione storicizza ASSET_HW
CREATE OR REPLACE FUNCTION fn_storicizza_asset_hw()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        INSERT INTO ASSET_HW_STORICO (
            TipoModifica, AssetID, CodiceInventario, ProduttoreId, Modello, 
            NumeroSeriale, Locazione, DataAcquisto, FornitoreId, Stato
        )
        VALUES (
            'Inserimento', NEW.AssetID, NEW.CodiceInventario, NEW.ProduttoreId, NEW.Modello, 
            NEW.NumeroSeriale, NEW.Locazione, NEW.DataAcquisto, NEW.FornitoreId, NEW.Stato
        );
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO ASSET_HW_STORICO (
            TipoModifica, AssetID, CodiceInventario, ProduttoreId, Modello, 
            NumeroSeriale, Locazione, DataAcquisto, FornitoreId, Stato
        )
        VALUES (
            'Modifica', NEW.AssetID, NEW.CodiceInventario, NEW.ProduttoreId, NEW.Modello, 
            NEW.NumeroSeriale, NEW.Locazione, NEW.DataAcquisto, NEW.FornitoreId, NEW.Stato
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 2.2 Funzione storicizza ASSET_SW
CREATE OR REPLACE FUNCTION fn_storicizza_asset_sw()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        INSERT INTO ASSET_SW_STORICO (
            TipoModifica, AssetID, Versione, SviluppatoreId, TipoLicenza, 
            DataScadenzaLicenza, DataAcquisto, FornitoreId, Stato
        )
        VALUES (
            'Inserimento', NEW.AssetID, NEW.Versione, NEW.SviluppatoreId, NEW.TipoLicenza, 
            NEW.DataScadenzaLicenza, NEW.DataAcquisto, NEW.FornitoreId, NEW.Stato
        );
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO ASSET_SW_STORICO (
            TipoModifica, AssetID, Versione, SviluppatoreId, TipoLicenza, 
            DataScadenzaLicenza, DataAcquisto, FornitoreId, Stato
        )
        VALUES (
            'Modifica', NEW.AssetID, NEW.Versione, NEW.SviluppatoreId, NEW.TipoLicenza, 
            NEW.DataScadenzaLicenza, NEW.DataAcquisto, NEW.FornitoreId, NEW.Stato
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 2.3 Funzione storicizza ASSET_FLOW
CREATE OR REPLACE FUNCTION fn_storicizza_asset_flow()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        INSERT INTO ASSET_FLOW_STORICO (
            TipoModifica, AssetID, Sorgente, Destinazione, Protocollo, 
            Porta, Direzione, CrittografiaTrasporto, Frequenza, Stato
        )
        VALUES (
            'Inserimento', NEW.AssetID, NEW.Sorgente, NEW.Destinazione, NEW.Protocollo, 
            NEW.Porta, NEW.Direzione, NEW.CrittografiaTrasporto, NEW.Frequenza, NEW.Stato
        );
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO ASSET_FLOW_STORICO (
            TipoModifica, AssetID, Sorgente, Destinazione, Protocollo, 
            Porta, Direzione, CrittografiaTrasporto, Frequenza, Stato
        )
        VALUES (
            'Modifica', NEW.AssetID, NEW.Sorgente, NEW.Destinazione, NEW.Protocollo, 
            NEW.Porta, NEW.Direzione, NEW.CrittografiaTrasporto, NEW.Frequenza, NEW.Stato
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 2.4 Funzione storicizza ASSET_SERVIZIO_ESTERNO
CREATE OR REPLACE FUNCTION fn_storicizza_asset_servizio_esterno()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        INSERT INTO ASSET_SERVIZIO_ESTERNO_STORICO (
            TipoModifica, AssetID, FornitoreId, TipoServizio, 
            DataInizioContratto, DataConclusioneContratto, ContattoEmergenza, Stato
        )
        VALUES (
            'Inserimento', NEW.AssetID, NEW.FornitoreId, NEW.TipoServizio, 
            NEW.DataInizioContratto, NEW.DataConclusioneContratto, NEW.ContattoEmergenza, NEW.Stato
        );
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO ASSET_SERVIZIO_ESTERNO_STORICO (
            TipoModifica, AssetID, FornitoreId, TipoServizio, 
            DataInizioContratto, DataConclusioneContratto, ContattoEmergenza, Stato
        )
        VALUES (
            'Modifica', NEW.AssetID, NEW.FornitoreId, NEW.TipoServizio, 
            NEW.DataInizioContratto, NEW.DataConclusioneContratto, NEW.ContattoEmergenza, NEW.Stato
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 2.5 Funzione storicizza SERVIZIO
CREATE OR REPLACE FUNCTION fn_storicizza_servizio()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        INSERT INTO SERVIZIO_STORICO (
            TipoModifica, ServizioID, Nome, Descrizione, Tipologia, 
			LivelloCriticita, ResponsabileGestioneID
        )
        VALUES (
            'Inserimento', NEW.ServizioID, NEW.Nome, NEW.Descrizione, 
			NEW.Tipologia, NEW.LivelloCriticita, NEW.ResponsabileGestioneID
        );
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO SERVIZIO_STORICO (
            TipoModifica, ServizioID, Nome, Descrizione, Tipologia, 
			LivelloCriticita, ResponsabileGestioneID
        )
        VALUES (
            'Modifica', NEW.ServizioID, NEW.Nome, NEW.Descrizione, NEW.Tipologia, 
			NEW.LivelloCriticita, NEW.ResponsabileGestioneID
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


---------------------------------------------------------------------------------
-- 3. TRIGGER PER ATTIVAZIONE FUNZIONE STORICIZZAIZONE DOPO INSERT / UPDATE
---------------------------------------------------------------------------------

-- 3.1 Trigger storicizza ASSET_HW
CREATE TRIGGER trg_storicizza_asset_hw
AFTER INSERT OR UPDATE ON ASSET_HW
FOR EACH ROW
EXECUTE FUNCTION fn_storicizza_asset_hw();

-- 3.2 Trigger storicizza ASSET_SW
CREATE TRIGGER trg_storicizza_asset_sw
AFTER INSERT OR UPDATE ON ASSET_SW
FOR EACH ROW
EXECUTE FUNCTION fn_storicizza_asset_sw();

-- 3.3 Trigger storicizza ASSET_FLOW
CREATE TRIGGER trg_storicizza_asset_flow
AFTER INSERT OR UPDATE ON ASSET_FLOW
FOR EACH ROW
EXECUTE FUNCTION fn_storicizza_asset_flow();

-- 3.4 Trigger storicizza ASSET_SERVIZIO_ESTERNO
CREATE TRIGGER trg_storicizza_asset_servizio_esterno
AFTER INSERT OR UPDATE ON ASSET_SERVIZIO_ESTERNO
FOR EACH ROW
EXECUTE FUNCTION fn_storicizza_asset_servizio_esterno();

-- 3.5 Trigger storicizza SERVIZIO
CREATE TRIGGER trg_storicizza_servizio
AFTER INSERT OR UPDATE ON SERVIZIO
FOR EACH ROW
EXECUTE FUNCTION fn_storicizza_servizio();


