/*******************************************************************************
 * Project Work: Governance degli asset, dei servizi informatici e profili di 
 * responsabilità - Base di dati relazionale per l'adempimento degli obblighi 
 * delle direttive ACN in ambito NIS2 
 * FILE: 05_generazione_view.sql
 * DESCRIZIONE: Generazione view da richiamare per generazione report conformi
 * alle misure di sicurezza.
 * ORDINE ESECUZIONE: 5
 *******************************************************************************/

------------------------------------------------------------------------
-- 1. Misura di sicurezza GV.OC-04:
--    Elenco aggiornato dei sistemi informativi e di rete rilevanti. 
------------------------------------------------------------------------

-- 1.1 view misura_sicurezza_GV_OC_04_view01

CREATE OR REPLACE VIEW misura_sicurezza_GV_OC_04_view01 AS
SELECT 
    s.ServizioID,
	s.Nome AS "Nome Servizio",
	s.Descrizione AS "Descrizione Servizio",
    s.LivelloCriticita AS "Livello Criticità",
    -- Responsabile Gestione
    r.Nome AS "Ruolo Responsabile Gestione",
    -- Conteggio Impiegati Attivi per quel ruolo
    (SELECT COUNT(*) 
     FROM INCARICO i 
     WHERE i.RuoloID = r.RuoloID 
	 AND i.Stato = 'Attivo' 
	 AND (i.DataConclusione IS NULL OR i.DataConclusione>CURRENT_DATE)
	)AS "Impiegati attivi nel ruolo"
FROM SERVIZIO s

JOIN RUOLO r ON s.ResponsabileGestioneID = r.RuoloID
ORDER BY s.ServizioID;


-- 1.2 view misura_sicurezza_GV_OC_04_view02

CREATE OR REPLACE VIEW misura_sicurezza_GV_OC_04_view02 AS
SELECT 
    s.ServizioID,
	s.Nome AS "Nome Servizio",
    s.LivelloCriticita AS "Livello Criticità",
	-- Responsabile Gestione
    rg.Nome AS "Ruolo Responsabile Gestione",
	-- Conteggio Impiegati Attivi per quel ruolo
	(SELECT COUNT(*) 
     FROM INCARICO i 
     WHERE i.RuoloID = rg.RuoloID 
	 AND i.Stato = 'Attivo' 
	 AND (i.DataConclusione IS NULL OR i.DataConclusione>CURRENT_DATE)
	)AS "Impiegati attivi nel ruolo" ,
    a.Nome AS "Dipendenza da Asset",
    -- Tipologia Asset
    CASE 
        WHEN hw.AssetID IS NOT NULL THEN 'Hardware'
        WHEN sw.AssetID IS NOT NULL THEN 'Software'
        WHEN fl.AssetID IS NOT NULL THEN 'Flusso'
        WHEN se.AssetID IS NOT NULL THEN 'Servizio Esterno'
    END AS "Tipologia Asset",
    -- Stato dell'Asset
    COALESCE(hw.Stato, sw.Stato, fl.Stato, se.Stato) AS Stato_Asset,
	 -- Responsabile Tecnico
    rt.Nome AS "Ruolo Responsabile Tecnico Asset",
    -- Conteggio Impiegati Attivi per quel ruolo
    (SELECT COUNT(*) 
     FROM INCARICO i 
     WHERE i.RuoloID = rt.RuoloID 
	 AND i.Stato = 'Attivo' 
	 AND (i.DataConclusione IS NULL OR i.DataConclusione>CURRENT_DATE)
	)AS "Impiegati tecnici gestione asset",
	 -- Fornitore Asset
    COALESCE(az_forn_hw.RagioneSociale, az_forn_sw.RagioneSociale, az_forn_se.RagioneSociale, 'n/a') AS "Fornitore Asset",
    -- Produttore o Sviluppatore
    COALESCE(az_prod.RagioneSociale, az_svil.RagioneSociale, 'n/a') AS "Produttore / Sviluppatore - Asset"

