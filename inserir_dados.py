import mysql.connector
import random
from faker import Faker
from datetime import datetime, timedelta
from mysql.connector import Error

fake = Faker('pt_BR')

def connect():
    try:
        connection = mysql.connector.connect(
            host='localhost',
            user='root',
            password='583950',
            database='doacoes_sangue'
        )
        cursor = connection.cursor()
        print("Conexão com o banco de dados estabelecida com sucesso.")
        return connection, cursor
    except mysql.connector.Error as err:
        print(f"Erro ao conectar ao banco de dados: {err}")
        return None, None

def close_connection(connection, cursor):
    if cursor:
        cursor.close()
    if connection:
        connection.close()
    print("Conexão com o banco de dados fechada.")

def gerar_doadores(cursor):
    for _ in range(200):
        nome = fake.name()
        idade = random.randint(18, 65)
        sexo = random.choice(['M', 'F'])
        tipo_sanguineo = random.choice(['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'])
        telefone = fake.phone_number()
        email = fake.email()
        endereco = fake.address().replace("\n", ", ")
        ultima_doacao = fake.date_between(start_date="-1y", end_date="today")
        data_cadastro = fake.date_between(start_date="-2y", end_date="today")
        status = random.choice(['Ativo', 'Inativo'])
        
        cursor.execute("""
            INSERT INTO Doadores (nome, idade, sexo, tipo_sanguineo, telefone, email, endereco, ultima_doacao, data_cadastro, status)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, (nome, idade, sexo, tipo_sanguineo, telefone, email, endereco, ultima_doacao, data_cadastro, status))

def gerar_hospitais(cursor):
    for _ in range(10):  
        nome = fake.company()
        endereco = fake.address().replace("\n", ", ")
        telefone = fake.phone_number()
        email = fake.email()
        responsavel = fake.name()

        cursor.execute("""
            INSERT INTO Hospitais (nome, endereco, telefone, email, responsavel)
            VALUES (%s, %s, %s, %s, %s)
        """, (nome, endereco, telefone, email, responsavel))

def gerar_doacoes(cursor):
    cursor.execute("SELECT id FROM Doadores")
    doadores_ids = [id[0] for id in cursor.fetchall()]
    
    cursor.execute("SELECT id FROM Hospitais")
    hospitais_ids = [id[0] for id in cursor.fetchall()]

    for _ in range(200):
        data_doacao = fake.date_between(start_date="-1y", end_date="today")
        quantidade_ml = random.randint(250, 500)
        tipo_sanguineo = random.choice(['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'])
        hospital_id = random.choice(hospitais_ids)
        doador_id = random.choice(doadores_ids)
        
        cursor.execute("""
            INSERT INTO Doacoes (data_doacao, quantidade_ml, tipo_sanguineo, hospital_id, doador_id)
            VALUES (%s, %s, %s, %s, %s)
        """, (data_doacao, quantidade_ml, tipo_sanguineo, hospital_id, doador_id))

def gerar_solicitacoes(cursor):
    cursor.execute("SELECT id FROM Hospitais")
    hospitais_ids = [id[0] for id in cursor.fetchall()]
    
    for _ in range(200):
        tipo_sanguineo = random.choice(['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'])
        quantidade_ml = random.randint(250, 1000)
        data_solicitacao = fake.date_between(start_date="-1y", end_date="today")
        status = random.choice(['Pendente', 'Atendida', 'Cancelada'])
        hospital_id = random.choice(hospitais_ids)

        cursor.execute("""
            INSERT INTO Solicitacoes (tipo_sanguineo, quantidade_ml, data_solicitacao, status, hospital_id)
            VALUES (%s, %s, %s, %s, %s)
        """, (tipo_sanguineo, quantidade_ml, data_solicitacao, status, hospital_id))

def gerar_pacientes(cursor):
    cursor.execute("SELECT id FROM Solicitacoes")
    solicitacoes_ids = [id[0] for id in cursor.fetchall()]
    
    cursor.execute("SELECT id FROM Hospitais")
    hospitais_ids = [id[0] for id in cursor.fetchall()]

    for _ in range(200):
        nome = fake.name()
        sexo = random.choice(['M', 'F'])
        data_nascimento = fake.date_of_birth(minimum_age=18, maximum_age=90)
        data_transfusao = fake.date_between(start_date="-1y", end_date="today")
        hospital_id = random.choice(hospitais_ids)
        solicitacao_id = random.choice(solicitacoes_ids)
        
        cursor.execute("""
            INSERT INTO Pacientes (nome, sexo, data_nascimento, data_transfusao, hospital_id, solicitacao_id)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (nome, sexo, data_nascimento, data_transfusao, hospital_id, solicitacao_id))

def gerar_estoques(cursor):
    cursor.execute("SELECT id FROM Hospitais")
    hospitais_ids = [id[0] for id in cursor.fetchall()]
    
    for hospital_id in hospitais_ids:
        for tipo_sanguineo in ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']:
            quantidade_ml = random.randint(500, 5000)
            
            cursor.execute("""
                INSERT INTO Estoques (tipo_sanguineo, quantidade_ml, hospital_id)
                VALUES (%s, %s, %s)
            """, (tipo_sanguineo, quantidade_ml, hospital_id))

def gerar_dados():
    connection, cursor = connect()
    if connection is None or cursor is None:
        return

    try:
        gerar_doadores(cursor)
        gerar_hospitais(cursor)
        gerar_doacoes(cursor)
        gerar_solicitacoes(cursor)
        gerar_pacientes(cursor)
        gerar_estoques(cursor)

        connection.commit()
        print("Dados gerados e inseridos com sucesso.")
    except Exception as e:
        print(f"Erro ao inserir dados: {e}")
        connection.rollback()
    finally:
        close_connection(connection, cursor)

if __name__ == "__main__":
    gerar_dados()