USE doacoes_sangue;

-- Adicionar um novo doador
DELIMITER //
CREATE PROCEDURE AdicionarDoador(
    IN p_nome VARCHAR(100),
    IN p_idade INT,
    IN p_sexo ENUM('M', 'F'),
    IN p_tipo_sanguineo ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'),
    IN p_telefone VARCHAR(30),
    IN p_email VARCHAR(50),
    IN p_endereco VARCHAR(255),
    IN p_ultima_doacao DATE,
    IN p_data_cadastro DATE,
    IN p_status ENUM('Ativo', 'Inativo')
)
BEGIN
    INSERT INTO Doadores (nome, idade, sexo, tipo_sanguineo, telefone, email, endereco, ultima_doacao, data_cadastro, status)
    VALUES (p_nome, p_idade, p_sexo, p_tipo_sanguineo, p_telefone, p_email, p_endereco, p_ultima_doacao, p_data_cadastro, p_status);
END //
DELIMITER ;

-- Atualizar informações de um doador
DELIMITER //
CREATE PROCEDURE AtualizarDoador(
    IN p_id INT,
    IN p_nome VARCHAR(100),
    IN p_idade INT,
    IN p_sexo ENUM('M', 'F'),
    IN p_tipo_sanguineo ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'),
    IN p_telefone VARCHAR(30),
    IN p_email VARCHAR(50),
    IN p_endereco VARCHAR(255),
    IN p_ultima_doacao DATE,
    IN p_data_cadastro DATE,
    IN p_status ENUM('Ativo', 'Inativo')
)
BEGIN
    UPDATE Doadores
    SET nome = p_nome, idade = p_idade, sexo = p_sexo, tipo_sanguineo = p_tipo_sanguineo, telefone = p_telefone,
        email = p_email, endereco = p_endereco, ultima_doacao = p_ultima_doacao, data_cadastro = p_data_cadastro, status = p_status
    WHERE id = p_id;
END //
DELIMITER ;

-- Excluir um doador
DELIMITER //
CREATE PROCEDURE ExcluirDoador(IN p_id INT)
BEGIN
    DELETE FROM Doadores WHERE id = p_id;
END //
DELIMITER ;

-- Atualizar informações de um hospital
DELIMITER //
CREATE PROCEDURE AtualizarHospital(
    IN p_id INT,
    IN p_nome VARCHAR(100),
    IN p_endereco VARCHAR(255),
    IN p_telefone VARCHAR(30),
    IN p_email VARCHAR(100),
    IN p_responsavel VARCHAR(100)
)
BEGIN
    UPDATE Hospitais
    SET nome = p_nome, endereco = p_endereco, telefone = p_telefone, email = p_email, responsavel = p_responsavel
    WHERE id = p_id;
END //
DELIMITER ;

-- Excluir um hospital
DELIMITER //
CREATE PROCEDURE ExcluirHospital(IN p_id INT)
BEGIN
    DELETE FROM Hospitais WHERE id = p_id;
END //
DELIMITER ;

-- Atualizar o estoque de sangue
DELIMITER //
CREATE PROCEDURE AtualizarEstoque(
    IN p_tipo_sanguineo ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'),
    IN p_quantidade_ml INT,
    IN p_hospital_id INT
)
BEGIN
    INSERT INTO Estoques (tipo_sanguineo, quantidade_ml, hospital_id)
    VALUES (p_tipo_sanguineo, p_quantidade_ml, p_hospital_id)
    ON DUPLICATE KEY UPDATE quantidade_ml = quantidade_ml + VALUES(quantidade_ml);
END //
DELIMITER ;

-- Adicionar uma nova solicitação
DELIMITER //
CREATE PROCEDURE AdicionarSolicitacao(
    IN p_tipo_sanguineo ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'),
    IN p_quantidade_ml INT,
    IN p_data_solicitacao DATE,
    IN p_status ENUM('Pendente', 'Atendida', 'Cancelada'),
    IN p_hospital_id INT
)
BEGIN
    INSERT INTO Solicitacoes (tipo_sanguineo, quantidade_ml, data_solicitacao, status, hospital_id)
    VALUES (p_tipo_sanguineo, p_quantidade_ml, p_data_solicitacao, p_status, p_hospital_id);
END //
DELIMITER ;

-- Adicionar uma nova doação
DELIMITER //
CREATE PROCEDURE AdicionarDoacao(
    IN p_data_doacao DATE,
    IN p_quantidade_ml INT,
    IN p_tipo_sanguineo ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'),
    IN p_hospital_id INT,
    IN p_doador_id INT
)
BEGIN
    INSERT INTO Doacoes (data_doacao, quantidade_ml, tipo_sanguineo, hospital_id, doador_id)
    VALUES (p_data_doacao, p_quantidade_ml, p_tipo_sanguineo, p_hospital_id, p_doador_id);
END //
DELIMITER ;

-- Gerar relatório de doações por hospital
DELIMITER //
CREATE PROCEDURE RelatorioDoacoesPorHospital(IN p_hospital_id INT)
BEGIN
    SELECT d.id, d.data_doacao, d.quantidade_ml, d.tipo_sanguineo, h.nome AS hospital_nome, do.nome AS doador_nome
    FROM Doacoes d
    JOIN Hospitais h ON d.hospital_id = h.id
    JOIN Doadores do ON d.doador_id = do.id
    WHERE d.hospital_id = p_hospital_id;
END //
DELIMITER ;

CALL RelatorioDoacoesPorHospital(1);
CALL RelatorioDoacoesPorHospital(3);
CALL RelatorioDoacoesPorHospital(5);