FROM SERVIZIO s
JOIN DIPENDENZA d ON s.ServizioID = d.ServizioID
JOIN ASSET a ON d.AssetID = a.AssetID
JOIN RUOLO rg ON s.ResponsabileGestioneID = rg.RuoloID
JOIN RUOLO rt ON a.ResponsabileTecnicoID = rt.RuoloID
-- Join con specializzazioni
LEFT JOIN ASSET_HW hw ON a.AssetID = hw.AssetID
LEFT JOIN ASSET_SW sw ON a.AssetID = sw.AssetID
LEFT JOIN ASSET_FLOW fl ON a.AssetID = fl.AssetID
LEFT JOIN ASSET_SERVIZIO_ESTERNO se ON a.AssetID = se.AssetID
-- Join con AZIENDA_EXT
LEFT JOIN AZIENDA_EXT az_prod ON hw.ProduttoreId = az_prod.AziendaExtID
LEFT JOIN AZIENDA_EXT az_svil ON sw.SviluppatoreId = az_svil.AziendaExtID
LEFT JOIN AZIENDA_EXT az_forn_hw ON hw.FornitoreId = az_forn_hw.AziendaExtID
LEFT JOIN AZIENDA_EXT az_forn_sw ON sw.FornitoreId = az_forn_sw.AziendaExtID
LEFT JOIN AZIENDA_EXT az_forn_se ON se.FornitoreId = az_forn_se.AziendaExtID
ORDER BY s.ServizioID ASC, "Tipologia Asset" ASC;


-- 1.3 view misura_sicurezza_GV_OC_04_storico_modifiche

CREATE OR REPLACE VIEW misura_sicurezza_GV_OC_04_view03 AS
SELECT 
	s.ServizioID,
	s.TipoModifica AS "Tipo Modifica",
	s.DataModifica AS "Data Modifica",
	s.Nome AS "Nome Servizio",
	s.Descrizione AS "Descrizione Servizio",
	s.Tipologia AS "Tipologia",
	s.LivelloCriticita AS "Livello Criticità",
	r.Nome AS "Responsabile gestione"
FROM SERVIZIO_STORICO s
JOIN RUOLO r ON s.ResponsabileGestioneID=r.RuoloID
ORDER BY ServizioID ASC, DataModifica ASC;



------------------------------------------------------------------------
-- 2. Misura di sicurezza GV.RR-02:
--    Elenco aggiornato del personale dell'organizzazione avente 
--    specifici ruoli e responsabilità. 
------------------------------------------------------------------------

-- 2.1 misura_sicurezza_GV_RR_02

CREATE OR REPLACE VIEW misura_sicurezza_GV_RR_02 AS
SELECT 
	r.RuoloID,
	r.Nome AS "Ruolo Tecnico",
	r.Tipologia AS "Tipologia Ruolo",
	r.Descrizione AS "Descrizione Ruolo",
	i.Cognome AS "Cognome Impiegato",
	i.Nome AS "Nome Impiegato",
	i.ContattoEmail AS "Contatto Email",
	inc.DataAssegnazione AS "Data Assegnazione",
	inc.DataConclusione AS "Data Conclusione",
	inc.Stato AS "Stato Incarico"
FROM RUOLO r
JOIN INCARICO inc ON r.RuoloID = inc.RuoloID
JOIN IMPIEGATO i ON inc.Matricola = i.Matricola
WHERE r.Tipologia = 'Tecnico'
AND inc.Stato = 'Attivo' 
AND	(inc.DataConclusione IS NULL OR inc.DataConclusione > CURRENT_DATE)
ORDER BY r.Nome, i.Cognome, i.Nome;

-- 2.2 misura_sicurezza_GV_RR_02_storico_incarichi

