resource "aws_security_group" "web_sg" {
  name        = "${var.project_name}-sg"
  description = "Permitir trafico HTTP y SSH"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Node App"
    from_port   = 8085
    to_port     = 8085
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              # Actualizar e instalar Node.js
              dnf update -y
              dnf install -y nodejs npm git

              # Crear directorio de la app
              mkdir -p /home/ec2-user/app/public
              cd /home/ec2-user/app

              # Crear server.js
              cat << 'JS' > server.js
              const express = require('express');
              const path = require('path');
              const app = express();
              const PORT = 8085;
              app.use(express.static(path.join(__dirname, 'public')));
              app.use(express.json());
              app.get('/', (req, res) => {
                  res.sendFile(path.join(__dirname, 'public', 'index.html'));
              });
              // Forzar bind a todas las interfaces
              app.listen(PORT, '0.0.0.0', () => {
                  console.log(`Servidor Node.js corriendo en el puerto $${PORT}`);
              });
              JS

              # Crear public/index.html
              cat << 'HTML' > public/index.html
              <!DOCTYPE html>
              <html lang="es">
              <head>
                  <meta charset="UTF-8">
                  <meta name="viewport" content="width=device-width, initial-scale=1.0">
                  <title>Formulario Node.js - AWS</title>
                  <style>
                      body { font-family: Arial, sans-serif; background-color: #f4f7f6; margin: 0; padding: 20px; display: flex; flex-direction: column; align-items: center; }
                      .container { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); width: 100%; max-width: 400px; margin-bottom: 20px; }
                      h2 { margin-top: 0; color: #333; }
                      .form-group { margin-bottom: 15px; }
                      label { display: block; margin-bottom: 5px; color: #666; }
                      input { width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
                      button { width: 100%; padding: 10px; background-color: #28a745; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; }
                      button:hover { background-color: #218838; }
                      .list-container { width: 100%; max-width: 400px; }
                      .list-item { background: white; padding: 15px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); margin-bottom: 10px; border-left: 5px solid #007bff; }
                  </style>
              </head>
              <body>
                  <div class="container">
                      <h2>Registro (En AWS!)</h2>
                      <form id="dataForm">
                          <div class="form-group"><label>Nombre:</label><input type="text" id="nombre" required></div>
                          <div class="form-group"><label>Dirección:</label><input type="text" id="direccion" required></div>
                          <div class="form-group"><label>Comuna:</label><input type="text" id="comuna" required></div>
                          <button type="submit">Agregar</button>
                      </form>
                  </div>
                  <div class="list-container" id="listaDatos"></div>
                  <script>
                      const form = document.getElementById('dataForm');
                      const listaDatos = document.getElementById('listaDatos');
                      form.addEventListener('submit', function(e) {
                          e.preventDefault();
                          const nombre = document.getElementById('nombre').value;
                          const direccion = document.getElementById('direccion').value;
                          const comuna = document.getElementById('comuna').value;
                          const nuevoItem = document.createElement('div');
                          nuevoItem.className = 'list-item';
                          nuevoItem.innerHTML = `<div><strong>Nombre:</strong> $${nombre}</div><div><strong>Dirección:</strong> $${direccion}</div><div><strong>Comuna:</strong> $${comuna}</div>`;
                          listaDatos.appendChild(nuevoItem);
                          form.reset();
                      });
                  </script>
              </body>
              </html>
              HTML

              # Inicializar NPM e instalar Express
              npm init -y
              npm install express

              # Iniciar aplicacion en background (puerto 8085, no requiere sudo)
              nohup node server.js > app.log 2>&1 &

              # Servidor de rescate en el puerto 80 para poder ver los logs si falla node
              sudo nohup python3 -m http.server 80 > python.log 2>&1 &
              EOF

  tags = {
    Name = "EV1_IngDevops"
  }
}
