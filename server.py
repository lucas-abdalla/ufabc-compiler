from flask import Flask, request, jsonify, send_file
import subprocess
import os
import uuid

app = Flask(__name__)

UPLOAD_FOLDER = 'uploads'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

@app.route('/files', methods=['POST'])
def upload_file():
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'}), 400
    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400

    file_id = str(uuid.uuid4())
    file_path = os.path.join(UPLOAD_FOLDER, file_id + '_' + file.filename)
    file.save(file_path)

    subprocess.run(['java', '-cp', 'antlr-4.13.2-complete.jar:bin/io/compiler/main', 'io.compiler.main.MainClass', file_path])

    return jsonify({'file_id': file_id, 'filename': file.filename}), 202

@app.route('/files/<file_id>', methods=['GET'])
def get_file_status(file_id):
    base_name = os.path.join(UPLOAD_FOLDER, file_id)
    java_file = base_name + '.java'
    c_file = base_name + '.c'

    if os.path.exists(java_file) and os.path.exists(c_file):
        return jsonify({'status': 'completed', 'java_file': java_file, 'c_file': c_file})
    else:
        return jsonify({'status': 'processing'}), 202

@app.route('/files/<file_id>/<file_type>', methods=['GET'])
def download_file(file_id, file_type):
    base_name = os.path.join(UPLOAD_FOLDER, file_id)
    file_path = base_name + '.' + file_type

    if os.path.exists(file_path):
        return send_file(file_path, as_attachment=True)
    else:
        return jsonify({'error': 'File not found'}), 404

if __name__ == '__main__':
    app.run(debug=True)