CREATE OR REPLACE VIEW misura_sicurezza_GV_RR_02_storico_incarichi AS
SELECT 
	r.RuoloID,
	r.Nome AS "Ruolo Tecnico",
	r.Tipologia AS "Tipologia Ruolo",
	r.Descrizione AS "Descrizione Ruolo",
	i.Cognome AS "Cognome Impiegato",
	i.Nome AS "Nome Impiegato",
	i.ContattoEmail AS "Contatto Email",
	inc.DataAssegnazione AS "Data Assegnazione",
	inc.DataConclusione AS "Data Conclusione",
	inc.Stato AS "Stato Incarico"
FROM RUOLO r
JOIN INCARICO inc ON r.RuoloID = inc.RuoloID
JOIN IMPIEGATO i ON inc.Matricola = i.Matricola
WHERE r.Tipologia = 'Tecnico'
ORDER BY r.Nome, i.Cognome, i.Nome;

------------------------------------------------------------------------
-- 3. Misura di sicurezza GV.SC-04:
--    Elenco dei fornitori prioritizzati in base alla criticità; 
------------------------------------------------------------------------

CREATE OR REPLACE VIEW misura_sicurezza_GV_SC_04 AS
SELECT 
    az.AziendaExtID,
	az.RagioneSociale AS "Fornitore",
    az.PartitaIVA AS "P.IVA Fornitore",
	az.Nazione AS "Nazione",
	az.Email as "E-mail",
    -- Aggregazione di tutti gli asset del fornitore in un'unica cella
    STRING_AGG(DISTINCT a.Nome || 
    ' [Tipo: ' || 
    CASE 
        WHEN hw.AssetID IS NOT NULL THEN 'HW'
        WHEN sw.AssetID IS NOT NULL THEN 'SW'
        WHEN se.AssetID IS NOT NULL THEN 'Serv. Esterno'
    END || ']' || 
    ' [Criticità: ' || COALESCE(a.LivelloCriticita, 'N.D.') || ']', 
    ',' || chr(10)
	) AS "Dettaglio Asset (Tipo e Criticità)",
	-- Conteggio totale asset
    COUNT(DISTINCT a.AssetID) AS "Totale Asset Forniti"
FROM AZIENDA_EXT az
-- Join con le tabelle di specializzazione
LEFT JOIN ASSET_HW hw ON az.AziendaExtID = hw.FornitoreId
LEFT JOIN ASSET_SW sw ON az.AziendaExtID = sw.FornitoreId
LEFT JOIN ASSET_SERVIZIO_ESTERNO se ON az.AziendaExtID = se.FornitoreId
-- Join con la tabella base Asset
JOIN ASSET a ON (a.AssetID = hw.AssetID OR a.AssetID = sw.AssetID OR a.AssetID = se.AssetID)
GROUP BY 
    az.AziendaExtID,
	az.RagioneSociale, 
    az.PartitaIVA
ORDER BY az.AziendaExtID;



------------------------------------------------------------------------
-- 4. Misura di sicurezza ID.AM:
--    Inventario degli asset e sue specializzazioni.
------------------------------------------------------------------------

-- 4.1.1 ID.AM-01: Elenco degli asset di tipo Hardware

CREATE OR REPLACE VIEW misura_sicurezza_ID_AM_01 AS
SELECT 
	a.AssetID,
	hw.CodiceInventario,
    a.Nome AS "Asset Hardware",
    hw.Modello,
	hw.NumeroSeriale,
	hw.Locazione,
	-- Produttore
    azp.RagioneSociale AS "Produttore",
    hw.DataAcquisto AS "Data Acquisto",
    hw.Stato,
    -- Fornitore
    azf.RagioneSociale AS "Fornitore",
    -- Responsabile Tecnico
    r.Nome AS "Ruolo Responsabile Tecnico",
	(SELECT COUNT(*) 
     FROM INCARICO inc 
     WHERE inc.RuoloID = r.RuoloID 
	 AND inc.Stato = 'Attivo' 
	 AND (inc.DataConclusione IS NULL OR inc.DataConclusione>CURRENT_DATE)
	)AS Operatori_Tecnici_Attivi,
    -- Servizi Supportati (Aggregati)
    COALESCE(STRING_AGG(DISTINCT s.Nome, ', '), 'Nessun servizio supportato') AS "Servizi Supportati"
