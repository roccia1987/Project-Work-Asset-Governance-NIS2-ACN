/*******************************************************************************
 * Project Work: Governance degli asset, dei servizi informatici e profili di 
 * responsabilità - Base di dati relazionale per l'adempimento degli obblighi 
 * delle direttive ACN in ambito NIS2 
 * FILE: 04_popolamento.sql
 * DESCRIZIONE: Inserimento dei dati di test per validare la struttura.
 * Include anagrafiche, servizi e asset tramite stored procedure.
 * ORDINE ESECUZIONE: 4
 *******************************************************************************/

---------------------------------------------------------------------------------
-- 1. POPOLAMENTO ANAGRAFICHE BASE
---------------------------------------------------------------------------------

-- 1.1 Inserimento IMPIEGATO
INSERT INTO IMPIEGATO (Matricola, Nome, Cognome, ContattoEmail, ContattoTelefonico, DataAssunzione, DataFineRapporto)
VALUES 
('MAT-001', 'Mario', 'Rossi', 'mario.rossi@azienda.it', '+39 02 1234567', '2015-01-15', NULL),
('MAT-002', 'Laura', 'Bianchi', 'laura.bianchi@azienda.it', '+39 02 1234568', '2016-03-20', NULL),
('MAT-003', 'Alessandro', 'Verdi', 'a.verdi@azienda.it', '+39 06 9876543', '2018-06-01', NULL),
('MAT-004', 'Elena', 'Neri', 'e.neri@azienda.it', '+39 340 1122334', '2019-11-10', NULL),
('MAT-005', 'Roberto', 'Gallo', 'r.gallo@azienda.it', '+39 02 5556667', '2020-02-15', NULL),
('MAT-006', 'Sofia', 'Russo', 'sofia.russo@azienda.it', '+39 333 4455667', '2021-05-22', NULL),
('MAT-007', 'Valerio', 'Fontana', 'v.fontana@azienda.it', '+39 081 2233445', '2021-09-01', NULL),
('MAT-008', 'Chiara', 'Moretti', 'c.moretti@azienda.it', '+39 347 8899001', '2022-01-10', NULL),
('MAT-009', 'Francesco', 'Rizzo', 'f.rizzo@azienda.it', '+39 02 4433221', '2023-04-12', NULL),
('MAT-010', 'Giulia', 'Ferrari', 'g.ferrari@azienda.it', '+39 320 9988776', '2024-01-05', NULL),
('MAT-011', 'Marco', 'Esposito', 'm.esposito@azienda.it', '+39 081 5566778', '2024-03-15', NULL),
('MAT-012', 'Silvia', 'Romano', 's.romano@azienda.it', '+39 335 1234567', '2024-06-01', NULL),
('MAT-013', 'Luca', 'Colombo', 'l.colombo@azienda.it', '+39 02 7788990', '2024-09-20', NULL),
('MAT-014', 'Beatrice', 'Ricci', 'b.ricci@azienda.it', '+39 349 0011223', '2025-01-10', NULL),
('MAT-015', 'Paolo', 'Bruno', 'p.bruno@azienda.it', '+39 011 4433556', '2025-02-01', NULL);
SELECT * FROM IMPIEGATO;

-- 1.2 Inserimento RUOLO
INSERT INTO RUOLO (Nome, Descrizione, Tipologia)
VALUES 
-- Ruoli di GESTIONE
('Addetto Dipartimento Agricoltura', 'Regolamentazione in materia di risorse agricole, gestione ed erogazione fondi.', 'Gestione'),
('addetto Dipartimento Urbanistica', 'Regolamentaizone e pianificazione territoriale per permessi edilizi.', 'Gestione'),
('Addetto Dipartimento Affari Generali', 'Gestione amministrativa e risorse umane dell''ente.', 'Gestione'),
('Addetto Dipartimento Bilancio e Finanza', 'Gestione della contabilità e dei flussi finanziari.', 'Gestione'),
('Addetto Dipartimento Formazione, Lavoro e Politiche Sociali', 'Regolamentazione in materia di Formazione, Lavoro e Politiche Sociali; gestone ed erogaizone fondi.', 'Gestione'),

