/*******************************************************************************
 * Project Work: Governance degli asset, dei servizi informatici e profili di 
 * responsabilità - Base di dati relazionale per l'adempimento degli obblighi 
 * delle direttive ACN in ambito NIS2 
 * FILE: 03_procedure.sql
 * DESCRIZIONE: Definizione delle procedure per l'inserimento coordinato
 * di Asset e relative specializzazioni.
 * ORDINE ESECUZIONE: 3
 *******************************************************************************/

--------------------------------------------------------------------------------
-- 1. PROCEDURE PER INSERIMENTO ASSET DI TIPO HARDWARE
--------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE p_inserisci_nuovo_asset_hw(
    -- Parametri ASSET
	p_nome VARCHAR, p_descrizione TEXT, p_criticita VARCHAR, p_responsabile_id INT,
	-- Parametri ASSET_HW
    p_codice_inventario VARCHAR, p_produttore_id INT, p_modello VARCHAR, 
    p_numero_seriale VARCHAR, p_locazione VARCHAR, p_data_acquisto DATE, 
    p_fornitore_id INT, p_stato VARCHAR
) 
LANGUAGE plpgsql AS $$
BEGIN
    WITH inserimento_padre AS (
        INSERT INTO ASSET (Nome, Descrizione, LivelloCriticita, ResponsabileTecnicoID)
        VALUES (p_nome, p_descrizione, p_criticita, p_responsabile_id)
        RETURNING AssetID
    )
    INSERT INTO ASSET_HW (
        AssetID, CodiceInventario, ProduttoreId, Modello, 
        NumeroSeriale, Locazione, DataAcquisto, FornitoreId, Stato
    )
    SELECT 
        AssetID, p_codice_inventario, p_produttore_id, p_modello, 
        p_numero_seriale, p_locazione, p_data_acquisto, p_fornitore_id, p_stato
    FROM inserimento_padre;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Errore nell''inserimento Hardware: %', SQLERRM;
END;
$$;

--------------------------------------------------------------------------------
-- 2. PROCEDURE PER INSERIMENTO ASSET DI TIPO SOFTWARE
--------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE p_inserisci_nuovo_asset_sw(
    -- Parametri ASSET
    p_nome VARCHAR, p_descrizione TEXT, p_criticita VARCHAR, p_responsabile_id INT,
    -- Parametri ASSET_SW
    p_versione VARCHAR, p_sviluppatore_id INT, p_tipo_licenza VARCHAR, 
    p_scadenza_licenza DATE, p_data_acquisto DATE, p_fornitore_id INT, p_stato VARCHAR
) 
LANGUAGE plpgsql AS $$
BEGIN
    WITH inserimento_padre AS (
        INSERT INTO ASSET (Nome, Descrizione, LivelloCriticita, ResponsabileTecnicoID)
        VALUES (p_nome, p_descrizione, p_criticita, p_responsabile_id)
        RETURNING AssetID
    )
    INSERT INTO ASSET_SW (
        AssetID, Versione, SviluppatoreId, TipoLicenza, 
        DataScadenzaLicenza, DataAcquisto, FornitoreId, Stato
    )
    SELECT 
        AssetID, p_versione, p_sviluppatore_id, p_tipo_licenza, 
        p_scadenza_licenza, p_data_acquisto, p_fornitore_id, p_stato
    FROM inserimento_padre;
	
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Errore nell''inserimento Software: %', SQLERRM;
END;
$$;

--------------------------------------------------------------------------------
-- 3. PROCEDURE PER INSERIMENTO ASSET DI TIPO FLUSSO
--------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE p_inserisci_nuovo_asset_flow(
    -- Parametri ASSET
    p_nome VARCHAR, p_descrizione TEXT, p_criticita VARCHAR, p_responsabile_id INT,
    -- Parametri ASSET_FLOW
    p_sorgente VARCHAR, p_destinazione VARCHAR, p_protocollo VARCHAR, 
    p_porta VARCHAR, p_direzione VARCHAR, p_crittografia VARCHAR, 
    p_frequenza VARCHAR, p_stato VARCHAR
) 
LANGUAGE plpgsql AS $$
BEGIN
    WITH inserimento_padre AS (
        INSERT INTO ASSET (Nome, Descrizione, LivelloCriticita, ResponsabileTecnicoID)
        VALUES (p_nome, p_descrizione, p_criticita, p_responsabile_id)
        RETURNING AssetID
    )
    INSERT INTO ASSET_FLOW (
        AssetID, Sorgente, Destinazione, Protocollo, 
        Porta, Direzione, CrittografiaTrasporto, Frequenza, Stato
    )
    SELECT 
        AssetID, p_sorgente, p_destinazione, p_protocollo, 
        p_porta, p_direzione, p_crittografia, p_frequenza, p_stato
    FROM inserimento_padre;
	
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Errore nell''inserimento Flusso: %', SQLERRM;
END;
$$;

--------------------------------------------------------------------------------
-- 4. PROCEDURE PER INSERIMENTO ASSET DI TIPO SERVIZIO ESTERNO
--------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE p_inserisci_nuovo_asset_servizio_esterno(
    -- Parametri ASSET
	p_nome VARCHAR, p_descrizione TEXT, p_criticita VARCHAR, p_responsabile_id INT,
	-- Parametri ASSET_SERVIZIO_ESTERNO
    p_fornitore_id INT, p_tipo_servizio VARCHAR, p_data_inizio DATE, 
    p_data_fine DATE, p_contatto_emergenza VARCHAR, p_stato VARCHAR
) 
LANGUAGE plpgsql AS $$
BEGIN
    WITH inserimento_padre AS (
        INSERT INTO ASSET (Nome, Descrizione, LivelloCriticita, ResponsabileTecnicoID)
        VALUES (p_nome, p_descrizione, p_criticita, p_responsabile_id)
        RETURNING AssetID
    )
    INSERT INTO ASSET_SERVIZIO_ESTERNO (
        AssetID, FornitoreId, TipoServizio, DataInizioContratto, 
        DataConclusioneContratto, ContattoEmergenza, Stato
    )
    SELECT 
        AssetID, p_fornitore_id, p_tipo_servizio, p_data_inizio, 
        p_data_fine, p_contatto_emergenza, p_stato
    FROM inserimento_padre;
   
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Errore nell''inserimento Servizio Esterno: %', SQLERRM;
END;
$$;

 