FROM ASSET a
JOIN ASSET_HW hw ON a.AssetID = hw.AssetID
-- Fornitore
LEFT JOIN AZIENDA_EXT azf ON hw.FornitoreId = azf.AziendaExtID
-- Produttore
LEFT JOIN AZIENDA_EXT azp ON hw.ProduttoreId = azp.AziendaExtID
-- Responsabile Tecnico
JOIN RUOLO r ON a.ResponsabileTecnicoID = r.RuoloID
-- Dipendenze e Servizi (solo quelli attivi)
LEFT JOIN DIPENDENZA d ON a.AssetID = d.AssetID 
    AND (d.DataFine IS NULL OR d.DataFine > CURRENT_DATE)
LEFT JOIN SERVIZIO s ON d.ServizioID = s.ServizioID
GROUP BY 
    a.AssetID, 
    hw.CodiceInventario,
	a.Nome, 
    hw.Modello, 
	hw.NumeroSeriale,
	hw.Locazione,
    hw.DataAcquisto,  
    hw.Stato, 
	r.RuoloID,
    azp.RagioneSociale, 
	azf.RagioneSociale, 
    r.Nome
ORDER BY a.AssetID;


-- 4.1.2 ID.AM-01: View per estrarre storicizzazione degli asset di tipo Hardware
CREATE OR REPLACE VIEW v_check_storico_hw AS
SELECT 
	h.AssetID,
	h.DataModifica,
	h.TipoModifica,
	a.Nome AS Nome_Asset,
	h.CodiceInventario,
	aep.RagioneSociale AS Produttore,
	h.Modello,
	h.NumeroSeriale,
	h.Locazione,
	h.DataAcquisto,
	aef.RagioneSociale AS Fornitore,
	h.Stato
FROM ASSET_HW_STORICO h
JOIN ASSET a ON h.AssetID = a.AssetID
LEFT JOIN AZIENDA_EXT aep ON h.ProduttoreId=aep.AziendaExtID
LEFT JOIN AZIENDA_EXT aef ON h.FornitoreId=aef.AziendaExtID
ORDER BY a.AssetID, h.AssetHwStoricoID;



-- 4.2.1 ID.AM-02: Elenco degli asset di tipo Software

CREATE OR REPLACE VIEW misura_sicurezza_ID_AM_02 AS
SELECT 
    a.AssetID,
    a.Nome AS "Asset Software",
    sw.Versione,
    sw.TipoLicenza AS "Tipo Licenza",
	-- Sviluppatore
    azs.RagioneSociale AS "Sviluppatore",
    sw.DataScadenzaLicenza AS "Scadenza Licenza",
    sw.Stato,
	sw.DataAcquisto,
    -- Fornitore
    azf.RagioneSociale AS "Fornitore",
    -- Responsabile Tecnico
    r.Nome AS "Ruolo Responsabile Tecnico",
    (SELECT COUNT(*) 
     FROM INCARICO inc 
     WHERE inc.RuoloID = r.RuoloID 
       AND inc.Stato = 'Attivo' 
       AND (inc.DataConclusione IS NULL OR inc.DataConclusione > CURRENT_DATE)
    ) AS Operatori_Tecnici_Attivi,
    -- Servizi Supportati (Aggregati)
    COALESCE(STRING_AGG(DISTINCT s.Nome, ', '), 'Nessun servizio attivo') AS "Servizi Supportati"
