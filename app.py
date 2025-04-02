# app.py
import os
import socket
from flask import Flask, request

app = Flask(__name__)

@app.route('/')
def hello():
    hostname = socket.gethostname()
    client_ip = request.remote_addr
    message = f"Hello from Kuard-like Python App!\n"
    message += f"Running on hostname: {hostname}\n"
    message += f"Client IP address: {client_ip}\n"

    # You could add more info here, like environment variables:
    message += "\nEnvironment Variables:\n"
    for key, value in os.environ.items():
        message += f"- {key}: {value}\n"

    # Return plain text response
    return message, 200, {'Content-Type': 'text/plain; charset=utf-8'}

if __name__ == '__main__':
    # This part is mainly for local development,
    # Gunicorn will run the app in production.
    app.run(host='0.0.0.0', port=8080)