-- Ruoli TECNICI (Inclusa Sicurezza NIS 2)
('Sistemista Senior', 'Gestione server, virtualizzazione e infrastruttura cloud.', 'Tecnico'),
('Amministratore di Rete', 'Configurazione e manutenzione apparati di rete e firewall.', 'Tecnico'),
('Addetto Presidio Informatico', 'Supporto tecnico di primo livello e manutenzione postazioni lavoro.', 'Tecnico'),
('Database Administrator', 'Gestione, ottimizzazione e backup dei database aziendali.', 'Tecnico'),
('Sviluppatore Full Stack', 'Manutenzione e sviluppo applicativi interni all''ente.', 'Tecnico'),
('CISO (Chief Information Security Officer)', 'Responsabile della strategia globale di sicurezza informatica.', 'Tecnico'),
('Punto di Contatto NIS', 'Interfaccia ufficiale verso l''Autorità competente NIS per la sicurezza delle reti.', 'Tecnico'),
('Sostituto Punto di Contatto NIS', 'Vicario del referente NIS in caso di assenza o impedimento.', 'Tecnico'),
('Referente CSIRT', 'Responsabile della comunicazione tecnica e operativa con il CSIRT nazionale.', 'Tecnico'),
('Sostituto Referente CSIRT', 'Supporto tecnico operativo per la gestione incidenti e contatti CSIRT.', 'Tecnico');
SELECT * FROM RUOLO;

-- 1.3 Inserimento AZIENDA_EXT
INSERT INTO AZIENDA_EXT (RagioneSociale, PartitaIva, CodiceFiscale, Nazione, Citta, Indirizzo, Telefono, Email, Pec)
VALUES 
-- PRODUTTORI HARDWARE (Vendor)
('Dell Technologies Italia', '08967530155', NULL, 'Italia', 'Milano', 'Via Giovanni Spadolini 7', '02 57761', 'info@dell.it', 'dellitalia@pec.it'),
('Cisco Systems Italy', '11483960150', NULL, 'Italia', 'Vimercate', 'Via Torri Bianche 8', '039 62911', 'contatti@cisco.it', 'ciscoitaly@legalmail.it'),
('Fortinet Italy srl', '08123450961', NULL, 'Italia', 'Roma', 'Via del Tintoretto 200', '06 5941', 'sales@fortinet.it', 'fortinet@cert.it'),

-- SVILUPPATORI SOFTWARE (Vendor)
('Microsoft Italia srl', '08106750154', NULL, 'Italia', 'Milano', 'Viale Pasubio 21', '02 70311', 'licenze@microsoft.it', 'microsoft@legalmail.it'),
('Oracle Italia srl', '04618380156', NULL, 'Italia', 'Roma', 'Via Cristoforo Colombo 112', '06 51021', 'db_admin@oracle.it', 'oracle_italia@pec.it'),
('SAP Italia SpA', '08246440158', NULL, 'Italia', 'Vimercate', 'Via Energy Park 14', '039 68791', 'support_sap@sap.com', 'sap_italia@pec.it'),

-- EROGATORI SERVIZI ESTERNI
('Amazon Web Services (AWS) Italy', '08643210960', NULL, 'Italia', 'Milano', 'Via della Liberazione 18', '02 123456', 'aws-ita@amazon.com', 'aws_italy@pec.it'),
('Aruba Enterprise', '01573850516', '01573850516', 'Italia', 'Bergamo', 'Via San Clemente 53', '0575 0505', 'cloud@aruba.it', 'aruba@pec.aruba.it'),
('CyberSecurity Shield srl', '09988770665', '09988770665', 'Italia', 'Torino', 'Corso Francia 12', '011 445566', 'soc@cybershield.it', 'cybershield@legalmail.it'),

-- FORNITORI 
('Infrastrutture Digitali SpA', '06655440100', '06655440100', 'Italia', 'Roma', 'Via dell''Informatica 45', '06 998877', 'business@infra-digitali.it', 'infrastrutture_digitali@pec.it'),
('System Integration Italia srl', '02233440150', '02233440150', 'Italia', 'Milano', 'Via Valtellina 5', '02 887766', 'progetti@sysinteg.it', 'sysinteg@pec.it'),
('Digital Hub srl', '04455660280', '04455660280', 'Italia', 'Padova', 'Via Venezia 40', '049 112233', 'commerciale@digitalhub.it', 'digitalhub@legalmail.it'),
('Global Support Services', '07766550121', NULL, 'UK', 'London', '221B Baker Street', '+44 20 7946', 'support@globalservices.com', 'global_support@pec.it'),
('TecnoInfrastrutture srl', '03344220810', '03344220810', 'Italia', 'Napoli', 'Centro Direzionale Is. G1', '081 778899', 'tech@tecnoinfra.it', 'tecnoinfra@cert.it'),
('Security & Compliance Partners', '05544330101', '05544330101', 'Italia', 'Genova', 'Via Gramsci 10', '010 223344', 'compliance@secpartners.it', 'secpartners@legalmail.it');

---------------------------------------------------------------------------------
-- 2. ASSEGNAZIONE INCARICHI (Impiegato <-> Ruolo)
---------------------------------------------------------------------------------
-- Gestione: 1-5 | Tecnici: 6-15