FROM ASSET a
JOIN ASSET_SW sw ON a.AssetID = sw.AssetID
-- Sviluppatore 
LEFT JOIN AZIENDA_EXT azs ON sw.SviluppatoreId = azs.AziendaExtID
-- Fornitore
LEFT JOIN AZIENDA_EXT azf ON sw.FornitoreId = azf.AziendaExtID
-- Responsabile Tecnico
JOIN RUOLO r ON a.ResponsabileTecnicoID = r.RuoloID
-- Dipendenze e Servizi (solo quelli attivi)
LEFT JOIN DIPENDENZA d ON a.AssetID = d.AssetID 
    AND (d.DataFine IS NULL OR d.DataFine > CURRENT_DATE)
LEFT JOIN SERVIZIO s ON d.ServizioID = s.ServizioID
GROUP BY 
    a.AssetID, 
    sw.Versione,
    sw.TipoLicenza,
	sw.DataAcquisto,
    sw.DataScadenzaLicenza,
    sw.Stato, 
    azs.RagioneSociale, 
    azf.RagioneSociale, 
    r.Nome,
    r.RuoloID
ORDER BY a.AssetID;


-- 4.2.1 ID.AM-02: View per estrarre storicizzazione degli asset di tipo Software

CREATE OR REPLACE VIEW v_check_storico_sw AS
SELECT 
    s.AssetID,
    s.DataModifica,
    s.TipoModifica,
    a.Nome AS Nome_Asset,
    s.Versione,
    s.TipoLicenza AS Tipo_Licenza,
    aes.RagioneSociale AS Sviluppatore,
    s.DataAcquisto,
    s.DataScadenzaLicenza AS Scadenza_Licenza,
    aef.RagioneSociale AS Fornitore,
    s.Stato
FROM ASSET_SW_STORICO s
JOIN ASSET a ON s.AssetID = a.AssetID
LEFT JOIN AZIENDA_EXT aes ON s.SviluppatoreId = aes.AziendaExtID
LEFT JOIN AZIENDA_EXT aef ON s.FornitoreId = aef.AziendaExtID
ORDER BY a.AssetID, s.AssetSwStoricoID;




-- 4.3.1 ID.AM-03: Elenco degli asset di tipo Flusso

CREATE OR REPLACE VIEW misura_sicurezza_ID_AM_03 AS
SELECT 
    a.AssetID,
    a.Nome AS "Flusso di Dati",
    fl.Protocollo,
	fl.Porta,
    fl.Sorgente,
    fl.Destinazione,
	fl.CrittografiaTrasporto,
    fl.Frequenza,
    fl.Stato,
    -- Responsabile Tecnico
    r.Nome AS "Ruolo Responsabile Tecnico",
    (SELECT COUNT(*) 
     FROM INCARICO inc 
     WHERE inc.RuoloID = r.RuoloID 
       AND inc.Stato = 'Attivo' 
       AND (inc.DataConclusione IS NULL OR inc.DataConclusione > CURRENT_DATE)
    ) AS Operatori_Tecnici_Attivi,
    -- Servizi Supportati (Aggregati)
    COALESCE(STRING_AGG(DISTINCT s.Nome, ', '), 'Nessun servizio attivo') AS "Servizi Supportati"
FROM ASSET a
JOIN ASSET_FLOW fl ON a.AssetID = fl.AssetID
-- Responsabile Tecnico
JOIN RUOLO r ON a.ResponsabileTecnicoID = r.RuoloID
-- Dipendenze e Servizi (solo quelli attivi)
LEFT JOIN DIPENDENZA d ON a.AssetID = d.AssetID 
    AND (d.DataFine IS NULL OR d.DataFine > CURRENT_DATE)
LEFT JOIN SERVIZIO s ON d.ServizioID = s.ServizioID
GROUP BY 
    a.AssetID, 
    fl.Protocollo,
	fl.Porta,
    fl.Sorgente,
    fl.Destinazione,
    fl.Frequenza,
	fl.CrittografiaTrasporto,
    fl.Stato, 
    r.Nome,
    r.RuoloID
