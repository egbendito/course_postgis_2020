# Practical PostGIS Course
**Master GIScience**
Universitá di Padova Gennaio 2020

## Parte I. Installazione PostgreSQL :elephant:
  ### 1. Ubuntu: ~~(https://itsfoss.com/install-postgresql-ubuntu/)~~
   1.1 Ottiene installatore:
   
    sudo apt-get install postgresql-11 pgadmin4

   1.2 Entra sul’ ambiente PostgreSQL e sulla PostgreSQL Shell:
   
    sudo su postgres
    psql
   
   1.3 Osservare gli utenti esistenti:
   
    \du
![Image of users](https://i0.wp.com/itsfoss.com/wp-content/uploads/2019/07/postgresql_tables.png)

  1.4 Crea un nuovo utente:
  
    CREATE USER my_user;
  
  1.5 Crea Crea una Data Base:

    CREATE DATABASE my_db;

  1.6 Per entrare a l’ nuova DB usciamo 
    
    \q

e rientriamo con nostro utente

    psql -U my_user -d my_db
*Si che un errore dobbiamo aggiustare la configurazione di PostgreSQL:

    sudo nano /etc/postgresql/11/main/pg_hba.conf
e cambiare:
    
    local   all             postgres                       peer
a:
    
    local   all             postgres                       md5

  1.7 Entra su la DB usando PgAdmin e collegiamo sulla nuova DB:

  ### 2. Windows: ~~(https://www.postgresqltutorial.com/postgresql-tutorial/install-postgresql/)~~

  2.1 Ottieni l’installatore da: https://www.enterprisedb.com/downloads/postgres-postgresql-downloads

  2.2 Seleziona l’ installatore:

![Image of installers](https://www.postgresqltutorial.com/wp-content/uploads/2019/05/Install-PostgreSQL-download-installer.png)
  
  2.3 Continua col’ processo d’installazione sul’ wizard…
  
  2.4 Verifica la installazione usando SQL Shell

![Image of SQL Shell](https://www.postgresqltutorial.com/wp-content/uploads/2019/05/Install-PostgreSQL-Connect-to-PostgreSQL-via-psql.png)

	   
