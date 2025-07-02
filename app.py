from flask import Flask, render_template
import pyodbc

app = Flask(__name__)

connection_string = (
    "Driver={ODBC Driver 17 for SQL Server};"
    "Server=Venus;"
    "Database=ConectaComunidade;"
    "Trusted_Connection=yes;"
)

def conectar_bd():
    try:
        return pyodbc.connect(connection_string)
    except pyodbc.Error as ex:
        print(f"Erro de conexão com o banco de dados: {ex}")
        return None

@app.route('/')
def index():
    conn = conectar_bd()
    eventos = []
    if conn:
        cursor = conn.cursor()
        cursor.execute("EXEC sp_ListarProximosEventos")
        eventos = cursor.fetchall()
        conn.close()
    return render_template('index.html', eventos=eventos)

@app.route('/evento/<int:evento_id>')
def detalhe_evento(evento_id):
    conn = conectar_bd()
    evento = None
    interessados = []
    if conn:
        cursor = conn.cursor()
        
        query_evento = "SELECT Titulo, Descricao, DataHoraInicio FROM EVENTO WHERE EventoID = ?;"
        cursor.execute(query_evento, evento_id)
        evento = cursor.fetchone()
        
        query_interessados = """
            SELECT U.Nome 
            FROM INTERESSE_EVENTO I
            JOIN USUARIO U ON I.UsuarioID_FK = U.UsuarioID
            WHERE I.EventoID_FK = ?;
        """
        cursor.execute(query_interessados, evento_id)
        interessados = cursor.fetchall()
        
        conn.close()
        
    return render_template('evento.html', evento=evento, interessados=interessados)

if __name__ == '__main__':
    app.run(debug=True)