INSERT INTO INCARICO (RuoloID, Matricola, DataAssegnazione, DataConclusione, Stato)
VALUES 
-- Dipendente MAT-001 
(1, 'MAT-001', '2015-01-15', '2020-12-31', 'Cessato'),
(11, 'MAT-001', '2021-01-01', NULL, 'Attivo'),

-- Dipendente MAT-002 
(2, 'MAT-002', '2016-03-20', '2022-05-15', 'Cessato'),
(7, 'MAT-002', '2022-05-16', NULL, 'Attivo'),

-- Dipendente MAT-003 
(14, 'MAT-003', '2018-06-01', NULL, 'Attivo'),

-- Dipendente MAT-004 
(3, 'MAT-004', '2019-11-10', NULL, 'Attivo'), 
(8, 'MAT-004', '2020-01-01', NULL, 'Attivo'),

-- Dipendente MAT-005 
(4, 'MAT-005', '2020-02-15', '2021-12-31', 'Cessato'),
(6, 'MAT-005', '2022-01-01', NULL, 'Attivo'),

-- Dipendente MAT-006 
(12, 'MAT-006', '2021-05-22', NULL, 'Attivo'),

-- Dipendente MAT-007 
(9, 'MAT-007', '2021-09-01', NULL, 'Attivo'),
(10, 'MAT-007', '2022-01-01', NULL, 'Attivo'),

-- Dipendente MAT-008
(15, 'MAT-008', '2022-01-10', NULL, 'Attivo'),

-- Dipendente MAT-009
(4, 'MAT-009', '2023-04-12', NULL, 'Attivo'),
(10, 'MAT-009', '2023-06-01', NULL, 'Attivo'),

-- Dipendente MAT-010 
(13, 'MAT-010', '2024-01-05', NULL, 'Attivo'),

-- Dipendente MAT-011
(6, 'MAT-011', '2024-03-15', NULL, 'Attivo'),

-- Dipendente MAT-012 
(2, 'MAT-012', '2024-06-01', NULL, 'Attivo'),
(8, 'MAT-012', '2024-07-01', NULL, 'Attivo'),

-- Dipendente MAT-013 
(3, 'MAT-013', '2024-09-20', NULL, 'Attivo'),

-- Dipendente MAT-014 
(10, 'MAT-014', '2025-01-10', NULL, 'Attivo'),

-- Dipendente MAT-015 
(9, 'MAT-015', '2025-02-01', NULL, 'Attivo'),

-- Incarichi aggiuntivi 
(5, 'MAT-001', '2016-01-01', '2018-01-01', 'Cessato'), 
(5, 'MAT-004', '2019-01-01', '2020-01-01', 'Cessato'), 
(1, 'MAT-011', '2024-04-01', NULL, 'Attivo'),         
(7, 'MAT-015', '2025-02-15', NULL, 'Attivo'),         
(8, 'MAT-009', '2023-05-01', '2024-01-01', 'Cessato'), 
(11, 'MAT-002', '2022-06-01', '2023-06-01', 'Cessato'), 
(6, 'MAT-013', '2024-10-01', NULL, 'Attivo'),         
(4, 'MAT-007', '2021-10-01', '2022-10-01', 'Cessato'); 

---------------------------------------------------------------------------------
-- 3. INSERIMENTO SERVIZI BUSINESS
---------------------------------------------------------------------------------
-- 3 Inserimento SERVIZIO 
INSERT INTO SERVIZIO (Nome, Descrizione, Tipologia, LivelloCriticita, ResponsabileGestioneID)
VALUES 
-- SERVIZI ESTERNI 
('Portale del Cittadino', 'Piattaforma per l''erogazione di servizi online e istanze telematiche.', 'Esterno', 'Alto', 2),
('Gestione Pagamenti (pagoPA)', 'Nodo dei pagamenti elettronici verso la Pubblica Amministrazione.', 'Esterno', 'Alto', 4),
('Sportello Unico Attività Produttive (SUAP)', 'Portale per la presentazione di pratiche da parte delle imprese.', 'Esterno', 'Alto', 2),
('Portale Trasparenza', 'Pubblicazione atti e dati in ottica di Open Data e trasparenza amministrativa.', 'Esterno', 'Medio', 3),
('App di Notifica Servizi Pubblici', 'Sistema di messaggistica per scadenze e avvisi alla cittadinanza.', 'Esterno', 'Basso', 3),

-- SERVIZI INTERNI 
('Protocollo Informatico', 'Gestione della segnatura e archiviazione dei documenti ufficiali dell''ente.', 'Interno', 'Alto', 3),
('Sistema ERP Risorse Umane', 'Gestione delle carriere, cedolini e presenze del personale.', 'Interno', 'Medio', 3),
('Sistema Gestione Biblioteche', 'Catalogo e prestiti per le biblioteche comunali/regionali.', 'Interno', 'Basso', 5),

