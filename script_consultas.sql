USE doacoes_sangue;

-- Verificar a distribuição dos tipos sanguíneos nos doadores
SELECT tipo_sanguineo, COUNT(*) AS quantidade
FROM Doadores
GROUP BY tipo_sanguineo;

-- Verificar a quantidade total de sangue doado em cada hospital
SELECT h.nome, SUM(d.quantidade_ml) AS total_ml_doado
FROM Doacoes d
JOIN Hospitais h ON d.hospital_id = h.id
GROUP BY h.nome;

-- Verificar quais solicitações ainda estão pendentes
SELECT *
FROM Solicitacoes
WHERE status = 'Pendente';

-- Verificar a quantidade de sangue disponível em cada hospital por tipo sanguíneo
SELECT h.nome, e.tipo_sanguineo, e.quantidade_ml
FROM Estoques e
JOIN Hospitais h ON e.hospital_id = h.id;

-- Verificar quais doadores fizeram mais de uma doação
SELECT d.nome, COUNT(doa.id) AS numero_doacoes
FROM Doadores d
JOIN Doacoes doa ON d.id = doa.doador_id
GROUP BY d.nome
HAVING numero_doacoes > 1;

-- Verificar quais pacientes receberam transfusões recentemente
SELECT p.nome, p.data_transfusao, h.nome AS hospital
FROM Pacientes p
JOIN Hospitais h ON p.hospital_id = h.id
WHERE p.data_transfusao > CURDATE() - INTERVAL 30 DAY;

-- Listar os doadores que doaram sangue no último mês
SELECT d.nome, doa.data_doacao
FROM Doadores d
JOIN Doacoes doa ON d.id = doa.doador_id
WHERE doa.data_doacao >= CURDATE() - INTERVAL 1 MONTH;

-- Verificar a quantidade de sangue doada por tipo sanguíneo no último ano
SELECT tipo_sanguineo, SUM(quantidade_ml) AS total_doado
FROM Doacoes
WHERE data_doacao >= CURDATE() - INTERVAL 1 YEAR
GROUP BY tipo_sanguineo;

-- Encontrar os doadores que possuem o mesmo tipo sanguíneo de algum paciente em uma solicitação pendente
SELECT DISTINCT d.nome
FROM Doadores d
JOIN Solicitacoes s ON d.tipo_sanguineo = s.tipo_sanguineo
WHERE s.status = 'Pendente';

-- Verificar a quantidade de transfusões realizadas por hospital
SELECT h.nome, COUNT(p.id) AS numero_transfusoes
FROM Pacientes p
JOIN Hospitais h ON p.hospital_id = h.id
WHERE p.data_transfusao IS NOT NULL
GROUP BY h.nome;

-- Encontrar os hospitais com mais solicitações pendentes
SELECT h.nome, COUNT(s.id) AS solicitacoes_pendentes
FROM Solicitacoes s
JOIN Hospitais h ON s.hospital_id = h.id
WHERE s.status = 'Pendente'
GROUP BY h.nome
ORDER BY solicitacoes_pendentes DESC;

-- Verificar a média de quantidade de sangue doada por doador
SELECT AVG(doa.quantidade_ml) AS media_quantidade_ml
FROM Doacoes doa;

-- Listar os doadores que não doaram sangue nos últimos 6 meses
SELECT d.nome
FROM Doadores d
WHERE d.id NOT IN (
    SELECT DISTINCT doador_id
    FROM Doacoes
    WHERE data_doacao >= CURDATE() - INTERVAL 6 MONTH
);

-- Verificar a quantidade total de doações e a quantidade total de solicitações atendidas em cada hospital
SELECT h.nome, 
       COUNT(DISTINCT doa.id) AS total_doacoes, 
       COUNT(DISTINCT s.id) AS total_solicitacoes_atendidas
FROM Hospitais h
LEFT JOIN Doacoes doa ON h.id = doa.hospital_id
LEFT JOIN Solicitacoes s ON h.id = s.hospital_id AND s.status = 'Atendida'
GROUP BY h.nome;

-- Listar os tipos sanguíneos que estão com estoque abaixo de 500 ml em qualquer hospital
SELECT h.nome, e.tipo_sanguineo, e.quantidade_ml
FROM Estoques e
JOIN Hospitais h ON e.hospital_id = h.id
WHERE e.quantidade_ml < 500;