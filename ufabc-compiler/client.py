import requests
import time

# Upload the file
url = 'http://localhost:5000/files'
file = input("Digite o path do arquivo de entrada: ")
files = {'file': open(file, 'rb')}
response = requests.post(url, files=files)
response_data = response.json()
file_id = response_data['file_id']
filename = response_data['filename']
print(response_data)

status_url = f'http://localhost:5000/files/{file_id}'
while True:
    status_response = requests.get(status_url)
    status_data = status_response.json()
    if status_data['status'] == 'completed':
        break
    time.sleep(5)

java_file_url = f'http://localhost:5000/files/{file_id}/java'
c_file_url = f'http://localhost:5000/files/{file_id}/c'

java_response = requests.get(java_file_url)
with open(filename.replace('.in', '.java'), 'wb') as f:
    f.write(java_response.content)

c_response = requests.get(c_file_url)
with open(filename.replace('.in', '.c'), 'wb') as f:
    f.write(c_response.content)