-- SERVIZI DI SUPPORTO 
('Piattaforma E-Learning', 'Erogazione corsi di formazione obbligatoria e professionale per i dipendenti.', 'Supporto', 'Medio', 5),
('Monitoraggio Risorse Agricole', 'Sistema di analisi e controllo dei fondi erogati nel settore agricolo.', 'Supporto', 'Alto', 1);

---------------------------------------------------------------------------------
-- 4. INSERIMENTO ASSET TRAMITE STORED PROCEDURE
---------------------------------------------------------------------------------
-- 4.1 Inserimento ASSET_HW 
-- I parametri seguono l'ordine definito nella procedura: 
-- a) ASSET: p_nome, p_descrizione, p_criticita, p_responsabile_id
-- b) ASSET_HW: p_codice_inventario, p_produttore_id, p_modello, p_numero_seriale, 
--              p_locazione, p_data_acquisto, p_fornitore_id, p_stato

-- 4.1.1 Server Core Protocollo
CALL p_inserisci_nuovo_asset_hw(
    'Server-PRT-01', 'Server fisico per Database Protocollo Informatico', 'Alto', 9, 
    'INV/2026/HW001', 1, 'Dell PowerEdge R750', 'SN-DELL-9901', 'Data Center - Rack A1', '2025-01-15', 10, 'Attivo'
);

-- 4.1.2 Server Web Portale Cittadino
CALL p_inserisci_nuovo_asset_hw(
    'Server-WEB-01', 'Host virtualizzazione per Portale Cittadino e SUAP', 'Alto', 6, 
    'INV/2026/HW002', 1, 'Dell PowerEdge R650', 'SN-DELL-9902', 'Data Center - Rack A1', '2025-01-15', 10, 'Attivo'
);

-- 4.1.3 Firewall Perimetrale
CALL p_inserisci_nuovo_asset_hw(
    'Firewall-PER-01', 'Firewall perimetrale principale ente', 'Alto', 7, 
    'INV/2026/HW003', 3, 'FortiGate 200F', 'SN-FORT-1122', 'Data Center - Rack B1', '2024-11-20', 11, 'Attivo'
);

-- 4.1.4 Storage SAN Backup
CALL p_inserisci_nuovo_asset_hw(
    'Storage-BKP-01', 'Storage dedicato ai backup di sistema', 'Alto', 6, 
    'INV/2026/HW004', 1, 'Dell PowerStore 500T', 'SN-DELL-8844', 'Data Center - Rack C2', '2025-01-20', 10, 'Attivo'
);

-- 4.1.5 Switch Core Centro Direzionale
CALL p_inserisci_nuovo_asset_hw(
    'Switch-CORE-01', 'Switch di centro stella della rete ente', 'Alto', 7, 
    'INV/2026/HW005', 2, 'Cisco Catalyst 9500', 'SN-CISC-5566', 'Data Center - Rack B1', '2024-05-10', 11, 'Attivo'
);

-- 4.1.6 Server ERP Risorse Umane 
CALL p_inserisci_nuovo_asset_hw(
    'Server-ERP-01', 'Server dedicato applicativo Risorse Umane - In aggiornamento RAM', 'Medio', 6, 
    'INV/2026/HW006', 1, 'Dell PowerEdge R450', 'SN-DELL-3322', 'Data Center - Rack A2', '2023-10-12', 14, 'In manutenzione'
);

-- 4.1.7 Firewall Interno
CALL p_inserisci_nuovo_asset_hw(
    'Firewall-INT-01', 'Firewall per segregazione reti interne e uffici', 'Alto', 11, 
    'INV/2026/HW007', 3, 'FortiGate 100F', 'SN-FORT-3344', 'Data Center - Rack B2', '2024-12-01', 11, 'Attivo'
);

-- 4.1.8 Server E-Learning
CALL p_inserisci_nuovo_asset_hw(
    'Server-EDU-01', 'Server per piattaforma Moodle e formazione', 'Medio', 6, 
    'INV/2026/HW008', 1, 'Dell PowerEdge T350', 'SN-DELL-1100', 'Sede Distaccata - Sala Tecnica', '2023-02-15', 14, 'Attivo'
);

-- 4.1.9 Bilanciatore di Carico Portale
CALL p_inserisci_nuovo_asset_hw(
    'Load-Balancer-01', 'Bilanciatore di carico per servizi esterni', 'Alto', 7, 
    'INV/2026/HW009', 2, 'Cisco Catalyst 9000-X', 'SN-CISC-0099', 'Data Center - Rack B1', '2025-01-10', 11, 'Attivo'
);

