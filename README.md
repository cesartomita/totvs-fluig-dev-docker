# TOTVS Fluig com Docker (Ambiente de desenvolvimento)

Este repositório disponibiliza um ambiente Docker configurado e isolado para desenvolvimento e testes com a plataforma TOTVS Fluig, facilitando a instalação e configuração, além de garantir a persistência de dados de forma simples.

Este projeto provisiona um ambiente com:
- **Plataforma TOTVS Fluig**
- **Banco de dados MySQL 8.0**
- **Servidor de E-mail (Mailpit)** para captura e visualização de e-mails enviados pelo Fluig.

Ferramentas necessárias:
- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

> Este ambiente foi testado com o *Fluig 1.8.2-250701* em sistema Linux e usando o driver *MySQL Connector/J 9.3.0*.

## Fluig no Docker

- **Ambiente isolado:** Evita conflitos com outras aplicações e serviços instalados na máquina.
- **Persistência de dados:** Os dados do banco de dados, dos volumes do Fluig e dos e-mails são salvos em volumes Docker, não sendo perdidos ao desligar os contêineres.
- **Instalação automatizada:** Um script de `entrypoint` cuida de toda a instalação e configuração inicial do Fluig.

### Avisos Importantes

- **Licenciamento**: A utilização do Fluig depende de um Servidor de Licenças (License Server) válido. Caso você não configure um servidor de licenças, o Fluig funcionará apenas em modo demonstração por até 7 dias.
- **Download do Fluig**: O arquivo .zip de instalação do Fluig está disponível somente para usuários credenciados na TOTVS, por meio do portal oficial.
- **Ambiente de desenvolvimento**: Este repositório foi criado com o objetivo de facilitar o uso do Fluig em ambientes de desenvolvimento e testes. Não possui qualquer vínculo oficial com a TOTVS.

> **O uso do Fluig com Docker em ambiente de produção não é recomendado**.

## Como iniciar

Siga os passos abaixo para configurar e executar o ambiente.

### 1. Clonar o Repositório

```bash
git clone https://github.com/cesartomita/totvs-fluig-dev-docker
cd totvs-fluig-dev-docker
```

### 2. Preparar os arquivos de instalação

Este projeto precisa do arquivo de instalação do Fluig e do driver JDBC do MySQL.  
Após fazer o download do instalador do Fluig, coloque o arquivo `.zip` na pasta indicada abaixo:

```bash
.
├── setup/
│   ├── configuration/
│   │   └── ...
│   ├── drivers/
│   │   └── ...
│   └── zip/
│       └── FLUIG-1.8.2-250701-LINUX64.ZIP   # Coloque o arquivo .zip do Fluig aqui
└── ...
```

Em seguida, abra o arquivo `.env` e ajuste as variáveis conforme necessário.

### 3. Construir e iniciar os contêineres

Com tudo configurado, execute o comando abaixo para construir as imagens e iniciar os serviços em segundo plano (-d):

```bash
docker-compose up --build -d
```

Ou, se preferir rodar em primeiro plano (útil para depuração):

```bash
docker-compose up --build
```

Quando rodar em primeiro plano, você verá no terminal os logs de inicialização do Fluig, incluindo o conteúdo do *server.log*.

> A primeira execução pode demorar alguns minutos, pois o Docker irá baixar as imagens base e o script de *entrypoint* realizará toda a instalação do Fluig.

## Acessando os serviços

Após a inicialização, os serviços estarão disponíveis nos seguintes endereços:

| Serviço              | URL / Ponto de Acesso                 | Credenciais                              |
|----------------------|---------------------------------------|------------------------------------------|
| Fluig                | http://localhost:8080/portal          | Usuário: `wdkadmin` <br> Senha: `adm`    |
| Mailpit              | http://localhost:8025                 | -                                        |
| MySQL                | Host: `127.0.0.1` <br> Porta: `3306` | Usuário: `fluig` <br> Senha: `fluigpass` |
| SMTP                 | Host: `mailpit` <br> Porta: `1025`    | -                                        |

### Persistência de dados

Todos os dados do ambiente são armazenados em volumes Docker, garantindo que nada seja perdido ao reiniciar ou remover os contêineres:

- **Dados do Fluig:** Documentos, datasets, configurações e arquivos são persistidos no volume nomeado `fluig-data`.
- **Dados do MySQL:** O volume `mysql-data` armazena o banco de dados.
- **E-mails do Mailpit:** As mensagens capturadas pelo Mailpit ficam salvas no volume `mailpit-data`.

No cadastro de empresa, pode utilizar o diretório `/opt/fluig-volume` como caminho para o volume de dados do Fluig. Esse diretório foi utilizado nos testes.

### Limpando os dados

Removendo todos os contêineres, redes e volumes criados pelo Docker Compose:
```bash
docker-compose down -v
```