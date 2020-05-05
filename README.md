# PLANEA

Analysis pipeline for the 2019 - PLANEA test. This test is part of the Secretaría de Educación Pública (SEP) and is an effort to evaluate the education level in the country.

It contains:

 * Population information from CONAPO
 * Marinalization data from CONAPO
 * Indigenous population data from CDI
 * School information data from CONAFE
 * Test scores from PLANEA

The basic requirements are :

 * Python 3 (3.6 < is preferred)
 * Docker (working without sudo in order to use the make commands)
 * Docker-compose

In order to prepare your computer you need to run:

```{bash}
make init
```

then initialize the airflow data base with

```{bash}
make airdb
```

create the required docker containers and run them  with

```{bash}
make start
```

you could also only create them in case you only need to download certain files

```{bash}
make create
```

Then

```{bash}
make getdata
```

should do the trick and you will have the data base up and running, ready for your analysis.

If the DAG is not running it could be because of it's failed logs so you should probably run a `clear`.

For example:

```{bash}
airdb clear ingest
```