-- 4.1.10 Router Sede Periferica
CALL p_inserisci_nuovo_asset_hw(
    'Router-SEDE-02', 'Router connettività sede distaccata Agricoltura', 'Medio', 7, 
    'INV/2026/HW010', 2, 'Cisco ISR 4331', 'SN-CISC-7788', 'Sede Distaccata - Rack 01', '2024-06-20', 11, 'Attivo'
);

---------------------------------------------------------------------------------
-- 4.2 Inserimento ASSET_SW 
-- Parametri: 
-- a) ASSET: p_nome, p_descrizione, p_criticita, p_responsabile_id
-- b) ASSET_SW: p_versione, p_sviluppatore_id, p_tipo_licenza, 
--              p_scadenza_licenza, p_data_acquisto, p_fornitore_id, p_stato

-- 4.2.1 Sistema Operativo Server Protocollo
CALL p_inserisci_nuovo_asset_sw(
    'Windows Server 2022 - PRT', 'OS per Server Protocollo Informatico', 'Alto', 6, 
    'v21H2', 4, 'Volume Licensing', '2027-12-31', '2025-01-15', 10, 'Attivo'
);

-- 4.2.2 Database Server Protocollo
CALL p_inserisci_nuovo_asset_sw(
    'SQL Server 2022 Standard', 'DBMS per base dati Protocollo', 'Alto', 9, 
    'v16.0', 4, 'Per Core', '2028-06-30', '2025-01-16', 10, 'Attivo'
);

-- 4.2.3 Suite Oracle Database 
CALL p_inserisci_nuovo_asset_sw(
    'Oracle Database 19c', 'DBMS per Portale Cittadino - Patching in corso', 'Alto', 9, 
    '19.3', 5, 'Enterprise Edition', NULL, '2024-12-01', 5, 'In manutenzione'
);

-- 4.2.4 Applicativo Protocollo "Iride"
CALL p_inserisci_nuovo_asset_sw(
    'Iride Workflow', 'Software gestione documentale e flussi', 'Alto', 10, 
    'v7.5', 11, 'SaaS/Subscription', '2026-12-31', '2025-01-20', 11, 'Attivo'
);

-- 4.2.5 Firmware Firewall Perimetrale
CALL p_inserisci_nuovo_asset_sw(
    'FortiOS Firewall', 'Sistema operativo e security engine Firewall', 'Alto', 11, 
    'v7.4', 3, 'Proprietaria', '2025-12-31', '2024-11-20', 11, 'Attivo'
);

-- 4.2.6 SAP ERP Modulo HR
CALL p_inserisci_nuovo_asset_sw(
    'SAP S/4HANA HR', 'Modulo gestione Risorse Umane', 'Medio', 10, 
    '2023 FPS02', 6, 'User Based', NULL, '2023-10-10', 6, 'Attivo'
);

-- 4.2.7 Piattaforma Moodle
CALL p_inserisci_nuovo_asset_sw(
    'Moodle LMS', 'Piattaforma e-learning ente', 'Medio', 10, 
    'v4.3', 11, 'Open Source (GPL)', NULL, '2023-02-15', 15, 'Attivo'
);

-- 4.2.8 Sistema Backup Veeam
CALL p_inserisci_nuovo_asset_sw(
    'Veeam Availability Suite', 'Software per gestione backup e replica', 'Alto', 6, 
    'v12.1', 11, 'Universal License', '2027-01-15', '2025-01-20', 11, 'Attivo'
);

-- 4.2.9 Modulo Pagamenti pagoPA
CALL p_inserisci_nuovo_asset_sw(
    'Gateway pagoPA Connector', 'Middleware per integrazione pagamenti', 'Alto', 10, 
    'v3.2', 11, 'Canone Annuo', '2026-06-30', '2024-06-01', 11, 'Attivo'
);

-- 4.2.10 OS Linux Server Web
CALL p_inserisci_nuovo_asset_sw(
    'Red Hat Enterprise Linux 9', 'OS per nodi Web Portale Cittadino', 'Alto', 6, 
    '9.3', 11, 'Subscription', '2026-01-15', '2025-01-15', 10, 'Attivo'
);

-- 4.2.11 Certificato SSL Portale Cittadino (Wildcard)
CALL p_inserisci_nuovo_asset_sw(
    'Certificato SSL - *.ente.it', 'Certificato SSL Wildcard per servizi esterni', 'Alto', 7, -- Amm. Rete
    'TLS 1.3', 15, 'Certificato Digitale', '2027-01-27', '2026-01-27', 15, 'Attivo'
);

-- 4.2.12 Certificato SSL VPN Aziendale
CALL p_inserisci_nuovo_asset_sw(
    'Certificato SSL - VPN Gate', 'Certificato per accesso remoto sicuro', 'Alto', 11, -- CISO
    'SHA-256', 15, 'Certificato Digitale', '2026-07-27', '2025-07-27', 15, 'Attivo'
);

