USE doacoes_sangue;

-- Quantidade total de sangue doado por cada doador
SELECT DISTINCT
    doador_id,
    quantidade_ml,
    SUM(quantidade_ml) OVER (PARTITION BY doador_id) AS total_sangue_doado
FROM Doacoes;

-- Número de doações realizadas por cada doador
SELECT DISTINCT
    doador_id,
    COUNT(*) OVER (PARTITION BY doador_id) AS numero_doacoes
FROM Doacoes;

-- Quantidade total de sangue disponível em cada hospital
SELECT DISTINCT
    hospital_id,
    tipo_sanguineo,
    quantidade_ml,
    SUM(quantidade_ml) OVER (PARTITION BY hospital_id) AS total_estoque
FROM Estoques;

-- Número de pacientes atendidos por cada hospital
SELECT DISTINCT
    hospital_id,
    COUNT(*) OVER (PARTITION BY hospital_id) AS numero_pacientes
FROM Pacientes;

-- Número de solicitações atendidas por cada hospital
SELECT DISTINCT
    hospital_id,
    COUNT(*) OVER (PARTITION BY hospital_id) AS numero_solicitacoes_atendidas
FROM Solicitacoes
WHERE status = 'Atendida';
