/*******************************************************************************
 * Project Work: Governance degli asset, dei servizi informatici e profili di 
 * responsabilità - Base di dati relazionale per l'adempimento degli obblighi 
 * delle direttive ACN in ambito NIS2
 * FILE: 07_generazione_report_CSV.sql
 * DESCRIZIONE: Script per generazione report file CSV conformi alle 
 * misure di sicurezza
 * ORDINE ESECUZIONE: 7 
 *******************************************************************************/

/* CONSIGLI IN CASO DI ERRORE DI PERMESSI (Access Denied) DURANTE GENERAZIONE CSV:
   -------------------------------------------------------
   Se il comando COPY fallisce, è perché l'utente di sistema 
   non ha i permessi di scrittura sulla cartella 'C:\Users\Public',
   nonostante questa solitamrnte ha permessi aperti di default.
   
   SOLUZIONE 1 (Rapida): 
   Inserire la destinazione del file ad una cartella di cui si hanno i permessi.
   
   SOLUZIONE 2 (Configurazione):
   Tasto destro sulla cartella di destinazione -> Proprietà -> Sicurezza -> Modifica -> 
   Aggiungi l'utente 'postgres' (o 'Everyone') e dai il controllo completo.     
*/

------------------------------------------------------------------------
-- 1. Misura di sicurezza GV.OC-04 - Elenco aggiornato dei sistemi 
--    informativi e di rete rilevanti. 
------------------------------------------------------------------------

-- 1.1 view misura_sicurezza_GV_OC_04_view01

COPY (SELECT * FROM misura_sicurezza_GV_OC_04_view01) 
TO 'C:\Users\Public\report_misura_sicurezza_GV_OC_04_view01.csv' WITH CSV HEADER;
--In caso di errore, modificare il percorso 'C:\Users\Public\' con uno accessibile


-- 1.2 view misura_sicurezza_GV_OC_04_view02

COPY (SELECT * FROM misura_sicurezza_GV_OC_04_view02) 
TO 'C:\Users\Public\report_misura_sicurezza_GV_OC_04_view02.csv' WITH CSV HEADER;
--In caso di errore, modificare il percorso 'C:\Users\Public\' con uno accessibile


-- 1.3 view misura_sicurezza_GV_OC_04_view03

COPY (SELECT * FROM misura_sicurezza_GV_OC_04_view03) 
TO 'C:\Users\Public\report_misura_sicurezza_GV_OC_04_storico_modifiche.csv' WITH CSV HEADER;
--In caso di errore, modificare il percorso 'C:\Users\Public\' con uno accessibile


------------------------------------------------------------------------
-- 2. Misura di sicurezza GV.RR-02 - Elenco aggiornato del personale 
--    dell'organizzazione avente specifici ruoli e responsabilità. 
------------------------------------------------------------------------

-- 2.1 misura_sicurezza_GV_RR_02

COPY (SELECT * FROM misura_sicurezza_GV_RR_02) 
TO 'C:\Users\Public\misura_sicurezza_GV_RR_02.csv' WITH CSV HEADER;
--In caso di errore, modificare il percorso 'C:\Users\Public\' con uno accessibile


-- 2.2 misura_sicurezza_GV_RR_02_storico_incarichi

COPY (SELECT * FROM misura_sicurezza_GV_RR_02_storico_incarichi) 
TO 'C:\Users\Public\misura_sicurezza_GV_RR_02_storico_incarichi.csv' WITH CSV HEADER;
--In caso di errore, modificare il percorso 'C:\Users\Public\' con uno accessibile


------------------------------------------------------------------------
-- 3. GV.SC-04: Elenco dei fornitori prioritizzati in base alla criticità; 
------------------------------------------------------------------------

COPY (SELECT * FROM misura_sicurezza_GV_SC_04) 
TO 'C:\Users\Public\misura_sicurezza_GV_SC_04.csv' WITH CSV HEADER;
--In caso di errore, modificare il percorso 'C:\Users\Public\' con uno accessibile


------------------------------------------------------------------------
-- 4 ID.AM: Inventario degli asset e sue specializzazioni.
------------------------------------------------------------------------

-- 4.1.1 ID.AM-01: Elenco degli asset di tipo Hardware
COPY (SELECT * FROM misura_sicurezza_ID_AM_01) 
TO 'C:\Users\Public\misura_sicurezza_ID_AM_01.csv' WITH CSV HEADER;
--In caso di errore, modificare il percorso 'C:\Users\Public\' con uno accessibile

-- 4.1.2 ID.AM-01: Elenco degli asset di tipo Hardware con storico modifiche 
COPY (SELECT * FROM v_check_storico_hw) 
TO 'C:\Users\Public\misura_sicurezza_ID_AM_01_storico_modifiche.csv' WITH CSV HEADER;
--In caso di errore, modificare il percorso 'C:\Users\Public\' con uno accessibile



-- 4.2.1 ID.AM-02: Elenco degli asset di tipo Software
COPY (SELECT * FROM misura_sicurezza_ID_AM_02) 
TO 'C:\Users\Public\misura_sicurezza_ID_AM_02.csv' WITH CSV HEADER;
--In caso di errore, modificare il percorso 'C:\Users\Public\' con uno accessibile

-- 4.2.2 ID.AM-02: Elenco degli asset di tipo Software con storico modifiche 
COPY (SELECT * FROM v_check_storico_sw) 
TO 'C:\Users\Public\misura_sicurezza_ID_AM_02_storico_modifiche.csv' WITH CSV HEADER;
--In caso di errore, modificare il percorso 'C:\Users\Public\' con uno accessibile



-- 4.3.1 ID.AM-03: Elenco degli asset di tipo Flusso
COPY (SELECT * FROM misura_sicurezza_ID_AM_03) 
TO 'C:\Users\Public\misura_sicurezza_ID_AM_03.csv' WITH CSV HEADER;
--In caso di errore, modificare il percorso 'C:\Users\Public\' con uno accessibile

-- 4.3.2 ID.AM-03: Elenco degli asset di tipo Flusso con storico modifiche 
COPY (SELECT * FROM v_check_storico_flow) 
TO 'C:\Users\Public\misura_sicurezza_ID_AM_03_storico_modifiche.csv' WITH CSV HEADER;
--In caso di errore, modificare il percorso 'C:\Users\Public\' con uno accessibile



-- 4.4.1 ID.AM-04: Elenco degli asset di tipo Servizi Esterni
COPY (SELECT * FROM misura_sicurezza_ID_AM_04) 
TO 'C:\Users\Public\misura_sicurezza_ID_AM_04.csv' WITH CSV HEADER;
--In caso di errore, modificare il percorso 'C:\Users\Public\' con uno accessibile

-- 4.4.2 ID.AM-02: Elenco degli asset di tipo Servizi Esterni con storico modifiche 
COPY (SELECT * FROM v_check_storico_servizi_esterni) 
TO 'C:\Users\Public\misura_sicurezza_ID_AM_04_storico_modifiche.csv' WITH CSV HEADER;
--In caso di errore, modificare il percorso 'C:\Users\Public\' con uno accessibile


