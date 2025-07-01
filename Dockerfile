# Etapa 1: Definir a imagem base
# Usar uma tag mais genérica como '3.13-alpine' é uma boa prática para obter
# correções de segurança, mantendo a imagem leve.
FROM python:3.13-alpine

# Definir variáveis de ambiente
# Garante que o output do Python não seja bufferizado, facilitando o log.
ENV PYTHONUNBUFFERED 1

# Etapa 2: Definir o diretório de trabalho
# Isso evita espalhar os arquivos da aplicação pelo sistema de arquivos do contêiner.
WORKDIR /app

# Etapa 3: Copiar e instalar as dependências
# Copiar 'requirements.txt' separadamente aproveita o cache de camadas do Docker.
# Se o código-fonte mudar, mas as dependências não, esta camada não será reconstruída.
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Etapa 4: Copiar o código da aplicação
COPY . .

# Etapa 5: Expor a porta que a aplicação usará
EXPOSE 8000

# Etapa 6: Comando para executar a aplicação
# Usa uvicorn para iniciar o servidor ASGI. 'app:app' refere-se ao objeto 'app' no arquivo 'app.py'.
# '--host 0.0.0.0' é crucial para que a aplicação seja acessível de fora do contêiner.
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]