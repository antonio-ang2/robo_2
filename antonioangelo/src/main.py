# Programa principal que mostra os jogos cadastrados no banco de dados no console, numa rota API e na página inicial do site

from config import db # Conexão com banco de dados
from models.Position import Position # Modelo de tabela de jogos
from flask import Flask, render_template, request # Framework web
from flask_cors import CORS
app = Flask(__name__)
CORS(app) # This will enable CORS for all routes

# Pega todos os jogos cadastrados no banco de dados
positions = db.session.query(Position).all()

# Mostra os jogos cadastrados no console
for position in positions:
    print(positions)

# Cria o servidor web
app = Flask(__name__)

@app.route('/position', methods=['GET']) # Rota API
def api_positions():
    # Retorna uma lista com os jogos cadastrados no banco de dados
    return {
        'positions': [position.return_json() for position in db.session.query(Position).all()]
    }
@app.route('/position', methods=['POST']) # Rota API
def create_position():
    # Obter dados enviados no corpo da solicitação
    data = request.json

    # Criar uma nova posição com os dados recebidos
    new_position = Position(x=data['x'], y=data['y'], z=data['z'], r=data['r'], j1=data['j1'], j2=data['j2'], j3=data['j3'], j4=data['j4'])

    # Adicionar a nova posição ao banco de dados
    db.session.add(new_position)
    db.session.commit()

    # Retornar a nova posição criada como JSON
    return {'success': 'Nova posição criada com sucesso', 'position': new_position.return_json()}, 201

# Rota que mostra a página inicial do site

@app.route('/')
def index():
     return render_template('index.html')


# Inicia o servidor web
if __name__ == '__main__':
    app.run(debug=True)