ORDER BY a.AssetID;


-- 4.3.1 ID.AM-03: View per estrarre storicizzazione degli asset di tipo Flusso

CREATE OR REPLACE VIEW v_check_storico_flow AS
SELECT 
    f.AssetID,
    f.DataModifica,
    f.TipoModifica,
    a.Nome AS Nome_Asset,
    f.Protocollo,
    f.Sorgente,
    f.Destinazione,
    f.Frequenza,
    f.Stato
FROM ASSET_FLOW_STORICO f
JOIN ASSET a ON f.AssetID = a.AssetID
ORDER BY a.AssetID, f.AssetFlowStoricoID;



-- 4.4.1 ID.AM-04: Elenco degli asset di tipo Servizi Esterni

CREATE OR REPLACE VIEW misura_sicurezza_ID_AM_04 AS
SELECT 
    a.AssetID,
    a.Nome AS "Servizio Esterno",
    se.TipoServizio AS "Tipologia",
	se.Stato,
    se.DataInizioContratto AS "Data Inizio Contratto",
    se.DataConclusioneContratto AS "Data Conclusione Contratto",
	-- Fornitore
    azf.RagioneSociale AS "Fornitore",
	se.ContattoEmergenza AS "Contatto di Emergenza",
    -- Responsabile Tecnico Interno (Referente)
    r.Nome AS "Ruolo Responsabile Tecnico",
    (SELECT COUNT(*) 
     FROM INCARICO inc 
     WHERE inc.RuoloID = r.RuoloID 
       AND inc.Stato = 'Attivo' 
       AND (inc.DataConclusione IS NULL OR inc.DataConclusione > CURRENT_DATE)
    ) AS Operatori_Tecnici_Attivi,
    -- Servizi Supportati (Aggregati)
    COALESCE(STRING_AGG(DISTINCT s.Nome, ', '), 'Nessun servizio supportato') AS "Servizi Supportati"
FROM ASSET a
JOIN ASSET_SERVIZIO_ESTERNO se ON a.AssetID = se.AssetID
-- Fornitore
LEFT JOIN AZIENDA_EXT azf ON se.FornitoreId = azf.AziendaExtID
-- Responsabile Tecnico
JOIN RUOLO r ON a.ResponsabileTecnicoID = r.RuoloID
-- Dipendenze e Servizi (solo quelli attivi)
LEFT JOIN DIPENDENZA d ON a.AssetID = d.AssetID 
    AND (d.DataFine IS NULL OR d.DataFine > CURRENT_DATE)
LEFT JOIN SERVIZIO s ON d.ServizioID = s.ServizioID
GROUP BY 
    a.AssetID, 
    se.TipoServizio,
    se.DataInizioContratto,
    se.DataConclusioneContratto,
    se.Stato, 
	se.ContattoEmergenza,
    azf.RagioneSociale,
    r.Nome,
    r.RuoloID
ORDER BY a.AssetID;


-- 4.4 ID.AM-04: View per estrarre storicizzazione degli asset di tipo Servizi Esterni
CREATE OR REPLACE VIEW v_check_storico_servizi_esterni AS
SELECT 
    se.AssetID,
    se.DataModifica,
    se.TipoModifica,
    a.Nome AS Nome_Asset,
    se.TipoServizio AS "Tipo Servizio",
    se.DataInizioContratto AS "Data Inizio Contratto",
    se.DataConclusioneContratto AS "Data Conclusione Contratto",
	se.ContattoEmergenza AS "Contatto Emergenza",
    aef.RagioneSociale AS Fornitore,
    se.Stato
FROM ASSET_SERVIZIO_ESTERNO_STORICO se
JOIN ASSET a ON se.AssetID = a.AssetID
LEFT JOIN AZIENDA_EXT aef ON se.FornitoreId = aef.AziendaExtID
ORDER BY a.AssetID, se.AssetServizioEsternoStoricoID;


