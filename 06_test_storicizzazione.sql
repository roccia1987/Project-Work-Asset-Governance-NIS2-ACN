/*******************************************************************************
 * Project Work: Governance degli asset, dei servizi informatici e profili di 
 * responsabilità - Base di dati relazionale per l'adempimento degli obblighi 
 * delle direttive ACN in ambito NIS2 
 * FILE: 06_test_storicizzazione.sql
 * DESCRIZIONE: Operazioni di aggiornamento e verifica trigger e funzioni 
 * di storicizzazione attraverso generazione file CSV
 * ORDINE ESECUZIONE: 6
 *******************************************************************************/


/* CONSIGLI IN CASO DI ERRORE DI PERMESSI (Access Denied) DURANTE GENERAZIONE CSV:
   -------------------------------------------------------
   Se il comando COPY fallisce, è perché l'utente di sistema 
   non ha i permessi di scrittura sulla cartella 'C:\Users\Public',
   nonostante questa solitamente ha permessi aperti di default.
   
   SOLUZIONE 1 (Rapida): 
   Inserire la destinazione del file ad una cartella di cui si hanno i permessi.
   
   SOLUZIONE 2 (Configurazione):
   Tasto destro sulla cartella di destinazione -> Proprietà -> Sicurezza -> Modifica -> 
   Aggiungi l'utente 'postgres' (o 'Everyone') e dai il controllo completo.     
*/

--------------------------------------------------------------------------------
-- 1. GENERAZIONE CSV TABELLE DI STORICIZZAZIONE PRIMA DELLE MODIFICHE
--------------------------------------------------------------------------------

COPY (SELECT * FROM v_check_storico_hw) 
TO 'C:\Users\Public\v_check_storico_asset_hw_01_pre_modifiche.csv' WITH CSV HEADER; 
--In caso di errore, modificare il percorso 'C:\Users\Public\' con uno accessibile

COPY (SELECT * FROM v_check_storico_sw) 
TO 'C:\Users\Public\v_check_storico_asset_sw_01_pre_modifiche.csv' WITH CSV HEADER;
--In caso di errore, modificare il percorso 'C:\Users\Public\' con uno accessibile

COPY (SELECT * FROM v_check_storico_flow) 
TO 'C:\Users\Public\v_check_storico_asset_flow_01_pre_modifiche.csv' WITH CSV HEADER;
--In caso di errore, modificare il percorso 'C:\Users\Public\' con uno accessibile

COPY (SELECT * FROM v_check_storico_servizi_esterni) 
TO 'C:\Users\Public\v_check_storico_asset_servizi_esterni_01_pre_modifiche.csv' WITH CSV HEADER;
--In caso di errore, modificare il percorso 'C:\Users\Public\' con uno accessibile

COPY (SELECT * FROM misura_sicurezza_GV_OC_04_view03) 
TO 'C:\Users\Public\v_check_storico_servizi_01_pre_modifiche.csv' WITH CSV HEADER;
--In caso di errore, modificare il percorso 'C:\Users\Public\' con uno accessibile


--------------------------------------------------------------------------------
-- 2. MODIFICA RESPONSABILE DI GESTIONE SU 2 SERVIZI
--------------------------------------------------------------------------------

-- Spostiamo il SERVIZIO (ID 1) sotto la gestione del RUOLO (ID 3) 
UPDATE SERVIZIO 
SET ResponsabileGestioneID = 3 
WHERE ServizioID = 1;

-- Spostiamo il SERVIZIO (ID 8) sotto la gestione del RUOLO (ID 2) 
UPDATE SERVIZIO 
SET ResponsabileGestioneID = 2 
WHERE ServizioID = 8;



--------------------------------------------------------------------------------
-- 3. MODIFICA STATO SU DIVERISI ASSET 
--------------------------------------------------------------------------------

-- A. Riportiamo il Server ERP in stato 'Attivo' (era in manutenzione)
UPDATE ASSET_HW 
SET Stato = 'Attivo' 
WHERE AssetID = (SELECT AssetID FROM ASSET WHERE Nome = 'Server-ERP-01');

-- B. Mettiamo il Firewall Perimetrale in 'In manutenzione' (era Attivo)
UPDATE ASSET_HW 
SET Stato = 'In manutenzione' 
WHERE AssetID = (SELECT AssetID FROM ASSET WHERE Nome = 'Firewall-PER-01');

-- C. Riportiamo il Database Oracle in 'Attivo' (era in manutenzione)
UPDATE ASSET_SW 
SET Stato = 'Attivo' 
WHERE AssetID = (SELECT AssetID FROM ASSET WHERE Nome = 'Oracle Database 19c');

-- D. Mettiamo il flusso HTTPS in 'In manutenzione' per test
UPDATE ASSET_FLOW 
SET Stato = 'In manutenzione' 
WHERE AssetID = (SELECT AssetID FROM ASSET WHERE Nome = 'FLOW-HTTPS-EXT');

-- E.1 Mettiamo servizio 'Servizio PEC Istituzionale' momentaneamente 'In manutenzione' per test
UPDATE ASSET_SERVIZIO_ESTERNO
SET Stato = 'In manutenzione' 
WHERE AssetID = (SELECT AssetID FROM ASSET WHERE Nome = 'Servizio PEC Istituzionale');

-- E.2 Ora lo riportiamo in stato 'Attivo'
UPDATE ASSET_SERVIZIO_ESTERNO
SET Stato = 'Attivo' 
WHERE AssetID = (SELECT AssetID FROM ASSET WHERE Nome = 'Servizio PEC Istituzionale');


--------------------------------------------------------------------------------
-- 4. GENERAZIONE CSV TABELLE DI STORICIZZAZIONE SUCCESSIVE ALLE MODIFICHE
--------------------------------------------------------------------------------

COPY (SELECT * FROM v_check_storico_hw) 
TO 'C:\Users\Public\v_check_storico_asset_hw_02_post_modifiche.csv' WITH CSV HEADER;
--In caso di errore, modificare il percorso 'C:\Users\Public\' con uno accessibile

COPY (SELECT * FROM v_check_storico_sw) 
TO 'C:\Users\Public\v_check_storico_asset_sw_02_post_modifiche.csv' WITH CSV HEADER;
--In caso di errore, modificare il percorso 'C:\Users\Public\' con uno accessibile

COPY (SELECT * FROM v_check_storico_flow) 
TO 'C:\Users\Public\v_check_storico_asset_flow_02_post_modifiche.csv' WITH CSV HEADER;
--In caso di errore, modificare il percorso 'C:\Users\Public\' con uno accessibile

COPY (SELECT * FROM v_check_storico_servizi_esterni) 
TO 'C:\Users\Public\v_check_storico_asset_servizi_esterni_02_post_modifiche.csv' WITH CSV HEADER;
--In caso di errore, modificare il percorso 'C:\Users\Public\' con uno accessibile

COPY (SELECT * FROM misura_sicurezza_GV_OC_04_view03) 
TO 'C:\Users\Public\v_check_storico_servizi_02_post_modifiche.csv' WITH CSV HEADER;
--In caso di errore, modificare il percorso 'C:\Users\Public\' con uno accessibile