-- 4.2.13 Macchina virtuale
CALL p_inserisci_nuovo_asset_sw(
    'VM-PROTOCOLLO-01', 'Macchina Virtuale dedicata al servizio Protocollo', 'Alto', 6, 
    'vSphere 7.0 Guest', 11, 'Virtual Machine', NULL, '2025-01-15', 10, 'Attivo'
);

-- 4.2.14 Macchina virtuale Web
CALL p_inserisci_nuovo_asset_sw(
    'VM-WEB-PORTALE-01', 'Macchina Virtuale Web Server per Portale Cittadino', 'Alto', 6, 
    'vSphere 7.0 Guest', 11, 'Virtual Machine', NULL, '2025-01-15', 10, 'Attivo'
);

-- 4.2.15 Macchina virtuale server 
CALL p_inserisci_nuovo_asset_sw(
    'VM-PAGAMENTI-01', 'Macchina Virtuale Gateway Pagamenti', 'Alto', 6, 
    'vSphere 7.0 Guest', 11, 'Virtual Machine', NULL, '2024-06-01', 11, 'Attivo'
);

---------------------------------------------------------------------------------
-- 4.3 Inserimento ASSET_FLOW 
-- Parametri: 
-- a) ASSET: p_nome, p_descrizione, p_criticita, p_responsabile_id
-- b) ASSET_FLOW: p_sorgente, p_destinazione, p_protocollo, p_porta, 
--                p_direzione, p_crittografia, p_frequenza, p_stato

-- 4.3.1 Traffico HTTPS Utenti Esterni 
CALL p_inserisci_nuovo_asset_flow(
    'FLOW-HTTPS-EXT', 'Traffico web da Internet verso Portale Cittadino', 'Alto', 7, 
    'Internet (Any)', 'VM-WEB-PORTALE-01', 'TCP', '443', 'Inbound', 'TLS 1.3', 'Real-time', 'Attivo'
);

-- 4.3.2 Flusso Database Protocollo 
CALL p_inserisci_nuovo_asset_flow(
    'FLOW-SQL-PRT', 'Connessione applicativa tra Backend e DB SQL Server', 'Alto', 7, 
    'VM-PROTOCOLLO-01', 'Server-PRT-01', 'TCP', '1433', 'Lateral', 'TDS Encrypted', 'On-demand', 'Attivo'
);

-- 4.3.3 Backup Replicato 
CALL p_inserisci_nuovo_asset_flow(
    'FLOW-BKP-REPLICA', 'Flusso di sincronizzazione backup verso Storage-BKP-01', 'Alto', 6, 
    'Veeam-Backup-Server', 'Storage-BKP-01', 'TCP/UDP', '2500, 6160', 'Lateral', 'AES-256', 'Daily', 'In manutenzione'
);

-- 4.3.4 Tunnel VPN Amministratori 
CALL p_inserisci_nuovo_asset_flow(
    'FLOW-VPN-ADMIN', 'Tunnel cifrato per telelavoro sistemisti', 'Alto', 11, 
    'Internet (Trusted)', 'Firewall-PER-01', 'UDP', '4500', 'Inbound', 'IPsec (IKEv2)', 'Real-time', 'Attivo'
);

-- 4.3.5 Interscambio pagoPA 
CALL p_inserisci_nuovo_asset_flow(
    'FLOW-PAGOPA-EXT', 'Connessione verso il nodo nazionale dei pagamenti', 'Alto', 7, 
    'VM-PAGAMENTI-01', 'Sogei/pagoPA Node', 'TCP', '8443', 'Outbound', 'mTLS', 'Real-time', 'Attivo'
);


---------------------------------------------------------------------------------
-- 4.4 Inserimento ASSET_SERVIZIO_ESTERNO 
-- Parametri:
-- 1. ASSET: p_nome, p_descrizione, p_criticita, p_responsabile_id
-- 2. ASSET_SERVIZIO_ESTERNO: p_fornitore_id, p_tipo_servizio, p_data_inizio, 
--                            p_data_fine, p_contatto_emergenza, p_stato

-- 4.4.1 Cloud Storage AWS
CALL p_inserisci_nuovo_asset_servizio_esterno(
    'AWS S3 Bucket - Backup', 'Spazio cloud per archiviazione remota backup', 'Alto', 6,
    7, 'Cloud Storage', '2025-01-01', NULL, 'aws-support@amazon.com', 'Attivo'
);

-- 4.4.2 Manutenzione Firewall 
CALL p_inserisci_nuovo_asset_servizio_esterno(
    'Canone Supporto Firewall', 'Supporto specialistico SOC 24/7', 'Alto', 11,
    9, 'Security Service', '2025-01-01', '2026-12-31', 'soc@cybershield.it', 'Attivo'
);

-- 4.4.3 Connettività Fibra Ottica 
CALL p_inserisci_nuovo_asset_servizio_esterno(
    'Linea Fibra Dedicata 1Gbps', 'Connettività principale sede centrale', 'Alto', 7,
    8, 'Connectivity', '2024-01-01', NULL, 'noc@aruba.it', 'Attivo'
);

-- 4.4.4 Supporto Sistemistico 
CALL p_inserisci_nuovo_asset_servizio_esterno(
    'Supporto Sistemistico Senior', 'Assistenza on-site infrastruttura', 'Medio', 6,
    10, 'Professional Services', '2025-01-01', '2025-12-31', 'tech@infra-digitali.it', 'Attivo'
);

-- 4.4.5 Pulizia Data Center 
CALL p_inserisci_nuovo_asset_servizio_esterno(
    'Sanificazione Sale Tecniche', 'Pulizia professionale ambienti server', 'Basso', 8,
    14, 'Maintenance', '2026-01-20', '2026-01-30', 'info@tecnoinfra.it', 'In manutenzione'
);

-- 4.4.6 Corso Sicurezza Informatica 
CALL p_inserisci_nuovo_asset_servizio_esterno(
    'Training Awareness 2024', 'Corso sicurezza dipendenti anno 2024', 'Medio', 11,
    15, 'Training', '2024-01-01', '2024-12-31', 'edu@secpartners.it', 'Dismesso'
);

-- 4.4.7 Audit Conformità GDPR 
CALL p_inserisci_nuovo_asset_servizio_esterno(
    'Audit Privacy 2025', 'Verifica conformità protezione dati', 'Medio', 11,
    15, 'Audit', '2025-01-01', '2025-06-30', 'compliance@secpartners.it', 'Dismesso'
);

-- 4.4.8 Microsoft 365 Subscription
CALL p_inserisci_nuovo_asset_servizio_esterno(
    'Licenze M365 Business', 'Posta elettronica e collaborazione cloud', 'Alto', 11,
    4, 'SaaS', '2025-01-01', '2026-01-01', 'support@microsoft.it', 'Attivo'
);

-- 4.4.9 Hosting Portale Trasparenza
CALL p_inserisci_nuovo_asset_servizio_esterno(
    'Hosting Web Trasparenza', 'Servizio hosting per sito Open Data', 'Medio', 10,
    12, 'Hosting', '2024-05-01', '2026-05-01', 'support@digitalhub.it', 'Attivo'
);

-- 4.4.10 Canone Oracle Support
CALL p_inserisci_nuovo_asset_servizio_esterno(
    'Oracle Premier Support', 'Aggiornamenti e patch critiche DBMS', 'Alto', 9,
    5, 'Software Support', '2025-01-01', NULL, 'support@oracle.it', 'Attivo'
);

-- 4.4.11 Consulenza NIS2 Strategy
CALL p_inserisci_nuovo_asset_servizio_esterno(
    'Project Work NIS2', 'Supporto adeguamento normativa ACN', 'Alto', 11,
    15, 'Consultancy', '2025-09-01', '2026-09-01', 'advisor@secpartners.it', 'Attivo'
);

-- 4.4.12 Gestione Email PEC
CALL p_inserisci_nuovo_asset_servizio_esterno(
    'Servizio PEC Istituzionale', 'Caselle PEC per uffici dell ente', 'Alto', 3,
    8, 'SaaS', '2024-01-01', NULL, 'pec-admin@aruba.it', 'Attivo'
);

-- 4.4.13 Manutenzione Gruppi Elettrogeni
CALL p_inserisci_nuovo_asset_servizio_esterno(
    'Manutenzione UPS e Power', 'Verifica semestrale continuità elettrica', 'Alto', 6,
    14, 'Maintenance', '2025-01-01', NULL, 'power@tecnoinfra.it', 'Attivo'
);

-- 4.4.14 Supporto Remoto UK
CALL p_inserisci_nuovo_asset_servizio_esterno(
    'External Help Desk 24/7', 'Supporto tecnico remoto lingua inglese', 'Basso', 8,
    13, 'BPO', '2025-01-01', '2025-12-31', 'uk-help@globalservices.com', 'Attivo'
);

-- 4.4.15 Canone Cisco SmartNet
CALL p_inserisci_nuovo_asset_servizio_esterno(
    'Cisco SmartNet Switch Core', 'Sostituzione hardware garantita 4h', 'Alto', 7,
    2, 'Hardware Support', '2025-06-01', '2027-06-01', 'tac@cisco.it', 'Attivo'
);


---------------------------------------------------------------------------------
-- 5. ASSEGNAZIONE DIPENDENZE (Asset <-> Servizio)
---------------------------------------------------------------------------------

-- 5.1 SERVIZIO: Portale del Cittadino (ID 1)
INSERT INTO DIPENDENZA (ServizioID, AssetID, DataInizio) VALUES 
(1, 2,  '2025-01-15'), -- Server-WEB-01 (HW)
(1, 23, '2025-01-15'), -- VM-WEB-PORTALE-01 (SW)
(1, 13, '2024-12-01'), -- Oracle Database (SW)
(1, 21, '2026-01-27'), -- Certificato SSL *.ente.it (SW)
(1, 26, '2026-01-27'); -- FLOW-HTTPS-EXT (FLOW)

-- 5.2 SERVIZIO: Protocollo Informatico (ID 6)
INSERT INTO DIPENDENZA (ServizioID, AssetID, DataInizio) VALUES 
(6, 1,  '2025-01-15'), -- Server-PRT-01 (HW)
(6, 22, '2025-01-15'), -- VM-PROTOCOLLO-01 (SW)
(6, 11, '2025-01-15'), -- Windows Server (SW)
(6, 12, '2025-01-16'), -- SQL Server (SW)
(6, 14, '2025-01-20'), -- Iride Workflow (SW)
(6, 27, '2025-01-20'); -- FLOW-SQL-PRT (FLOW)

-- 5.3 SERVIZIO: Gestione Pagamenti (pagoPA) (ID 2) 
INSERT INTO DIPENDENZA (ServizioID, AssetID, DataInizio) VALUES 
(2, 24, '2024-06-01'), -- VM-PAGAMENTI-01 (SW)
(2, 19, '2024-06-01'), -- Gateway pagoPA Connector (SW)
(2, 33, '2024-01-01'), -- Linea Fibra Aruba (SERVIZIO ESTERNO)
(2, 30, '2024-06-01'); -- FLOW-PAGOPA-EXT (FLOW)

-- 5.4 SERVIZIO: ERP Risorse Umane (ID 7)
INSERT INTO DIPENDENZA (ServizioID, AssetID, DataInizio) VALUES 
(7, 6,  '2023-10-12'), -- Server-ERP-01 (HW)
(7, 16, '2023-10-10'), -- SAP ERP Modulo HR (SW)
(7, 34, '2025-01-01'); -- Supporto Sistemistico (SERVIZIO ESTERNO)

-- 5.5 SERVIZIO: Piattaforma E-Learning (ID 9)
INSERT INTO DIPENDENZA (ServizioID, AssetID, DataInizio) VALUES 
(9, 8,  '2023-02-15'), -- Server-EDU-01 (HW)
(9, 17, '2023-02-15'), -- Moodle LMS (SW)
(9, 36, '2024-01-01'); -- Training Awareness 2024 (SERVIZIO ESTERNO)

-- 5.6 SERVIZIO: Monitoraggio Risorse Agricole (ID 10)
INSERT INTO DIPENDENZA (ServizioID, AssetID, DataInizio) VALUES 
(10, 10, '2024-06-20'), -- Router-SEDE-02 (HW)
(10, 33, '2024-01-01'), -- Linea Fibra Aruba (SERVIZIO ESTERNO)
(10, 20, '2025-01-15'); -- RHEL 9 (SW)

-- 5.7 SERVIZIO: Sportello Unico Attività Produttive (SUAP) (ID 3)
INSERT INTO DIPENDENZA (ServizioID, AssetID, DataInizio) VALUES 
(3, 2,  '2025-01-15'), -- Server-WEB-01 (HW)
(3, 23, '2025-01-15'), -- VM-WEB-PORTALE-01 (SW)
(3, 40, '2025-01-01'); -- Oracle Support (SERVIZIO ESTERNO)

-- 5.8 SERVIZIO: Portale Trasparenza (ID 4)
INSERT INTO DIPENDENZA (ServizioID, AssetID, DataInizio) VALUES 
(4, 39, '2024-05-01'), -- Hosting Web Trasparenza (SERVIZIO ESTERNO)
(4, 21, '2026-01-27'); -- Certificato SSL *.ente.it (SW)

-- 5.9 SERVIZIO: App Notifica Servizi (ID 5)
INSERT INTO DIPENDENZA (ServizioID, AssetID, DataInizio) VALUES 
(5, 38, '2025-01-01'), -- M365 Subscription (SERVIZIO ESTERNO)
(5, 21, '2026-01-27'); -- Certificato SSL (SW)

-- 5.10 SERVIZIO: Gestione Biblioteche (ID 8)
INSERT INTO DIPENDENZA (ServizioID, AssetID, DataInizio) VALUES 
(8, 8,  '2023-02-15'), -- Server-EDU-01 (HW)
(8, 44, '2025-01-01'); -- Supporto Remoto UK (SERVIZIO ESTERNO)
